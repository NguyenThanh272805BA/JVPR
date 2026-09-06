package vn.edu.eaut.fruitables.service.impl;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;

public class EmailServiceImpl {
    private String fromEmail;
    private String password;

    // Sử dụng Constructor để load file properties khi Service được khởi tạo
    public EmailServiceImpl() {
        try (InputStream input = Thread.currentThread().getContextClassLoader().getResourceAsStream("application.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Không tìm thấy file application.properties");
                return;
            }
            // Load file properties
            prop.load(input);
            // Lấy giá trị từ file
            this.fromEmail = prop.getProperty("mail.sender.email");
            this.password = prop.getProperty("mail.sender.password");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public boolean sendOTP(String toEmail, String otpCode) {
        // Nếu cấu hình lỗi, không cho gửi để tránh exception
        if (fromEmail == null || password == null) {
            System.out.println("Chưa cấu hình Email hệ thống!");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP xác thực tài khoản Fruitables");
            message.setContent(
                    "<h3>Chào mừng bạn đến với Fruitables!</h3>" +
                            "<p>Mã OTP kích hoạt tài khoản của bạn là: <b style='color:green; font-size: 20px;'>" + otpCode + "</b></p>" +
                            "<p>Mã này có hiệu lực trong 5 phút. Không chia sẻ mã này cho bất kỳ ai.</p>",
                    "text/html; charset=utf-8"
            );
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendPasswordResetOTP(String toEmail, String otpCode) {
        if (fromEmail == null || password == null) {
            System.out.println("Chưa cấu hình Email hệ thống!");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Yêu cầu đặt lại mật khẩu - Fruitables");
            message.setContent(
                    "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 12px; background-color: #ffffff;'>" +
                            "<h2 style='color: #4CAF50; text-align: center; margin-bottom: 20px;'>Khôi phục Mật khẩu Fruitables</h2>" +
                            "<p>Xin chào quý khách,</p>" +
                            "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản liên kết với địa chỉ email này.</p>" +
                            "<div style='background-color: #f1f8e9; padding: 15px; border-radius: 8px; text-align: center; margin: 25px 0;'>" +
                            "  <p style='margin: 0; color: #555; font-size: 14px;'>Mã xác minh OTP của bạn là:</p>" +
                            "  <h1 style='color: #2E7D32; letter-spacing: 6px; margin: 10px 0; font-size: 32px; font-weight: bold;'>" + otpCode + "</h1>" +
                            "  <p style='margin: 0; color: #888; font-size: 12px;'>Mã có hiệu lực trong vòng <b>5 phút</b></p>" +
                            "</div>" +
                            "<p style='color: #666; font-size: 13px; line-height: 1.6;'>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này. Tài khoản của bạn vẫn an toàn tuyệt đối.</p>" +
                            "<hr style='border: none; border-top: 1px solid #eee; margin: 20px 0;'/>" +
                            "<p style='text-align: center; color: #999; font-size: 12px;'>Fruitables - Thực phẩm sạch cho gia đình bạn.</p>" +
                            "</div>",
                    "text/html; charset=utf-8"
            );
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}