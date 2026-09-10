package vn.edu.eaut.fruitables.controller.admin;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.IProductDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.ProductDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/dashboard/export-excel"})
public class AdminExportExcelServlet extends HttpServlet {

    private final IDashboardDAO dashboardDAO;
    private final IOrderDAO orderDAO;
    private final IProductDAO productDAO;

    public AdminExportExcelServlet() {
        this.dashboardDAO = new DashboardDAOImpl();
        this.orderDAO = new OrderDAOImpl();
        this.productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filterType = request.getParameter("filter");
        if (filterType == null || filterType.trim().isEmpty()) {
            filterType = "month";
        }

        try (Workbook workbook = new XSSFWorkbook()) {
            // Định dạng Cell Style
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREEN.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setBold(true);
            titleFont.setFontHeightInPoints((short) 14);
            titleStyle.setFont(titleFont);

            CellStyle currencyStyle = workbook.createCellStyle();
            DataFormat format = workbook.createDataFormat();
            currencyStyle.setDataFormat(format.getFormat("#,##0 ₫"));

            CellStyle percentStyle = workbook.createCellStyle();
            percentStyle.setDataFormat(format.getFormat("0.0%"));

            // -------------------------------------------------------------
            // SHEET 1: BÁO CÁO TỔNG QUAN TÀI CHÍNH (LÃI / LỖ)
            // -------------------------------------------------------------
            Sheet sheet1 = workbook.createSheet("Báo cáo Lãi - Lỗ Tổng Quan");
            sheet1.setDisplayGridlines(true);

            Row titleRow = sheet1.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("BÁO CÁO TÀI CHÍNH DOANH THU & LỢI NHUẬN (FRUITABLES)");
            titleCell.setCellStyle(titleStyle);

            Row dateRow = sheet1.createRow(1);
            dateRow.createCell(0).setCellValue("Thời điểm xuất báo cáo: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));

            Row hRow = sheet1.createRow(3);
            String[] headers1 = {"Chỉ số tài chính", "Giá trị", "Ghi chú & Tỷ suất"};
            for (int i = 0; i < headers1.length; i++) {
                Cell c = hRow.createCell(i);
                c.setCellValue(headers1[i]);
                c.setCellStyle(headerStyle);
            }

            double totalRev = dashboardDAO.getTotalRevenue();
            double totalCost = 0.0;
            // Tính tổng giá vốn từ các đơn thành công
            List<OrderModel> orders = orderDAO.findAll();
            for (OrderModel o : orders) {
                if ("PAID".equalsIgnoreCase(o.getPaymentStatus()) || "COMPLETED".equalsIgnoreCase(o.getStatus())) {
                    List<OrderDetailModel> details = orderDAO.findOrderDetailsByOrderId(o.getId());
                    if (details != null) {
                        for (OrderDetailModel d : details) {
                            double cp = d.getCostPrice() != null ? d.getCostPrice() : 0.0;
                            totalCost += (cp * d.getQuantity());
                        }
                    }
                }
            }
            double grossProfit = totalRev - totalCost;
            double profitMargin = totalRev > 0 ? (grossProfit / totalRev) : 0.0;

            int rowIdx = 4;
            createFinanceRow(sheet1, rowIdx++, "Tổng Doanh Thu Thuần", totalRev, currencyStyle, "Các đơn đã thanh toán hoặc hoàn thành");
            createFinanceRow(sheet1, rowIdx++, "Tổng Giá Vốn Hàng Bán (COGS)", totalCost, currencyStyle, "Giá vốn bình quân lúc xuất bán");
            createFinanceRow(sheet1, rowIdx++, "Lợi Nhuận Gộp (Lãi / Lỗ)", grossProfit, currencyStyle, grossProfit >= 0 ? "Kinh doanh có lãi" : "Cảnh báo LỖ vốn!");
            createFinanceRow(sheet1, rowIdx++, "Tỷ Suất Lợi Nhuận Gộp (Margin)", profitMargin, percentStyle, "Lợi nhuận gộp / Doanh thu");
            createFinanceRow(sheet1, rowIdx++, "Tổng Số Đơn Hàng Đã Ghi Nhận", (double) dashboardDAO.getTotalOrders(), null, "Bao gồm tất cả các trạng thái");

            for (int i = 0; i < 3; i++) { sheet1.autoSizeColumn(i); sheet1.setColumnWidth(i, sheet1.getColumnWidth(i) + 1500); }

            // -------------------------------------------------------------
            // SHEET 2: CHI TIẾT ĐƠN HÀNG & LÃI/LỖ TỪNG ĐƠN
            // -------------------------------------------------------------
            Sheet sheet2 = workbook.createSheet("Chi Tiết Đơn Hàng");
            sheet2.setDisplayGridlines(true);

            Row hRow2 = sheet2.createRow(0);
            String[] headers2 = {"Mã Đơn", "Ngày Tạo", "Khách Hàng", "SĐT", "Phương Thức", "Trạng Thái", "Doanh Thu Đơn", "Giá Vốn Đơn", "Lợi Nhuận Gộp", "Biên Lãi %"};
            for (int i = 0; i < headers2.length; i++) {
                Cell c = hRow2.createCell(i);
                c.setCellValue(headers2[i]);
                c.setCellStyle(headerStyle);
            }

            int r2 = 1;
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            for (OrderModel o : orders) {
                double orderRev = o.getTotalAmount() != null ? o.getTotalAmount() : 0.0;
                double orderCost = 0.0;
                List<OrderDetailModel> details = orderDAO.findOrderDetailsByOrderId(o.getId());
                if (details != null) {
                    for (OrderDetailModel d : details) {
                        double cp = d.getCostPrice() != null ? d.getCostPrice() : 0.0;
                        orderCost += (cp * d.getQuantity());
                    }
                }
                double orderProfit = orderRev - orderCost;
                double orderMargin = orderRev > 0 ? (orderProfit / orderRev) : 0.0;

                Row row = sheet2.createRow(r2++);
                row.createCell(0).setCellValue(o.getOrderCode());
                row.createCell(1).setCellValue(o.getCreatedAt() != null ? df.format(o.getCreatedAt()) : "");
                row.createCell(2).setCellValue(o.getRecipientName() != null ? o.getRecipientName() : "Khách vãng lai");
                row.createCell(3).setCellValue(o.getPhone() != null ? o.getPhone() : "");
                row.createCell(4).setCellValue(o.getPaymentMethod() != null ? o.getPaymentMethod() : "");
                row.createCell(5).setCellValue(o.getStatus() != null ? o.getStatus() : "");

                Cell cRev = row.createCell(6);
                cRev.setCellValue(orderRev);
                cRev.setCellStyle(currencyStyle);

                Cell cCost = row.createCell(7);
                cCost.setCellValue(orderCost);
                cCost.setCellStyle(currencyStyle);

                Cell cProf = row.createCell(8);
                cProf.setCellValue(orderProfit);
                cProf.setCellStyle(currencyStyle);

                Cell cMarg = row.createCell(9);
                cMarg.setCellValue(orderMargin);
                cMarg.setCellStyle(percentStyle);
            }
            for (int i = 0; i < headers2.length; i++) { sheet2.autoSizeColumn(i); }

            // -------------------------------------------------------------
            // SHEET 3: DANH MỤC TỒN KHO & ĐỊNH GIÁ VỐN SẢN PHẨM
            // -------------------------------------------------------------
            Sheet sheet3 = workbook.createSheet("Tồn Kho & Giá Vốn Sản Phẩm");
            sheet3.setDisplayGridlines(true);

            Row hRow3 = sheet3.createRow(0);
            String[] headers3 = {"Mã SP", "Tên Sản Phẩm", "Danh Mục", "Giá Bán Niêm Yết", "Giá Vốn Bình Quân", "Tồn Kho", "Tổng Giá Trị Vốn Tồn", "Tổng Giá Trị Bán Tồn"};
            for (int i = 0; i < headers3.length; i++) {
                Cell c = hRow3.createCell(i);
                c.setCellValue(headers3[i]);
                c.setCellStyle(headerStyle);
            }

            List<ProductModel> products = productDAO.findAll();
            int r3 = 1;
            if (products != null) {
                for (ProductModel p : products) {
                    double price = p.getPrice() != null ? p.getPrice() : 0.0;
                    double cost = p.getCostPrice() != null ? p.getCostPrice() : 0.0;
                    int stock = p.getStock() != null ? p.getStock() : 0;

                    Row row = sheet3.createRow(r3++);
                    row.createCell(0).setCellValue("#PRD-" + p.getId());
                    row.createCell(1).setCellValue(p.getName());
                    row.createCell(2).setCellValue(p.getCategoryName() != null ? p.getCategoryName() : "");

                    Cell cPrice = row.createCell(3);
                    cPrice.setCellValue(price);
                    cPrice.setCellStyle(currencyStyle);

                    Cell cCost = row.createCell(4);
                    cCost.setCellValue(cost);
                    cCost.setCellStyle(currencyStyle);

                    row.createCell(5).setCellValue(stock);

                    Cell cTotalCost = row.createCell(6);
                    cTotalCost.setCellValue(cost * stock);
                    cTotalCost.setCellStyle(currencyStyle);

                    Cell cTotalPrice = row.createCell(7);
                    cTotalPrice.setCellValue(price * stock);
                    cTotalPrice.setCellStyle(currencyStyle);
                }
            }
            for (int i = 0; i < headers3.length; i++) { sheet3.autoSizeColumn(i); }

            // Ghi file ra response
            String filename = "Fruitables_Bao_Cao_Tai_Chinh_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xlsx";
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
                out.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?exportError=true");
        }
    }

    private void createFinanceRow(Sheet sheet, int rowIdx, String label, Double value, CellStyle style, String note) {
        Row row = sheet.createRow(rowIdx);
        row.createCell(0).setCellValue(label);
        Cell valCell = row.createCell(1);
        if (value != null) {
            valCell.setCellValue(value);
            if (style != null) valCell.setCellStyle(style);
        }
        row.createCell(2).setCellValue(note);
    }
}
