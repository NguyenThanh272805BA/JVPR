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
        // Nếu cấu hình lỗi, không cho gửi để tránh exception[cite: 2]
        if (fromEmail == null || password == null) {
            System.out.println("Chưa cấu hình Email hệ thống!");
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); //[cite: 2]
        props.put("mail.smtp.port", "587"); //[cite: 2]
        props.put("mail.smtp.auth", "true"); //[cite: 2]
        props.put("mail.smtp.starttls.enable", "true"); //[cite: 2]

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password); //[cite: 2]
            }
        });

        try {
            Message message = new MimeMessage(session); //[cite: 2]
            message.setFrom(new InternetAddress(fromEmail)); //[cite: 2]
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); //[cite: 2]
            message.setSubject("Mã OTP xác thực tài khoản Fruitables"); //[cite: 2]
            message.setContent( //[cite: 2]
                    "<h3>Chào mừng bạn đến với Fruitables!</h3>" + //[cite: 2]
                            "<p>Mã OTP kích hoạt tài khoản của bạn là: <b style='color:green; font-size: 20px;'>" + otpCode + "</b></p>" + //[cite: 2]
                            "<p>Mã này có hiệu lực trong 5 phút. Không chia sẻ mã này cho bất kỳ ai.</p>", //[cite: 2]
                    "text/html; charset=utf-8" //[cite: 2]
            ); //[cite: 2]
            Transport.send(message); //[cite: 2]
            return true; //[cite: 2]
        } catch (MessagingException e) { //[cite: 2]
            e.printStackTrace(); //[cite: 2]
            return false; //[cite: 2]
        }
    }
}