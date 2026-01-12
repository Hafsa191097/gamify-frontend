import 'package:gamify/services/token.dart';
import 'package:get/get.dart';

class ApiHeaders {
  /// Get headers with authorization token
  /// Token is automatically retrieved from TokenService
  static Map<String, String> getHeaders() {
    final tokenService = Get.find<TokenService>();
    final token = tokenService.getToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get token
  static String? getToken() {
    final tokenService = Get.find<TokenService>();
    return tokenService.getToken();
  }

  /// Check if authenticated
  static bool isAuthenticated() {
    final tokenService = Get.find<TokenService>();
    return tokenService.isAuthenticated();
  }

  /// Clear token (logout)
  static Future<void> clearToken() async {
    final tokenService = Get.find<TokenService>();
    await tokenService.clearToken();
  }
}
