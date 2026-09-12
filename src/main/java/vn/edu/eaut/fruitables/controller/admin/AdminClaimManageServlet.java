package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IClaimDAO;
import vn.edu.eaut.fruitables.dao.INotificationDAO;
import vn.edu.eaut.fruitables.dao.impl.ClaimDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.NotificationDAOImpl;
import vn.edu.eaut.fruitables.model.entity.OrderClaimModel;

import vn.edu.eaut.fruitables.dao.ICouponDAO;
import vn.edu.eaut.fruitables.dao.impl.CouponDAOImpl;
import vn.edu.eaut.fruitables.model.entity.CouponModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {"/admin/claims"})
public class AdminClaimManageServlet extends HttpServlet {

    private final IClaimDAO claimDAO = new ClaimDAOImpl();
    private final INotificationDAO notificationDAO = new NotificationDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<OrderClaimModel> claims = claimDAO.findAll();
        request.setAttribute("claims", claims);
        request.getRequestDispatcher("/WEB-INF/views/admin/claim-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            Long claimId = Long.parseLong(request.getParameter("claimId"));
            String action = request.getParameter("action"); // APPROVE, REJECT
            String adminNote = request.getParameter("adminNote");

            OrderClaimModel claim = claimDAO.findById(claimId);
            if (claim == null) {
                response.sendRedirect(request.getContextPath() + "/admin/claims?error=not_found");
                return;
            }

            String status = "PENDING";
            String voucherCode = null;

            if ("APPROVE".equalsIgnoreCase(action)) {
                status = "APPROVED";
                if ("REFUND_VOUCHER".equalsIgnoreCase(claim.getClaimSolution())) {
                    voucherCode = "CARE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                    try {
                        ICouponDAO couponDAO = new CouponDAOImpl();
                        CouponModel compCoupon = new CouponModel();
                        compCoupon.setCode(voucherCode);
                        compCoupon.setDiscountType("PERCENTAGE");
                        compCoupon.setDiscountValue(100.0);
                        compCoupon.setMinOrderValue(0.0);
                        compCoupon.setProductId(null);
                        compCoupon.setStartDate(new Timestamp(System.currentTimeMillis()));
                        // Hạn dùng 30 ngày
                        compCoupon.setEndDate(new Timestamp(System.currentTimeMillis() + 30L * 24 * 3600 * 1000));
                        compCoupon.setUsageLimit(1);
                        compCoupon.setStatus(true);
                        couponDAO.save(compCoupon);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                if (adminNote == null || adminNote.trim().isEmpty()) {
                    adminNote = "Fruitables chân thành xin lỗi về sự cố quả dập hỏng. Chúng tôi đã duyệt phương án " +
                            ("REFUND_VOUCHER".equalsIgnoreCase(claim.getClaimSolution()) ? "bồi thường Voucher 100%." : "đổi phần quả mới hỏa tốc gửi đến bạn.");
                }
            } else if ("REJECT".equalsIgnoreCase(action)) {
                status = "REJECTED";
                if (adminNote == null || adminNote.trim().isEmpty()) {
                    adminNote = "Yêu cầu bồi thường chưa được phê duyệt do hình ảnh hoa quả không thể hiện dấu hiệu dập hỏng theo chính sách bảo hành.";
                }
            }

            claimDAO.updateClaimStatus(claimId, status, adminNote, voucherCode);

            // Gửi Notification cho user nếu có
            if (claim.getUserId() != null && claim.getUserId() > 0) {
                try {
                    String title = "APPROVED".equals(status) ? "Khiếu nại hoa quả được duyệt đền bù" : "Phản hồi yêu cầu khiếu nại hoa quả";
                    notificationDAO.createNotification(
                            claim.getUserId(),
                            claim.getOrderId(),
                            claim.getOrderCode() != null ? claim.getOrderCode() : ("ORDER-" + claim.getOrderId()),
                            title,
                            adminNote,
                            "ORDER_CLAIM"
                    );
                } catch (Exception ignored) {}
            }

            response.sendRedirect(request.getContextPath() + "/admin/claims?msg=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/claims?error=exception");
        }
    }
}
