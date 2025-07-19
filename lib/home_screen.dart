import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

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

    final finalText = formatIeltsText(text);

    setState(() {
      isLoading = false;
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExtractedTextPage(text: finalText),
      ),
    );

    if (result != null && result is String) {
      Navigator.pop(context, result);
    }
  }

  Future<void> processPdf(String path) async {
    final bytes = File(path).readAsBytesSync();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    String allText = document.pages
        .map((page) => page.extractText())
        .join('\n\n');

    document.dispose();

    allText = cleanText(allText);

    final finalText = formatIeltsText(allText);

    setState(() {
      isLoading = false;
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExtractedTextPage(text: finalText),
      ),
    );

    if (result != null && result is String) {
      Navigator.pop(context, result);
    }
  }

  String cleanText(String text) {
    final lines = text.split('\n');
    final filtered = lines
        .map((line) => line.trim())
        .where((line) =>
            line.isNotEmpty &&
            !RegExp(r'^[^\w]*\$').hasMatch(line) &&
            line.length > 2)
        .toList();

    return filtered.join('\n');
  }

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
        buffer.writeln('\n🟡 **Question \$questionNumber**');
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,

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
                  ),
                   Center(
        child: DottedBorder(
          color: Colors.blueAccent,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Radius.circular(30),
          dashPattern: [10, 6],
          child: Container(
            width: screenSize.width * 0.9,
            height: screenSize.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: GestureDetector(
                onTap:showPickerDialog ,
                child: Icon(
                  Icons.touch_app,
                  size: 60,
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ),
      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: showPickerDialog,
        child: const Icon(Icons.add_a_photo,color: Colors.black,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ExtractedTextPage extends StatelessWidget {
  final String text;

  const ExtractedTextPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('متن استخراج‌شده'), backgroundColor: Colors.green,automaticallyImplyLeading: false,
),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.pop(context, text);
                    },
                    child: const Text('تأیید', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTextPage(initialText: text),
                        ),
                      ).then((editedText) {
                        if (editedText != null) {
                          Navigator.pop(context, editedText);
                        }
                      });
                    },
                    child: const Text('ویرایش', style: TextStyle(color: Colors.black)),
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

  const EditTextPage({super.key, required this.initialText});

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
      appBar: AppBar(title: const Text('ویرایش متن'), backgroundColor: Colors.orange,automaticallyImplyLeading: false,
),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'متن را ویرایش کنید...',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context, _controller.text);
              },
              child: const Text('ارسال به چت', style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}

extension on PdfPageCollection {
  map(Function(dynamic page) param0) {}
}
