package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IChatDAO;
import vn.edu.eaut.fruitables.dao.impl.ChatDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/chat"})
public class AdminChatServlet extends HttpServlet {

    private IChatDAO chatDAO;

    public AdminChatServlet() {
        this.chatDAO = new ChatDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalUnread = chatDAO.countTotalUnreadForAdmin();
        request.setAttribute("totalUnread", totalUnread);
        request.getRequestDispatcher("/WEB-INF/views/admin/chat.jsp").forward(request, response);
    }
}
