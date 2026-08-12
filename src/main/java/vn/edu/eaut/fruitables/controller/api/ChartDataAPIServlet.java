package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/chart-data")
public class ChartDataAPIServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Trong đồ án thực tế, bạn gọi DashboardDAO để lấy hàm sum(total_amount) group by Month.
        // Ở đây tạo JSON data tĩnh đại diện cho 6 tháng gần nhất để ráp giao diện Chart.js
        JsonObject root = new JsonObject();

        JsonArray labels = new JsonArray();
        labels.add("Tháng 1"); labels.add("Tháng 2"); labels.add("Tháng 3");
        labels.add("Tháng 4"); labels.add("Tháng 5"); labels.add("Tháng 6");

        JsonArray data = new JsonArray();
        data.add(15000000); data.add(22000000); data.add(18000000);
        data.add(30000000); data.add(25000000); data.add(45000000); // Doanh thu giả lập

        root.add("labels", labels);
        root.add("data", data);

        PrintWriter out = response.getWriter();
        out.print(root.toString());
        out.flush();
    }
}