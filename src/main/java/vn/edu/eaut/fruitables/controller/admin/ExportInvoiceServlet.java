package vn.edu.eaut.fruitables.controller.admin;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.Locale;

@WebServlet(urlPatterns = {"/admin/orders/export-invoice"})
public class ExportInvoiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderCode = request.getParameter("orderCode");

        // Báo cho trình duyệt biết chuẩn bị tải file PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Invoice_" + orderCode + ".pdf\"");

        try (Connection conn = DBConnectionUtil.getConnection()) {
            // Lấy thông tin đơn hàng và người dùng
            String sqlOrder = "SELECT o.*, u.full_name FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.order_code = ?";
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder);
            psOrder.setString(1, orderCode);
            ResultSet rsOrder = psOrder.executeQuery();

            if (rsOrder.next()) {
                Document document = new Document();
                PdfWriter.getInstance(document, response.getOutputStream());
                document.open();

                // Format tiền tệ chuẩn Việt Nam
                Locale localeVN = new Locale("vi", "VN");
                NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(localeVN);

                String customerName = rsOrder.getString("full_name") != null ? rsOrder.getString("full_name") : "Khach vang lai";
                double totalAmount = rsOrder.getDouble("total_amount");
                String address = rsOrder.getString("shipping_address");
                String phone = rsOrder.getString("phone");

                // Viết Header Hóa Đơn (sử dụng tiếng Việt không dấu để tránh lỗi font iTextPDF mặc định)
                document.add(new Paragraph("HOA DON MUA HANG - FRUITABLES"));
                document.add(new Paragraph("Ma don hang: " + orderCode));
                document.add(new Paragraph("Khach hang: " + customerName));
                document.add(new Paragraph("So dien thoai: " + phone));
                document.add(new Paragraph("Dia chi nhan: " + address));
                document.add(new Paragraph("-------------------------------------------------"));

                // Lấy chi tiết sản phẩm thuộc đơn hàng và tính thuế
                String sqlDetail = "SELECT od.*, p.name FROM order_details od JOIN products p ON od.product_id = p.id WHERE od.order_id = ?";
                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                psDetail.setLong(1, rsOrder.getLong("id"));
                ResultSet rsDetail = psDetail.executeQuery();

                double totalTax = 0;
                while (rsDetail.next()) {
                    String pName = rsDetail.getString("name");
                    int qty = rsDetail.getInt("quantity");
                    double price = rsDetail.getDouble("price");
                    double subTotal = rsDetail.getDouble("sub_total");
                    double taxRate = rsDetail.getDouble("tax_rate");

                    // Tính tiền thuế riêng cho từng sản phẩm
                    double taxAmount = (subTotal * taxRate) / 100;
                    totalTax += taxAmount;

                    // In từng dòng sản phẩm
                    document.add(new Paragraph("- " + pName + " | SL: " + qty + " | Gia: " + currencyFormat.format(price)));
                }

                document.add(new Paragraph("-------------------------------------------------"));
                document.add(new Paragraph("Tien thue VAT: " + currencyFormat.format(totalTax)));
                document.add(new Paragraph("Tong thanh toan: " + currencyFormat.format(totalAmount)));

                String paymentStatus = rsOrder.getString("payment_status");
                document.add(new Paragraph("Trang thai: " + ("PAID".equals(paymentStatus) ? "Da thanh toan" : "Chua thanh toan")));

                document.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}