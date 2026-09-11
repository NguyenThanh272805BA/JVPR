package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

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
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(urlPatterns = {"/profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10) // Tối đa 5MB cho Avatar
public class ProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "assets/uploads/avatars";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        vn.edu.eaut.fruitables.dao.IUserDAO userDAO = new vn.edu.eaut.fruitables.dao.impl.UserDAOImpl();
        UserModel freshUser = userDAO.findById(user.getId());
        if (freshUser != null) {
            session.setAttribute("USERMODEL", freshUser);
        }
        request.getRequestDispatcher("/WEB-INF/views/web/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        if (user != null) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Xử lý Upload Avatar
            Part filePart = request.getPart("avatarFile");
            String fileName = extractFileName(filePart);
            String dbAvatarUrl = user.getAvatarUrl(); // Giữ nguyên ảnh cũ nếu không up ảnh mới

            if (fileName != null && !fileName.isEmpty()) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) {
                    fileSaveDir.mkdirs();
                }

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                filePart.write(uploadFilePath + File.separator + uniqueFileName);
                dbAvatarUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
            }

            String sql = "UPDATE users SET full_name = ?, phone = ?, address = ?, avatar_url = ? WHERE id = ?";
            try (Connection conn = DBConnectionUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, phone);
                ps.setString(3, address);
                ps.setString(4, dbAvatarUrl);
                ps.setLong(5, user.getId());

                if (ps.executeUpdate() > 0) {
                    user.setFullName(fullName);
                    user.setPhone(phone);
                    user.setAddress(address);
                    user.setAvatarUrl(dbAvatarUrl);
                    session.setAttribute("USERMODEL", user);
                    request.setAttribute("message", "Cập nhật thông tin thành công!");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/web/profile.jsp").forward(request, response);
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}