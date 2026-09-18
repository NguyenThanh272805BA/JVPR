package vn.edu.eaut.fruitables.controller.admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/device-preview"})
public class AdminDevicePreviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Danh sách các trang mẫu kiểm tra giao diện đa thiết bị
        List<Map<String, String>> samplePages = new ArrayList<>();

        addPage(samplePages, "Trang chủ (Home)", "/home", "Trang landing page chính của hệ thống");
        addPage(samplePages, "Cửa hàng sản phẩm (Shop)", "/shop", "Danh mục hàng hóa, bộ lọc, phân trang");
        addPage(samplePages, "Chi tiết sản phẩm (Product Detail)", "/product-detail?id=1", "Thông tin sản phẩm, hình ảnh, đánh giá");
        addPage(samplePages, "Giỏ hàng (Cart)", "/cart", "Danh sách sản phẩm trong giỏ, mã giảm giá");
        addPage(samplePages, "Thanh toán (Checkout)", "/checkout", "Biểu mẫu địa chỉ, phương thức thanh toán");
        addPage(samplePages, "Khuyến mãi & Voucher (Promotions)", "/promotions", "Vòng quay may mắn & danh sách coupon");
        addPage(samplePages, "Đăng nhập (Login)", "/login", "Form đăng nhập tài khoản");
        addPage(samplePages, "Đăng ký (Register)", "/register", "Form tạo tài khoản mới");
        addPage(samplePages, "Hồ sơ cá nhân (Profile)", "/profile", "Thông tin tài khoản khách hàng");
        addPage(samplePages, "Lịch sử đơn hàng (Order History)", "/order-history", "Quản lý các đơn hàng đã đặt");
        addPage(samplePages, "Tra cứu đơn hàng (Order Tracking)", "/guest-order-tracking", "Tra cứu đơn hàng cho khách vãng lai");

        // Lấy URL khởi tạo nếu người dùng truyền qua param (hoặc mặc định /home)
        String initialPath = request.getParameter("target");
        if (initialPath == null || initialPath.trim().isEmpty()) {
            initialPath = "/home";
        }

        request.setAttribute("samplePages", samplePages);
        request.setAttribute("initialPath", initialPath);

        // Chuyển hướng tới view JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/device-preview.jsp").forward(request, response);
    }

    private void addPage(List<Map<String, String>> list, String name, String path, String desc) {
        Map<String, String> page = new HashMap<>();
        page.put("name", name);
        page.put("path", path);
        page.put("desc", desc);
        list.add(page);
    }
}
