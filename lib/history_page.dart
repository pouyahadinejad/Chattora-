// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:otpuivada/storage_helper.dart';

// // // // class HistoryPage extends StatelessWidget {
// // // //   const HistoryPage({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: const Text('تاریخچه تصاویر'), backgroundColor: Colors.green),
// // // //       body: FutureBuilder<List<String>>(
// // // //         future: HistoryStorage.getImages(),
// // // //         builder: (context, snapshot) {
// // // //           if (!snapshot.hasData) {
// // // //             return const Center(child: CircularProgressIndicator());
// // // //           }

// // // //           final images = snapshot.data!;
// // // //           if (images.isEmpty) {
// // // //             return const Center(child: Text('هیچ تصویری ذخیره نشده.'));
// // // //           }

// // // //           return ListView.builder(
// // // //             itemCount: images.length,
// // // //             itemBuilder: (context, index) {
// // // //               return Card(
// // // //                 margin: const EdgeInsets.all(8),
// // // //                 child: Image.file(File(images[index]), height: 200, fit: BoxFit.cover),
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }


// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:otpuivada/storage_helper.dart';

// // // class HistoryPage extends StatefulWidget {
// // //   const HistoryPage({super.key});

// // //   @override
// // //   State<HistoryPage> createState() => _HistoryPageState();
// // // }

// // // class _HistoryPageState extends State<HistoryPage> {
// // //   late Future<List<String>> _imageFuture;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _imageFuture = HistoryStorage.getImages();
// // //   }

// // //   void _refreshImages() {
// // //     setState(() {
// // //       _imageFuture = HistoryStorage.getImages();
// // //     });
// // //   }

// // //   Future<void> _confirmDelete(BuildContext context, String path) async {
// // //     final shouldDelete = await showDialog<bool>(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: const Text('حذف تصویر'),
// // //         content: const Text('آیا از حذف این تصویر اطمینان دارید؟'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: const Text('خیر'),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () => Navigator.pop(context, true),
// // //             child: const Text('بله'),
// // //           ),
// // //         ],
// // //       ),
// // //     );

// // //     if (shouldDelete == true) {
// // //       await HistoryStorage.removeImage(path);
// // //       _refreshImages();
// // //     }
// // //   }

// // //   void _openImage(String path) {
// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => FullImagePage(imagePath: path),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('تاریخچه تصاویر'),
// // //         backgroundColor: Colors.green,
// // //       ),
// // //       body: FutureBuilder<List<String>>(
// // //         future: _imageFuture,
// // //         builder: (context, snapshot) {
// // //           if (!snapshot.hasData) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }

// // //           final images = snapshot.data!;
// // //           if (images.isEmpty) {
// // //             return const Center(child: Text('هیچ تصویری ذخیره نشده.'));
// // //           }

// // //           return GridView.builder(
// // //             padding: const EdgeInsets.all(8),
// // //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //               crossAxisCount: 2, // تعداد ستون‌ها
// // //               crossAxisSpacing: 8,
// // //               mainAxisSpacing: 8,
// // //             ),
// // //             itemCount: images.length,
// // //             itemBuilder: (context, index) {
// // //               final imagePath = images[index];
// // //               return Stack(
// // //                 children: [
// // //                   InkWell(
// // //                     onTap: () => _openImage(imagePath),
// // //                     child: ClipRRect(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                       child: Image.file(
// // //                         File(imagePath),
// // //                         height: double.infinity,
// // //                         width: double.infinity,
// // //                         fit: BoxFit.cover,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   Positioned(
// // //                     top: 6,
// // //                     right: 6,
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.black.withOpacity(0.5),
// // //                         shape: BoxShape.circle,
// // //                       ),
// // //                       child: IconButton(
// // //                         icon: const Icon(Icons.delete, color: Colors.white, size: 20),
// // //                         onPressed: () => _confirmDelete(context, imagePath),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // // class FullImagePage extends StatelessWidget {
// // //   final String imagePath;

// // //   const FullImagePage({super.key, required this.imagePath});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.black,
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //       ),
// // //       body: Center(
// // //         child: Image.file(File(imagePath)),
// // //       ),
// // //     );
// // //   }
// // // }




// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:otpuivada/storage_helper.dart';

// // // class HistoryPage extends StatefulWidget {
// // //   const HistoryPage({super.key});

// // //   @override
// // //   State<HistoryPage> createState() => _HistoryPageState();
// // // }

// // // class _HistoryPageState extends State<HistoryPage> {
// // //   late Future<List<String>> _imageFuture;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _imageFuture = HistoryStorage.getImages();
// // //   }

// // //   void _refreshImages() {
// // //     setState(() {
// // //       _imageFuture = HistoryStorage.getImages();
// // //     });
// // //   }

// // //   Future<void> _confirmDelete(BuildContext context, String path) async {
// // //     final shouldDelete = await showDialog<bool>(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: const Text('حذف تصویر'),
// // //         content: const Text('آیا از حذف این تصویر اطمینان دارید؟'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: const Text('خیر'),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () => Navigator.pop(context, true),
// // //             child: const Text('بله'),
// // //           ),
// // //         ],
// // //       ),
// // //     );

// // //     if (shouldDelete == true) {
// // //       await HistoryStorage.removeImage(path);
// // //       _refreshImages();
// // //     }
// // //   }

// // //   void _openImage(String path) {
// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => FullImagePage(imagePath: path),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('تاریخچه تصاویر'),
// // //         backgroundColor: Colors.green,
// // //       ),
// // //       body: FutureBuilder<List<String>>(
// // //         future: _imageFuture,
// // //         builder: (context, snapshot) {
// // //           if (!snapshot.hasData) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }

// // //           final images = snapshot.data!;
// // //           if (images.isEmpty) {
// // //             return const Center(child: Text('هیچ تصویری ذخیره نشده.'));
// // //           }

// // //           return GridView.builder(
// // //             padding: const EdgeInsets.all(8),
// // //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //               crossAxisCount: 2, // تعداد ستون‌ها
// // //               crossAxisSpacing: 8,
// // //               mainAxisSpacing: 8,
// // //             ),
// // //             itemCount: images.length,
// // //             itemBuilder: (context, index) {
// // //               final imagePath = images[index];
// // //               return Stack(
// // //                 children: [
// // //                   InkWell(
// // //                     onTap: () => _openImage(imagePath),
// // //                     child: ClipRRect(
// // //                       borderRadius: BorderRadius.circular(12),
// // //                       child: Image.file(
// // //                         File(imagePath),
// // //                         height: double.infinity,
// // //                         width: double.infinity,
// // //                         fit: BoxFit.cover,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   Positioned(
// // //                     top: 6,
// // //                     right: 6,
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.black.withOpacity(0.5),
// // //                         shape: BoxShape.circle,
// // //                       ),
// // //                       child: IconButton(
// // //                         icon: const Icon(Icons.delete, color: Colors.white, size: 20),
// // //                         onPressed: () => _confirmDelete(context, imagePath),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // // class FullImagePage extends StatelessWidget {
// // //   final String imagePath;

// // //   const FullImagePage({super.key, required this.imagePath});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.black,
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //       ),
// // //       body: Center(
// // //         child: Image.file(File(imagePath)),
// // //       ),
// // //     );
// // //   }
// // // }












// //////////nice




// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:otpuivada/storage_helper.dart';

// // class HistoryPage extends StatefulWidget {
// //   const HistoryPage({super.key});

// //   @override
// //   State<HistoryPage> createState() => _HistoryPageState();
// // }

// // class _HistoryPageState extends State<HistoryPage> {
// //   late Future<List<String>> _imagesFuture;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadImages();
// //   }

// //   void _loadImages() {
// //     _imagesFuture = HistoryStorage.getImages();
// //   }

// //   Future<void> _deleteImage(String path) async {
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text('حذف تصویر'),
// //         content: const Text('آیا مطمئن هستید که می‌خواهید این تصویر را حذف کنید؟'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(false),
// //             child: const Text('خیر'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(true),
// //             child: const Text('بله'),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirmed == true) {
// //       await HistoryStorage.removeImage(path);
// //       setState(() {
// //         _loadImages();
// //       });
// //     }
// //   }

// //   void _showImageFullScreen(String path) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => Scaffold(
// //           appBar: AppBar(
// //             backgroundColor: Colors.green,
// //             title: const Text('نمایش تصویر'),
// //           ),
// //           body: Center(
// //             child: Image.file(File(path)),
// //           ),
// //           floatingActionButton: FloatingActionButton(
// //             backgroundColor: Colors.red,
// //             onPressed: () async {
// //               Navigator.of(context).pop();
// //               await _deleteImage(path);
// //             },
// //             child: const Icon(Icons.delete),
// //             tooltip: 'حذف تصویر',
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('تاریخچه تصاویر'),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: FutureBuilder<List<String>>(
// //         future: _imagesFuture,
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           final images = snapshot.data!;
// //           if (images.isEmpty) {
// //             return const Center(child: Text('هیچ تصویری ذخیره نشده.'));
// //           }

// //           return ListView.builder(
// //             itemCount: images.length,
// //             itemBuilder: (context, index) {
// //               final imagePath = images[index];
// //               return Card(
// //                 margin: const EdgeInsets.all(8),
// //                 child: ListTile(
// //                   contentPadding: const EdgeInsets.all(8),
// //                   leading: Image.file(File(imagePath), width: 80, height: 80, fit: BoxFit.cover),
// //                   title: Text('تصویر شماره ${index + 1}'),
// //                   onTap: () => _showImageFullScreen(imagePath),
// //                   trailing: IconButton(
// //                     icon: const Icon(Icons.delete, color: Colors.red),
// //                     onPressed: () => _deleteImage(imagePath),
// //                     tooltip: 'حذف تصویر',
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
















// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:otpuivada/storage_helper.dart';

// // class HistoryPage extends StatefulWidget {
// //   const HistoryPage({super.key});

// //   @override
// //   State<HistoryPage> createState() => _HistoryPageState();
// // }

// // class _HistoryPageState extends State<HistoryPage> {
// //   late Future<List<String>> _imagesFuture;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _imagesFuture = HistoryStorage.getImages();
// //   }

// //   void _refreshImages() {
// //     setState(() {
// //       _imagesFuture = HistoryStorage.getImages();
// //     });
// //   }

// //   Future<void> _confirmDelete(BuildContext context, String imagePath) async {
// //     final confirm = await showDialog<bool>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text('حذف تصویر'),
// //         content: const Text('آیا از حذف این تصویر مطمئن هستید؟'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx, false),
// //             child: const Text('لغو'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx, true),
// //             child: const Text('حذف', style: TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );

// //     if (confirm == true) {
// //       await HistoryStorage.removeImage(imagePath);
// //       _refreshImages();
// //     }
// //   }

// //   void _openImageFullScreen(String imagePath) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => ImagePreviewPage(imagePath: imagePath),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('تاریخچه تصاویر'),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: FutureBuilder<List<String>>(
// //         future: _imagesFuture,
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           final images = snapshot.data!;
// //           if (images.isEmpty) {
// //             return const Center(child: Text('هیچ تصویری ذخیره نشده.'));
// //           }

// //           return ListView.builder(
// //             itemCount: images.length,
// //             itemBuilder: (context, index) {
// //               final path = images[index];
// //               return Card(
// //                 margin: const EdgeInsets.all(8),
// //                 child: ListTile(
// //                   contentPadding: const EdgeInsets.all(8),
// //                   leading: GestureDetector(
// //                     onTap: () => _openImageFullScreen(path),
// //                     child: Image.file(
// //                       File(path),
// //                       width: 80,
// //                       height: 80,
// //                       fit: BoxFit.cover,
// //                     ),
// //                   ),
// //                   title: Text('تصویر ${index + 1}'),
// //                   trailing: IconButton(
// //                     icon: const Icon(Icons.delete, color: Colors.red),
// //                     onPressed: () => _confirmDelete(context, path),
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // class ImagePreviewPage extends StatelessWidget {
// //   final String imagePath;

// //   const ImagePreviewPage({super.key, required this.imagePath});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('نمایش تصویر'),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: Center(
// //         child: Image.file(File(imagePath)),
// //       ),
// //     );
// //   }
// // }



















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:otpuivada/storage_helper.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<String> images = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImages();
//   }

//   Future<void> _loadImages() async {
//     final loadedImages = await HistoryStorage.getImages();
//     setState(() {
//       images = loadedImages;
//     });
//   }

//   Future<void> _deleteImage(String path) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('حذف تصویر'),
//         content: const Text('آیا از حذف این تصویر اطمینان دارید؟'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('خیر')),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('بله')),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await HistoryStorage.removeImage(path);
//       _loadImages(); // Refresh
//     }
//   }

//   void _showImage(String path) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           appBar: AppBar(title: const Text('نمایش تصویر'), backgroundColor: Colors.green),
//           body: Center(child: Image.file(File(path))),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تاریخچه تصاویر'), backgroundColor: Colors.green),
//       body: images.isEmpty
//           ? const Center(child: Text('هیچ تصویری ذخیره نشده.'))
//           : ListView.builder(
//               itemCount: images.length,
//               itemBuilder: (context, index) {
//                 final path = images[index];
//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: ListTile(
//                     leading: GestureDetector(
//                       onTap: () => _showImage(path),
//                       child: Image.file(
//                         File(path),
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text('تصویر ${index + 1}'),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteImage(path),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
////////////////////////////////////////////////1.1

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:otpuivada/storage_helper.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({super.key});

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   List<HistoryItem> items = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadItems();
//   }

//   Future<void> _loadItems() async {
//     final loadedItems = await HistoryStorage.getItems();
//     setState(() {
//       items = loadedItems;
//     });
//   }

//   Future<void> _deleteItem(String imagePath) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('حذف'),
//         content: const Text('آیا از حذف این مورد اطمینان دارید؟'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('خیر')),
//           TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('بله')),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await HistoryStorage.removeItem(imagePath);
//       _loadItems();
//     }
//   }

//   void _showDetails(HistoryItem item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           appBar: AppBar(title: const Text('نمایش چت'), backgroundColor: Colors.green),
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.file(File(item.imagePath)),
//                 const SizedBox(height: 16),
//                 Text('سوال:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(item.userMessage),
//                 const SizedBox(height: 8),
//                 Text('پاسخ:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(item.chatResponse),
//                 const SizedBox(height: 8),
//                 Text('Chat ID: ${item.chatId}', style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تاریخچه'), backgroundColor: Colors.green),
//       body: items.isEmpty
//           ? const Center(child: Text('موردی ذخیره نشده.'))
//           : ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: ListTile(
//                     leading: GestureDetector(
//                       onTap: () => _showDetails(item),
//                       child: Image.file(
//                         File(item.imagePath),
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(item.userMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
//                     subtitle: Text(item.chatResponse, maxLines: 2, overflow: TextOverflow.ellipsis),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteItem(item.imagePath),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
//1.2

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:otpuivada/storage_helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final loadedItems = await HistoryStorage.getItems();
    setState(() {
      items = loadedItems;
    });
  }

  Future<void> _deleteItem(String imagePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف'),
        content: const Text('آیا از حذف این مورد اطمینان دارید؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('خیر')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('بله')),
        ],
      ),
    );

    if (confirmed == true) {
      await HistoryStorage.removeItem(imagePath);
      _loadItems();
    }
  }

  void _showDetails(HistoryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('نمایش چت'), backgroundColor: Colors.green),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
                //   Image.file(File(item.imagePath)),
                const SizedBox(height: 16),
                Text('سوال:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.userMessage),
                const SizedBox(height: 8),
                Text('پاسخ:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.chatResponse),
                const SizedBox(height: 8),
                Text('Chat ID: ${item.chatId}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تاریخچه'), backgroundColor: Colors.green),
      body: items.isEmpty
          ? const Center(child: Text('موردی ذخیره نشده.'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () => _showDetails(item),
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: item.imagePath.isNotEmpty && File(item.imagePath).existsSync()
                          ? GestureDetector(
                              onTap: () => _showDetails(item),
                              child: Image.file(
                                File(item.imagePath),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image_not_supported, size: 48),
                      title: Text(item.userMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(item.chatResponse, maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item.imagePath),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}