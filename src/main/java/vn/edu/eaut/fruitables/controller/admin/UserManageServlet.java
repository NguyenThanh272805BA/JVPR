package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/users"})
public class UserManageServlet extends HttpServlet {
    private UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", userDAO.findAllUsers());
        request.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Integer roleId = Integer.parseInt(request.getParameter("roleId"));
        String status = request.getParameter("status");

        userDAO.updateUserRoleAndStatus(id, roleId, status);
        response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
    }
}