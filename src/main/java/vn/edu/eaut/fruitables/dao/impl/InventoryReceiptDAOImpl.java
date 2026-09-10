package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.IInventoryReceiptDAO;
import vn.edu.eaut.fruitables.mapper.InventoryReceiptDetailMapper;
import vn.edu.eaut.fruitables.mapper.InventoryReceiptMapper;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptDetailModel;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptModel;

import java.util.List;

public class InventoryReceiptDAOImpl extends AbstractDAO<InventoryReceiptModel> implements IInventoryReceiptDAO {

    @Override
    public List<InventoryReceiptModel> findAll() {
        String sql = "SELECT ir.*, s.name AS supplier_name, u.full_name AS creator_name, " +
                     "(SELECT COUNT(*) FROM inventory_receipt_details WHERE receipt_id = ir.id) AS total_items " +
                     "FROM inventory_receipts ir " +
                     "LEFT JOIN suppliers s ON ir.supplier_id = s.id " +
                     "LEFT JOIN users u ON ir.created_by = u.id " +
                     "ORDER BY ir.created_at DESC, ir.id DESC";
        return query(sql, new InventoryReceiptMapper());
    }

    @Override
    public InventoryReceiptModel findById(Long id) {
        String sql = "SELECT ir.*, s.name AS supplier_name, u.full_name AS creator_name, " +
                     "(SELECT COUNT(*) FROM inventory_receipt_details WHERE receipt_id = ir.id) AS total_items " +
                     "FROM inventory_receipts ir " +
                     "LEFT JOIN suppliers s ON ir.supplier_id = s.id " +
                     "LEFT JOIN users u ON ir.created_by = u.id " +
                     "WHERE ir.id = ?";
        List<InventoryReceiptModel> list = query(sql, new InventoryReceiptMapper(), id);
        return list != null && !list.isEmpty() ? list.get(0) : null;
    }

    @Override
    public Long saveReceipt(InventoryReceiptModel receipt) {
        String sql = "INSERT INTO inventory_receipts (receipt_code, supplier_id, created_by, total_cost, status, note) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        return insert(sql, receipt.getReceiptCode(), receipt.getSupplierId(), receipt.getCreatedBy(),
                receipt.getTotalCost(), receipt.getStatus() != null ? receipt.getStatus() : "COMPLETED", receipt.getNote());
    }

    @Override
    public void saveReceiptDetail(InventoryReceiptDetailModel detail) {
        String sql = "INSERT INTO inventory_receipt_details (receipt_id, product_id, quantity, import_price, sub_total) " +
                     "VALUES (?, ?, ?, ?, ?)";
        insert(sql, detail.getReceiptId(), detail.getProductId(), detail.getQuantity(), detail.getImportPrice(), detail.getSubTotal());
    }

    @Override
    public List<InventoryReceiptDetailModel> findDetailsByReceiptId(Long receiptId) {
        String sql = "SELECT ird.*, p.name AS product_name, p.image_url AS product_image, c.name AS category_name " +
                     "FROM inventory_receipt_details ird " +
                     "JOIN products p ON ird.product_id = p.id " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE ird.receipt_id = ? " +
                     "ORDER BY ird.id ASC";
        AbstractDAO<InventoryReceiptDetailModel> detailDAO = new AbstractDAO<>();
        return detailDAO.query(sql, new InventoryReceiptDetailMapper(), receiptId);
    }
}
