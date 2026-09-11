package vn.edu.eaut.fruitables.controller.admin;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/users", "/admin/users/stats", "/admin/users/detail"})
public class UserManageServlet extends HttpServlet {
    private UserDAOImpl userDAO = new UserDAOImpl();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();

        // 1. API AJAX trả số liệu tăng trưởng người dùng theo thời gian cho Chart.js
        if ("/admin/users/stats".equals(servletPath)) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            String filter = request.getParameter("filter");
            if (filter == null || filter.isEmpty()) filter = "day";
            Map<String, Object> chartData = userDAO.getUserGrowthChartData(filter);
            response.getWriter().write(gson.toJson(chartData));
            return;
        }

        // 2. API AJAX trả tóm tắt chi tiêu / đơn hàng của người dùng
        if ("/admin/users/detail".equals(servletPath)) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            String userIdStr = request.getParameter("userId");
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                userIdStr = request.getParameter("id");
            }
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    Long userId = Long.parseLong(userIdStr);
                    Map<String, Object> summary = userDAO.getUserPurchaseSummary(userId);
                    response.getWriter().write(gson.toJson(summary));
                    return;
                } catch (Exception ignored) {}
            }
            response.getWriter().write("{}");
            return;
        }

        // 3. Chuyển tiếp tới trang Quản lý Khách hàng
        response.sendRedirect(request.getContextPath() + "/admin/customers");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        // BẢO MẬT & PHÂN QUYỀN (RBAC):
        // 1. Chỉ Super Admin (Role 1) mới có quyền thay đổi vai trò hoặc trạng thái tài khoản
        if (currentUser == null || currentUser.getRoleId() == null || currentUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=permission_denied");
            return;
        }

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Integer roleId = Integer.parseInt(request.getParameter("roleId"));
            String status = request.getParameter("status");

            // 2. Chống tự khóa tài khoản hoặc tự hạ quyền (Prevent Self-Lockout & Self-Demotion)
            if (currentUser.getId().equals(id)) {
                if (roleId != 1 || "LOCKED".equalsIgnoreCase(status)) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=cannot_modify_self");
                    return;
                }
            }

            userDAO.updateUserRoleAndStatus(id, roleId, status);
            response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=system_error");
        }
    }
}