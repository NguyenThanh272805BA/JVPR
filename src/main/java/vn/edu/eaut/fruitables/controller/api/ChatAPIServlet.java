package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IChatDAO;
import vn.edu.eaut.fruitables.dao.impl.ChatDAOImpl;
import vn.edu.eaut.fruitables.model.entity.ChatMessageModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = {"/api/chat"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 20)
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

            int unread = chatDAO.countUnreadForUser(user.getId());
            List<ChatMessageModel> messages = chatDAO.findByUserId(user.getId(), 100);
            chatDAO.markAsReadByUser(user.getId());

            jsonResponse.add("messages", gson.toJsonTree(messages));
            jsonResponse.addProperty("unread", unread);
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }

    private String getFormFieldValue(HttpServletRequest request, String name) {
        String val = request.getParameter(name);
        if (val != null && !val.trim().isEmpty()) {
            return val.trim();
        }
        try {
            Part part = request.getPart(name);
            if (part != null && part.getSize() > 0) {
                try (java.io.InputStream is = part.getInputStream();
                     java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream()) {
                    byte[] buffer = new byte[1024];
                    int len;
                    while ((len = is.read(buffer)) != -1) {
                        baos.write(buffer, 0, len);
                    }
                    String partVal = baos.toString("UTF-8").trim();
                    if (!partVal.isEmpty()) {
                        return partVal;
                    }
                }
            }
        } catch (Exception ignored) {}
        return (val != null) ? val.trim() : null;
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

        String message = getFormFieldValue(request, "message");

        // Xử lý upload ảnh đính kèm (nếu có)
        String uploadedImageUrl = null;
        try {
            Part filePart = null;
            try {
                filePart = request.getPart("chatImage");
                if (filePart == null || filePart.getSize() == 0) {
                    filePart = request.getPart("image");
                }
            } catch (Exception ignored) {}

            // Fallback tìm part có tên file nếu tên field khác
            if (filePart == null || filePart.getSize() == 0) {
                try {
                    for (Part p : request.getParts()) {
                        if (p.getSubmittedFileName() != null && !p.getSubmittedFileName().trim().isEmpty() && p.getSize() > 0) {
                            filePart = p;
                            break;
                        }
                    }
                } catch (Exception ignored) {}
            }

            if (filePart != null && filePart.getSize() > 0) {
                String rawFileName = filePart.getSubmittedFileName();
                if (rawFileName != null && !rawFileName.trim().isEmpty()) {
                    String submittedFileName = Paths.get(rawFileName).getFileName().toString();
                    String fileExt = "";
                    int dotIdx = submittedFileName.lastIndexOf('.');
                    if (dotIdx >= 0) {
                        fileExt = submittedFileName.substring(dotIdx).toLowerCase();
                    }

                    if (fileExt.matches("\\.(jpg|jpeg|png|webp|gif)$")) {
                        String uploadDirRel = "assets/uploads/chat";
                        String applicationPath = request.getServletContext().getRealPath("");
                        if (applicationPath == null) {
                            applicationPath = System.getProperty("catalina.base") + File.separator + "webapps" + request.getContextPath();
                        }
                        File uploadDir = new File(applicationPath, uploadDirRel);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        String uniqueFileName = "chat_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + fileExt;
                        File targetFile = new File(uploadDir, uniqueFileName);
                        filePart.write(targetFile.getAbsolutePath());

                        // Lưu dự phòng vào thư mục nguồn để không bị xóa khi redeploy
                        try {
                            File srcDir = new File("d:/JavaPRJ/Fruitables-Web-App/src/main/webapp/assets/uploads/chat");
                            if (!srcDir.exists()) {
                                srcDir.mkdirs();
                            }
                            Files.copy(targetFile.toPath(), new File(srcDir, uniqueFileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
                        } catch (Exception ignored) {}

                        uploadedImageUrl = request.getContextPath() + "/" + uploadDirRel + "/" + uniqueFileName;
                    }
                }
            }
        } catch (Exception uploadErr) {
            System.err.println("[ChatAPIServlet] Upload error: " + uploadErr.getMessage());
        }

        // Nếu gửi kèm ảnh mà không gõ tin nhắn, gán nhãn [Hình ảnh] để lưu DB
        if (uploadedImageUrl != null && (message == null || message.isEmpty())) {
            message = "[Hình ảnh]";
        }

        // Kiểm tra hợp lệ: Phải có ít nhất tin nhắn hoặc ảnh
        if ((message == null || message.isEmpty()) && uploadedImageUrl == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Nội dung tin nhắn không được để trống.");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        boolean isAdmin = (user.getRoleId() != null && (user.getRoleId() == 1 || user.getRoleId() == 2));

        try {
            if (isAdmin) {
                String targetUserIdStr = getFormFieldValue(request, "targetUserId");
                if (targetUserIdStr == null || targetUserIdStr.trim().isEmpty()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Thiếu targetUserId khách hàng.");
                } else {
                    Long targetUserId = Long.parseLong(targetUserIdStr);
                    Long msgId = chatDAO.sendMessage(targetUserId, "ADMIN", user.getId(), message, uploadedImageUrl);
                    jsonResponse.addProperty("success", msgId != null);
                    if (uploadedImageUrl != null) jsonResponse.addProperty("imageUrl", uploadedImageUrl);
                }
            } else {
                Long msgId = chatDAO.sendMessage(user.getId(), "USER", null, message, uploadedImageUrl);
                jsonResponse.addProperty("success", msgId != null);
                if (uploadedImageUrl != null) jsonResponse.addProperty("imageUrl", uploadedImageUrl);
            }
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("error", e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
