package vn.edu.eaut.fruitables.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

// Bắt TẤT CẢ các request (/*) để ép kiểu dữ liệu
@WebFilter(urlPatterns = {"/*"})
public class UTF8EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // 1. Ép kiểu UTF-8 cho dữ liệu người dùng gửi lên (Request)
        request.setCharacterEncoding("UTF-8");

        // 2. Ép kiểu UTF-8 cho dữ liệu trả về trình duyệt (Response)
        response.setCharacterEncoding("UTF-8");

        // Cho phép request tiếp tục đi tới các Servlet
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Hủy filter
    }
}