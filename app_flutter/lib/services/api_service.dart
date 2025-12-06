// app_flutter/lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000/api"; // للمحاكي Android

  /// تحقق من رقم الهوية عبر الـ backend
  static Future<Map<String, dynamic>> verifyNationalId(
    String nationalId,
  ) async {
    final url = Uri.parse("$baseUrl/verify_national_id");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'national_id': nationalId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return {
          "status": "error",
          "message": "Backend error: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": "error", "message": "Cannot reach backend: $e"};
    }
  }
}
