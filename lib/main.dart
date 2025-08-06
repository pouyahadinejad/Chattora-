import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:otpuivada/UserInfoPage.dart';
import 'otp_login_page.dart';
import 'ocrpdf.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// رنگ‌های برنامه
const Color primaryColor = Color(0xFF2E7D32); // تغییر به رنگ سبز اصلی شما
const Color primaryVariantColor = Color(0xFF5C0AFF);
const Color secondaryTextColor = Color(0xFFAFBED0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تنظیمات سیستم
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2E7D32),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
    await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  await Hive.openBox<String>('auth');
  await Hive.openBox<String>('imageHistory');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> checkToken() async {
    final box = Hive.box<String>('auth');
    return box.get('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'پردازش OCR',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32), // رنگ اصلی
        primarySwatch: Colors.green,
        fontFamily: 'Kalameh',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32), // فقط از backgroundColor استفاده کنید
          elevation: 0,
          centerTitle: true,
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarColor: Color(0xFF2E7D32),
          //   statusBarBrightness: Brightness.light,
          //   statusBarIconBrightness: Brightness.light,
          // ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFF1D2830)),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondaryTextColor),
          border: InputBorder.none,
          iconColor: secondaryTextColor,
        ),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2E7D32), // هماهنگ با رنگ اصلی
          secondary: const Color(0xFF2E7D32),
          background: const Color(0xFFF3F5F8),
          onPrimary: Colors.white,
          onSurface: const Color(0xFF1D2830),
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F8E9),
      ),
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<bool>(
        future: checkToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data == true ? OCRPdfApp() : OtpLoginPage();
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