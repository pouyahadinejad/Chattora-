import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class OCRPdfApp extends StatefulWidget {
  const OCRPdfApp({super.key});

  @override
  State<OCRPdfApp> createState() => _OCRPdfAppState();
}

class _OCRPdfAppState extends State<OCRPdfApp> with SingleTickerProviderStateMixin {
  String extractedText = '';
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
      setState(() {
        isLoading = true;
        extractedText = '';
      });
      await processImage(File(pickedFile.path));
    }
  }

  Future<void> pickPDF() async {
    await requestPermissions();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        isLoading = true;
        extractedText = '';
      });
      await processPdf(result.files.single.path!);
    }
  }

  Future<void> processImage(File file) async {
    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    textRecognizer.close();

    String text = recognizedText.text;

    text = cleanText(text);

    setState(() {
      extractedText = formatIeltsText(text);
      isLoading = false;
      _controller.forward(from: 0);
    });
    // در انتهای پردازش متن:
    // Navigator.pop(context, extractedText);

  }

  Future<void> processPdf(String path) async {
    final bytes = File(path).readAsBytesSync();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    String allText = document.pages
        .map((page) => page.extractText())
        .join('\n\n');

    document.dispose();

    allText = cleanText(allText);

    setState(() {
      extractedText = formatIeltsText(allText);
      isLoading = false;
      _controller.forward(from: 0);
    });
    // در انتهای پردازش متن:
  //  Navigator.pop(context, extractedText);

  }

  /// ✅ پاک‌سازی نویز و خطوط اضافی
  String cleanText(String text) {
    final lines = text.split('\n');
    final filtered = lines
        .map((line) => line.trim())
        .where((line) =>
            line.isNotEmpty &&
            !RegExp(r'^[^\w]*$').hasMatch(line) && // حذف خط‌های پر از کاراکترهای غیرحروف
            line.length > 2) // حذف خطوط خیلی کوتاه
        .toList();

    return filtered.join('\n');
  }

  /// ✅ فرمت حرفه‌ای متن IELTS
  String formatIeltsText(String text) {
    final lines = text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

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
      backgroundColor: Colors.green.shade50,
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("گرفتن عکس با دوربین"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("انتخاب فایل ( عکس / PDF)"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF باز کردن '),
              onTap: () {
                Navigator.pop(context);
                pickPDF();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('IELTS OCR'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      extractedText.isNotEmpty
                          ? extractedText
                          : 'No text extracted yet.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                if (extractedText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green)),
                      onPressed: () {
                        Navigator.pop(context, extractedText);
                      },
                      child: const Text(
                        'ارسال متن به چت',
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    ),
                  )
              ],
            ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: showPickerDialog,
      //   child: const Icon(Icons.add),
      // ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
        onPressed: showPickerDialog,
        child: const Icon(Icons.add_a_photo,color: Colors.black,),
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

extension on PdfPageCollection {
  map(Function(dynamic page) param0) {}
}
