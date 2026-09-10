package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.IInventoryReceiptDAO;
import vn.edu.eaut.fruitables.dao.impl.InventoryReceiptDAOImpl;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptDetailModel;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptModel;
import vn.edu.eaut.fruitables.service.IInventoryReceiptService;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class InventoryReceiptServiceImpl implements IInventoryReceiptService {

    private final IInventoryReceiptDAO inventoryReceiptDAO;

    public InventoryReceiptServiceImpl() {
        this.inventoryReceiptDAO = new InventoryReceiptDAOImpl();
    }

    @Override
    public List<InventoryReceiptModel> findAll() {
        return inventoryReceiptDAO.findAll();
    }

    @Override
    public InventoryReceiptModel findById(Long id) {
        InventoryReceiptModel receipt = inventoryReceiptDAO.findById(id);
        if (receipt != null) {
            receipt.setDetails(inventoryReceiptDAO.findDetailsByReceiptId(id));
        }
        return receipt;
    }

    @Override
    public boolean createReceipt(InventoryReceiptModel receipt, List<InventoryReceiptDetailModel> details) {
        if (receipt == null || details == null || details.isEmpty()) {
            return false;
        }

        Connection conn = null;
        PreparedStatement psReceipt = null;
        PreparedStatement psDetail = null;
        PreparedStatement psGetProduct = null;
        PreparedStatement psUpdateProduct = null;
        ResultSet rsKeys = null;

        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Tính tổng tiền chi phí nhập
            double totalCost = 0;
            for (InventoryReceiptDetailModel d : details) {
                double subTotal = d.getQuantity() * d.getImportPrice();
                d.setSubTotal(subTotal);
                totalCost += subTotal;
            }
            receipt.setTotalCost(totalCost);

            // 2. Insert phiếu nhập inventory_receipts
            String sqlReceipt = "INSERT INTO inventory_receipts (receipt_code, supplier_id, created_by, total_cost, status, note) " +
                                "VALUES (?, ?, ?, ?, ?, ?)";
            psReceipt = conn.prepareStatement(sqlReceipt, Statement.RETURN_GENERATED_KEYS);
            psReceipt.setString(1, receipt.getReceiptCode());
            psReceipt.setLong(2, receipt.getSupplierId());
            if (receipt.getCreatedBy() != null) {
                psReceipt.setLong(3, receipt.getCreatedBy());
            } else {
                psReceipt.setNull(3, java.sql.Types.BIGINT);
            }
            psReceipt.setDouble(4, receipt.getTotalCost());
            psReceipt.setString(5, receipt.getStatus() != null ? receipt.getStatus() : "COMPLETED");
            psReceipt.setString(6, receipt.getNote());
            psReceipt.executeUpdate();

            rsKeys = psReceipt.getGeneratedKeys();
            if (!rsKeys.next()) {
                conn.rollback();
                return false;
            }
            long receiptId = rsKeys.getLong(1);
            receipt.setId(receiptId);

            // 3. Chuẩn bị câu lệnh Insert details và Update sản phẩm
            String sqlDetail = "INSERT INTO inventory_receipt_details (receipt_id, product_id, quantity, import_price, sub_total) " +
                               "VALUES (?, ?, ?, ?, ?)";
            psDetail = conn.prepareStatement(sqlDetail);

            String sqlGetProd = "SELECT stock, cost_price FROM products WHERE id = ? FOR UPDATE";
            psGetProduct = conn.prepareStatement(sqlGetProd);

            String sqlUpdateProd = "UPDATE products SET stock = ?, cost_price = ? WHERE id = ?";
            psUpdateProduct = conn.prepareStatement(sqlUpdateProd);

            for (InventoryReceiptDetailModel d : details) {
                // Lưu detail
                psDetail.setLong(1, receiptId);
                psDetail.setLong(2, d.getProductId());
                psDetail.setInt(3, d.getQuantity());
                psDetail.setDouble(4, d.getImportPrice());
                psDetail.setDouble(5, d.getSubTotal());
                psDetail.executeUpdate();

                // Lấy thông tin tồn kho và giá vốn hiện tại
                psGetProduct.setLong(1, d.getProductId());
                try (ResultSet rsProd = psGetProduct.executeQuery()) {
                    if (rsProd.next()) {
                        int oldStock = Math.max(0, rsProd.getInt("stock"));
                        double oldCost = rsProd.getDouble("cost_price");
                        int importQty = d.getQuantity();
                        double importPrice = d.getImportPrice();

                        int newStock = oldStock + importQty;

                        // Tính giá vốn bình quân di động (Moving Weighted Average)
                        double newCostPrice = importPrice;
                        if (newStock > 0 && oldStock > 0 && oldCost > 0) {
                            newCostPrice = ((oldStock * oldCost) + (importQty * importPrice)) / newStock;
                        } else {
                            newCostPrice = importPrice;
                        }
                        // Làm tròn 2 chữ số thập phân
                        newCostPrice = Math.round(newCostPrice * 100.0) / 100.0;

                        // Cập nhật tồn kho và giá vốn mới vào bảng products
                        psUpdateProduct.setInt(1, newStock);
                        psUpdateProduct.setDouble(2, newCostPrice);
                        psUpdateProduct.setLong(3, d.getProductId());
                        psUpdateProduct.executeUpdate();
                    }
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (rsKeys != null) try { rsKeys.close(); } catch (Exception ignored) {}
            if (psReceipt != null) try { psReceipt.close(); } catch (Exception ignored) {}
            if (psDetail != null) try { psDetail.close(); } catch (Exception ignored) {}
            if (psGetProduct != null) try { psGetProduct.close(); } catch (Exception ignored) {}
            if (psUpdateProduct != null) try { psUpdateProduct.close(); } catch (Exception ignored) {}
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {}
            }
        }
    }
}
