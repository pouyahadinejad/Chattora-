import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:otpuivada/chat_list_page.dart';
import 'data.dart';
import 'home_screen.dart';
import 'otp_login_page.dart';
import 'package:flutter/services.dart';


// --- اضافه کردن رنگ‌ها ---
const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const Color secondaryTextColor = Color(0xffAFBED0);
const Color normalPriority = Color(0xffF09819);
const Color lowPriority = Color(0xff3BE1F1);
const Color highPriority = primaryColor;


const taskBoxName = 'tasks';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('auth');
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor:  Colors.green.shade50, // اینجا رنگ Status Bar
      statusBarIconBrightness: Brightness.light, // آیکن‌های سفید
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> checkToken() async {
    var box = Hive.box<String>('auth');
    var token = box.get('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff1D2830)),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondaryTextColor),
          border: InputBorder.none,
          iconColor: secondaryTextColor,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimaryFixed: primaryVariantColor,
          background: Color(0xffF3F5F8),
          onSurface: Color(0xff1D2830),
          onPrimary: Colors.white,
          onBackground: Color(0xff1D2830),
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data == true) {
            return ChatListPage();
          } else {
            return OtpLoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => ChatListPage(),
        '/login': (context) => OtpLoginPage(),
      },
    );
  }
}


















// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pdf_text/pdf_text.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OCR App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const OCRHomePage(),
//     );
//   }
// }

// class OCRHomePage extends StatefulWidget {
//   const OCRHomePage({super.key});

//   @override
//   State<OCRHomePage> createState() => _OCRHomePageState();
// }

// class _OCRHomePageState extends State<OCRHomePage> {
//   String _extractedText = '';

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _showPicker() async {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) => SizedBox(
//         height: 150,
//         child: Column(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('انتخاب فایل (عکس / PDF / هر فایل)'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickFile();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('گرفتن عکس با دوربین'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _captureImage();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
//     );

//     if (result != null && result.files.single.path != null) {
//       String filePath = result.files.single.path!;
//       String extension = filePath.split('.').last.toLowerCase();

//       if (extension == 'pdf') {
//         await _extractTextFromPdf(filePath);
//       } else {
//         await _extractTextFromImage(File(filePath));
//       }
//     }
//   }

//   Future<void> _captureImage() async {
//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo != null) {
//       await _extractTextFromImage(File(photo.path));
//     }
//   }

//   Future<void> _extractTextFromImage(File imageFile) async {
//     final InputImage inputImage = InputImage.fromFile(imageFile);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);

//     setState(() {
//       _extractedText = recognizedText.text;
//     });
//   }

//   Future<void> _extractTextFromPdf(String filePath) async {
//     PDFDoc doc = await PDFDoc.fromPath(filePath);
//     String text = await doc.text;

//     setState(() {
//       _extractedText = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OCR App for IELTS'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: _extractedText.isEmpty
//             ? IconButton(
//                 icon: const Icon(Icons.add_circle, size: 80, color: Colors.deepPurple),
//                 onPressed: _showPicker,
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _extractedText,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//       ),
//       floatingActionButton: _extractedText.isNotEmpty
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _extractedText = '';
//                 });
//               },
//               child: const Icon(Icons.clear),
//             )
//           : null,
//     );
//   }
// }













// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: PdfOcrApp(),
//   ));
// }

// class PdfOcrApp extends StatefulWidget {
//   const PdfOcrApp({super.key});

//   @override
//   State<PdfOcrApp> createState() => _PdfOcrAppState();
// }

// class _PdfOcrAppState extends State<PdfOcrApp> {
//   String extractedText = "";
//   bool isLoading = false;

//   Future<void> pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: false,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//       );

//       if (result != null && result.files.single.bytes != null) {
//         final bytes = result.files.single.bytes!;
//         final extension = result.files.single.extension?.toLowerCase();

//         if (extension == 'pdf') {
//           await extractTextFromPdf(bytes);
//         } else {
//           await extractTextFromImageBytes(bytes);
//         }
//       }
//     } catch (e) {
//       setState(() {
//         extractedText = "خطا در انتخاب فایل: $e";
//       });
//     }
//   }

//   Future<void> pickImageFromCamera() async {
//     try {
//       var status = await Permission.camera.status;
//       if (!status.isGranted) {
//         status = await Permission.camera.request();
//         if (!status.isGranted) {
//           setState(() {
//             extractedText = "مجوز دوربین داده نشد.";
//           });
//           return;
//         }
//       }

//       final picked = await ImagePicker().pickImage(source: ImageSource.camera);
//       if (picked != null) {
//         final bytes = await picked.readAsBytes();
//         await extractTextFromImageBytes(bytes);
//       }
//     } catch (e) {
//       setState(() {
//         extractedText = "خطا در گرفتن عکس: $e";
//       });
//     }
//   }

//       Future<void> extractTextFromPdf(Uint8List bytes) async {
//         setState(() {
//           isLoading = true;
//         });

//         final PdfDocument document = PdfDocument(inputBytes: bytes);

//         final PdfTextExtractor extractor = PdfTextExtractor(document);

//         final String text = extractor.extractText();

//         document.dispose();

//         setState(() {
//           extractedText = text.trim().isEmpty
//               ? "متنی داخل فایل PDF پیدا نشد."
//               : text.trim();
//           isLoading = false;
//         });
//       }



//   Future<void> extractTextFromImageBytes(Uint8List bytes) async {
//     print("Start OCR processing...");
//     setState(() {
//       isLoading = true;
//     });

//     final InputImage image = InputImage.fromFilePath(
//       await saveImageTemporarily(bytes),
//     );

//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(image);

//     textRecognizer.close();

//     setState(() {
//       extractedText = recognizedText.text.trim().isEmpty
//           ? "متنی در تصویر پیدا نشد."
//           : recognizedText.text.trim();
//       isLoading = false;
//     });
//   }

//   Future<String> saveImageTemporarily(Uint8List bytes) async {
//     final tempDir = Directory.systemTemp;
//     final file = File('${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
//     await file.writeAsBytes(bytes, flush: true);
//     return file.path;
//   }

//   void showFileOptions() {
//     showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
//         builder: (ctx) => SafeArea(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     leading: const Icon(Icons.upload_file),
//                     title: const Text("انتخاب فایل (PDF/عکس)"),
//                     onTap: () {
//                       Navigator.pop(ctx);
//                       pickFile();
//                     },
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.camera_alt),
//                     title: const Text("گرفتن عکس با دوربین"),
//                     onTap: () {
//                       Navigator.pop(ctx);
//                       pickImageFromCamera();
//                     },
//                   ),
//                 ],
//               ),
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'IELTS OCR App',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: isLoading
//               ? const CircularProgressIndicator()
//               : SingleChildScrollView(
//                   child: Text(
//                     extractedText.isEmpty
//                         ? "فایلی انتخاب نشده است."
//                         : extractedText,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: showFileOptions,
//         label: const Text("افزودن فایل"),
//         icon: const Icon(Icons.add),
//       ),
//     );
//   }
// }











/////////////////////nice=>





// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:path_provider/path_provider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: OCRHomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class OCRHomePage extends StatefulWidget {
//   const OCRHomePage({super.key});
//   @override
//   State<OCRHomePage> createState() => _OCRHomePageState();
// }

// class _OCRHomePageState extends State<OCRHomePage> {
//   final ImagePicker _picker = ImagePicker();

//   String extractedText = "";
//   bool isLoading = false;

//   // --- درخواست مجوزها ---
//   Future<bool> requestPermissions() async {
//     var cameraStatus = await Permission.camera.status;
//     if (!cameraStatus.isGranted) {
//       cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) return false;
//     }

//     var storageStatus = await Permission.storage.status;
//     if (!storageStatus.isGranted) {
//       storageStatus = await Permission.storage.request();
//       if (!storageStatus.isGranted) return false;
//     }
    
//     return true;
//   }

//   // --- ذخیره موقت عکس ---
//   Future<String> saveImageTemporarily(Uint8List bytes) async {
//     final tempDir = await getTemporaryDirectory();
//     final file = await File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png').create();
//     await file.writeAsBytes(bytes);
//     return file.path;
//   }

//   // --- استخراج متن از عکس ---
//   Future<void> extractTextFromImageBytes(Uint8List bytes) async {
//     setState(() {
//       isLoading = true;
//       extractedText = "";
//     });

//     final path = await saveImageTemporarily(bytes);

//     final InputImage inputImage = InputImage.fromFilePath(path);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     try {
//       final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

//       setState(() {
//         extractedText = recognizedText.text.trim().isEmpty
//             ? "متنی در تصویر پیدا نشد."
//             : recognizedText.text.trim();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         extractedText = "خطا در خواندن متن از تصویر: $e";
//         isLoading = false;
//       });
//     } finally {
//       textRecognizer.close();
//     }
//   }

//   // --- استخراج متن از PDF ---
//   Future<void> extractTextFromPdf(Uint8List bytes) async {
//     setState(() {
//       isLoading = true;
//       extractedText = "";
//     });

//     try {
//       final PdfDocument document = PdfDocument(inputBytes: bytes);
//       final PdfTextExtractor extractor = PdfTextExtractor(document);
//       final String text = extractor.extractText();
//       document.dispose();

//       setState(() {
//         extractedText = text.trim().isEmpty ? "متنی در فایل PDF پیدا نشد." : text.trim();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         extractedText = "خطا در خواندن متن از PDF: $e";
//         isLoading = false;
//       });
//     }
//   }

//   // --- انتخاب فایل (عکس یا PDF) ---
//   Future<void> pickFile() async {
//     bool granted = await requestPermissions();
//     if (!granted) {
//       setState(() {
//         extractedText = "مجوزهای لازم داده نشده است.";
//       });
//       return;
//     }

//     final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
//     if (file == null) {
//       // کاربر انصراف داده
//       return;
//     }

//     final bytes = await file.readAsBytes();

//     if (file.name.toLowerCase().endsWith('.pdf')) {
//       await extractTextFromPdf(bytes);
//     } else {
//       await extractTextFromImageBytes(bytes);
//     }
//   }

//   // --- گرفتن عکس مستقیم با دوربین ---
//   Future<void> takePhoto() async {
//     bool granted = await requestPermissions();
//     if (!granted) {
//       setState(() {
//         extractedText = "مجوزهای لازم داده نشده است.";
//       });
//       return;
//     }

//     final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//     if (photo == null) return;

//     final bytes = await photo.readAsBytes();

//     await extractTextFromImageBytes(bytes);
//   }

//   // --- منوی انتخاب ---
//   void showPickOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.folder_open),
//               title: const Text("انتخاب فایل (عکس یا PDF)"),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 pickFile();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("گرفتن عکس با دوربین"),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 takePhoto();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("OCR حرفه‌ای")),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   extractedText.isEmpty ? "متن استخراج شده اینجا نمایش داده می‌شود" : extractedText,
//                   style: const TextStyle(fontSize: 18),
//                 ),
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showPickOptions,
//         child: const Icon(Icons.add_a_photo),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }



















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:pdfx/pdfx.dart';

// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: HomePage(),
//   ));
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String extractedText = "";
//   List<Map<String, String>> parsedData = [];
//   bool isLoading = false;

//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//     if (pickedFile != null) {
//       final inputImage = InputImage.fromFilePath(pickedFile.path);
//       recognizeTextFromImage(inputImage);
//     }
//   }

//   Future<void> pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       extractTextFromPdf(file.path);
//     }
//   }

//   Future<void> extractTextFromPdf(String path) async {
//     setState(() {
//       isLoading = true;
//     });

//     final pdfDoc = await PdfDocument.openFile(path);
//     String fullText = "";

//     for (int i = 1; i <= pdfDoc.pagesCount; i++) {
//       final page = await pdfDoc.getPage(i);
//       final text = await page.text;
//       fullText += "$text\n";
//       await page.close();
//     }

//     setState(() {
//       extractedText = fullText.trim();
//       parsedData = parseIeltsText(extractedText);
//       isLoading = false;
//     });
//   }

//   Future<void> recognizeTextFromImage(InputImage inputImage) async {
//     setState(() {
//       isLoading = true;
//     });

//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);
//     await textRecognizer.close();

//     setState(() {
//       extractedText = recognizedText.text.trim();
//       parsedData = parseIeltsText(extractedText);
//       isLoading = false;
//     });
//   }

//   List<Map<String, String>> parseIeltsText(String text) {
//     final List<Map<String, String>> result = [];

//     // هر سوال با عدد. شروع می‌شود (مثلاً 1. ...)
//     final regex = RegExp(r'(\d+\.\s.*?)(?=(\d+\.\s)|$)', dotAll: true);
//     final matches = regex.allMatches(text);

//     for (final match in matches) {
//       String block = match.group(1)!.trim();

//       if (block.contains(RegExp(r'(Answer|Ans):', caseSensitive: false))) {
//         final parts =
//             block.split(RegExp(r'(Answer|Ans):', caseSensitive: false));
//         final question = parts[0].trim();
//         final answer = parts.length > 1 ? parts[1].trim() : "";
//         result.add({
//           'question': question,
//           'answer': answer,
//         });
//       } else {
//         result.add({
//           'question': block,
//           'answer': "",
//         });
//       }
//     }

//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("IELTS OCR App"),
//         backgroundColor: Colors.teal,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => Wrap(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text("Take Photo"),
//                   onTap: () {
//                     Navigator.pop(context);
//                     pickImage(ImageSource.camera);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text("Choose from Gallery"),
//                   onTap: () {
//                     Navigator.pop(context);
//                     pickImage(ImageSource.gallery);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.picture_as_pdf),
//                   title: const Text("Pick PDF"),
//                   onTap: () {
//                     Navigator.pop(context);
//                     pickFile();
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : parsedData.isNotEmpty
//               ? buildParsedResult(parsedData)
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     extractedText.isEmpty
//                         ? "هنوز متنی بارگذاری نشده است."
//                         : extractedText,
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//     );
//   }

//   Widget buildParsedResult(List<Map<String, String>> parsedData) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: parsedData.length,
//       itemBuilder: (context, index) {
//         final item = parsedData[index];
//         return Card(
//           color: Colors.white,
//           elevation: 4,
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item['question'] ?? '',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 if ((item['answer'] ?? '').isNotEmpty)
//                   Text(
//                     "Answer: ${item['answer']}",
//                     style: const TextStyle(fontSize: 16),
//                   )
//                 else
//                   const Text(
//                     "(جواب ثبت نشده است.)",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // extension on PdfPage {
// //   get text => null;
// // }






















// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: OCRPdfApp(),
//   ));
// }

// class OCRPdfApp extends StatefulWidget {
//   const OCRPdfApp({super.key});

//   @override
//   State<OCRPdfApp> createState() => _OCRPdfAppState();
// }

// class _OCRPdfAppState extends State<OCRPdfApp> {
//   String extractedText = '';
//   bool isLoading = false;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> requestPermissions() async {
//     await [
//       Permission.storage,
//       Permission.camera,
//       Permission.photos,
//     ].request();
//   }

//   Future<void> pickImage(ImageSource source) async {
//     await requestPermissions();

//     final XFile? pickedFile = await _picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         isLoading = true;
//         extractedText = '';
//       });
//       await processImage(File(pickedFile.path));
//     }
//   }

//   Future<void> pickPDF() async {
//     await requestPermissions();

//     final XFile? pickedFile = await _picker.pickDocument(
//       allowedExtensions: ['pdf'],
//     );

//     if (pickedFile != null) {
//       setState(() {
//         isLoading = true;
//         extractedText = '';
//       });
//       await processPdf(pickedFile.path);
//     }
//   }

//   Future<void> processImage(File file) async {
//     final inputImage = InputImage.fromFile(file);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);

//     textRecognizer.close();

//     String text = recognizedText.text;

//     setState(() {
//       extractedText = formatIeltsText(text);
//       isLoading = false;
//     });
//   }

//   Future<void> processPdf(String path) async {
//     final bytes = File(path).readAsBytesSync();
//     final PdfDocument document = PdfDocument(inputBytes: bytes);

//     String allText = document.pages
//         .map((page) => page.extractText())
//         .join('\n\n');

//     document.dispose();

//     setState(() {
//       extractedText = formatIeltsText(allText);
//       isLoading = false;
//     });
//   }

//   String formatIeltsText(String text) {
//     // متن رو خط‌به‌خط جدا می‌کنیم و خالی‌ها رو حذف می‌کنیم
//     final lines = text
//         .split('\n')
//         .map((line) => line.trim())
//         .where((line) => line.isNotEmpty)
//         .toList();

//     StringBuffer buffer = StringBuffer();
//     int questionNumber = 1;

//     for (final line in lines) {
//       if (RegExp(r'^\d+\.').hasMatch(line)) {
//         // اگر خط با عدد و نقطه شروع شده (مثل 1. یا 23.)
//         buffer.writeln('\n🟡 **Question $questionNumber**');
//         buffer.writeln(line);
//         questionNumber++;
//       } else {
//         buffer.writeln(line);
//       }
//     }

//     return buffer.toString();
//   }

//   void showPickerDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Take Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Pick Image from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.picture_as_pdf),
//               title: const Text('Pick PDF'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickPDF();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('IELTS OCR / PDF Extractor'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: SelectableText(
//                 extractedText.isNotEmpty
//                     ? extractedText
//                     : 'No text extracted yet.',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showPickerDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// extension on PdfPageCollection {
//   map(Function(dynamic page) param0) {}
// }

// extension on ImagePicker {
//   pickDocument({required List<String> allowedExtensions}) {}
// }


























// import 'package:flutter/material.dart';
// import 'package:otpuivada/ocrpdf.dart';


// void main() {
//   runApp(const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: OCRPdfApp(),
//   ));
// }
