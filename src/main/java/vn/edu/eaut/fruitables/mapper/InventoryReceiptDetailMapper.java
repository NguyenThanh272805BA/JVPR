package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.InventoryReceiptDetailModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InventoryReceiptDetailMapper implements IRowMapper<InventoryReceiptDetailModel> {
    @Override
    public InventoryReceiptDetailModel mapRow(ResultSet rs) {
        try {
            InventoryReceiptDetailModel detail = new InventoryReceiptDetailModel();
            detail.setId(rs.getLong("id"));
            detail.setReceiptId(rs.getLong("receipt_id"));
            detail.setProductId(rs.getLong("product_id"));
            detail.setQuantity(rs.getInt("quantity"));
            detail.setImportPrice(rs.getDouble("import_price"));
            detail.setSubTotal(rs.getDouble("sub_total"));

            try {
                detail.setProductName(rs.getString("product_name"));
            } catch (SQLException ignored) {}

            try {
                detail.setProductImageUrl(rs.getString("product_image"));
            } catch (SQLException ignored) {}

            try {
                detail.setCategoryName(rs.getString("category_name"));
            } catch (SQLException ignored) {}

            return detail;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
