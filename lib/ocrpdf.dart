// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/chat_list_page.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:otpuivada/history_page.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:sidebarx/sidebarx.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// class OCRPdfApp extends StatefulWidget {
//   final String? initialMessage;
//   const OCRPdfApp({super.key, this.initialMessage});

//   @override
//   State<OCRPdfApp> createState() => _OCRPdfAppState();
// }

// class _OCRPdfAppState extends State<OCRPdfApp> with SingleTickerProviderStateMixin {
//   final TextEditingController messageController = TextEditingController();
//   bool isloading=false;
//   String extractedText = '';
//   bool isLoading = false;
//   late AnimationController _controller; 
//   late Animation<double> _fadeAnimation;

//   final ImagePicker _picker = ImagePicker();
  
//   get controller => SidebarXController(selectedIndex: 0, extended: true);
//   // final SidebarXController _controller = SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> requestPermissions() async {
//     await [
//       Permission.storage,
//       Permission.camera,
//       Permission.photos,
//     ].request();
//   }

//   // Future<void> pickImage(ImageSource source) async {
//   //   await requestPermissions();

//   //   final XFile? pickedFile = await _picker.pickImage(source: source);

//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       isLoading = true;
//   //       extractedText = '';
//   //     });

//   //     await processImage(File(pickedFile.path), pickedFile.path);
//   //   }
//   // }
//   Future<void> pickImage(ImageSource source) async {
//   await requestPermissions();

//   final XFile? pickedFile = await _picker.pickImage(source: source);

//   if (pickedFile != null) {
//     await processImage(File(pickedFile.path), pickedFile.path);
//   }
// }

//   Future<void> processImage(File file, String imagePath) async {
//     final inputImage = InputImage.fromFile(file);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//     textRecognizer.close();

//     String text = cleanText(recognizedText.text);
//     final finalText = formatIeltsText(text);

//     setState(() {
//       isLoading = false;
//     });

//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ExtractedTextPage(text: finalText, imagePath: imagePath),
//       ),
//     );

//     if (result != null && result is String) {
//       Navigator.pop(context, result);
//     }
//   }

//   Future<void> pickPDF() async {
//     await requestPermissions();

//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         isLoading = true;
//         extractedText = '';
//       });
//       // await processPdf(result.files.single.path!);
//     }
//   }
//  String cleanText(String text) {
//     final lines = text.split('\n');
//     final filtered = lines
//         .map((line) => line.trim())
//         .where((line) => line.isNotEmpty && !RegExp(r'^[^\w]*\$').hasMatch(line) && line.length > 2)
//         .toList();

//     return filtered.join('\n');
//   }

//   String formatIeltsText(String text) {
//     final lines = text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
//     StringBuffer buffer = StringBuffer();
//     int questionNumber = 1;

//     for (final line in lines) {
//       if (RegExp(r'^\d+\.\s*').hasMatch(line)) {
//         buffer.writeln('\n🟡 **Question $questionNumber**');
//         buffer.writeln(line);
//         questionNumber++;
//       } else {
//         buffer.writeln(line);
//       }
//     }

//     return buffer.toString();
//   }

//   // void showPickerDialog() {
//   //   showModalBottomSheet(
//   //     backgroundColor: Colors.green.shade50,
//   //     context: context,
//   //     builder: (_) => SafeArea(
//   //       child: Wrap(
//   //         children: [
//   //           ListTile(
//   //             leading: const Icon(Icons.camera_alt),
//   //             title: const Text("گرفتن عکس با دوربین"),
//   //             onTap: () {
//   //               Navigator.pop(context);
//   //               pickImage(ImageSource.camera);
//   //             },
//   //           ),
//   //           ListTile(
//   //             leading: const Icon(Icons.photo_library),
//   //             title: const Text("انتخاب از گالری "),
//   //             onTap: () async{
                
//   //               Navigator.pop(context);
//   //               pickImage(ImageSource.gallery);
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   void showPickerDialog() {
//   showModalBottomSheet(
//     backgroundColor: Colors.green.shade50,
//     context: context,
//     builder: (_) => SafeArea(
//       child: Wrap(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.camera_alt),
//             title: const Text("گرفتن عکس با دوربین"),
//             onTap: () async {
//               Navigator.pop(context);
//               setState(() => isLoading = true);
//               try {
//                 await pickImage(ImageSource.camera);
//               } finally {
//                 if (mounted) {
//                   setState(() => isLoading = false);
//                 }
//               }
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.photo_library),
//             title: const Text("انتخاب از گالری"),
//             onTap: () async {
//               Navigator.pop(context);
//               setState(() => isLoading = true);
//               try {
//                 await pickImage(ImageSource.gallery);
//               } finally {
//                 if (mounted) {
//                   setState(() => isLoading = false);
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }

// @override
// Widget build(BuildContext context) {
//   final Box<String> authBox = Hive.box<String>('auth');
//   final mobileNumber = authBox.get('mobile') ?? 'نامشخص';
//   final firstName = authBox.get('first_name') ?? '---';
//   final lastName = authBox.get('last_name') ?? '---';
//   final fullName = '$firstName $lastName';
//   final screenSize = MediaQuery.of(context).size;

//   return Directionality(
//     textDirection: TextDirection.rtl,
//     child: WillPopScope(
//       onWillPop: () async {
//         final shouldPop = await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('خروج'),
//             content: Text('آیا می‌خواهید از صفحه خارج شوید؟'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: Text('خیر'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 child: Text('بله'),
//               ),
//             ],
//           ),
//         );
//         return shouldPop ?? false;
//       },
//       child: Scaffold(
//         drawer: Row(
//           children: [
//             SidebarX(
//               controller: controller,
//               theme: SidebarXTheme(
//                 width: 300,
//                 margin: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade700,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 hoverColor: Colors.green.shade400,
//                 textStyle: const TextStyle(
//                   fontFamily: 'Vazir',
//                   color: Colors.white,
//                 ),
//                 selectedTextStyle: const TextStyle(
//                   fontFamily: 'Vazir',
//                   color: Colors.black,
//                 ),
//                 selectedItemDecoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 selectedIconTheme: const IconThemeData(color: Colors.black),
//               ),
//               extendedTheme: const SidebarXTheme(
//                 width: 300,
//               ),
//               headerBuilder: (context, extended) {
//                 return Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 30),
//                       const Icon(Icons.account_circle, size: 60, color: Colors.white),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'خوش آمدید',
//                         style: TextStyle(
//                           fontFamily: 'Vazir',
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         fullName,
//                         style: const TextStyle(
//                           fontFamily: 'Vazir',
//                           fontSize: 16,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               items: [
//                 SidebarXItem(
//                   icon: Icons.chat,
//                   label: 'چت',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChatListPage(imagePath: ''),
//                       ),
//                     );
//                   },
//                 ),
//                 SidebarXItem(
//                   icon: Icons.logout,
//                   label: 'خروج',
//                   onTap: () async {
//                     await AuthService.clearToken();
//                     Navigator.pushNamedAndRemoveUntil(
//                       context,
//                       '/login',
//                       (route) => false,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green.shade50,
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//           backgroundColor: Colors.green,
//           title: Center(child: const Text('پردازش OCR', style: TextStyle(fontFamily: 'Vazir', color: Colors.white))),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.history),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HistoryPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: isLoading
//             ? Center(
//                 child: LoadingAnimationWidget.staggeredDotsWave(
//                   color: Colors.green,
//                   size: 80,
//                 ),
//               )
//             : Column(
//                 children: [
//                   // اطلاعات کاربر
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.all(12),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade100,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildInfoRow(Icons.phone_android, 'شماره موبایل: $mobileNumber'),
//                         const SizedBox(height: 8),
//                         _buildInfoRow(Icons.person, 'نام: $firstName'),
//                         const SizedBox(height: 8),
//                         _buildInfoRow(Icons.person_outline, 'نام خانوادگی: $lastName'),
//                       ],
//                     ),
//                   ),
//                   // آپلود تصویر OCR
//                   Expanded(
//                     child: Center(
//                       child: DottedBorder(
//                         color: Colors.green,
//                         strokeWidth: 1.5,
//                         borderType: BorderType.RRect,
//                         radius: const Radius.circular(30),
//                         dashPattern: const [10, 6],
//                         child: Container(
//                           width: screenSize.width * 0.9,
//                           height: screenSize.height * 0.7,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: showPickerDialog,
//                                 child: SvgPicture.asset(
//                                   'assets/document-upload.svg',
//                                   width: 60,
//                                   height: 60,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               const Text('آپلود تصویر سوال مورد نظر', style: TextStyle(fontFamily: 'Vazir')),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     ),
//   );
// }
// // ✅ تابع کمکی
// Widget _buildInfoRow(IconData icon, String text) {
//   return Row(
//     children: [
//       Icon(icon, color: Colors.green.shade800, size: 20),
//       const SizedBox(width: 8),
//       Text(
//         text,
//         style: const TextStyle(fontFamily: 'Vazir', fontSize: 14),
//       ),
//     ],
//   );
// }
// } 
// class ExtractedTextPage extends StatelessWidget {
//   final String text;
//   final String imagePath;

//   const ExtractedTextPage({super.key, required this.text, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('متن استخراج‌شده'), backgroundColor: Colors.green),
//       body: _ExtractedTextBody(text: text, imagePath: imagePath),
//     );
//   }
// }

// class _ExtractedTextBody extends StatefulWidget {
//   final String text;
//   final String imagePath;

//   const _ExtractedTextBody({required this.text, required this.imagePath});

//   @override
//   State<_ExtractedTextBody> createState() => _ExtractedTextBodyState();
// }

// class _ExtractedTextBodyState extends State<_ExtractedTextBody> {
//   bool isloading = false; // ✅ تعریف در سطح کلاس

//   @override
//   Widget build(BuildContext context) {
//     return isloading
//         ? Center(
//             child: LoadingAnimationWidget.staggeredDotsWave(
//               color: Colors.green,
//               size: 50,
//             ),
//           )
//         : Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: SelectableText(widget.text),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                         onPressed: () {
//                           // setState(() => isloading = true);
//                           // await Future.delayed(Duration(seconds: 1)); // عملیات مورد نظر
//                           // setState(() => isloading = false);
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => ChatListPage(
//                                 initialMessage: widget.text,
//                                 imagePath: widget.imagePath,
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text('تأیید'),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                         onPressed: () async {
//                           // setState(() => isloading = true);
//                           final editedText = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => EditTextPage(
//                                 initialText: widget.text,
//                                 imagePath: widget.imagePath,
//                               ),
//                             ),
//                           );
//                           setState(() => isloading = false);
//                           if (editedText != null) {
//                             Navigator.pop(context, editedText);
//                           }
//                         },
//                         child: const Text('ویرایش'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//   }
// }

// class EditTextPage extends StatefulWidget {
//   final String initialText;
//   final String imagePath;

//   const EditTextPage({super.key, required this.initialText, required this.imagePath});

//   @override
//   State<EditTextPage> createState() => _EditTextPageState();
// }

// class _EditTextPageState extends State<EditTextPage> {
//   late TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.initialText);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ویرایش متن'), backgroundColor: Colors.orange, automaticallyImplyLeading: false),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: TextField(
//                 controller: _controller,
//                 maxLines: null,
//                 expands: true,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'متن را ویرایش کنید...',
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ChatListPage(initialMessage: _controller.text, imagePath: widget.imagePath),
//                   ),
//                 );
//               },
//               child: const Text('ارسال به چت', style: TextStyle(color: Colors.black)),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }














import 'package:otpuivada/auth_service.dart';
import 'package:otpuivada/chat_list_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:otpuivada/history_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('auth');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR پردازشگر',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Vazir',
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
        appBarTheme: const AppBarTheme(
          elevation: 4,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const OCRPdfApp(),
    );
  }
}

class OCRPdfApp extends StatefulWidget {
  final String? initialMessage;
  const OCRPdfApp({super.key, this.initialMessage});

  @override
  State<OCRPdfApp> createState() => _OCRPdfAppState();
}

class _OCRPdfAppState extends State<OCRPdfApp> with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  bool isloading = false;
  String extractedText = '';
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final ImagePicker _picker = ImagePicker();
  final SidebarXController _sidebarController = SidebarXController(selectedIndex: 0, extended: true);

  // رنگ‌های اختصاصی
  final Color primaryColor = const Color(0xFF2E7D32);
  final Color secondaryColor = const Color(0xFF81C784);
  final Color backgroundColor = const Color(0xFFF1F8E9);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF263238);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _sidebarController.dispose();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<void> pickImage(ImageSource source) async {
    await requestPermissions();
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() => isLoading = true);
      try {
        await processImage(File(pickedFile.path), pickedFile.path);
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  Future<void> processImage(File file, String imagePath) async {
    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    textRecognizer.close();

    String text = cleanText(recognizedText.text);
    final finalText = formatIeltsText(text);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExtractedTextPage(text: finalText, imagePath: imagePath),
      ),
    );

    if (result != null && result is String) {
      Navigator.pop(context, result);
    }
  }

  Future<void> pickPDF() async {
    await requestPermissions();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => isLoading = true);
      // await processPdf(result.files.single.path!);
    }
  }

  String cleanText(String text) {
    final lines = text.split('\n');
    final filtered = lines
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !RegExp(r'^[^\w]*\$').hasMatch(line) && line.length > 2)
        .toList();

    return filtered.join('\n');
  }

  String formatIeltsText(String text) {
    final lines = text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    StringBuffer buffer = StringBuffer();
    int questionNumber = 1;

    for (final line in lines) {
      if (RegExp(r'^\d+\.\s*').hasMatch(line)) {
        buffer.writeln('\n🟡 **Question $questionNumber**');
        buffer.writeln(line);
        questionNumber++;
      } else {
        buffer.writeln(line);
      }
    }

    return buffer.toString();
  }

  void showPickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'انتخاب منبع تصویر',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: primaryColor),
                ),
                title: const Text("دوربین", style: TextStyle(fontFamily: 'Vazir')),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Colors.blue),
                ),
                title: const Text("گالری تصاویر", style: TextStyle(fontFamily: 'Vazir')),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خروج', style: TextStyle(fontFamily: 'Vazir')),
        content: const Text('آیا می‌خواهید از برنامه خارج شوید؟', style: TextStyle(fontFamily: 'Vazir')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('خیر', style: TextStyle(fontFamily: 'Vazir')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('بله', style: TextStyle(fontFamily: 'Vazir')),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget _buildSidebar(BuildContext context, String fullName, Color primaryColor) {
    return SidebarX(
      controller: _sidebarController,
      theme: SidebarXTheme(
        width: 280,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.green.shade400,
        textStyle: const TextStyle(
          fontFamily: 'Vazir',
          color: Colors.white,
        ),
        selectedTextStyle: const TextStyle(
          fontFamily: 'Vazir',
          color: Colors.black,
        ),
        itemTextPadding: const EdgeInsets.only(right: 16),
        selectedItemDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.black),
      ),
      extendedTheme: const SidebarXTheme(width: 280),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_circle, size: 50, color: Colors.green),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: const Text(
                  'خوش آمدید',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  fullName,
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'صفحه اصلی',
          onTap: () => Navigator.pop(context),
        ),
        SidebarXItem(
          icon: Icons.chat,
          label: 'چت',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatListPage(imagePath: ''),
              ),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.history,
          label: 'تاریخچه',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'خروج',
          onTap: () async {
            await AuthService.clearToken();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(String mobileNumber, String firstName, String lastName) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'پروفایل کاربری',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_android, 'شماره موبایل: $mobileNumber'),
          const Divider(height: 20, thickness: 0.5),
          _buildInfoRow(Icons.person, 'نام: $firstName'),
          const Divider(height: 20, thickness: 0.5),
          _buildInfoRow(Icons.person_outline, 'نام خانوادگی: $lastName'),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: showPickerDialog,
          child: DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(16), 
              color: primaryColor,         // رنگ نقطه‌ها
              dashPattern: [6, 3],         // اندازه نقطه‌ها و فاصله بینشون
              strokeWidth: 1,              
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload,
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'برای آپلود تصویر کلیک کنید',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 16,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'فرمت‌های پشتیبانی شده: JPG, PNG',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontFamily: 'Vazir', fontSize: 14, color: textColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<String> authBox = Hive.box<String>('auth');
    final mobileNumber = authBox.get('mobile') ?? 'نامشخص';
    final firstName = authBox.get('first_name') ?? '---';
    final lastName = authBox.get('last_name') ?? '---';
    final fullName = '$firstName $lastName';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () => _showExitDialog(context),
        child: Scaffold(
          drawer: _buildSidebar(context, fullName, primaryColor),
          backgroundColor: backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: primaryColor,
            title: const Center(
              child: Text(
                'پردازش OCR',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //هم رنگ appbar
            actions: [
              IconButton(
                icon: const Icon(Icons.history, size: 28,color: Colors.transparent,),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage()),
                ),
              ),
            ],

            // actions: [Container()],
          ),
          body: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: primaryColor,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'در حال پردازش تصویر...',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          color: primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildUserInfoCard(mobileNumber, firstName, lastName),
                    _buildUploadSection(),
                  ],
                ),
        ),
      ),
    );
  }
}

class ExtractedTextPage extends StatelessWidget {
  final String text;
  final String imagePath;

  const ExtractedTextPage({super.key, required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متن استخراج‌شده', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.green,
      ),
      body: _ExtractedTextBody(text: text, imagePath: imagePath),
    );
  }
}

class _ExtractedTextBody extends StatefulWidget {
  final String text;
  final String imagePath;

  const _ExtractedTextBody({required this.text, required this.imagePath});

  @override
  State<_ExtractedTextBody> createState() => _ExtractedTextBodyState();
}

class _ExtractedTextBodyState extends State<_ExtractedTextBody> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final editedText = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTextPage(
                            initialText: widget.text,
                            imagePath: widget.imagePath,
                          ),
                        ),
                      );
                      if (editedText != null) {
                        Navigator.pop(context, editedText);
                      }
                    },
                    child: const Text(
                      'ویرایش متن',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatListPage(
                            initialMessage: widget.text,
                            imagePath: widget.imagePath,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'ارسال به چت',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditTextPage extends StatefulWidget {
  final String initialText;
  final String imagePath;

  const EditTextPage({super.key, required this.initialText, required this.imagePath});

  @override
  State<EditTextPage> createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایش متن', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintText: 'متن استخراج شده را در اینجا ویرایش کنید...',
                    hintStyle: TextStyle(fontFamily: 'Vazir'),
                  ),
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatListPage(
                        initialMessage: _controller.text,
                        imagePath: widget.imagePath,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'ذخیره و ارسال به چت',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}