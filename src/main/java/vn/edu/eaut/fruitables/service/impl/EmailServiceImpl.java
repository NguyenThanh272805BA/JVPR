package vn.edu.eaut.fruitables.service.impl;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailServiceImpl {
    // THAY THẾ BẰNG EMAIL VÀ APP PASSWORD CỦA BẠN
    private final String fromEmail = "your-email@gmail.com";
    private final String password = "your-app-password-here";

    public boolean sendOTP(String toEmail, String otpCode) {
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
}