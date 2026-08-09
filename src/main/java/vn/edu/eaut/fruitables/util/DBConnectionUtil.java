package vn.edu.eaut.fruitables.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnectionUtil {
    private static HikariDataSource dataSource;

    // Khởi tạo block static để load cấu hình ngay khi class được nạp
    static {
        try (InputStream input = DBConnectionUtil.class.getClassLoader().getResourceAsStream("application.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Sorry, unable to find application.properties");
            } else {
                prop.load(input);

                HikariConfig config = new HikariConfig();
                config.setDriverClassName(prop.getProperty("db.driver"));
                config.setJdbcUrl(prop.getProperty("db.url"));
                config.setUsername(prop.getProperty("db.username"));
                config.setPassword(prop.getProperty("db.password"));

                // Tối ưu pool
                config.setMinimumIdle(Integer.parseInt(prop.getProperty("hikari.minimumIdle", "5")));
                config.setMaximumPoolSize(Integer.parseInt(prop.getProperty("hikari.maximumPoolSize", "20")));
                config.setIdleTimeout(Long.parseLong(prop.getProperty("hikari.idleTimeout", "30000")));
                config.setMaxLifetime(Long.parseLong(prop.getProperty("hikari.maxLifetime", "1800000")));
                config.setConnectionTimeout(Long.parseLong(prop.getProperty("hikari.connectionTimeout", "30000")));
                config.setPoolName(prop.getProperty("hikari.poolName", "HikariPool"));

                // Cấu hình tối ưu hiệu năng MySQL
                config.addDataSourceProperty("cachePrepStmts", "true");
                config.addDataSourceProperty("prepStmtCacheSize", "250");
                config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

                dataSource = new HikariDataSource(config);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing HikariCP", e);
        }
    }

    // Hàm lấy Connection từ Pool
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // Đóng Pool khi shutdown server (Cần gọi trong ServletContextListener)
    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}