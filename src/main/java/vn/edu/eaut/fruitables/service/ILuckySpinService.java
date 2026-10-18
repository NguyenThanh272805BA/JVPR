package vn.edu.eaut.fruitables.service;

import vn.edu.eaut.fruitables.model.dto.LuckySpinResult;
import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinPrizeModel;

import java.util.List;
import java.util.Map;

public interface ILuckySpinService {
    List<LuckySpinPrizeModel> getActiveWheelPrizes();
    List<LuckySpinPrizeModel> getAllPrizesForAdmin();
    LuckySpinPrizeModel getPrizeById(Integer id);
    boolean savePrize(LuckySpinPrizeModel prize);
    boolean updatePrize(LuckySpinPrizeModel prize);
    boolean togglePrizeStatus(Integer id, boolean status);
    boolean resetPrizeQuota(Integer id, int newQuota);
    boolean deletePrize(Integer id);

    LuckySpinResult spinWheel(Long userId);
    boolean claimDailyFreeSpin(Long userId);
    int getUserRemainingSpins(Long userId);

    List<LuckySpinHistoryModel> getUserRewardWallet(Long userId);
    List<LuckySpinHistoryModel> getRecentSpinsForAdmin(int limit);
    Map<String, Object> getAdminStatistics();
    boolean grantUserSpins(Long userId, int spins);
}
