import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class TokenService extends GetxService {
  var token = ''.obs;
  var userEmail = ''.obs;

  bool isAuthenticated() {
    return token.value.isNotEmpty;
  }

  Future<void> saveToken(String newToken) async {
    token.value = newToken;
  }

  String? getToken() {
    return token.value.isNotEmpty ? token.value : null;
  }

  Future<void> clearToken() async {
    token.value = '';
    userEmail.value = '';
  }

  Future<void> saveUserEmail(String email) async {}
}
