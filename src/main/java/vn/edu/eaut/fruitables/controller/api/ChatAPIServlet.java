package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IChatDAO;
import vn.edu.eaut.fruitables.dao.impl.ChatDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ChatMessageModel;
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
import java.util.Map;

@WebServlet(urlPatterns = {"/api/chat"})
public class ChatAPIServlet extends HttpServlet {

    private IChatDAO chatDAO;
    private Gson gson;

    public ChatAPIServlet() {
        this.chatDAO = new ChatDAOImpl();
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
            jsonResponse.add("messages", gson.toJsonTree(List.of()));
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        boolean isAdmin = (user.getRoleId() != null && (user.getRoleId() == 1 || user.getRoleId() == 2));
        String action = request.getParameter("action");

        if (isAdmin) {
            jsonResponse.addProperty("authenticated", true);
            jsonResponse.addProperty("isAdmin", true);

            if ("conversations".equals(action)) {
                List<Map<String, Object>> convs = chatDAO.findActiveChatUsers();
                int totalUnread = chatDAO.countTotalUnreadForAdmin();
                jsonResponse.add("conversations", gson.toJsonTree(convs));
                jsonResponse.addProperty("totalUnread", totalUnread);
            } else {
                String targetUserIdStr = request.getParameter("targetUserId");
                if (targetUserIdStr != null && !targetUserIdStr.trim().isEmpty()) {
                    try {
                        Long targetUserId = Long.parseLong(targetUserIdStr);
                        List<ChatMessageModel> messages = chatDAO.findByUserId(targetUserId, 100);
                        chatDAO.markAsReadByAdmin(targetUserId);
                        jsonResponse.add("messages", gson.toJsonTree(messages));
                    } catch (NumberFormatException e) {
                        jsonResponse.add("messages", gson.toJsonTree(List.of()));
                    }
                } else {
                    jsonResponse.add("messages", gson.toJsonTree(List.of()));
                }
            }
        } else {
            // Khách hàng thông thường
            jsonResponse.addProperty("authenticated", true);
            jsonResponse.addProperty("isAdmin", false);

            List<ChatMessageModel> messages = chatDAO.findByUserId(user.getId(), 100);
            chatDAO.markAsReadByUser(user.getId());
            int unread = chatDAO.countUnreadForUser(user.getId());

            jsonResponse.add("messages", gson.toJsonTree(messages));
            jsonResponse.addProperty("unread", unread);
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        JsonObject jsonResponse = new JsonObject();

        if (user == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập để sử dụng chat.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        String message = request.getParameter("message");
        if (message == null || message.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Nội dung tin nhắn không được để trống.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        message = message.trim();
        boolean isAdmin = (user.getRoleId() != null && (user.getRoleId() == 1 || user.getRoleId() == 2));

        try {
            if (isAdmin) {
                String targetUserIdStr = request.getParameter("targetUserId");
                if (targetUserIdStr == null || targetUserIdStr.trim().isEmpty()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thiếu targetUserId khách hàng.");
                } else {
                    Long targetUserId = Long.parseLong(targetUserIdStr);
                    Long msgId = chatDAO.sendMessage(targetUserId, "ADMIN", user.getId(), message);
                    jsonResponse.addProperty("success", msgId != null);
                }
            } else {
                Long msgId = chatDAO.sendMessage(user.getId(), "USER", null, message);
                jsonResponse.addProperty("success", msgId != null);
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
