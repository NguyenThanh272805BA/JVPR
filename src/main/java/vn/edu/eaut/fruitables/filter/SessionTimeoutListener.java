package vn.edu.eaut.fruitables.filter;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class SessionTimeoutListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Thiết lập timeout cứng là 30 phút
        se.getSession().setMaxInactiveInterval(30 * 60);
        System.out.println("Một Session mới được tạo: " + se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // Chủ động dọn dẹp các attribute khi timeout
        se.getSession().removeAttribute("USERMODEL");
        se.getSession().removeAttribute("CART");
        System.out.println("Session đã bị hủy do timeout hoặc logout: " + se.getSession().getId());
    }
}