package vn.edu.eaut.fruitables.service.impl;

import vn.edu.eaut.fruitables.dao.ICouponDAO;
import vn.edu.eaut.fruitables.dao.ILuckySpinDAO;
import vn.edu.eaut.fruitables.dao.impl.CouponDAOImpl;
import vn.edu.eaut.fruitables.dao.impl.LuckySpinDAOImpl;
import vn.edu.eaut.fruitables.model.dto.LuckySpinResult;
import vn.edu.eaut.fruitables.model.entity.CouponModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinPrizeModel;
import vn.edu.eaut.fruitables.service.ILuckySpinService;

import java.sql.Timestamp;
import java.util.*;

public class LuckySpinServiceImpl implements ILuckySpinService {

    private final ILuckySpinDAO luckySpinDAO;
    private final ICouponDAO couponDAO;
    private final Random random = new Random();

    public LuckySpinServiceImpl() {
        this.luckySpinDAO = new LuckySpinDAOImpl();
        this.couponDAO = new CouponDAOImpl();
    }

    @Override
    public List<LuckySpinPrizeModel> getActiveWheelPrizes() {
        return luckySpinDAO.findAllActivePrizes();
    }

    @Override
    public List<LuckySpinPrizeModel> getAllPrizesForAdmin() {
        return luckySpinDAO.findAllPrizesForAdmin();
    }

    @Override
    public LuckySpinPrizeModel getPrizeById(Integer id) {
        return luckySpinDAO.findPrizeById(id);
    }

    @Override
    public boolean savePrize(LuckySpinPrizeModel prize) {
        if (prize == null) return false;
        return luckySpinDAO.savePrize(prize) != null;
    }

    @Override
    public boolean updatePrize(LuckySpinPrizeModel prize) {
        if (prize == null || prize.getId() == null) return false;
        return luckySpinDAO.updatePrize(prize);
    }

    @Override
    public boolean togglePrizeStatus(Integer id, boolean status) {
        if (id == null) return false;
        return luckySpinDAO.togglePrizeStatus(id, status);
    }

    @Override
    public boolean resetPrizeQuota(Integer id, int newQuota) {
        if (id == null) return false;
        return luckySpinDAO.resetPrizeQuota(id, newQuota);
    }

    @Override
    public boolean deletePrize(Integer id) {
        if (id == null) return false;
        return luckySpinDAO.deletePrize(id);
    }

    @Override
    public int getUserRemainingSpins(Long userId) {
        if (userId == null) return 0;
        return luckySpinDAO.getUserSpinCount(userId);
    }

    @Override
    public boolean claimDailyFreeSpin(Long userId) {
        if (userId == null) return false;
        return luckySpinDAO.claimDailyFreeSpin(userId);
    }

    @Override
    public synchronized LuckySpinResult spinWheel(Long userId) {
        if (userId == null) {
            return LuckySpinResult.fail("Vui lòng đăng nhập để tham gia quay thưởng!", 0);
        }

        // 1. Kiểm tra số lượt quay hiện tại
        int currentSpins = luckySpinDAO.getUserSpinCount(userId);
        if (currentSpins <= 0) {
            return LuckySpinResult.fail("Bạn đã hết lượt quay! Hãy điểm danh ngày mai hoặc mua đơn hàng để nhận thêm lượt nhé 🍎", 0);
        }

        // 2. Trừ lượt quay nguyên tử trong Database (chống race condition)
        boolean decSuccess = luckySpinDAO.decrementUserSpinCount(userId);
        if (!decSuccess) {
            return LuckySpinResult.fail("Bạn đã hết lượt quay! Vui lòng tải lại trang.", 0);
        }

        int remainingSpinsAfter = currentSpins - 1;

        // 3. Lấy danh sách giải thưởng đang kích hoạt
        List<LuckySpinPrizeModel> activePrizes = luckySpinDAO.findAllActivePrizes();
        if (activePrizes == null || activePrizes.isEmpty()) {
            luckySpinDAO.grantUserSpins(userId, 1); // Hoàn lại lượt nếu hệ thống chưa cấu hình giải
            return LuckySpinResult.fail("Vòng quay đang được bảo trì phần thưởng. Vui lòng thử lại sau!", currentSpins);
        }

        // 4. Thuật toán chọn giải ngẫu nhiên có trọng số (Weighted Random Algorithm)
        double totalWeight = 0;
        List<LuckySpinPrizeModel> eligiblePrizes = new ArrayList<>();
        for (LuckySpinPrizeModel p : activePrizes) {
            // Nếu giải có giới hạn số lượng và đã hết kho (remain == 0) -> bỏ qua
            if (p.getQuantityLimit() > 0 && p.getQuantityRemain() <= 0) {
                continue;
            }
            double prob = Math.max(0.1, p.getProbability());
            totalWeight += prob;
            eligiblePrizes.add(p);
        }

        if (eligiblePrizes.isEmpty()) {
            eligiblePrizes = activePrizes;
            totalWeight = 100.0;
        }

        double randVal = random.nextDouble() * totalWeight;
        double accum = 0;
        LuckySpinPrizeModel wonPrize = eligiblePrizes.get(0);
        for (LuckySpinPrizeModel p : eligiblePrizes) {
            accum += Math.max(0.1, p.getProbability());
            if (randVal <= accum) {
                wonPrize = p;
                break;
            }
        }

        // Xác định vị trí Index của giải trên bánh xe
        int prizeIndex = 0;
        for (int i = 0; i < activePrizes.size(); i++) {
            if (activePrizes.get(i).getId().equals(wonPrize.getId())) {
                prizeIndex = i;
                break;
            }
        }

        // 5. Tính góc quay mục tiêu (Target Degree)
        // Bánh xe chia đều N phần, kim chỉ ở đỉnh (top: 270 độ hoặc 90 độ tùy canvas)
        int n = activePrizes.size();
        double sliceArc = 360.0 / n;
        // Tâm của góc phần trúng: (prizeIndex + 0.5) * sliceArc
        // Để dừng tại kim chỉ ở vị trí đỉnh 270° (hoặc 0° căn chỉnh chuẩn):
        double baseSpins = 5.0 * 360.0; // Quay tối thiểu 5 vòng
        double targetDegree = baseSpins + (360.0 - (prizeIndex * sliceArc + sliceArc / 2.0));

        // 6. Xử lý phần thưởng nhận được
        String rewardCode = null;
        Timestamp now = new Timestamp(System.currentTimeMillis());
        Timestamp expiredAt = new Timestamp(now.getTime() + 7L * 24 * 60 * 60 * 1000L); // 7 ngày HSD

        if ("EXTRA_SPIN".equalsIgnoreCase(wonPrize.getPrizeType())) {
            // Tặng thêm lượt quay
            int extra = Math.max(1, wonPrize.getDiscountValue().intValue());
            luckySpinDAO.grantUserSpins(userId, extra);
            remainingSpinsAfter += extra;

            LuckySpinHistoryModel hist = new LuckySpinHistoryModel();
            hist.setUserId(userId);
            hist.setPrizeId(wonPrize.getId());
            hist.setPrizeName(wonPrize.getName());
            hist.setPrizeType(wonPrize.getPrizeType());
            hist.setRewardCode("EXTRA-" + extra);
            hist.setDiscountValue(wonPrize.getDiscountValue());
            hist.setIsUsed(true);
            hist.setUsedAt(now);
            hist.setExpiredAt(expiredAt);
            luckySpinDAO.saveHistory(hist);

        } else if ("NO_PRIZE".equalsIgnoreCase(wonPrize.getPrizeType())) {
            // Không trúng thưởng
            LuckySpinHistoryModel hist = new LuckySpinHistoryModel();
            hist.setUserId(userId);
            hist.setPrizeId(wonPrize.getId());
            hist.setPrizeName(wonPrize.getName());
            hist.setPrizeType(wonPrize.getPrizeType());
            hist.setRewardCode(null);
            hist.setDiscountValue(0.0);
            hist.setIsUsed(false);
            hist.setExpiredAt(expiredAt);
            luckySpinDAO.saveHistory(hist);

        } else {
            // Trúng Voucher / Freeship / Quà tặng
            // Trừ kho Quota nếu có giới hạn
            if (wonPrize.getQuantityLimit() > 0 && wonPrize.getQuantityRemain() > 0) {
                wonPrize.setQuantityRemain(wonPrize.getQuantityRemain() - 1);
                luckySpinDAO.updatePrize(wonPrize);
            }

            // Sinh mã Coupon duy nhất đưa vào bảng coupons
            String prefix = "FREESHIP".equalsIgnoreCase(wonPrize.getPrizeType()) ? "SHIP" :
                    ("DISCOUNT_PERCENT".equalsIgnoreCase(wonPrize.getPrizeType()) ? "SALE" : "SPIN");
            int valInt = wonPrize.getDiscountValue().intValue();
            rewardCode = prefix + (valInt > 0 ? valInt : "") + "-" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();

            CouponModel coupon = new CouponModel();
            coupon.setCode(rewardCode);
            coupon.setDiscountType("FREESHIP".equalsIgnoreCase(wonPrize.getPrizeType()) ? "FREESHIP" :
                    ("DISCOUNT_PERCENT".equalsIgnoreCase(wonPrize.getPrizeType()) ? "PERCENT" : "FIXED"));
            coupon.setDiscountValue(wonPrize.getDiscountValue());
            coupon.setMinOrderValue(wonPrize.getMinOrderValue());
            coupon.setStartDate(now);
            coupon.setEndDate(expiredAt);
            coupon.setUsageLimit(1);
            coupon.setUsedCount(0);
            coupon.setStatus(true);
            coupon.setTargetAudience("ALL");
            coupon.setProductId(wonPrize.getProductId());

            couponDAO.save(coupon);

            // Lưu lịch sử trúng giải vào Ví quà tặng của User
            LuckySpinHistoryModel hist = new LuckySpinHistoryModel();
            hist.setUserId(userId);
            hist.setPrizeId(wonPrize.getId());
            hist.setPrizeName(wonPrize.getName());
            hist.setPrizeType(wonPrize.getPrizeType());
            hist.setRewardCode(rewardCode);
            hist.setDiscountValue(wonPrize.getDiscountValue());
            hist.setIsUsed(false);
            hist.setExpiredAt(expiredAt);
            luckySpinDAO.saveHistory(hist);
        }

        // 7. Tạo kết quả trả về
        LuckySpinResult result = new LuckySpinResult();
        result.setSuccess(true);
        result.setPrizeIndex(prizeIndex);
        result.setPrizeId(wonPrize.getId());
        result.setPrizeName(wonPrize.getName());
        result.setPrizeType(wonPrize.getPrizeType());
        result.setRewardCode(rewardCode);
        result.setDiscountValue(wonPrize.getDiscountValue());
        result.setMinOrderValue(wonPrize.getMinOrderValue());
        result.setRemainingSpins(remainingSpinsAfter);
        result.setTargetDegree(targetDegree);
        result.setMessage("Chúc mừng bạn đã trúng: " + wonPrize.getName() + " 🎉");

        return result;
    }

    @Override
    public List<LuckySpinHistoryModel> getUserRewardWallet(Long userId) {
        if (userId == null) return Collections.emptyList();
        return luckySpinDAO.findHistoryByUserId(userId);
    }

    @Override
    public List<LuckySpinHistoryModel> getRecentSpinsForAdmin(int limit) {
        return luckySpinDAO.findAllHistoryForAdmin(limit);
    }

    @Override
    public Map<String, Object> getAdminStatistics() {
        return luckySpinDAO.getAdminStatistics();
    }

    @Override
    public boolean grantUserSpins(Long userId, int spins) {
        if (userId == null || spins <= 0) return false;
        return luckySpinDAO.grantUserSpins(userId, spins);
    }
}
