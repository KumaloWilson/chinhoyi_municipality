import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:public_ip_address/public_ip_address.dart';


class MailServices{

  static final Logger _logger = Logger();

  static Future<void> sendEmail({required String recipientEmail, required String recipientUserName, required String emailSubject, required String emailBody}) async {
    String sender = 'kumalowilson900@outlook.com';
    String password = 'Wily0734?';

    final smtpServer = hotmail(sender, password);

    // Create our message.
    final message = Message()
      ..from = Address(sender, 'Markiti')
      ..recipients.add(recipientEmail)
      ..subject = '$emailSubject at ${DateTime.now()}'
      ..text = emailBody
      ..html = "<h1>Dear $recipientUserName </h1>\n<p>$emailBody</p>\n\n<h2>Best Regards </h2>\n<h2>Markiti Team</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      _logger.i('Message sent: $sendReport');
    } on MailerException catch (e) {
      _logger.e('Message not sent.');
      for (var p in e.problems) {
        _logger.e('Problem: ${p.code}: ${p.msg}');
      }
    }

  }

  static Future<void> sendEmailAfterSuccessfulLogin({required String email, required String username }) async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;

    var ipAddress = await IpAddress().getIp();
    var city = await IpAddress().getCity();
    var country = await IpAddress().getCountry();


    String emailSubject = 'Login Activity';

    String emailBody = (
        "\nWe are pleased to inform you that you have successfully logged in to our app."
            "\nHere are the details of your login:"

            "\n- Logged-in Device: ${webInfo.browserName} ${webInfo.platform} ${webInfo.appName}"
            "\n- IP Address: $ipAddress"
            "\n- Location: $city, $country"

            "\n\nIf you did not initiate this login or suspect any unauthorized access to your account, please contact us immediately."
            "\nThank you for using our app!"

    );

    await sendEmail(recipientEmail: email, recipientUserName: username, emailSubject: emailSubject, emailBody: emailBody);


  }

  static Future<void> sendEmailAfterOrderAction({required String email, required String username, required String message, required String subject }) async{
    sendEmail(recipientEmail: email, recipientUserName: username, emailSubject: subject, emailBody: message);
  }


}