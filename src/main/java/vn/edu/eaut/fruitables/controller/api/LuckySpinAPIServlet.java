package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IUserDAO;
import vn.edu.eaut.fruitables.dao.impl.UserDAOImpl;
import vn.edu.eaut.fruitables.model.dto.LuckySpinResult;
import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
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
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/api/lucky-spin"})
public class LuckySpinAPIServlet extends HttpServlet {

    private ILuckySpinService luckySpinService;
    private IUserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.luckySpinService = new LuckySpinServiceImpl();
        this.userDAO = new UserDAOImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        UserModel sessionUser = (UserModel) session.getAttribute("USERMODEL");

        String action = request.getParameter("action");
        if (action == null) action = "spin";

        JsonObject jsonResponse = new JsonObject();

        if (sessionUser == null) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("authenticated", false);
            jsonResponse.addProperty("message", "Vui lòng đăng nhập tài khoản để tham gia Vòng quay may mắn!");
            out.print(gson.toJson(jsonResponse));
            out.flush();
            return;
        }

        Long userId = sessionUser.getId();

        try {
            switch (action) {
                case "spin": {
                    LuckySpinResult result = luckySpinService.spinWheel(userId);

                    // Đồng bộ lại lượt quay vào session
                    UserModel fresh = userDAO.findById(userId);
                    if (fresh != null) {
                        session.setAttribute("USERMODEL", fresh);
                    }

                    out.print(gson.toJson(result));
                    out.flush();
                    return;
                }

                case "claim_daily": {
                    boolean success = luckySpinService.claimDailyFreeSpin(userId);
                    UserModel fresh = userDAO.findById(userId);
                    if (fresh != null) {
                        session.setAttribute("USERMODEL", fresh);
                    }

                    jsonResponse.addProperty("success", success);
                    if (success) {
                        jsonResponse.addProperty("message", "🎉 Điểm danh thành công! Bạn nhận được +1 lượt quay miễn phí hôm nay.");
                        jsonResponse.addProperty("remainingSpins", fresh != null ? fresh.getSpinCount() : 1);
                    } else {
                        jsonResponse.addProperty("message", "Bạn đã điểm danh nhận lượt quay hôm nay rồi! Hãy quay lại vào ngày mai nhé 🌿");
                        jsonResponse.addProperty("remainingSpins", fresh != null ? fresh.getSpinCount() : 0);
                    }
                    break;
                }

                case "wallet": {
                    List<LuckySpinHistoryModel> wallet = luckySpinService.getUserRewardWallet(userId);
                    jsonResponse.addProperty("success", true);
                    jsonResponse.add("rewards", gson.toJsonTree(wallet));
                    break;
                }

                default:
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Hành động không hợp lệ.");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Đã xảy ra sự cố khi xử lý quay thưởng: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
