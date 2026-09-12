package vn.edu.eaut.fruitables.util;

import java.io.InputStream;
import java.util.Properties;

public class GeminiConfigUtil {

    private static String apiKey = "";
    private static String model = "gemini-3.6-flash";
    private static int maxOutputTokens = 800;
    private static double temperature = 0.5;

    static {
        loadConfig();
    }

    public static synchronized void loadConfig() {
        // 1. Kiểm tra biến môi trường hệ thống
        String envKey = System.getenv("GEMINI_API_KEY");
        if (envKey != null && !envKey.trim().isEmpty()) {
            apiKey = envKey.trim();
        }

        // 2. Đọc từ file gemini.properties trong classpath
        try (InputStream input = GeminiConfigUtil.class.getClassLoader().getResourceAsStream("gemini.properties")) {
            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);

                String propKey = prop.getProperty("gemini.api.key");
                if ((apiKey == null || apiKey.isEmpty()) && propKey != null && !propKey.trim().isEmpty()) {
                    apiKey = propKey.trim();
                }

                String propModel = prop.getProperty("gemini.model");
                if (propModel != null && !propModel.trim().isEmpty()) {
                    model = propModel.trim();
                }

                String propMaxTokens = prop.getProperty("gemini.max.output.tokens");
                if (propMaxTokens != null) {
                    try {
                        maxOutputTokens = Integer.parseInt(propMaxTokens.trim());
                    } catch (NumberFormatException ignored) {}
                }

                String propTemp = prop.getProperty("gemini.temperature");
                if (propTemp != null) {
                    try {
                        temperature = Double.parseDouble(propTemp.trim());
                    } catch (NumberFormatException ignored) {}
                }
            }
        } catch (Exception e) {
            System.err.println("[GeminiConfigUtil] Error loading gemini.properties: " + e.getMessage());
        }
    }

    public static String getApiKey() {
        if (apiKey == null || apiKey.isEmpty()) {
            loadConfig();
        }
        return apiKey;
    }

    public static String getModel() {
        return model;
    }

    public static int getMaxOutputTokens() {
        return maxOutputTokens;
    }

    public static double getTemperature() {
        return temperature;
    }

    public static String getApiUrl() {
        return "https://generativelanguage.googleapis.com/v1beta/models/" + getModel() + ":generateContent?key=" + getApiKey();
    }

    public static boolean isConfigured() {
        return getApiKey() != null && !getApiKey().trim().isEmpty();
    }
}
