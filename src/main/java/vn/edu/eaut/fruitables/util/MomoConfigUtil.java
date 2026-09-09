package vn.edu.eaut.fruitables.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class MomoConfigUtil {

    // Thông tin ví MoMo cá nhân của chủ cửa hàng
    public static final String PHONE_NUMBER = "0375162932";
    public static final String ACCOUNT_NAME = "Nguyễn Kim Thành";
    public static final String ACCOUNT_NAME_RAW = "NGUYEN KIM THANH";

    /**
     * Sinh chuỗi payload theo chuẩn QR chuyển khoản P2P của ứng dụng MoMo:
     * Định dạng: 2|99|{sdt}|{ten}||0|0|{so_tien}|{noi_dung}|transfer_mycode
     */
    public static String generateMomoPayload(String orderCode, long amount) {
        String cleanCode = (orderCode != null) ? orderCode.trim() : "FRUIT";
        return String.format("2|99|%s|%s||0|0|%d|%s|transfer_mycode",
                PHONE_NUMBER,
                ACCOUNT_NAME_RAW,
                amount,
                cleanCode);
    }

    /**
     * Sinh link ảnh mã QR chất lượng cao từ payload MoMo
     */
    public static String generateQrImageUrl(String orderCode, long amount) {
        String payload = generateMomoPayload(orderCode, amount);
        try {
            String encoded = URLEncoder.encode(payload, StandardCharsets.UTF_8.toString());
            // Sử dụng QR Server API nhanh, ổn định và không giới hạn request
            return "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=" + encoded;
        } catch (UnsupportedEncodingException e) {
            return "https://quickchart.io/qr?text=" + payload + "&size=300";
        }
    }
}
