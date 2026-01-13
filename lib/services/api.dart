import 'package:gamify/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      late String baseUrl = EnvironmentConfig.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/auth/auth/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'grant_type': '',
          'username': email,
          'password': password,
          'scope': '',
          'client_id': '',
          'client_secret': '',
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Invalid username or password'};
      } else if (response.statusCode == 422) {
        _handleValidationError(response.body);
        return {'success': false, 'error': _lastValidationError};
      } else {
        return {
          'success': false,
          'error': 'Login failed. Please try again. (${response.statusCode})',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
  }) async {
    try {
      late String base_url = EnvironmentConfig.baseUrl;
      final response = await http.post(
        Uri.parse('$base_url/auth/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': 'user',
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 400) {
        return {'success': false, 'error': 'Email already registered'};
      } else if (response.statusCode == 422) {
        _handleValidationError(response.body);
        return {'success': false, 'error': _lastValidationError};
      } else {
        return {
          'success': false,
          'error': 'Signup failed. Please try again. (${response.statusCode})',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static String _lastValidationError = 'Validation error';

  static void _handleValidationError(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded['detail'] != null) {
        final detail = decoded['detail'];

        // Handle array of validation errors
        if (detail is List && detail.isNotEmpty) {
          final firstError = detail[0];

          if (firstError is Map && firstError['msg'] != null) {
            _lastValidationError = firstError['msg'];
          } else if (firstError is String) {
            _lastValidationError = firstError;
          } else {
            _lastValidationError = 'Validation error occurred';
          }
        }
        // Handle single string error
        else if (detail is String) {
          _lastValidationError = detail;
        }
        // Handle single object error
        else if (detail is Map && detail['msg'] != null) {
          _lastValidationError = detail['msg'];
        } else {
          _lastValidationError = 'Validation error';
        }
      } else {
        _lastValidationError = 'Validation error occurred';
      }
    } catch (e) {
      _lastValidationError = 'Error parsing response: ${e.toString()}';
    }
  }

  static Future<Map<String, dynamic>> getBookDetails({
    required int bookId,
    String? token,
  }) async {
    try {
       late String base_url = EnvironmentConfig.baseUrl;
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse('$base_url/books/$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else if (response.statusCode == 404) {
        return {'success': false, 'error': 'Book not found'};
      } else {
        return {
          'success': false,
          'error': 'Failed to load book. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> logout({required String token}) async {
    try {
       late String base_url = EnvironmentConfig.baseUrl;
      final response = await http.post(
        Uri.parse('$base_url/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Logged out successfully'};
      } else {
        return {'success': false, 'error': 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> verifyToken({
    required String token,
  }) async {
    try {
       late String base_url = EnvironmentConfig.baseUrl;
      final response = await http.get(
        Uri.parse('$base_url/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Token verification failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Get user profile
  /// Endpoint: GET /auth/me
  static Future<Map<String, dynamic>> getUserProfile({
    required String token,
  }) async {
    try {
       late String base_url = EnvironmentConfig.baseUrl;
      final response = await http.get(
        Uri.parse('$base_url/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'error': 'Failed to fetch profile'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }
}
