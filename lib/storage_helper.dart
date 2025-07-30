import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryStorage {
  static const String _boxName = 'history_items';

  static Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }
    static Future<void> addImage(String imagePath) async {
    final item = HistoryItem(
      imagePath: imagePath,
      userMessage: '',
      chatResponse: '',
      chatId: '',
       time: DateTime.now().toIso8601String(),
    );
    await addItem(item);
  }

  static Future<void> addItem(HistoryItem item) async {
    final box = await _openBox();
    await box.add(item.toJsonString());
  }

  static Future<List<HistoryItem>> getItems() async {
    final box = await _openBox();
    return box.values.map((e) => HistoryItem.fromJsonString(e)).toList();
  }

  static Future<void> removeItem(String imagePath) async {
    final box = await _openBox();
    final keyToDelete = box.keys.firstWhere(
      (key) {
        final item = HistoryItem.fromJsonString(box.get(key)!);
        return item.imagePath == imagePath;
      },
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }

    final file = File(imagePath);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        print('خطا در حذف فایل: $e');
      }
    }
  }

  // static removeImage(String imagePath) {}
  static removeImage(String imagePath) {
  return removeItem(imagePath);
}


  // static clearAll() {}
  static Future<void> clearAll() async {
  final box = await _openBox();

  // حذف همه فایل‌ها از حافظه
  for (var value in box.values) {
    final item = HistoryItem.fromJsonString(value);
    final file = File(item.imagePath);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        print('خطا در حذف فایل: $e');
      }
    }
  }

  // پاک‌سازی کل داده‌ها
  await box.clear();
}

}

class HistoryItem {
  final String imagePath;
  final String userMessage;
  final String chatResponse;
  final String chatId; // اضافه شده
  final String time; // یا date یا createdAt و غیره
// dateFormat.format(DateTime.parse(item.time))


  HistoryItem({
    required this.time,
    required this.imagePath,
    required this.userMessage,
    required this.chatResponse,
    required this.chatId,
  });

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'userMessage': userMessage,
        'chatResponse': chatResponse,
        'chatId': chatId,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
        imagePath: json['imagePath'] ?? '',
        userMessage: json['userMessage'] ?? '',
        chatResponse: json['chatResponse'] ?? '',
        chatId: json['chatId'] ?? '',
         time: json['time']??'',
      );
  String toJsonString() => jsonEncode(toJson());

  static HistoryItem fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return HistoryItem.fromJson(json);
  }
}
