package vn.edu.eaut.fruitables.util;

import java.text.Normalizer;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class DistanceAndShippingUtil {

    // Tọa độ trung tâm cửa hàng/kho Fruitables (Khu đô thị Nam Từ Liêm / Cầu Giấy, Hà Nội)
    public static final double STORE_LAT = 21.0381;
    public static final double STORE_LNG = 105.7468;
    public static final String STORE_ADDRESS = "Đường Trịnh Văn Bô, Nam Từ Liêm, Hà Nội";

    // Bảng cự ly ước lượng (km) cho các quận/huyện Hà Nội tính từ kho
    private static final Map<String, Double> HANOI_DISTRICT_DISTANCES = new HashMap<>();

    static {
        HANOI_DISTRICT_DISTANCES.put("nam tu liem", 3.0);
        HANOI_DISTRICT_DISTANCES.put("bac tu liem", 5.0);
        HANOI_DISTRICT_DISTANCES.put("cau giay", 4.5);
        HANOI_DISTRICT_DISTANCES.put("hoai duc", 6.5);
        HANOI_DISTRICT_DISTANCES.put("ha dong", 8.5);
        HANOI_DISTRICT_DISTANCES.put("thanh xuan", 7.5);
        HANOI_DISTRICT_DISTANCES.put("tay ho", 9.5);
        HANOI_DISTRICT_DISTANCES.put("dong da", 9.0);
        HANOI_DISTRICT_DISTANCES.put("ba dinh", 9.5);
        HANOI_DISTRICT_DISTANCES.put("hai ba trung", 12.0);
        HANOI_DISTRICT_DISTANCES.put("hoan kiem", 13.0);
        HANOI_DISTRICT_DISTANCES.put("hoang mai", 14.5);
        HANOI_DISTRICT_DISTANCES.put("long bien", 18.0);
        HANOI_DISTRICT_DISTANCES.put("dong anh", 18.0);
        HANOI_DISTRICT_DISTANCES.put("gia lam", 22.0);
        HANOI_DISTRICT_DISTANCES.put("dan phuong", 12.0);
        HANOI_DISTRICT_DISTANCES.put("thanh tri", 16.0);
        HANOI_DISTRICT_DISTANCES.put("me linh", 22.0);
        HANOI_DISTRICT_DISTANCES.put("soc son", 30.0);
        HANOI_DISTRICT_DISTANCES.put("thach that", 25.0);
        HANOI_DISTRICT_DISTANCES.put("quoc oai", 20.0);
        HANOI_DISTRICT_DISTANCES.put("phuc tho", 26.0);
        HANOI_DISTRICT_DISTANCES.put("chuong my", 25.0);
        HANOI_DISTRICT_DISTANCES.put("son tay", 38.0);
        HANOI_DISTRICT_DISTANCES.put("ba vi", 50.0);
        HANOI_DISTRICT_DISTANCES.put("thuong tin", 28.0);
        HANOI_DISTRICT_DISTANCES.put("phu xuyen", 38.0);
        HANOI_DISTRICT_DISTANCES.put("ung hoa", 40.0);
        HANOI_DISTRICT_DISTANCES.put("my duc", 48.0);
    }

    /**
     * Chuẩn hóa chuỗi tiếng Việt không dấu, chữ thường để so sánh
     */
    public static String normalizeText(String input) {
        if (input == null) return "";
        String nfdNormalizedString = Normalizer.normalize(input.trim().toLowerCase(), Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(nfdNormalizedString)
                .replaceAll("")
                .replaceAll("đ", "d")
                .replaceAll("[^a-z0-9\\s]", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    /**
     * Tính khoảng cách đường cong mặt cầu Haversine (km) theo tọa độ GPS
     */
    public static double calculateHaversine(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Bán kính trái đất (km)
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = R * c;
        // Nhân hệ số uốn lượn đường sá đô thị 1.25
        return Math.round(distance * 1.25 * 10.0) / 10.0;
    }

    /**
     * Ước tính khoảng cách (km) từ địa chỉ hành chính
     */
    public static double estimateDistance(String province, String district, String ward, String street, Double lat, Double lng) {
        // 1. Nếu có tọa độ GPS chính xác
        if (lat != null && lng != null && (lat != 0.0 || lng != 0.0)) {
            return calculateHaversine(STORE_LAT, STORE_LNG, lat, lng);
        }

        String normProvince = normalizeText(province);
        String normDistrict = normalizeText(district);

        // 2. Nếu nằm trong Hà Nội
        if (normProvince.contains("ha noi")) {
            for (Map.Entry<String, Double> entry : HANOI_DISTRICT_DISTANCES.entrySet()) {
                if (normDistrict.contains(entry.getKey())) {
                    return entry.getValue();
                }
            }
            return 8.0; // Trung bình nội thành Hà Nội
        }

        // 3. Các tỉnh lân cận Hà Nội
        if (normProvince.contains("hung yen") || normProvince.contains("bac ninh") 
                || normProvince.contains("vinh phuc") || normProvince.contains("ha nam")) {
            return 38.0;
        }
        if (normProvince.contains("hai phong") || normProvince.contains("quang ninh") 
                || normProvince.contains("hai duong") || normProvince.contains("nam dinh")
                || normProvince.contains("thai binh") || normProvince.contains("ninh binh")
                || normProvince.contains("thai nguyen") || normProvince.contains("phu tho")
                || normProvince.contains("bac giang") || normProvince.contains("hoa binh")) {
            return 85.0;
        }

        // 4. Các tỉnh miền Trung, miền Nam
        if (normProvince.contains("da nang") || normProvince.contains("hue")) {
            return 680.0;
        }
        if (normProvince.contains("ho chi minh") || normProvince.contains("sai gon") 
                || normProvince.contains("binh duong") || normProvince.contains("dong nai")) {
            return 1150.0;
        }

        // Mặc định ngoại tỉnh khác
        return 120.0;
    }

    /**
     * Kết quả tính toán phí vận chuyển chi tiết
     */
    public static class ShippingCalculationResult {
        public double distanceKm;
        public double baseShippingFee;
        public double weightSurcharge;
        public double storageSurcharge;
        public double rawShippingFee;
        public double shippingDiscount;
        public double finalShippingFee;
        public int totalWeightGram;
        public boolean isFreeShipping;
        public String note;

        public ShippingCalculationResult() {}
    }

    /**
     * Tính toán tổng cước vận chuyển chi tiết
     * 
     * @param distanceKm cự ly vận chuyển (km)
     * @param totalWeightGram tổng khối lượng (gram)
     * @param hasColdChain có sản phẩm cần bảo quản lạnh đá gel
     * @param hasFragileGift có sản phẩm giỏ quà / dễ dập
     * @param hasFreeShippingProduct có sản phẩm tự tài trợ freeship
     * @param cartTotal tổng tiền hàng
     * @param appliedCouponType loại voucher ("FREESHIP" / "PERCENT" / "FIXED")
     * @param appliedCouponDiscountValue giá trị giảm của voucher
     */
    public static ShippingCalculationResult calculateShipping(
            double distanceKm,
            int totalWeightGram,
            boolean hasColdChain,
            boolean hasFragileGift,
            boolean hasFreeShippingProduct,
            double cartTotal,
            String appliedCouponType,
            double appliedCouponDiscountValue) {

        ShippingCalculationResult result = new ShippingCalculationResult();
        result.distanceKm = Math.round(distanceKm * 10.0) / 10.0;
        result.totalWeightGram = Math.max(500, totalWeightGram);

        // 1. Phí theo khoảng cách (Base Fee)
        // 0 - 3km: 15.000đ; trên 3km: +5.000đ/km (tối đa liên tỉnh theo kiện hàng)
        double baseFee = 0;
        if (distanceKm <= 3.0) {
            baseFee = 15000.0;
        } else if (distanceKm <= 20.0) {
            baseFee = 15000.0 + (distanceKm - 3.0) * 5000.0;
        } else if (distanceKm <= 50.0) {
            baseFee = 15000.0 + 17.0 * 5000.0 + (distanceKm - 20.0) * 2500.0;
        } else {
            // Ngoại tỉnh đường dài: cước kiện hoa quả chuyển phát nhanh ướp đá
            baseFee = 60000.0 + Math.min(60000.0, (distanceKm / 100.0) * 8000.0);
        }
        result.baseShippingFee = Math.round(baseFee);

        // 2. Phụ phí cân nặng: vượt quá 5kg (5000g) thì mỗi kg thêm 5.000đ
        double weightSurcharge = 0;
        if (result.totalWeightGram > 5000) {
            int extraKg = (int) Math.ceil((result.totalWeightGram - 5000) / 1000.0);
            weightSurcharge = extraKg * 5000.0;
        }
        result.weightSurcharge = weightSurcharge;

        // 3. Phụ phí bảo quản lạnh & giỏ quà biếu chống dập
        double storageSurcharge = 0;
        if (hasColdChain) {
            storageSurcharge += 10000.0; // Túi giữ nhiệt + đá gel 4°C
        }
        if (hasFragileGift) {
            storageSurcharge += 20000.0; // Màng xốp chống sốc + nơ quà
        }
        result.storageSurcharge = storageSurcharge;

        // Tổng cước thô trước khi giảm giá
        result.rawShippingFee = result.baseShippingFee + result.weightSurcharge + result.storageSurcharge;

        // 4. Giảm giá vận chuyển (Freeship policy & Voucher)
        double discount = 0;
        StringBuilder noteBuilder = new StringBuilder();

        if (hasFreeShippingProduct) {
            discount = result.rawShippingFee;
            noteBuilder.append("Miễn phí 100% cước vận chuyển từ sản phẩm tài trợ.");
        } else {
            // Chính sách shop: Đơn từ 500.000đ được hỗ trợ tối đa 30.000đ phí ship (trong bán kính <= 15km)
            if (cartTotal >= 500000.0 && distanceKm <= 15.0) {
                double autoDiscount = Math.min(30000.0, result.rawShippingFee);
                discount = Math.max(discount, autoDiscount);
                noteBuilder.append("Đơn từ 500.000đ được hỗ trợ 30.000đ cước ship. ");
            }

            // Voucher loại FREESHIP
            if ("FREESHIP".equalsIgnoreCase(appliedCouponType) && appliedCouponDiscountValue > 0) {
                double voucherDiscount = Math.min(appliedCouponDiscountValue, result.rawShippingFee);
                if (voucherDiscount > discount) {
                    discount = voucherDiscount;
                }
                noteBuilder.append("Đã áp dụng mã Voucher Freeship: -").append(String.format("%,.0f", discount)).append("₫. ");
            }
        }

        result.shippingDiscount = Math.round(discount);
        result.finalShippingFee = Math.max(0, result.rawShippingFee - result.shippingDiscount);
        result.isFreeShipping = (result.finalShippingFee == 0);
        result.note = noteBuilder.toString().trim();

        return result;
    }
}
