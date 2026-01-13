import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';

  var token = ''.obs;
  var userEmail = ''.obs;

  // ✅ NEW: Add secure storage
  final _secureStorage = const FlutterSecureStorage();

  // ✅ NEW: Initialize storage - load saved token on app start
  Future<TokenService> init() async {
    try {
      // Read token from secure storage
      final savedToken = await _secureStorage.read(key: _tokenKey);
      final savedEmail = await _secureStorage.read(key: _userEmailKey);

      if (savedToken != null) {
        token.value = savedToken;
        print('✅ Token loaded from storage: ${savedToken.substring(0, 20)}...');
      }

      if (savedEmail != null) {
        userEmail.value = savedEmail;
        print('✅ Email loaded from storage: $savedEmail');
      }

      return this;
    } catch (e) {
      print('❌ Error initializing TokenService: $e');
      return this;
    }
  }

  // Save token
  Future<void> saveToken(String newToken) async {
    try {
      token.value = newToken;

      // ✅ NEW: Also save to secure storage (persistent)
      await _secureStorage.write(key: _tokenKey, value: newToken);
      print('✅ Token saved to secure storage');
    } catch (e) {
      print('❌ Error saving token: $e');
      rethrow;
    }
  }

  // Save user email
  Future<void> saveUserEmail(String email) async {
    try {
      userEmail.value = email;

      // ✅ NEW: Also save to secure storage (persistent)
      await _secureStorage.write(key: _userEmailKey, value: email);
      print('✅ Email saved to secure storage');
    } catch (e) {
      print('❌ Error saving email: $e');
      rethrow;
    }
  }

  // Get stored token
  String? getToken() {
    return token.value.isNotEmpty ? token.value : null;
  }

  // Get stored email
  String? getUserEmail() {
    return userEmail.value.isNotEmpty ? userEmail.value : null;
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return token.value.isNotEmpty;
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    try {
      token.value = '';
      userEmail.value = '';

      // ✅ NEW: Also delete from secure storage
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userEmailKey);
      print('✅ Token cleared from storage');
    } catch (e) {
      print('❌ Error clearing token: $e');
      rethrow;
    }
  }
}
