package vn.edu.eaut.fruitables.mapper;

import vn.edu.eaut.fruitables.model.entity.InventoryReceiptModel;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InventoryReceiptMapper implements IRowMapper<InventoryReceiptModel> {
    @Override
    public InventoryReceiptModel mapRow(ResultSet rs) {
        try {
            InventoryReceiptModel receipt = new InventoryReceiptModel();
            receipt.setId(rs.getLong("id"));
            receipt.setReceiptCode(rs.getString("receipt_code"));
            receipt.setSupplierId(rs.getLong("supplier_id"));
            receipt.setCreatedBy(rs.getObject("created_by") != null ? rs.getLong("created_by") : null);
            receipt.setTotalCost(rs.getDouble("total_cost"));
            receipt.setStatus(rs.getString("status"));
            receipt.setNote(rs.getString("note"));
            receipt.setCreatedAt(rs.getTimestamp("created_at"));

            try {
                receipt.setSupplierName(rs.getString("supplier_name"));
            } catch (SQLException ignored) {}

            try {
                receipt.setCreatorName(rs.getString("creator_name"));
            } catch (SQLException ignored) {}

            try {
                receipt.setTotalItems(rs.getInt("total_items"));
            } catch (SQLException ignored) {}

            return receipt;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
