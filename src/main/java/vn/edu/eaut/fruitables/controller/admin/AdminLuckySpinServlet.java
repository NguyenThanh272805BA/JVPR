package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinPrizeModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.ILuckySpinService;
import vn.edu.eaut.fruitables.service.impl.LuckySpinServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/admin/lucky-spin"})
public class AdminLuckySpinServlet extends HttpServlet {

    private ILuckySpinService luckySpinService;
    private IUserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.luckySpinService = new LuckySpinServiceImpl();
        this.userDAO = new UserDAOImpl();
    }

    private boolean checkAdminAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAuth(request, response)) return;

        Map<String, Object> stats = luckySpinService.getAdminStatistics();
        List<LuckySpinPrizeModel> prizes = luckySpinService.getAllPrizesForAdmin();
        List<LuckySpinHistoryModel> history = luckySpinService.getRecentSpinsForAdmin(60);

        request.setAttribute("stats", stats);
        request.setAttribute("prizes", prizes);
        request.setAttribute("history", history);

        request.getRequestDispatcher("/WEB-INF/views/admin/lucky-spin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!checkAdminAuth(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "save_prize";

        try {
            switch (action) {
                case "save_prize": {
                    String idStr = request.getParameter("id");
                    String name = request.getParameter("name");
                    String prizeType = request.getParameter("prizeType");
                    String discountValueStr = request.getParameter("discountValue");
                    String minOrderValueStr = request.getParameter("minOrderValue");
                    String probabilityStr = request.getParameter("probability");
                    String quantityLimitStr = request.getParameter("quantityLimit");
                    String colorBg = request.getParameter("colorBg");
                    String colorText = request.getParameter("colorText");
                    String iconType = request.getParameter("iconType");
                    String displayOrderStr = request.getParameter("displayOrder");
                    String statusStr = request.getParameter("status");

                    LuckySpinPrizeModel prize = new LuckySpinPrizeModel();
                    prize.setName(name != null ? name.trim() : "Phần thưởng");
                    prize.setPrizeType(prizeType != null ? prizeType.trim() : "DISCOUNT_AMOUNT");
                    prize.setDiscountValue(discountValueStr != null && !discountValueStr.isEmpty() ? Double.parseDouble(discountValueStr) : 0.0);
                    prize.setMinOrderValue(minOrderValueStr != null && !minOrderValueStr.isEmpty() ? Double.parseDouble(minOrderValueStr) : 0.0);
                    prize.setProbability(probabilityStr != null && !probabilityStr.isEmpty() ? Double.parseDouble(probabilityStr) : 10.0);
                    int limit = (quantityLimitStr != null && !quantityLimitStr.isEmpty()) ? Integer.parseInt(quantityLimitStr) : -1;
                    prize.setQuantityLimit(limit);
                    prize.setQuantityRemain(limit);
                    prize.setColorBg(colorBg != null && !colorBg.isEmpty() ? colorBg : "#10B981");
                    prize.setColorText(colorText != null && !colorText.isEmpty() ? colorText : "#FFFFFF");
                    prize.setIconType(iconType != null && !iconType.isEmpty() ? iconType : "voucher");
                    prize.setDisplayOrder(displayOrderStr != null && !displayOrderStr.isEmpty() ? Integer.parseInt(displayOrderStr) : 0);
                    prize.setStatus(statusStr != null ? Boolean.parseBoolean(statusStr) : true);

                    if (idStr != null && !idStr.trim().isEmpty() && !idStr.equals("0")) {
                        prize.setId(Integer.parseInt(idStr.trim()));
                        // Nếu là update, giữ lại số lượng còn lại nếu quota không đổi
                        LuckySpinPrizeModel existing = luckySpinService.getPrizeById(prize.getId());
                        if (existing != null && existing.getQuantityLimit().equals(limit)) {
                            prize.setQuantityRemain(existing.getQuantityRemain());
                        }
                        luckySpinService.updatePrize(prize);
                        request.getSession().setAttribute("ADMIN_FLASH_MSG", "Cập nhật giải thưởng thành công!");
                    } else {
                        luckySpinService.savePrize(prize);
                        request.getSession().setAttribute("ADMIN_FLASH_MSG", "Tạo giải thưởng mới thành công!");
                    }
                    break;
                }

                case "toggle_status": {
                    int prizeId = Integer.parseInt(request.getParameter("id"));
                    boolean newStatus = Boolean.parseBoolean(request.getParameter("status"));
                    luckySpinService.togglePrizeStatus(prizeId, newStatus);
                    request.getSession().setAttribute("ADMIN_FLASH_MSG", "Đã cập nhật trạng thái giải thưởng!");
                    break;
                }

                case "reset_quota": {
                    int prizeId = Integer.parseInt(request.getParameter("id"));
                    int newQuota = Integer.parseInt(request.getParameter("quota"));
                    luckySpinService.resetPrizeQuota(prizeId, newQuota);
                    request.getSession().setAttribute("ADMIN_FLASH_MSG", "Đã đặt lại kho số lượng giải thưởng!");
                    break;
                }

                case "delete_prize": {
                    int prizeId = Integer.parseInt(request.getParameter("id"));
                    luckySpinService.deletePrize(prizeId);
                    request.getSession().setAttribute("ADMIN_FLASH_MSG", "Đã xóa giải thưởng khỏi bánh xe!");
                    break;
                }

                case "grant_spins": {
                    String userIdentifier = request.getParameter("userIdentifier"); // SĐT hoặc ID hoặc Username
                    int spinAmount = Integer.parseInt(request.getParameter("spinAmount"));

                    UserModel target = null;
                    if (userIdentifier != null && !userIdentifier.trim().isEmpty()) {
                        String iden = userIdentifier.trim();
                        try {
                            target = userDAO.findById(Long.parseLong(iden));
                        } catch (NumberFormatException ignored) {}

                        if (target == null) {
                            target = userDAO.findByUsernameOrPhoneOrEmail(iden);
                        }
                    }

                    if (target != null) {
                        luckySpinService.grantUserSpins(target.getId(), spinAmount);
                        request.getSession().setAttribute("ADMIN_FLASH_MSG", "Đã tặng " + spinAmount + " lượt quay cho khách hàng: " + target.getFullName() + " (" + target.getPhone() + ")!");
                    } else {
                        request.getSession().setAttribute("ADMIN_FLASH_ERR", "Không tìm thấy khách hàng với thông tin: " + userIdentifier);
                    }
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("ADMIN_FLASH_ERR", "Lỗi: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/lucky-spin");
    }
}
