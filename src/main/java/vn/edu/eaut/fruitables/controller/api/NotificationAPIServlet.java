package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.model.entity.NotificationModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/api/notifications"})
public class NotificationAPIServlet extends HttpServlet {

    private INotificationDAO notificationDAO;
    private Gson gson;

    public NotificationAPIServlet() {
        this.notificationDAO = new NotificationDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        JsonObject jsonResponse = new JsonObject();

        if (user == null) {
            jsonResponse.addProperty("authenticated", false);
            jsonResponse.addProperty("unreadCount", 0);
            jsonResponse.add("notifications", gson.toJsonTree(List.of()));
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        int unreadCount = notificationDAO.countUnread(user.getId());
        List<NotificationModel> notifications = notificationDAO.findByUserId(user.getId(), 10);

        jsonResponse.addProperty("authenticated", true);
        jsonResponse.addProperty("unreadCount", unreadCount);
        jsonResponse.add("notifications", gson.toJsonTree(notifications));

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        JsonObject jsonResponse = new JsonObject();

        if (user == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("mark_all_read".equals(action)) {
                notificationDAO.markAllAsRead(user.getId());
                jsonResponse.addProperty("success", true);
            } else if ("mark_read".equals(action)) {
                Long id = Long.parseLong(request.getParameter("id"));
                notificationDAO.markAsRead(id, user.getId());
                jsonResponse.addProperty("success", true);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hành động không hợp lệ");
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
