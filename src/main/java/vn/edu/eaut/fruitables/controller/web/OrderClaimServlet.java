package vn.edu.eaut.fruitables.controller.web;

import vn.edu.eaut.fruitables.dao.IClaimDAO;
import vn.edu.eaut.fruitables.dao.IOrderDAO;
import vn.edu.eaut.fruitables.dao.impl.ClaimDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.OrderDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderDetailModel;
import vn.edu.eaut.fruitables.model.entity.OrderModel;
import vn.edu.eaut.fruitables.model.entity.OrderClaimModel;
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
import java.nio.file.Paths;
import java.util.List;

@WebServlet(urlPatterns = {"/order/claim"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class OrderClaimServlet extends HttpServlet {

    private final IOrderDAO orderDAO = new OrderDAOImpl();
    private final IClaimDAO claimDAO = new ClaimDAOImpl();
    private static final String UPLOAD_DIR = "assets/uploads/claims";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order-history");
            return;
        }

        try {
            Long orderId = Long.parseLong(orderIdStr.trim());
            OrderModel order = orderDAO.findById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            List<OrderDetailModel> details = orderDAO.findOrderDetailsByOrderId(orderId);
            order.setDetails(details);

            // Kiểm tra xem đơn này đã có khiếu nại chưa
            List<OrderClaimModel> existingClaims = claimDAO.findByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("existingClaims", existingClaims);
            request.getRequestDispatcher("/WEB-INF/views/web/order-claim.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/order-history");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        try {
            long orderId = Long.parseLong(request.getParameter("orderId"));
            long productId = Long.parseLong(request.getParameter("productId"));
            String reason = request.getParameter("reason");
            String customerNote = request.getParameter("customerNote");
            String claimSolution = request.getParameter("claimSolution");

            // Xử lý upload ảnh bằng chứng
            String proofImageUrl = null;
            try {
                Part filePart = request.getPart("proofImage");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String appPath = request.getServletContext().getRealPath("");
                    String savePath = appPath + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(savePath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                    filePart.write(savePath + File.separator + uniqueFileName);
                    proofImageUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + uniqueFileName;
                }
            } catch (Exception ignored) {}

            if (proofImageUrl == null || proofImageUrl.trim().isEmpty()) {
                // Link ảnh minh họa mẫu hoa quả bị dập
                proofImageUrl = "https://images.unsplash.com/photo-1546548970-71785318a17b?w=500";
            }

            OrderClaimModel claim = new OrderClaimModel();
            claim.setOrderId(orderId);
            claim.setUserId(user != null ? user.getId() : null);
            claim.setProductId(productId);
            claim.setReason(reason != null ? reason : "Hoa quả dập nát, hỏng trong quá trình vận chuyển");
            claim.setCustomerNote(customerNote);
            claim.setProofImageUrl(proofImageUrl);
            claim.setClaimSolution(claimSolution != null ? claimSolution : "REPLACE_PRODUCT");
            claim.setStatus("PENDING");

            claimDAO.insertClaim(claim);

            session.setAttribute("ORDER_MESSAGE_SUCCESS", "Khiếu nại của bạn đã được gửi thành công! Fruitables cam kết hoàn tiền hoặc đổi quả tươi trong 2 giờ.");
            response.sendRedirect(request.getContextPath() + "/order/claim?orderId=" + orderId + "&success=1");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("ORDER_MESSAGE_ERROR", "Không thể gửi yêu cầu khiếu nại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/order-history");
        }
    }
}
