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
    isScrollControlled: true,
    builder: (_) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'انتخاب منبع تصویر',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
            ),
            
            // Camera Option
            _buildOptionItem(
              icon: Icons.camera_alt,
              color: Colors.green,
              title: "دوربین",
              onTap: () => _handleImageSelection(ImageSource.camera),
            ),
            
            // Gallery Option
            _buildOptionItem(
              icon: Icons.photo_library,
              color: Colors.blue,
              title: "گالری تصاویر",
              onTap: () => _handleImageSelection(ImageSource.gallery),
            ),
            
            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "انصراف",
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildOptionItem({
  required IconData icon,
  required Color color,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'Vazir',
        fontSize: 16,
      ),
    ),
    trailing: Icon(Icons.chevron_left, color: Colors.grey.shade400),
    onTap: onTap,
  );
}

Future<void> _handleImageSelection(ImageSource source) async {
  Navigator.pop(context);
  await pickImage(source);
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      hoverColor: Colors.white.withOpacity(0.2),
      textStyle: TextStyle(
        fontFamily: 'Vazir',
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      selectedTextStyle: TextStyle(
        fontFamily: 'Vazir',
        color: primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      itemTextPadding: const EdgeInsets.only(right: 16),
      itemPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selectedItemDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          )
        ],
      ),
      iconTheme: IconThemeData(color: Colors.white, size: 22),
      selectedIconTheme: IconThemeData(color: primaryColor, size: 22),
    ),
    headerBuilder: (context, extended) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle, 
                  size: 54, 
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'خوش آمدید',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fullName,
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Divider(
              color: Colors.white.withOpacity(0.3),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      );
    },
    items: [
      SidebarXItem(
        icon: Icons.home_outlined,
        label: 'صفحه اصلی',
        onTap: () => Navigator.pop(context),
      ),
      SidebarXItem(
        icon: Icons.chat_bubble_outline,
        label: 'چت',
        onTap: () => _navigateWithFade(context, const ChatListPage(imagePath: '')),
      ),
      SidebarXItem(
        icon: Icons.history_toggle_off,
        label: 'تاریخچه',
        onTap: () => _navigateWithFade(context, const HistoryPage()),
      ),
      const SidebarXItem(
        icon: Icons.settings_outlined,
        label: 'تنظیمات',
      ),
      SidebarXItem(
        icon: Icons.logout,
        label: 'خروج',
        onTap: () => _showLogoutConfirmation(context),
      ),
    ],
  );
}

// تابع کمکی برای انیمیشن انتقال صفحه
void _navigateWithFade(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}

// تابع کمکی برای نمایش دیالوگ تایید خروج
Future<void> _showLogoutConfirmation(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('تایید خروج', style: TextStyle(fontFamily: 'Vazir')),
      content: Text('آیا مطمئن هستید که می‌خواهید خارج شوید؟', 
               style: TextStyle(fontFamily: 'Vazir')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('انصراف', style: TextStyle(color: Colors.grey[700]))),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('خروج', style: TextStyle(color: Colors.red))),
      ],
    ),
  );

  if (confirmed == true) {
    await AuthService.clearToken();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }
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