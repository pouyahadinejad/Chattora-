import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

class OtpVerifyPage extends StatefulWidget {
  final String mobile;
  OtpVerifyPage({required this.mobile});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> 
    with CodeAutoFill, SingleTickerProviderStateMixin {
  final otpController = TextEditingController();
  bool loading = false;
  int timerSeconds = 0;
  Timer? timer;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // requestSmsPermission();
    listenForCode();
    startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  // Future<void> requestSmsPermission() async {
  //   var status = await Permission.sms.status;
  //   if (!status.isGranted) {
  //     await Permission.sms.request();
  //   }
  // }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    setState(() {
      timerSeconds = 60;
    });
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (timerSeconds == 0) {
        t.cancel();
      } else {
        setState(() {
          timerSeconds--;
        });
      }
    });
  }

  Future<void> sendOtpAgain() async {
    setState(() => loading = true);

    var url = Uri.parse('https://payment.vada.ir/api/auth/login-otp');

    try {
      var response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'mobile': widget.mobile,
          // 'package_name': 'com.vada.karvarz',
          'package_name': 'com.vada.ielts',
        },
      );

      if (response.statusCode == 200) {
        showSnack('کد جدید ارسال شد');
        startTimer();
      } else {
        var data = jsonDecode(response.body);
        showSnack(data['message'] ?? 'خطا در ارسال کد');
      }
    } catch (e) {
      showSnack('خطا در ارتباط با سرور');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      showSnack('کد تایید را وارد کنید');
      return;
    }

    setState(() => loading = true);

    var url = Uri.parse('https://payment.vada.ir/api/auth/verify-otp');

    try {
      var response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'mobile': widget.mobile,
          'code': otpController.text,
          // 'package_name': 'com.vada.karvarz',
          'package_name': 'com.vada.ielts',
        },
      );

      if (response.statusCode == 200) {
        showSnack('ورود موفقیت آمیز بود');
        // TODO: هدایت به صفحه بعدی
      } else {
        var data = jsonDecode(response.body);
        showSnack(data['message'] ?? 'کد تایید اشتباه است');
      }
    } catch (e) {
      showSnack('خطا در ارتباط');
    } finally {
      setState(() => loading = false);
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Kalameh',
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void codeUpdated() {
    if (code != null) {
      final regex = RegExp(r'\b\d{5}\b');
      final match = regex.firstMatch(code!);
      if (match != null) {
        final extractedCode = match.group(0);
        setState(() {
          otpController.text = extractedCode!;
        });
        // checkOtp(); ← حذف شد که خودکار اجرا نشه
      } else {
        print('هیچ کدی پیدا نشد!');
      }
    }
  }
  Future<void> checkOtp() async {
  if (otpController.text.length != 5) {
    showSnack('لطفا کد را کامل وارد کنید');
    return;
  }

  setState(() => loading = true);

  var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

  try {
    var response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {'mobile': widget.mobile, 'token': otpController.text},
    );

    if (response.statusCode == 200) {
      var token = jsonDecode(response.body)['token'];
      if (token != null) {
        var box = Hive.box<String>('auth');
        await box.put('token', token);
        await box.put('mobile', widget.mobile);

        // چک کردن وجود اطلاعات نام و نام خانوادگی
        final firstName = box.get('first_name');
        final lastName = box.get('last_name');

        if (firstName == null || lastName == null) {
          // اگر اطلاعات نیست، میریم صفحه پر کردن اطلاعات
          // Navigator.pushReplacementNamed(context, '/userinfo');
          Navigator.pushNamedAndRemoveUntil(context, '/userinfo', (route)=>false);
        } else {
          // اطلاعات موجوده، میریم صفحه اصلی
          Navigator.pushNamedAndRemoveUntil(context, '/home',(route)=>false);
        }
      }
    } else {
      var data = jsonDecode(response.body);
      showSnack(data['message'] ?? 'کد نادرست است');
    }
  } catch (e) {
    showSnack('خطا در ارتباط');
  } finally {
    setState(() => loading = false);
  }
}


  BoxDecoration glassBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: Offset(0, 10),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 24,
        color: Colors.green.shade800,
        fontFamily: 'Kalameh',
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.greenAccent, width: 2),
      color: Colors.white.withOpacity(0.3),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.green.withOpacity(0.15),
        border: Border.all(color: Colors.green.shade500, width: 2),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(

            automaticallyImplyLeading: false,
        
            backgroundColor: Color(0xFF2E7D32),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Image.asset(
                            'assets/image.png',
                            width: constraints.maxWidth,
                            // height: 220,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 30),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 400),
                              padding: EdgeInsets.symmetric(
                                  vertical: 32, horizontal: 24),
                              decoration: glassBoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'کد تایید به شماره ${widget.mobile} ارسال شد',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Kalameh',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Pinput(
                                    length: 5,
                                    controller: otpController,
                                    androidSmsAutofillMethod:
                                        AndroidSmsAutofillMethod.smsUserConsentApi,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: focusedPinTheme,
                                    submittedPinTheme: submittedPinTheme,
                                    showCursor: true,
                                    animationCurve: Curves.easeInOut,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    onCompleted: (pin) => checkOtp(),
                                  ),
                                  SizedBox(height: 16),
                                  if (timerSeconds > 0)
                                    Text(
                                      'ارسال مجدد تا $timerSeconds ثانیه دیگر',
                                      style: TextStyle(
                                        fontFamily: 'Kalameh',
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    )
                                  else
                                    TextButton(
                                      onPressed: loading ? null : sendOtpAgain,
                                      child: Text(
                                        'ارسال مجدد کد',
                                        style: TextStyle(
                                          fontFamily: 'Kalameh',
                                          color: Color(0xFF2E7D32),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed:
                                          loading || otpController.text.isEmpty
                                              ? null
                                              : checkOtp,
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: Colors.green,
                                        elevation: 8,
                                        shadowColor:
                                            Color(0xFF2E7D32),
                                        disabledForegroundColor:
                                            Colors.white.withOpacity(0.5),
                                        disabledBackgroundColor:
                                            Color(0xFF2E7D32),
                                      ),
                                      child: loading
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : Text(
                                              "تایید",
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                color: Colors.white,
                                                fontFamily: 'Kalameh',
                                                fontSize: 15,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';

// class OtpVerifyPage extends StatefulWidget {
//   final String mobile;
//   OtpVerifyPage({required this.mobile});

//   @override
//   State<OtpVerifyPage> createState() => _OtpVerifyPageState();
// }

// class _OtpVerifyPageState extends State<OtpVerifyPage> 
//     with CodeAutoFill, SingleTickerProviderStateMixin {
//   final otpController = TextEditingController();
//   bool loading = false;
//   int timerSeconds = 0;
//   Timer? timer;
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//   String? _appSignature;

//   @override
//   void initState() {
//     super.initState();
//     _initSmsAutoFill();
//     startTimer();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 600),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     ));
//     _fadeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     ));

//     _animationController.forward();
//   }

//   // Future<void> _initSmsAutoFill() async {
//   //   try {
//   //     // دریافت امضای برنامه برای SMS Retriever API
//   //     _appSignature = await SmsAutoFill().getAppSignature;
//   //     await listenForCode();
//   //   } catch (e) {
//   //     print('خطا در راه‌اندازی SMS Autofill: $e');
//   //   }
//   // }
//   Future<void> _initSmsAutoFill() async {
//   try {
//     // دریافت امضای برنامه
//     _appSignature = await SmsAutoFill().getAppSignature;
    
//     // شروع گوش دادن به کدهای SMS - بدون await
//     listenForCode();
    
//     // یا اگر نیاز به تنظیم الگوی regex دارید:
//     // listenForCode(smsCodeRegexPattern: r'\d{5}');
//   } catch (e) {
//     print('خطا در راه‌اندازی SMS Autofill: $e');
//   }
// }

//   @override
//   void dispose() {
//     timer?.cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     SmsAutoFill().unregisterListener();
//     super.dispose();
//   }

//   void startTimer() {
//     timer?.cancel();
//     setState(() => timerSeconds = 60);
//     timer = Timer.periodic(Duration(seconds: 1), (t) {
//       if (timerSeconds == 0) {
//         t.cancel();
//       } else {
//         setState(() => timerSeconds--);
//       }
//     });
//   }

//   Future<void> sendOtpAgain() async {
//     setState(() => loading = true);

//     try {
//       final response = await http.post(
//         Uri.parse('https://payment.vada.ir/api/auth/login-otp'),
//         headers: {'Accept': 'application/json'},
//         body: {
//           'mobile': widget.mobile,
//           'package_name': 'com.vada.karvarz',
//           'app_signature': _appSignature, // ارسال امضا برای تطبیق در پیامک
//         },
//       );

//       if (response.statusCode == 200) {
//         showSnack('کد جدید ارسال شد');
//         startTimer();
//       } else {
//         final data = jsonDecode(response.body);
//         showSnack(data['message'] ?? 'خطا در ارسال کد');
//       }
//     } catch (e) {
//       showSnack('خطا در ارتباط با سرور');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> verifyOtp() async {
//     if (otpController.text.isEmpty) {
//       showSnack('کد تایید را وارد کنید');
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       final response = await http.post(
//         Uri.parse('https://payment.vada.ir/api/auth/verify-otp'),
//         headers: {'Accept': 'application/json'},
//         body: {
//           'mobile': widget.mobile,
//           'code': otpController.text,
//           'package_name': 'com.vada.karvarz',
//         },
//       );

//       if (response.statusCode == 200) {
//         await _handleSuccessfulVerification(response.body);
//       } else {
//         final data = jsonDecode(response.body);
//         showSnack(data['message'] ?? 'کد تایید اشتباه است');
//       }
//     } catch (e) {
//       showSnack('خطا در ارتباط');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> _handleSuccessfulVerification(String responseBody) async {
//     final token = jsonDecode(responseBody)['token'];
//     if (token == null) return;

//     final box = Hive.box<String>('auth');
//     await box.put('token', token);
//     await box.put('mobile', widget.mobile);

//     final firstName = box.get('first_name');
//     final lastName = box.get('last_name');

//     if (firstName == null || lastName == null) {
//       Navigator.pushNamedAndRemoveUntil(context, '/userinfo', (route) => false);
//     } else {
//       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//     }
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() => otpController.text = extractedCode!);
//       }
//     }
//   }

//   void showSnack(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             fontFamily: 'Kalameh',
//             color: Colors.white,
//             fontSize: 15,
//           ),
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 60,
//       textStyle: TextStyle(
//         fontSize: 24,
//         color: Colors.green.shade800,
//         fontFamily: 'Kalameh',
//         fontWeight: FontWeight.bold,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.green.shade300, width: 1.5),
//       ),
//     );

//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.green,
//         ),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: [
//                         Image.asset(
//                           'assets/image.png',
//                           width: constraints.maxWidth,
//                           fit: BoxFit.cover,
//                         ),
//                         SizedBox(height: 30),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 24),
//                           child: Container(
//                             width: double.infinity,
//                             constraints: BoxConstraints(maxWidth: 400),
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 32, horizontal: 24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: Colors.white.withOpacity(0.3)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 20,
//                                   offset: Offset(0, 10),
//                                 )
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'کد تایید به شماره ${widget.mobile} ارسال شد',
//                                   style: theme.textTheme.bodyLarge?.copyWith(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Kalameh',
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 SizedBox(height: 24),
//                                 Pinput(
//                                   length: 5,
//                                   controller: otpController,
//                                   defaultPinTheme: defaultPinTheme,
//                                   showCursor: true,
//                                   onCompleted: (pin) => verifyOtp(),
//                                 ),
//                                 SizedBox(height: 16),
//                                 if (timerSeconds > 0)
//                                   Text(
//                                     'ارسال مجدد تا $timerSeconds ثانیه دیگر',
//                                     style: TextStyle(
//                                       fontFamily: 'Kalameh',
//                                       color: Colors.black54,
//                                       fontSize: 13,
//                                     ),
//                                   )
//                                 else
//                                   TextButton(
//                                     onPressed: loading ? null : sendOtpAgain,
//                                     child: Text(
//                                       'ارسال مجدد کد',
//                                       style: TextStyle(
//                                         fontFamily: 'Kalameh',
//                                         color: Colors.green,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ),
//                                 SizedBox(height: 16),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   height: 50,
//                                   child: ElevatedButton(
//                                     onPressed:
//                                         loading || otpController.text.isEmpty
//                                             ? null
//                                             : verifyOtp,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(12)),
//                                     ),
//                                     child: loading
//                                         ? CircularProgressIndicator(
//                                             color: Colors.white,
//                                             strokeWidth: 3,
//                                           )
//                                         : Text(
//                                             "تایید",
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: 'Kalameh',
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }