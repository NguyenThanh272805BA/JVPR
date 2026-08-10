package vn.edu.eaut.fruitables.util;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class FormatterUtil {

    /**
     * Định dạng số tiền sang chuẩn Việt Nam (VD: 150,000 ₫)
     */
    public static String formatCurrency(Double amount) {
        if (amount == null) return "0 ₫";
        Locale localeVN = new Locale("vi", "VN");
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(localeVN);
        return currencyFormatter.format(amount);
    }

    /**
     * Định dạng đối tượng Date/Timestamp ra chuỗi ngày tháng dễ nhìn (VD: 25/08/2026 14:30:00)
     */
    public static String formatDate(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        return sdf.format(date);
    }

    /**
     * Định dạng ngày tháng ngắn gọn cho hóa đơn (VD: 25/08/2026)
     */
    public static String formatShortDate(Date date) {
        if (date == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(date);
    }
}