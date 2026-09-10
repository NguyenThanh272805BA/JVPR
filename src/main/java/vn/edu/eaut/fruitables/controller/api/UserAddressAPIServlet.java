package vn.edu.eaut.fruitables.controller.api;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import vn.edu.eaut.fruitables.dao.IUserAddressDAO;
import vn.edu.eaut.fruitables.dao.impl.UserAddressDAOImpl;
import vn.edu.eaut.fruitables.model.entity.UserAddressModel;
import vn.edu.eaut.fruitables.model.entity.UserModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/api/user-addresses"})
public class UserAddressAPIServlet extends HttpServlet {

    private IUserAddressDAO userAddressDAO = new UserAddressDAOImpl();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");

        if (user == null) {
            JsonObject json = new JsonObject();
            json.addProperty("success", false);
            json.addProperty("message", "Chưa đăng nhập");
            out.print(gson.toJson(json));
            return;
        }

        List<UserAddressModel> addresses = userAddressDAO.findByUserId(user.getId());
        out.print(gson.toJson(addresses));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        UserModel user = (UserModel) session.getAttribute("USERMODEL");
        JsonObject json = new JsonObject();

        if (user == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Vui lòng đăng nhập");
            out.print(gson.toJson(json));
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("set_default".equals(action)) {
                Long addressId = Long.parseLong(request.getParameter("addressId"));
                userAddressDAO.setDefault(user.getId(), addressId);
                json.addProperty("success", true);
                json.addProperty("message", "Đã đặt làm địa chỉ mặc định");
            } else if ("delete".equals(action)) {
                Long addressId = Long.parseLong(request.getParameter("addressId"));
                userAddressDAO.delete(addressId, user.getId());
                json.addProperty("success", true);
                json.addProperty("message", "Đã xóa địa chỉ");
            } else {
                // Thêm địa chỉ mới
                String recipientName = request.getParameter("recipientName");
                String phone = request.getParameter("phone");
                String province = request.getParameter("province");
                String district = request.getParameter("district");
                String ward = request.getParameter("ward");
                String streetAddress = request.getParameter("streetAddress");
                String fullAddress = request.getParameter("fullAddress");
                boolean isDefault = "true".equalsIgnoreCase(request.getParameter("isDefault")) || "1".equals(request.getParameter("isDefault"));

                if (recipientName == null || recipientName.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                    json.addProperty("success", false);
                    json.addProperty("message", "Vui lòng điền đủ tên và số điện thoại");
                    out.print(gson.toJson(json));
                    return;
                }

                if (fullAddress == null || fullAddress.trim().isEmpty()) {
                    fullAddress = streetAddress + ", " + ward + ", " + district + ", " + province;
                }

                UserAddressModel newAddr = new UserAddressModel();
                newAddr.setUserId(user.getId());
                newAddr.setRecipientName(recipientName.trim());
                newAddr.setPhone(phone.trim());
                newAddr.setProvince(province != null ? province.trim() : "");
                newAddr.setDistrict(district != null ? district.trim() : "");
                newAddr.setWard(ward != null ? ward.trim() : "");
                newAddr.setStreetAddress(streetAddress != null ? streetAddress.trim() : "");
                newAddr.setFullAddress(fullAddress.trim());
                newAddr.setIsDefault(isDefault);

                Long savedId = userAddressDAO.save(newAddr);
                newAddr.setId(savedId);

                json.addProperty("success", true);
                json.addProperty("message", "Lưu địa chỉ thành công");
                json.add("address", gson.toJsonTree(newAddr));
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Lỗi xử lý địa chỉ: " + e.getMessage());
        }

        out.print(gson.toJson(json));
    }
}
