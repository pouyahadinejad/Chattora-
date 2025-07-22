// // import 'package:hive/hive.dart';

// // class HistoryStorage {
// //   static Future<void> addImage(String path) async {
// //     final box = await Hive.openBox<String>('imageHistory');
// //     if (!box.values.contains(path)) {
// //       await box.add(path);
// //     }
// //   }

// //   static Future<List<String>> getImages() async {
// //     final box = await Hive.openBox<String>('imageHistory');
// //     return box.values.toList();
// //   }

// //   static Future<void> clearImages() async {
// //     final box = await Hive.openBox<String>('imageHistory');
// //     await box.clear();
// //   }

// //   static removeImage(String path) {}
// // }














// import 'dart:io';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// class HistoryStorage {
//   static const String _boxName = 'history_images';

//   static Future<void> addImage(String imagePath) async {
//     final box = await Hive.openBox<String>(_boxName);
//     if (!box.values.contains(imagePath)) {
//       await box.add(imagePath);
//     }
//   }

//   static Future<List<String>> getImages() async {
//     final box = await Hive.openBox<String>(_boxName);
//     return box.values.toList();
//   }

//   static Future<void> removeImage(String imagePath) async {
//     final box = await Hive.openBox<String>(_boxName);

//     // حذف از Hive
//     final keyToRemove = box.keys.firstWhere(
//       (key) => box.get(key) == imagePath,
//       orElse: () => null,
//     );
//     if (keyToRemove != null) {
//       await box.delete(keyToRemove);
//     }

//     // حذف از حافظه
//     final file = File(imagePath);
//     if (await file.exists()) {
//       await file.delete();
//     }
//   }

//   static Future<void> clearAllImages() async {
//     final box = await Hive.openBox<String>(_boxName);
//     for (final path in box.values) {
//       final file = File(path);
//       if (await file.exists()) {
//         await file.delete();
//       }
//     }
//     await box.clear();
//   }
// }



///////////////////////////////////1.1

// import 'dart:convert';
// import 'dart:io';
// import 'package:hive_flutter/hive_flutter.dart';

// class HistoryStorage {
//   static const String _boxName = 'history_items';

//   static Future<Box<String>> _openBox() async {
//     if (!Hive.isBoxOpen(_boxName)) {
//       return await Hive.openBox<String>(_boxName);
//     }
//     return Hive.box<String>(_boxName);
//   }
//     /// این متد برای سازگاری با بخش‌هایی که فقط تصویر ذخیره می‌کردند
//   static Future<void> addImage(String imagePath) async {
//     final item = HistoryItem(
//       imagePath: imagePath,
//       userMessage: '',
//       chatResponse: '',
//       chatId: '',
//     );
//     await addItem(item);
//   }


//   static Future<void> addItem(HistoryItem item) async {
//     final box = await _openBox();
//     await box.add(item.toJsonString());
//   }

//   static Future<List<HistoryItem>> getItems() async {
//     final box = await _openBox();
//     return box.values.map((e) => HistoryItem.fromJsonString(e)).toList();
//   }

//   static Future<void> removeItem(String imagePath) async {
//     final box = await _openBox();
//     final keyToDelete = box.keys.firstWhere(
//       (key) {
//         final item = HistoryItem.fromJsonString(box.get(key)!);
//         return item.imagePath == imagePath;
//       },
//       orElse: () => null,
//     );

//     if (keyToDelete != null) {
//       await box.delete(keyToDelete);
//     }

//     final file = File(imagePath);
//     if (await file.exists()) {
//       try {
//         await file.delete();
//       } catch (e) {
//         print('خطا در حذف فایل: $e');
//       }
//     }
//   }
// }

// class HistoryItem {
//   final String imagePath;
//   final String userMessage;
//   final String chatResponse;
//   final String chatId; // اضافه شده

//   HistoryItem({
//     required this.imagePath,
//     required this.userMessage,
//     required this.chatResponse,
//     required this.chatId,
//   });

//   Map<String, dynamic> toJson() => {
//         'imagePath': imagePath,
//         'userMessage': userMessage,
//         'chatResponse': chatResponse,
//         'chatId': chatId,
//       };

//   factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
//         imagePath: json['imagePath'] ?? '',
//         userMessage: json['userMessage'] ?? '',
//         chatResponse: json['chatResponse'] ?? '',
//         chatId: json['chatId'] ?? '',
//       );

//   String toJsonString() => jsonEncode(toJson());

//   static HistoryItem fromJsonString(String jsonString) {
//     final Map<String, dynamic> json = jsonDecode(jsonString);
//     return HistoryItem.fromJson(json);
//   }
// }
//1.2


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
}

class HistoryItem {
  final String imagePath;
  final String userMessage;
  final String chatResponse;
  final String chatId; // اضافه شده

  HistoryItem({
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
      );

  String toJsonString() => jsonEncode(toJson());

  static HistoryItem fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return HistoryItem.fromJson(json);
  }
}
