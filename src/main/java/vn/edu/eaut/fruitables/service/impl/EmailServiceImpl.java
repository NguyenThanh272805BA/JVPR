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

    public boolean sendEmailLinkOTP(String toEmail, String otpCode) {
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
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Fruitables Hoa Quả Sạch", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP xác minh liên kết Gmail - Fruitables", "UTF-8");
            message.setContent(
                    "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 16px; background-color: #ffffff;'>" +
                            "<div style='text-align: center; margin-bottom: 20px;'>" +
                            "  <h1 style='color: #81c408; margin: 0; font-size: 26px; font-weight: 800;'>Fruitables</h1>" +
                            "  <p style='color: #64748b; font-size: 13px; margin-top: 4px;'>Xác minh liên kết tài khoản Gmail</p>" +
                            "</div>" +
                            "<p>Xin chào,</p>" +
                            "<p>Bạn vừa yêu cầu liên kết địa chỉ Gmail này với tài khoản Fruitables để nhận thông báo và phần quà <b>Voucher 50.000₫</b>.</p>" +
                            "<div style='background-color: #f0fdf4; border: 1px solid #bbf7d0; padding: 18px; border-radius: 12px; text-align: center; margin: 25px 0;'>" +
                            "  <p style='margin: 0; color: #15803d; font-size: 13px; font-weight: bold;'>MÃ XÁC MINH OTP CỦA BẠN LÀ:</p>" +
                            "  <h1 style='color: #166534; letter-spacing: 8px; margin: 12px 0; font-size: 36px; font-weight: 900;'>" + otpCode + "</h1>" +
                            "  <p style='margin: 0; color: #64748b; font-size: 12px;'>Mã có hiệu lực trong vòng <b>5 phút</b></p>" +
                            "</div>" +
                            "<p style='color: #64748b; font-size: 13px; line-height: 1.5;'>Không chia sẻ mã này với bất kỳ ai để đảm bảo an toàn cho tài khoản của bạn.</p>" +
                            "<hr style='border: none; border-top: 1px solid #f1f5f9; margin: 20px 0;'/>" +
                            "<p style='text-align: center; color: #94a3b8; font-size: 11px;'>Fruitables - Thực phẩm sạch cho gia đình bạn.</p>" +
                            "</div>",
                    "text/html; charset=utf-8"
            );
            Transport.send(message);
            return true;
        } catch (Exception e) {
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

    public void sendShippingNotification(String toEmail, String orderCode, String customerName, double totalAmount, String estimateTime) {
        vn.edu.eaut.fruitables.model.entity.OrderModel order = new vn.edu.eaut.fruitables.model.entity.OrderModel();
        order.setOrderCode(orderCode);
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod("COD / Trực tuyến");
        sendShippingNotification(toEmail, customerName, order);
    }

    public void sendShippingNotification(String toEmail, String customerName, vn.edu.eaut.fruitables.model.entity.OrderModel order) {
        if (toEmail == null || toEmail.trim().isEmpty() || fromEmail == null || password == null) {
            return;
        }

        // Chạy trên luồng riêng biệt để không làm đơ giao diện Admin
        new Thread(() -> {
            try {
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

                String name = (customerName != null && !customerName.trim().isEmpty()) ? customerName : "Quý khách";
                String orderCode = order.getOrderCode() != null ? order.getOrderCode() : ("#" + order.getId());
                String totalFormatted = String.format("%,.0f ₫", order.getTotalAmount() != null ? order.getTotalAmount() : 0.0);
                String address = order.getShippingAddress() != null ? order.getShippingAddress() : "Địa chỉ đã đăng ký";

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(fromEmail, "Fruitables Hoa Quả Sạch", "UTF-8"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail.trim()));
                message.setSubject("🚚 [Fruitables] Đơn hàng " + orderCode + " đang trên đường giao tới bạn!", "UTF-8");

                StringBuilder html = new StringBuilder();
                html.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 25px; border: 1px solid #e0e0e0; border-radius: 16px; background-color: #ffffff;'>");
                html.append("<div style='text-align: center; margin-bottom: 20px;'>");
                html.append("  <h1 style='color: #81c408; margin: 0; font-size: 28px; font-weight: 800;'>Fruitables</h1>");
                html.append("  <p style='color: #666; font-size: 13px; margin-top: 4px;'>Nông sản & Hoa quả sạch chuẩn VietGAP</p>");
                html.append("</div>");

                html.append("<div style='background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); padding: 20px; border-radius: 12px; border: 1px solid #bbf7d0; text-align: center; margin-bottom: 24px;'>");
                html.append("  <div style='font-size: 38px; margin-bottom: 8px;'>🚚💨</div>");
                html.append("  <h2 style='color: #15803d; margin: 0 0 8px 0; font-size: 20px;'>Đơn hàng của bạn đang được giao tới!</h2>");
                html.append("  <p style='color: #166534; font-size: 14px; margin: 0;'>Shipper Fruitables đã nhận hoa quả tươi và đang trên đường giao đến bạn trong khoảng <b>30 - 45 phút</b> tới.</p>");
                html.append("</div>");

                html.append("<p style='font-size: 15px; color: #333;'>Xin chào <b>").append(name).append("</b>,</p>");
                html.append("<p style='font-size: 14px; color: #555; line-height: 1.6;'>Các sản phẩm trái cây trong đơn hàng của bạn đã được nhân viên tuyển chọn kỹ càng và bọc lưới xốp chống dập bảo quản cẩn thận.</p>");

                html.append("<div style='background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; margin: 20px 0;'>");
                html.append("  <h3 style='margin: 0 0 12px 0; color: #1e293b; font-size: 15px; border-bottom: 1px dashed #cbd5e1; pb: 8px;'>Thông tin đơn hàng:</h3>");
                html.append("  <p style='margin: 6px 0; font-size: 13px; color: #475569;'>• Mã đơn: <b style='color: #81c408;'>").append(orderCode).append("</b></p>");
                html.append("  <p style='margin: 6px 0; font-size: 13px; color: #475569;'>• Tổng thanh toán: <b style='color: #dc2626;'>").append(totalFormatted).append("</b> (").append(order.getPaymentMethod()).append(")</p>");
                html.append("  <p style='margin: 6px 0; font-size: 13px; color: #475569;'>• Địa chỉ nhận: <b>").append(address).append("</b></p>");
                html.append("  <p style='margin: 6px 0; font-size: 13px; color: #475569;'>• Số điện thoại: <b>").append(order.getPhone() != null ? order.getPhone() : "").append("</b></p>");
                html.append("</div>");

                html.append("<div style='background-color: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px;'>");
                html.append("  <p style='margin: 0; color: #92400e; font-size: 13px; line-height: 1.5;'><b>Lưu ý nhận hàng:</b> Quý khách vui lòng để ý điện thoại và được quyền <b>mở thùng đồng kiểm độ tươi</b> của trái cây trước khi thanh toán. Nếu có bất kỳ quả dập nát, quý khách sẽ được đổi trả miễn phí trong 24h!</p>");
                html.append("</div>");

                html.append("<p style='color: #64748b; font-size: 13px; text-align: center; margin-top: 25px;'>Cảm ơn bạn đã tin chọn thực phẩm sạch của Fruitables!</p>");
                html.append("<hr style='border: none; border-top: 1px solid #f1f5f9; margin: 20px 0;'/>");
                html.append("<p style='text-align: center; color: #94a3b8; font-size: 12px;'>Hotline hỗ trợ CSKH: 0375162932 | Email: ").append(fromEmail).append("</p>");
                html.append("</div>");

                message.setContent(html.toString(), "text/html; charset=utf-8");
                Transport.send(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }
}