import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:otpuivada/UserInfoPage.dart';
import 'otp_login_page.dart';
import 'ocrpdf.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ برای فارسی‌سازی

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
  await Hive.openBox<String>('imageHistory');

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.green.shade50, // اینجا رنگ Status Bar
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
          fontFamily: 'Kalameh',
          //  bodyMedium: TextStyle(fontSize: 14),
      // headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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

      // ✅ تنظیمات لازم برای راست‌چین شدن کل اپ
      locale: const Locale('fa'), // زبان پیش‌فرض فارسی
      supportedLocales: const [
        Locale('fa'), // لیست زبان‌های پشتیبانی‌شده
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: FutureBuilder<bool>(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data == true) {
            return OCRPdfApp();
            // bottomNavigationBar: _buildBottomNavigationBar()
          } else {
            return OtpLoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => OCRPdfApp(),
        '/login': (context) => OtpLoginPage(),
        '/userinfo': (_) => const UserInfoPage(),
      },
    );
  }
}

