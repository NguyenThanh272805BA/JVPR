package vn.edu.eaut.fruitables.dao;

import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinPrizeModel;

import java.util.List;
import java.util.Map;

public interface ILuckySpinDAO {
    List<LuckySpinPrizeModel> findAllActivePrizes();
    List<LuckySpinPrizeModel> findAllPrizesForAdmin();
    LuckySpinPrizeModel findPrizeById(Integer id);
    Integer savePrize(LuckySpinPrizeModel prize);
    boolean updatePrize(LuckySpinPrizeModel prize);
    boolean togglePrizeStatus(Integer id, boolean status);
    boolean resetPrizeQuota(Integer id, int newQuota);
    boolean deletePrize(Integer id);

    List<LuckySpinHistoryModel> findHistoryByUserId(Long userId);
    List<LuckySpinHistoryModel> findAllHistoryForAdmin(int limit);
    Long saveHistory(LuckySpinHistoryModel history);
    boolean markRewardUsed(String rewardCode);

    int getUserSpinCount(Long userId);
    boolean decrementUserSpinCount(Long userId);
    boolean grantUserSpins(Long userId, int spins);
    boolean claimDailyFreeSpin(Long userId);

    Map<String, Object> getAdminStatistics();
    void ensureSchemaInitialized();
}
