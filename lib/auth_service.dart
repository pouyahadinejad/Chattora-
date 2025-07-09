import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  static Future<void> saveToken(String token) async {
    var box = Hive.box<String>('auth');
    await box.put('token', token);
  }

  static String? getToken() {
    var box = Hive.box<String>('auth');
    return box.get('token');
  }

  static Future<void> clearToken() async {
    var box = Hive.box<String>('auth');
    await box.delete('token');
  }

  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}
