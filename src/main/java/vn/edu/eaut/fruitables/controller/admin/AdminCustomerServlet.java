package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IUserDAO;
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

@WebServlet(urlPatterns = {"/admin/customers"})
public class AdminCustomerServlet extends HttpServlet {

    private final IUserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String loginType = request.getParameter("loginType");

        List<UserModel> customers = userDAO.findCustomers(keyword, status, loginType);
        Map<String, Object> customerStats = userDAO.getCustomerStats();

        request.setAttribute("customers", customers);
        request.setAttribute("customerStats", customerStats);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedLoginType", loginType);

        request.getRequestDispatcher("/WEB-INF/views/admin/customer-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;

        // Bảo mật RBAC: Chỉ Super Admin (1) hoặc Sale (2) được quyền quản lý khách hàng
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/admin/customers?error=permission_denied");
            return;
        }

        try {
            Long customerId = Long.parseLong(request.getParameter("customerId"));
            String status = request.getParameter("status");

            if ("LOCKED".equalsIgnoreCase(status) || "ACTIVE".equalsIgnoreCase(status)) {
                userDAO.updateUserRoleAndStatus(customerId, 3, status);
                response.sendRedirect(request.getContextPath() + "/admin/customers?msg=status_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/customers?error=invalid_status");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/customers?error=system_error");
        }
    }
}
