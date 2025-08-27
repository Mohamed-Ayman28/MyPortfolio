import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendEmail(String name, String email, String message) async {
  const serviceId = "your_service_id";
  const templateId = "your_template_id";
  const userId = "your_public_key";

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
    url,
    headers: {"origin": "http://localhost", "Content-Type": "application/json"},
    body: json.encode({
      "service_id": serviceId,
      "template_id": templateId,
      "user_id": userId,
      "template_params": {
        "user_name": name,
        "user_email": email,
        "user_message": message,
      },
    }),
  );

  if (response.statusCode == 200) {
    print("✅ Email sent successfully!");
  } else {
    print("❌ Failed to send email: ${response.body}");
  }
}
