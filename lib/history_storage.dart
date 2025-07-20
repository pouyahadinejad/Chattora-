// import 'package:hive/hive.dart';

// class HistoryStorage {
//   static Future<void> addImage(String imagePath) async {
//     final box = await Hive.openBox<String>('imageHistory');
//     await box.add(imagePath);
//   }

//   static Future<List<String>> getImages() async {
//     final box = await Hive.openBox<String>('imageHistory');
//     return box.values.toList();
//   }

//   static Future<void> clearHistory() async {
//     final box = await Hive.openBox<String>('imageHistory');
//     await box.clear();
//   }
// }





import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryStorage {
  static const _boxName = 'history_images';

  /// باز کردن باکس Hive
  static Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  /// گرفتن همه تصاویر (مسیرهای فایل)
  static Future<List<String>> getImages() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// اضافه کردن مسیر عکس جدید
  static Future<void> addImage(String path) async {
    final box = await _openBox();
    if (!box.values.contains(path)) {
      await box.add(path);
    }
  }

  /// حذف مسیر عکس و همچنین حذف فایل عکس فیزیکی
  static Future<void> removeImage(String path) async {
    final box = await _openBox();

    // حذف آدرس از Hive
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key) == path,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }

    // حذف فایل عکس از حافظه دستگاه
    final file = File(path);
    if (await file.exists()) {
      try {
        await file.delete();
      } catch (e) {
        // اگر حذف فایل با خطا مواجه شد، می‌توان اینجا مدیریت کرد
        print('خطا در حذف فایل: $e');
      }
    }
  }
}
