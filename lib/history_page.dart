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
//                 // if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
//                 //   Image.file(File(item.imagePath)),
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
//                 return GestureDetector(
//                   onTap: () => _showDetails(item),
//                   child: Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       leading: item.imagePath.isNotEmpty && File(item.imagePath).existsSync()
//                           ? GestureDetector(
//                               onTap: () => _showDetails(item),
//                               child: Image.file(
//                                 File(item.imagePath),
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : const Icon(Icons.image_not_supported, size: 48),
//                       title: Text(item.userMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
//                       subtitle: Text(item.chatResponse, maxLines: 2, overflow: TextOverflow.ellipsis),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _deleteItem(item.imagePath),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }





/////تست تصویر

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

//   // Future<void> _deleteItem(String imagePath) async {
//   //   final confirmed = await showDialog<bool>(
//   //     context: context,
//   //     builder: (_) => AlertDialog(
//   //       title: const Text('حذف'),
//   //       content: const Text('آیا از حذف این مورد اطمینان دارید؟'),
//   //       actions: [
//   //         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('خیر')),
//   //         TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('بله')),
//   //       ],
//   //     ),
//   //   );

//   //   if (confirmed == true) {
//   //     await HistoryStorage.removeItem(imagePath);
//   //     _loadItems();
//   //   }
//   // }
//   Future<void> _deleteItem(String imagePath) async {
//   final confirmed = await showDialog<bool>(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('حذف'),
//       content: const Text('آیا از حذف این مورد اطمینان دارید؟'),
//       actions: [
//         TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('خیر')),
//         TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('بله')),
//       ],
//     ),
//   );

//   if (confirmed == true) {
//     // حذف از منبع داده ذخیره شده
//     await HistoryStorage.removeItem(imagePath);

//     // حذف از لیست داخل صفحه و به‌روزرسانی UI به صورت فوری
//     setState(() {
//       items.removeWhere((item) => item.imagePath == imagePath);
//     });
//   }
// }


//   void _showDetails(HistoryItem item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => Directionality(
//           textDirection: TextDirection.rtl,
//           child: Scaffold(
//             appBar: AppBar(title: const Text('نمایش چت'), backgroundColor: Colors.green),
//             body: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       child: Image.file(
//                         File(item.imagePath),
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   const Text('سوال:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                   const SizedBox(height: 6),
//                   Text(item.userMessage, style: TextStyle(fontSize: 16)),
//                   const SizedBox(height: 16),
//                   const Text('پاسخ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                   const SizedBox(height: 6),
//                   Text(item.chatResponse, style: TextStyle(fontSize: 16)),
//                   const SizedBox(height: 16),
//                   Text('Chat ID: ${item.chatId}', style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('تاریخچه'), backgroundColor: Colors.green),
//         body: items.isEmpty
//             ? const Center(child: Text('موردی ذخیره نشده.', style: TextStyle(fontSize: 16)))
//             : ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   final item = items[index];
//                   return Card(
//                     elevation: 3,
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap: () => _showDetails(item),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // تصویر بالای کارت
//                             if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.file(
//                                   File(item.imagePath),
//                                   width: double.infinity,
//                                   height: 180,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             else
//                               Container(
//                                 height: 180,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade300,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
//                               ),
                            
//                             const SizedBox(height: 12),
      
//                             // متن سوال
//                             Text(
//                               'سوال:',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green.shade800),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               item.userMessage,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 14),
//                             ),
                            
//                             const SizedBox(height: 10),
      
//                             // متن پاسخ
//                             Text(
//                               'پاسخ:',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green.shade800),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               item.chatResponse,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//                             ),
      
//                             // دکمه حذف
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.redAccent),
//                                 onPressed: () => _deleteItem(item.imagePath),
//                                 tooltip: 'حذف مورد',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import 'dart:io';
// import 'package:flutter/material.dart';
import 'package:otpuivada/storage_helper.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> items = [];
  bool isLoading = false;
  bool isDeleting = false;

  // رنگ‌های اختصاصی
  final Color primaryColor = const Color(0xFF2E7D32);
  final Color secondaryColor = const Color(0xFF81C784);
  final Color backgroundColor = const Color(0xFFF1F8E9);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF263238);
  final Color errorColor = const Color(0xFFE57373);

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => isLoading = true);
    final loadedItems = await HistoryStorage.getItems();
    setState(() {
      items = loadedItems;
      isLoading = false;
    });
  }

  Future<void> _deleteItem(String imagePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف آیتم', style: TextStyle(fontFamily: 'Vazir')),
        content: const Text('آیا از حذف این مورد اطمینان دارید؟', 
            style: TextStyle(fontFamily: 'Vazir')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Vazir')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Vazir')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isDeleting = true);
      await HistoryStorage.removeItem(imagePath);
      setState(() {
        items.removeWhere((item) => item.imagePath == imagePath);
        isDeleting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('آیتم با موفقیت حذف شد', 
              style: TextStyle(fontFamily: 'Vazir')),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _deleteAllItems() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف همه تاریخچه', style: TextStyle(fontFamily: 'Vazir')),
        content: const Text('آیا می‌خواهید تمام تاریخچه را پاک کنید؟', 
            style: TextStyle(fontFamily: 'Vazir')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Vazir')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف همه', style: TextStyle(fontFamily: 'Vazir')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isLoading = true);
      await HistoryStorage.clearAll();
      setState(() {
        items.clear();
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تمام تاریخچه حذف شد', 
              style: TextStyle(fontFamily: 'Vazir')),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showDetails(HistoryItem item) {
    final dateFormat = DateFormat('yyyy/MM/dd - HH:mm');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('جزئیات تاریخچه', style: TextStyle(fontFamily: 'Vazir')),
            backgroundColor: primaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تصویر
                if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(item.imagePath),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                // اطلاعات تاریخچه
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاریخ و زمان:',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '',
                        // dateFormat.format(DateTime.parse(item.timestamp)),
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'شناسه چت:',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        item.chatId,
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // سوال کاربر
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سوال شما:',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.userMessage,
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 16,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // پاسخ چت
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'پاسخ:',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.chatResponse,
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 16,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    final dateFormat = DateFormat('yyyy/MM/dd - HH:mm');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // تصویر
          if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.file(
                File(item.imagePath),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          
          // محتوای کارت
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تاریخ و زمان
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: textColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      '',
                      // dateFormat.format(DateTime.parse(item.timestamp)),
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // سوال کاربر
                Text(
                  'سوال:',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.userMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    color: textColor,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // پاسخ چت
                Text(
                  'پاسخ:',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.chatResponse,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // دکمه‌های عملیاتی
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _showDetails(item),
                      child: const Text(
                        'مشاهده جزئیات',
                        style: TextStyle(fontFamily: 'Vazir'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: errorColor,
                      ),
                      onPressed: () => _deleteItem(item.imagePath),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'تاریخچه‌ای یافت نشد',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 18,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'پردازش‌های شما اینجا نمایش داده می‌شود',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 14,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('تاریخچه پردازش‌ها', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: primaryColor,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _deleteAllItems,
              tooltip: 'حذف همه تاریخچه',
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: primaryColor,
                size: 80,
              ),
            )
          : items.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: items.map(_buildHistoryItem).toList(),
                  ),
                ),
    );
  }
}