package vn.edu.eaut.fruitables.controller.admin;

import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private IDashboardDAO dashboardDAO;

    public AdminDashboardServlet() {
        this.dashboardDAO = new DashboardDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Truy xuất các chỉ số thực tế từ DB
        double totalRevenue = dashboardDAO.getTotalRevenue();
        double totalCost = dashboardDAO.getTotalCost();
        double grossProfit = dashboardDAO.getGrossProfit();
        int totalOrders = dashboardDAO.getTotalOrders();
        int totalProducts = dashboardDAO.getTotalProducts();
        int outOfStock = dashboardDAO.getOutOfStockProducts();
        java.util.Map<String, Object> kpiMetrics = dashboardDAO.getKpiComparativeMetrics();
        java.util.Map<String, Object> categoryDistribution = dashboardDAO.getCategoryProductDistribution();

        // Truyền dữ liệu sang JSP
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalCost", totalCost);
        request.setAttribute("grossProfit", grossProfit);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("outOfStock", outOfStock);
        request.setAttribute("kpiMetrics", kpiMetrics);
        request.setAttribute("categoryDistribution", categoryDistribution);

        // Chuyển hướng tới giao diện JSP
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}