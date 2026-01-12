import 'package:gamify/services/token.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final String baseUrl = 'https://annett-stereoscopic-xavi.ngrok-free.dev';

  // ✅ Use your existing TokenService
  late TokenService _tokenService;

  @override
  void onInit() {
    super.onInit();
    _tokenService = Get.find<TokenService>();
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse('$baseUrl/auth/auth/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': '',
          'username': email,
          'password': password,
          'scope': '',
          'client_id': '',
          'client_secret': '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // ✅ Save token using your TokenService (only saveToken)
        await _tokenService.saveToken(token);

        successMessage.value = 'Login successful!';
        return true;
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Invalid email or password';
        return false;
      } else if (response.statusCode == 422) {
        _parseValidationError(response.body);
        return false;
      } else {
        errorMessage.value = 'Login failed. Status: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (password != confirmPassword) {
        errorMessage.value = 'Passwords do not match';
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/auth/register'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'email': email, 'password': password, 'role': 'user'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];

        // ✅ Save token using your TokenService (only saveToken)
        await _tokenService.saveToken(token);

        successMessage.value = 'Account created successfully!';
        return true;
      } else if (response.statusCode == 400) {
        errorMessage.value = 'Email already registered';
        return false;
      } else if (response.statusCode == 422) {
        _parseValidationError(response.body);
        return false;
      } else {
        errorMessage.value = 'Signup failed. Status: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Logout method
  Future<void> logout() async {
    try {
      await _tokenService.clearToken();
      clearMessages();

      // Navigate to login
      Get.offAllNamed('/login');
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
      errorMessage.value = 'Logout failed: ${e.toString()}';
    }
  }

  void _parseValidationError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded['detail'] != null) {
        final detail = decoded['detail'];

        if (detail is List && detail.isNotEmpty) {
          final firstError = detail[0];

          if (firstError is Map && firstError['msg'] != null) {
            errorMessage.value = firstError['msg'] ?? 'Validation error';
          } else if (firstError is String) {
            errorMessage.value = firstError;
          } else {
            errorMessage.value = 'Validation error occurred';
          }
        } else if (detail is String) {
          errorMessage.value = detail;
        } else if (detail is Map && detail['msg'] != null) {
          errorMessage.value = detail['msg'];
        } else {
          errorMessage.value = 'Validation error';
        }
      } else {
        errorMessage.value = 'Validation error occurred';
      }
    } catch (e) {
      errorMessage.value = 'Error parsing response: ${e.toString()}';
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }
}
