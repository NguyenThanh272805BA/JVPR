package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.entity.InventoryReceiptDetailModel;
import vn.edu.eaut.fruitables.model.entity.InventoryReceiptModel;

import java.util.List;

public interface IInventoryReceiptService {
    List<InventoryReceiptModel> findAll();
    InventoryReceiptModel findById(Long id);
    boolean createReceipt(InventoryReceiptModel receipt, List<InventoryReceiptDetailModel> details);
}
