package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
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
import java.io.PrintWriter;

@WebServlet(urlPatterns = {"/api/admin/product-ai"})
public class AdminProductAIApiServlet extends HttpServlet {

    private IGeminiService geminiService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.geminiService = new GeminiServiceImpl();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // 1. Phan quyen: Chi cho phep ADMIN (1) hoac EMPLOYEE (2)
        HttpSession session = request.getSession(false);
        UserModel currentUser = (session != null) ? (UserModel) session.getAttribute("USERMODEL") : null;
        if (currentUser == null || currentUser.getRoleId() == null
                || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            JsonObject err = new JsonObject();
            err.addProperty("success", false);
            err.addProperty("message", "Tu choi truy cap. Chuc nang Tro Ly AI chi danh cho Quan tri vien.");
            out.print(gson.toJson(err));
            return;
        }

        String action = request.getParameter("action");
        String productName = request.getParameter("productName");
        String categoryName = request.getParameter("categoryName");
        String toneStyle = request.getParameter("toneStyle");
        String templateType = request.getParameter("templateType");

        JsonObject jsonResponse = new JsonObject();

        if (productName == null || productName.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui long nhap ten san pham truoc khi su dung Tro Ly AI.");
            out.print(gson.toJson(jsonResponse));
            return;
        }

        try {
            if ("short_desc".equalsIgnoreCase(action)) {
                String desc = geminiService.generateProductShortDescription(productName.trim(), categoryName, toneStyle);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("content", desc);
            } else if ("article".equalsIgnoreCase(action)) {
                String articleHtml = geminiService.generateProductArticle(productName.trim(), categoryName, templateType, toneStyle);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("content", articleHtml);
            } else if ("faq".equalsIgnoreCase(action)) {
                String faqHtml = geminiService.generateProductFaq(productName.trim(), categoryName);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("content", faqHtml);
            } else if ("suggest_specs".equalsIgnoreCase(action)) {
                String specsJsonStr = geminiService.suggestProductSpecs(productName.trim(), categoryName);
                JsonObject parsedSpecs = gson.fromJson(specsJsonStr, JsonObject.class);
                jsonResponse.addProperty("success", true);
                jsonResponse.add("specs", parsedSpecs);
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hanh dong khong hop le.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Loi xu ly tu Tro Ly AI: " + e.getMessage());
        }

        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
