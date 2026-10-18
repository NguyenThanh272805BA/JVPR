package vn.edu.eaut.fruitables.dao.impl;

import vn.edu.eaut.fruitables.dao.ILuckySpinDAO;
import vn.edu.eaut.fruitables.model.entity.LuckySpinHistoryModel;
import vn.edu.eaut.fruitables.model.entity.LuckySpinPrizeModel;
import vn.edu.eaut.fruitables.util.DBConnectionUtil;

import java.sql.*;
import java.util.*;

public class LuckySpinDAOImpl extends AbstractDAO<LuckySpinPrizeModel> implements ILuckySpinDAO {

    private static volatile boolean schemaChecked = false;

    public LuckySpinDAOImpl() {
        if (!schemaChecked) {
            synchronized (LuckySpinDAOImpl.class) {
                if (!schemaChecked) {
                    ensureSchemaInitialized();
                    schemaChecked = true;
                }
            }
        }
    }

    @Override
    public void ensureSchemaInitialized() {
        try (Connection conn = DBConnectionUtil.getConnection();
             Statement st = conn.createStatement()) {

            // 1. Kiểm tra và thêm cột spin_count & last_daily_spin_date vào bảng users
            try {
                DatabaseMetaData meta = conn.getMetaData();
                try (ResultSet rs = meta.getColumns(null, null, "users", "spin_count")) {
                    if (!rs.next()) {
                        st.executeUpdate("ALTER TABLE users ADD COLUMN spin_count INT DEFAULT 1");
                    }
                }
                try (ResultSet rs = meta.getColumns(null, null, "users", "last_daily_spin_date")) {
                    if (!rs.next()) {
                        st.executeUpdate("ALTER TABLE users ADD COLUMN last_daily_spin_date DATE DEFAULT NULL");
                    }
                }
            } catch (Exception ex) {
                System.err.println("[LuckySpinDAO] Alter users warning: " + ex.getMessage());
            }

            // 2. Tạo bảng lucky_spin_prizes
            String createPrizesSql = """
                CREATE TABLE IF NOT EXISTS lucky_spin_prizes (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    prize_type VARCHAR(50) NOT NULL,
                    discount_value DOUBLE DEFAULT 0,
                    min_order_value DOUBLE DEFAULT 0,
                    product_id BIGINT NULL,
                    probability DOUBLE NOT NULL DEFAULT 10,
                    quantity_limit INT DEFAULT -1,
                    quantity_remain INT DEFAULT -1,
                    color_bg VARCHAR(50) DEFAULT '#10B981',
                    color_text VARCHAR(50) DEFAULT '#FFFFFF',
                    icon_type VARCHAR(50) DEFAULT 'voucher',
                    status BOOLEAN DEFAULT TRUE,
                    display_order INT DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            """;
            st.executeUpdate(createPrizesSql);

            // 3. Tạo bảng lucky_spin_history
            String createHistorySql = """
                CREATE TABLE IF NOT EXISTS lucky_spin_history (
                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                    user_id BIGINT NOT NULL,
                    prize_id INT NOT NULL,
                    prize_name VARCHAR(255) NOT NULL,
                    prize_type VARCHAR(50) NOT NULL,
                    reward_code VARCHAR(100) NULL,
                    discount_value DOUBLE DEFAULT 0,
                    is_used BOOLEAN DEFAULT FALSE,
                    used_at TIMESTAMP NULL,
                    expired_at TIMESTAMP NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    INDEX idx_spin_user (user_id),
                    INDEX idx_spin_code (reward_code)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
            """;
            st.executeUpdate(createHistorySql);

            // 4. Nếu bảng lucky_spin_prizes trống, tự động nạp 8 giải thưởng mặc định
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM lucky_spin_prizes")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    String seedSql = """
                        INSERT INTO lucky_spin_prizes (name, prize_type, discount_value, min_order_value, probability, quantity_limit, quantity_remain, color_bg, color_text, icon_type, display_order) VALUES
                        ('Voucher 10.000₫', 'DISCOUNT_AMOUNT', 10000, 100000, 30.0, -1, -1, '#10B981', '#FFFFFF', 'voucher', 1),
                        ('Freeship 100%', 'FREESHIP', 30000, 150000, 20.0, -1, -1, '#059669', '#FFFFFF', 'shipping', 2),
                        ('Voucher 20.000₫', 'DISCOUNT_AMOUNT', 20000, 200000, 15.0, -1, -1, '#047857', '#FFFFFF', 'voucher', 3),
                        ('Chúc May Mắn', 'NO_PRIZE', 0, 0, 18.0, -1, -1, '#F59E0B', '#FFFFFF', 'luck', 4),
                        ('Giảm Giá 10%', 'DISCOUNT_PERCENT', 10, 180000, 10.0, -1, -1, '#0D9488', '#FFFFFF', 'voucher', 5),
                        ('Voucher VIP 50K', 'DISCOUNT_AMOUNT', 50000, 350000, 4.0, 50, 50, '#DC2626', '#FFFFFF', 'star', 6),
                        ('Hộp Quà Trái Cây', 'GIFT_PRODUCT', 45000, 250000, 2.0, 20, 20, '#7C3AED', '#FFFFFF', 'gift', 7),
                        ('Thêm 1 Lượt Quay', 'EXTRA_SPIN', 1, 0, 1.0, -1, -1, '#D97706', '#FFFFFF', 'spin', 8);
                    """;
                    st.executeUpdate(seedSql);
                    System.out.println("[LuckySpinDAO] Seeded 8 default wheel prizes successfully.");
                }
            }

        } catch (Exception e) {
            System.err.println("[LuckySpinDAO] Schema init exception: " + e.getMessage());
        }
    }

    private LuckySpinPrizeModel mapPrize(ResultSet rs) throws SQLException {
        LuckySpinPrizeModel p = new LuckySpinPrizeModel();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrizeType(rs.getString("prize_type"));
        p.setDiscountValue(rs.getDouble("discount_value"));
        p.setMinOrderValue(rs.getDouble("min_order_value"));
        try { p.setProductId(rs.getObject("product_id") != null ? rs.getLong("product_id") : null); } catch (Exception ignored) {}
        p.setProbability(rs.getDouble("probability"));
        p.setQuantityLimit(rs.getInt("quantity_limit"));
        p.setQuantityRemain(rs.getInt("quantity_remain"));
        p.setColorBg(rs.getString("color_bg"));
        p.setColorText(rs.getString("color_text"));
        p.setIconType(rs.getString("icon_type"));
        p.setStatus(rs.getBoolean("status"));
        p.setDisplayOrder(rs.getInt("display_order"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }

    @Override
    public List<LuckySpinPrizeModel> findAllActivePrizes() {
        String sql = "SELECT * FROM lucky_spin_prizes WHERE status = TRUE ORDER BY display_order ASC, id ASC";
        List<LuckySpinPrizeModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPrize(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<LuckySpinPrizeModel> findAllPrizesForAdmin() {
        String sql = "SELECT * FROM lucky_spin_prizes ORDER BY display_order ASC, id ASC";
        List<LuckySpinPrizeModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapPrize(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public LuckySpinPrizeModel findPrizeById(Integer id) {
        if (id == null) return null;
        String sql = "SELECT * FROM lucky_spin_prizes WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPrize(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Integer savePrize(LuckySpinPrizeModel prize) {
        String sql = """
            INSERT INTO lucky_spin_prizes 
            (name, prize_type, discount_value, min_order_value, probability, quantity_limit, quantity_remain, color_bg, color_text, icon_type, status, display_order)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, prize.getName());
            ps.setString(2, prize.getPrizeType());
            ps.setDouble(3, prize.getDiscountValue());
            ps.setDouble(4, prize.getMinOrderValue());
            ps.setDouble(5, prize.getProbability());
            ps.setInt(6, prize.getQuantityLimit());
            ps.setInt(7, prize.getQuantityRemain());
            ps.setString(8, prize.getColorBg());
            ps.setString(9, prize.getColorText());
            ps.setString(10, prize.getIconType());
            ps.setBoolean(11, prize.getStatus());
            ps.setInt(12, prize.getDisplayOrder());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updatePrize(LuckySpinPrizeModel prize) {
        String sql = """
            UPDATE lucky_spin_prizes SET
            name = ?, prize_type = ?, discount_value = ?, min_order_value = ?, probability = ?,
            quantity_limit = ?, quantity_remain = ?, color_bg = ?, color_text = ?, icon_type = ?,
            status = ?, display_order = ?
            WHERE id = ?
        """;
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prize.getName());
            ps.setString(2, prize.getPrizeType());
            ps.setDouble(3, prize.getDiscountValue());
            ps.setDouble(4, prize.getMinOrderValue());
            ps.setDouble(5, prize.getProbability());
            ps.setInt(6, prize.getQuantityLimit());
            ps.setInt(7, prize.getQuantityRemain());
            ps.setString(8, prize.getColorBg());
            ps.setString(9, prize.getColorText());
            ps.setString(10, prize.getIconType());
            ps.setBoolean(11, prize.getStatus());
            ps.setInt(12, prize.getDisplayOrder());
            ps.setInt(13, prize.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean togglePrizeStatus(Integer id, boolean status) {
        String sql = "UPDATE lucky_spin_prizes SET status = ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean resetPrizeQuota(Integer id, int newQuota) {
        String sql = "UPDATE lucky_spin_prizes SET quantity_limit = ?, quantity_remain = ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuota);
            ps.setInt(2, newQuota);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deletePrize(Integer id) {
        String sql = "DELETE FROM lucky_spin_prizes WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<LuckySpinHistoryModel> findHistoryByUserId(Long userId) {
        if (userId == null) return Collections.emptyList();
        String sql = "SELECT * FROM lucky_spin_history WHERE user_id = ? ORDER BY created_at DESC";
        List<LuckySpinHistoryModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LuckySpinHistoryModel h = new LuckySpinHistoryModel();
                    h.setId(rs.getLong("id"));
                    h.setUserId(rs.getLong("user_id"));
                    h.setPrizeId(rs.getInt("prize_id"));
                    h.setPrizeName(rs.getString("prize_name"));
                    h.setPrizeType(rs.getString("prize_type"));
                    h.setRewardCode(rs.getString("reward_code"));
                    h.setDiscountValue(rs.getDouble("discount_value"));
                    h.setIsUsed(rs.getBoolean("is_used"));
                    h.setUsedAt(rs.getTimestamp("used_at"));
                    h.setExpiredAt(rs.getTimestamp("expired_at"));
                    h.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<LuckySpinHistoryModel> findAllHistoryForAdmin(int limit) {
        String sql = """
            SELECT h.*, u.full_name as user_name, u.phone as user_phone 
            FROM lucky_spin_history h
            LEFT JOIN users u ON h.user_id = u.id
            ORDER BY h.created_at DESC LIMIT ?
        """;
        List<LuckySpinHistoryModel> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit <= 0 ? 50 : limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LuckySpinHistoryModel h = new LuckySpinHistoryModel();
                    h.setId(rs.getLong("id"));
                    h.setUserId(rs.getLong("user_id"));
                    h.setUserName(rs.getString("user_name"));
                    h.setUserPhone(rs.getString("user_phone"));
                    h.setPrizeId(rs.getInt("prize_id"));
                    h.setPrizeName(rs.getString("prize_name"));
                    h.setPrizeType(rs.getString("prize_type"));
                    h.setRewardCode(rs.getString("reward_code"));
                    h.setDiscountValue(rs.getDouble("discount_value"));
                    h.setIsUsed(rs.getBoolean("is_used"));
                    h.setUsedAt(rs.getTimestamp("used_at"));
                    h.setExpiredAt(rs.getTimestamp("expired_at"));
                    h.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Long saveHistory(LuckySpinHistoryModel history) {
        String sql = """
            INSERT INTO lucky_spin_history 
            (user_id, prize_id, prize_name, prize_type, reward_code, discount_value, is_used, expired_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, history.getUserId());
            ps.setInt(2, history.getPrizeId());
            ps.setString(3, history.getPrizeName());
            ps.setString(4, history.getPrizeType());
            ps.setString(5, history.getRewardCode());
            ps.setDouble(6, history.getDiscountValue());
            ps.setBoolean(7, history.getIsUsed() != null ? history.getIsUsed() : false);
            ps.setTimestamp(8, history.getExpiredAt());

            int aff = ps.executeUpdate();
            if (aff > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getLong(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean markRewardUsed(String rewardCode) {
        if (rewardCode == null || rewardCode.trim().isEmpty()) return false;
        String sql = "UPDATE lucky_spin_history SET is_used = TRUE, used_at = CURRENT_TIMESTAMP WHERE reward_code = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, rewardCode.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int getUserSpinCount(Long userId) {
        if (userId == null) return 0;
        String sql = "SELECT spin_count FROM users WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("spin_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean decrementUserSpinCount(Long userId) {
        if (userId == null) return false;
        // Trừ nguyên tử trong DB để chống Race condition (đua lệnh)
        String sql = "UPDATE users SET spin_count = spin_count - 1 WHERE id = ? AND spin_count > 0";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean grantUserSpins(Long userId, int spins) {
        if (userId == null || spins <= 0) return false;
        String sql = "UPDATE users SET spin_count = COALESCE(spin_count, 0) + ? WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, spins);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean claimDailyFreeSpin(Long userId) {
        if (userId == null) return false;
        // Kiểm tra xem hôm nay đã điểm danh nhận lượt quay chưa
        String checkSql = "SELECT last_daily_spin_date FROM users WHERE id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.sql.Date lastDate = rs.getDate("last_daily_spin_date");
                    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                    if (lastDate != null && lastDate.toString().equals(today.toString())) {
                        return false; // Hôm nay đã nhận rồi
                    }
                }
            }

            // Cập nhật +1 lượt quay và lưu ngày điểm danh hôm nay
            String updateSql = "UPDATE users SET spin_count = COALESCE(spin_count, 0) + 1, last_daily_spin_date = CURRENT_DATE WHERE id = ?";
            try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                updatePs.setLong(1, userId);
                return updatePs.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Map<String, Object> getAdminStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalSpins", 0);
        stats.put("totalWonPrizes", 0);
        stats.put("totalUsedPrizes", 0);
        stats.put("winRate", 0.0);

        String sql = """
            SELECT 
                COUNT(*) as total_spins,
                SUM(CASE WHEN prize_type != 'NO_PRIZE' THEN 1 ELSE 0 END) as total_won,
                SUM(CASE WHEN is_used = TRUE THEN 1 ELSE 0 END) as total_used
            FROM lucky_spin_history
        """;
        try (Connection conn = DBConnectionUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                int total = rs.getInt("total_spins");
                int won = rs.getInt("total_won");
                int used = rs.getInt("total_used");
                double rate = total > 0 ? ((double) won / total) * 100 : 0.0;

                stats.put("totalSpins", total);
                stats.put("totalWonPrizes", won);
                stats.put("totalUsedPrizes", used);
                stats.put("winRate", Math.round(rate * 10.0) / 10.0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
