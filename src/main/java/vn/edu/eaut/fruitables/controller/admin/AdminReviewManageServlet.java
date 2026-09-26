package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IReviewDAO;
import vn.edu.eaut.fruitables.dao.impl.ReviewDAOImpl;
import vn.edu.eaut.fruitables.model.dto.ReviewAnalysisDTO;
import vn.edu.eaut.fruitables.model.entity.ReviewModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;
import vn.edu.eaut.fruitables.service.IGeminiService;
import vn.edu.eaut.fruitables.service.impl.GeminiServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/reviews"})
public class AdminReviewManageServlet extends HttpServlet {

    private final IReviewDAO reviewDAO = new ReviewDAOImpl();
    private final IGeminiService geminiService = new GeminiServiceImpl();
    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;
        if (currentUser == null || currentUser.getRoleId() == null
                || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String sentiment = request.getParameter("sentiment");
        if (sentiment == null || sentiment.trim().isEmpty()) {
            sentiment = "ALL";
        }

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }

        List<ReviewModel> reviews = reviewDAO.findAllReviews(sentiment, keyword, page, PAGE_SIZE);
        int totalReviews = reviewDAO.countReviews(sentiment, keyword);
        int totalPages = (int) Math.ceil((double) totalReviews / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        // Thống kê nhanh cho các tab badge
        int countPositive = reviewDAO.countReviews("POSITIVE", null);
        int countNegative = reviewDAO.countReviews("NEGATIVE", null);
        int countNeutral = reviewDAO.countReviews("NEUTRAL", null);
        int countAll = reviewDAO.countReviews("ALL", null);

        request.setAttribute("reviews", reviews);
        request.setAttribute("totalReviews", totalReviews);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("selectedSentiment", sentiment);
        request.setAttribute("keyword", keyword != null ? keyword : "");

        request.setAttribute("countAll", countAll);
        request.setAttribute("countPositive", countPositive);
        request.setAttribute("countNegative", countNegative);
        request.setAttribute("countNeutral", countNeutral);

        request.getRequestDispatcher("/WEB-INF/views/admin/review-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;
        if (currentUser == null || currentUser.getRoleId() == null
                || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String reviewIdStr = request.getParameter("reviewId");

        if (reviewIdStr != null && !reviewIdStr.trim().isEmpty()) {
            try {
                Long reviewId = Long.parseLong(reviewIdStr);

                if ("update_reply".equalsIgnoreCase(action)) {
                    String replyContent = request.getParameter("replyContent");
                    if (replyContent != null && !replyContent.trim().isEmpty()) {
                        String adminName = (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty())
                                ? currentUser.getFullName() : currentUser.getUsername();
                        reviewDAO.updateAdminReply(reviewId, replyContent.trim(), adminName);
                    }
                } else if ("regenerate_ai".equalsIgnoreCase(action)) {
                    ReviewModel rv = reviewDAO.findById(reviewId);
                    if (rv != null) {
                        ReviewAnalysisDTO analysis = geminiService.analyzeAndReplyReview(
                                rv.getProductName(),
                                "Trái cây tươi",
                                rv.getRating(),
                                rv.getComment(),
                                rv.getUserName()
                        );
                        if (analysis != null) {
                            reviewDAO.updateAIReply(reviewId, analysis.getReply(), "AI_AGENT", analysis.getSentiment(), analysis.isNeedsSupportFollowup());
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String redirectUrl = request.getContextPath() + "/admin/reviews";
        String sentiment = request.getParameter("sentiment");
        if (sentiment != null && !sentiment.isEmpty()) {
            redirectUrl += "?sentiment=" + sentiment;
        }
        response.sendRedirect(redirectUrl);
    }
}
