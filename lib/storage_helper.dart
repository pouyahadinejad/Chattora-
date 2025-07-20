// import 'package:hive/hive.dart';

// class HistoryStorage {
//   static Future<void> addImage(String path) async {
//     final box = await Hive.openBox<String>('imageHistory');
//     if (!box.values.contains(path)) {
//       await box.add(path);
//     }
//   }

//   static Future<List<String>> getImages() async {
//     final box = await Hive.openBox<String>('imageHistory');
//     return box.values.toList();
//   }

//   static Future<void> clearImages() async {
//     final box = await Hive.openBox<String>('imageHistory');
//     await box.clear();
//   }

//   static removeImage(String path) {}
// }














import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HistoryStorage {
  static const String _boxName = 'history_images';

  static Future<void> addImage(String imagePath) async {
    final box = await Hive.openBox<String>(_boxName);
    if (!box.values.contains(imagePath)) {
      await box.add(imagePath);
    }
  }

  static Future<List<String>> getImages() async {
    final box = await Hive.openBox<String>(_boxName);
    return box.values.toList();
  }

  static Future<void> removeImage(String imagePath) async {
    final box = await Hive.openBox<String>(_boxName);

    // حذف از Hive
    final keyToRemove = box.keys.firstWhere(
      (key) => box.get(key) == imagePath,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await box.delete(keyToRemove);
    }

    // حذف از حافظه
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> clearAllImages() async {
    final box = await Hive.openBox<String>(_boxName);
    for (final path in box.values) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await box.clear();
  }
}
