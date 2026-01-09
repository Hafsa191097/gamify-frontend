import 'package:get/get.dart';

class TokenService extends GetxService {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  
  var token = ''.obs;
  var userEmail = ''.obs;

  // Initialize token from storage
  Future<TokenService> init() async {
    // In a real app, you would use flutter_secure_storage
    // For now, we're using in-memory storage
    return this;
  }

  // Save token
  Future<void> saveToken(String newToken) async {
    token.value = newToken;
    // In a real app:
    // await _storage.write(key: _tokenKey, value: newToken);
  }

  // Save user email
  Future<void> saveUserEmail(String email) async {
    userEmail.value = email;
    // In a real app:
    // await _storage.write(key: _userEmailKey, value: email);
  }

  // Get stored token
  String? getToken() {
    return token.value.isNotEmpty ? token.value : null;
    // In a real app:
    // return await _storage.read(key: _tokenKey);
  }

  // Get stored email
  String? getUserEmail() {
    return userEmail.value.isNotEmpty ? userEmail.value : null;
    // In a real app:
    // return await _storage.read(key: _userEmailKey);
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return token.value.isNotEmpty;
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    token.value = '';
    userEmail.value = '';
    // In a real app:
    // await _storage.delete(key: _tokenKey);
    // await _storage.delete(key: _userEmailKey);
  }
}