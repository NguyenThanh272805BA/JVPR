package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import vn.edu.eaut.fruitables.dao.IDashboardDAO;
import vn.edu.eaut.fruitables.dao.impl.DashboardDAOImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/chart-data"})
public class ChartDataAPIServlet extends HttpServlet {

    private IDashboardDAO dashboardDAO;

    public ChartDataAPIServlet() {
        this.dashboardDAO = new DashboardDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "month"; // Mặc định hiển thị theo tháng
        }

        Map<String, Double> chartDataMap = dashboardDAO.getRevenueChartData(filter);

        List<String> labels = new ArrayList<>(chartDataMap.keySet());
        List<Double> data = new ArrayList<>(chartDataMap.values());

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("labels", labels);
        jsonResponse.put("data", data);

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(jsonResponse));
    }
}