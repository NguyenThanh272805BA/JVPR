package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.InventoryReceiptDetailModel;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptModel;

import java.util.List;

public interface IInventoryReceiptDAO extends GenericDAO<InventoryReceiptModel> {
    List<InventoryReceiptModel> findAll();
    InventoryReceiptModel findById(Long id);
    Long saveReceipt(InventoryReceiptModel receipt);
    void saveReceiptDetail(InventoryReceiptDetailModel detail);
    List<InventoryReceiptDetailModel> findDetailsByReceiptId(Long receiptId);
}
