package vn.edu.eaut.fruitables.controller.admin;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/employees"})
public class AdminEmployeeServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAOImpl();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String roleIdStr = request.getParameter("roleId");
        String status = request.getParameter("status");

        Integer roleId = null;
        if (roleIdStr != null && !roleIdStr.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleIdStr)) {
            try {
                roleId = Integer.parseInt(roleIdStr);
            } catch (Exception ignored) {}
        }

        List<UserModel> employees = userDAO.findEmployees(keyword, roleId, status);
        Map<String, Object> employeeStats = userDAO.getEmployeeStats();

        request.setAttribute("employees", employees);
        request.setAttribute("employeeStats", employeeStats);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedRoleId", roleIdStr);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/WEB-INF/views/admin/employee-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        // BẢO MẬT & PHÂN QUYỀN (RBAC):
        // Chỉ Super Admin (Role 1) mới có quyền tạo nhân viên hoặc thay đổi phân quyền nội bộ
        if (currentUser == null || currentUser.getRoleId() == null || currentUser.getRoleId() != 1) {
            String isAjax = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equalsIgnoreCase(isAjax)) {
                Map<String, Object> err = new HashMap<>();
                err.put("success", false);
                err.put("message", "Từ chối truy cập: Chỉ Quản trị viên cấp cao nhất (Super Admin) mới có quyền phân bổ nhân sự!");
                response.getWriter().write(gson.toJson(err));
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/employees?error=permission_denied");
            return;
        }

        String action = request.getParameter("action");
        Map<String, Object> result = new HashMap<>();
        boolean success = false;
        String message = "";

        try {
            if ("create".equals(action)) {
                String fullName = request.getParameter("fullName");
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String password = request.getParameter("password");
                String roleIdStr = request.getParameter("roleId");
                String vehiclePlate = request.getParameter("vehiclePlate");

                if (fullName == null || fullName.trim().isEmpty() ||
                    password == null || password.trim().isEmpty() ||
                    roleIdStr == null || roleIdStr.trim().isEmpty()) {
                    message = "Vui lòng nhập đầy đủ các trường bắt buộc!";
                } else if (username != null && !username.trim().isEmpty() && userDAO.existsByUsername(username.trim())) {
                    message = "Tên đăng nhập '" + username + "' đã tồn tại!";
                } else if (email != null && !email.trim().isEmpty() && userDAO.existsByEmail(email.trim())) {
                    message = "Email '" + email + "' đã tồn tại!";
                } else {
                    int roleId = Integer.parseInt(roleIdStr);
                    UserModel newEmp = new UserModel();
                    newEmp.setFullName(fullName.trim());
                    newEmp.setUsername((username != null && !username.trim().isEmpty()) ? username.trim() : null);
                    newEmp.setEmail((email != null && !email.trim().isEmpty()) ? email.trim() : null);
                    newEmp.setPhone(phone != null ? phone.trim() : null);
                    newEmp.setRoleId(roleId);
                    newEmp.setPasswordHash(SecurityUtil.hashPassword(password.trim()));
                    newEmp.setStatus("ACTIVE");

                    Long newId = userDAO.createEmployee(newEmp, vehiclePlate);
                    if (newId != null) {
                        success = true;
                        message = "Tạo mới tài khoản nhân viên thành công (ID: #" + newId + ")!";
                    } else {
                        message = "Lỗi khi lưu thông tin nhân viên vào cơ sở dữ liệu!";
                    }
                }

            } else if ("update_role".equals(action)) {
                Long userId = Long.parseLong(request.getParameter("userId"));
                int newRoleId = Integer.parseInt(request.getParameter("roleId"));
                String status = request.getParameter("status");
                String vehiclePlate = request.getParameter("vehiclePlate");

                // Cơ chế bảo vệ an toàn: Chống Super Admin tự khóa hoặc tự giáng cấp chính mình
                if (currentUser.getId().equals(userId)) {
                    if (newRoleId != 1 || "LOCKED".equalsIgnoreCase(status)) {
                        message = "Bạn không thể tự khóa tài khoản hoặc tự hạ quyền quản trị của chính mình!";
                        result.put("success", false);
                        result.put("message", message);
                        response.getWriter().write(gson.toJson(result));
                        return;
                    }
                }

                success = userDAO.updateEmployeeRoleAndStatus(userId, newRoleId, status, vehiclePlate);
                message = success ? "Cập nhật vai trò và trạng thái nhân viên thành công!" : "Lỗi khi cập nhật nhân viên!";

            } else if ("toggle_status".equals(action)) {
                Long userId = Long.parseLong(request.getParameter("userId"));
                String status = request.getParameter("status");

                if (currentUser.getId().equals(userId)) {
                    message = "Không thể tự khóa tài khoản của chính mình!";
                } else {
                    UserModel target = userDAO.findById(userId);
                    if (target != null) {
                        userDAO.updateUserRoleAndStatus(userId, target.getRoleId(), status);
                        success = true;
                        message = "Đã đổi trạng thái tài khoản thành " + status;
                    } else {
                        message = "Không tìm thấy tài khoản nhân viên!";
                    }
                }
            } else {
                message = "Hành động không hợp lệ!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Lỗi hệ thống: " + e.getMessage();
        }

        result.put("success", success);
        result.put("message", message);

        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(isAjax) || "true".equalsIgnoreCase(request.getParameter("ajax"))) {
            response.getWriter().write(gson.toJson(result));
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/employees?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }
}
