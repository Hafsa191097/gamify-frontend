import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  final String baseUrl = 'http://192.168.110.254:8000';

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
        // Store token in secure storage (implement with secure_storage package)
        final token = data['access_token'];
        Get.put<String>(token); // Store token for later use

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
        // ✅ CORRECT: Use form-urlencoded, not JSON
        body: {'email': email, 'password': password, 'role': 'user'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        Get.put<String>(token); // Store token for later use
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

  void _parseValidationError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      // Check if detail exists
      if (decoded['detail'] != null) {
        final detail = decoded['detail'];

        // Handle if detail is a list (array of validation errors)
        if (detail is List && detail.isNotEmpty) {
          // Get the first error message
          final firstError = detail[0];

          if (firstError is Map && firstError['msg'] != null) {
            errorMessage.value = firstError['msg'] ?? 'Validation error';
          } else if (firstError is String) {
            // If it's just a string error message
            errorMessage.value = firstError;
          } else {
            errorMessage.value = 'Validation error occurred';
          }
        }
        // Handle if detail is a string (single error message)
        else if (detail is String) {
          errorMessage.value = detail;
        }
        // Handle if detail is a map (single error object)
        else if (detail is Map && detail['msg'] != null) {
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
