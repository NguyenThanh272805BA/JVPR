package vn.edu.eaut.fruitables.controller.admin;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/orders/export-invoice"})
public class ExportInvoiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderCode = request.getParameter("orderCode");

        // Báo cho trình duyệt biết chuẩn bị tải file PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Invoice_" + orderCode + ".pdf\"");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Ghi nội dung vào PDF (Thực tế sẽ móc DB ra để in chi tiết đơn)
            document.add(new Paragraph("HOA DON MUA HANG - FRUITABLES"));
            document.add(new Paragraph("Ma don hang: " + orderCode));
            document.add(new Paragraph("Khach hang: Nguyen Kim Thanh"));
            document.add(new Paragraph("-------------------------------------------------"));
            document.add(new Paragraph("1. Tao Gala Huu Co   - So luong: 2 - Gia: 230,000 VND"));
            document.add(new Paragraph("-------------------------------------------------"));
            document.add(new Paragraph("Tong thanh toan: 230,000 VND"));
            document.add(new Paragraph("Trang thai: Da thanh toan (VNPAY)"));

            document.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}