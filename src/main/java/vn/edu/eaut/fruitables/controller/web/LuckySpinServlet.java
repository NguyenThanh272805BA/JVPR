package vn.edu.eaut.fruitables.controller.web;

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
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/lucky-spin"})
public class LuckySpinServlet extends HttpServlet {

    private ILuckySpinService luckySpinService;
    private IUserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.luckySpinService = new LuckySpinServiceImpl();
        this.userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserModel sessionUser = (UserModel) session.getAttribute("USERMODEL");

        // Lấy danh sách giải thưởng đang mở trên vòng quay
        List<LuckySpinPrizeModel> activePrizes = luckySpinService.getActiveWheelPrizes();
        request.setAttribute("activePrizes", activePrizes);

        int userSpins = 0;
        boolean canClaimDaily = false;
        List<LuckySpinHistoryModel> userRewards = null;

        if (sessionUser != null) {
            UserModel freshUser = userDAO.findById(sessionUser.getId());
            if (freshUser != null) {
                session.setAttribute("USERMODEL", freshUser);
                userSpins = freshUser.getSpinCount();

                // Kiểm tra xem hôm nay đã điểm danh chưa
                Date lastDate = freshUser.getLastDailySpinDate();
                Date today = new Date(System.currentTimeMillis());
                canClaimDaily = (lastDate == null || !lastDate.toString().equals(today.toString()));
            } else {
                userSpins = sessionUser.getSpinCount();
            }

            // Lấy danh sách phần thưởng trong Ví quà tặng của user
            userRewards = luckySpinService.getUserRewardWallet(sessionUser.getId());
        }

        request.setAttribute("userSpins", userSpins);
        request.setAttribute("canClaimDaily", canClaimDaily);
        request.setAttribute("userRewards", userRewards);

        request.getRequestDispatcher("/WEB-INF/views/web/lucky-spin.jsp").forward(request, response);
    }
}
