// import 'package:hive_flutter/hive_flutter.dart';

// class AuthService {
//   static Future<void> saveToken(String token) async {
//     var box = Hive.box<String>('auth');
//     await box.put('token', token);
//   }

//   static String? getToken() {
//     var box = Hive.box<String>('auth');
//     return box.get('token');
//   }

//   static Future<void> clearToken() async {
//     var box = Hive.box<String>('auth');
//     await box.delete('token');
//   }

//   static bool isLoggedIn() {
//     final token = getToken();
//     return token != null && token.isNotEmpty;
//   }
// }




import 'dart:convert';
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

  // متدی برای استخراج userId از توکن JWT
  static String? getUserId() {
    final token = getToken();
    if (token == null) return null;

    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded);

      // کلید user_id ممکنه متفاوت باشه، اینو با کلید واقعی جایگزین کن
      if (payloadMap.containsKey('user_id')) {
        return payloadMap['user_id'].toString();
      } else if (payloadMap.containsKey('id')) {
        // مثلا اگر کلید id است
        return payloadMap['id'].toString();
      } else {
        return null;
      }
    } catch (e) {
      print('Error decoding token to get userId: $e');
      return null;
    }
  }
}
