// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:otpuivada/otp_verify_page.dart';

// class OtpLoginPage extends StatefulWidget {
//   @override
//   State<OtpLoginPage> createState() => _OtpLoginPageState();
// }

// class _OtpLoginPageState extends State<OtpLoginPage> with TickerProviderStateMixin {
//   final mobileController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   bool loading = false;
//   int timerSeconds = 0;
//   Timer? timer;
//   bool showLabel = true;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;
//   late AnimationController _bgAnimationController;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _bgAnimationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     );

//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * pi,
//     ).animate(
//       CurvedAnimation(parent: _bgAnimationController, curve: Curves.easeOut),
//     );

//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         _bgAnimationController.forward(from: 0);
//         setState(() {
//           showLabel = false;
//         });
//       } else {
//         setState(() {
//           showLabel = true;
//         });
//       }
//     });

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _bgAnimationController.dispose();
//     mobileController.dispose();
//     _focusNode.dispose();
//     timer?.cancel();
//     super.dispose();
//   }

//   void startTimer() {
//     timer?.cancel();
//     setState(() {
//       timerSeconds = 60;
//     });
//     timer = Timer.periodic(Duration(seconds: 1), (t) {
//       if (timerSeconds == 0) {
//         t.cancel();
//       } else {
//         setState(() {
//           timerSeconds--;
//         });
//       }
//     });
//   }

//   Future<void> sendOtp() async {
//     if (mobileController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'لطفا شماره موبایل را وارد کنید',
//             style: TextStyle(fontFamily: 'Vazir', color: Colors.white70, fontSize: 15),
//           ),
//         ),
//       );
//       return;
//     }

//     setState(() {
//       loading = true;
//     });

//     var url = Uri.parse('https://payment.vada.ir/api/auth/login-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {
//           'mobile': mobileController.text,
//           'package_name': 'com.vada.karvarz',
//         },
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'کد تایید ارسال شد',
//               style: TextStyle(fontFamily: 'Vazir', color: Colors.white70, fontSize: 15),
//             ),
//           ),
//         );
//         startTimer();
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OtpVerifyPage(mobile: mobileController.text),
//           ),
//         );
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'خطا در ارسال کد')),
//         );
//       }
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطایی رخ داد')),
//       );
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor:Color(0xFF2E7D32),
//       appBar: AppBar(
//         title: Text("ورود", style: TextStyle(fontFamily: 'Vazir', fontWeight: FontWeight.w600)),
//         backgroundColor: Color(0xFF2E7D32),
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           AnimatedBuilder(
//             animation: _rotationAnimation,
//             builder: (context, child) {
//               return Transform.rotate(
//                 angle: _rotationAnimation.value,
//                 child: child,
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage("assets/ChatGPT Image Jul 9, 2025, 03_19_02 AM.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     if (showLabel)
//                       Text(
//                         'شماره موبایل خود را وارد کنید',
//                         style: theme.textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Vazir',
//                           color: Colors.deepPurple.shade700,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     if (showLabel) SizedBox(height: 30),
//                     TextField(
//                       controller: mobileController,
//                       focusNode: _focusNode,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: 'شماره موبایل',
//                         hintStyle: TextStyle(fontFamily: 'Vazir'),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         prefixIcon: Icon(Icons.phone_android, color: Colors.deepPurple),
//                         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                       ),
//                     ),
//                     SizedBox(height: 30),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 70),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 60,
//                         child: ElevatedButton(
//                           onPressed: (loading || timerSeconds > 0) ? null : sendOtp,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepPurple,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             elevation: 5,
//                             shadowColor: Color(0xFF2E7D32),
//                           ),
//                           child: loading
//                               ? SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                                 )
//                               : timerSeconds > 0
//                                   ? Text('ارسال مجدد تا $timerSeconds', style: TextStyle(fontSize: 16, fontFamily: 'Vazir'))
//                                   : Text('ارسال کد', style: TextStyle(fontFamily: 'Vazir', fontSize: 16, color: Colors.white)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }  























import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otpuivada/otp_verify_page.dart';

class OtpLoginPage extends StatefulWidget {
  @override
  State<OtpLoginPage> createState() => _OtpLoginPageState();
}

class _OtpLoginPageState extends State<OtpLoginPage> with TickerProviderStateMixin {
  final mobileController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool loading = false;
  int timerSeconds = 0;
  Timer? timer;
  bool showLabel = true;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _bgAnimationController;
  late Animation<double> _rotationAnimation;

  // رنگ‌های تم سبز
  final Color primaryGreen = Color(0xFF2E7D32); // سبز پایه
  final Color darkGreen = Color(0xFF1B5E20); // سبز تیره‌تر برای دکمه و AppBar
  final Color lightGreen = Color(0xFFA5D6A7); // سبز روشن برای آیکون و hint

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _bgAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(
      CurvedAnimation(parent: _bgAnimationController, curve: Curves.easeOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _bgAnimationController.forward(from: 0);
        setState(() {
          showLabel = false;
        });
      } else {
        setState(() {
          showLabel = true;
        });
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bgAnimationController.dispose();
    mobileController.dispose();
    _focusNode.dispose();
    timer?.cancel();
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

  Future<void> sendOtp() async {
    if (mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لطفا شماره موبایل را وارد کنید',
            style: TextStyle(fontFamily: 'Vazir', color: Colors.white70, fontSize: 15),
          ),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    var url = Uri.parse('https://payment.vada.ir/api/auth/login-otp');

    try {
      var response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'mobile': mobileController.text,
          'package_name': 'com.vada.karvarz',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'کد تایید ارسال شد',
              style: TextStyle(fontFamily: 'Vazir', color: Colors.white70, fontSize: 15),
            ),
          ),
        );
        startTimer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerifyPage(mobile: mobileController.text),
          ),
        );
      } else {
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'خطا در ارسال کد')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطایی رخ داد')),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        title: Text(
          "ورود",
          style: TextStyle(fontFamily: 'Vazir', fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: darkGreen,
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ChatGPT Image Jul 9, 2025, 03_19_02 AM.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    primaryGreen.withOpacity(0.3),
                    BlendMode.srcOver,
                  ),
                ),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showLabel)
                      Text(
                        'شماره موبایل خود را وارد کنید',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazir',
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (showLabel) SizedBox(height: 30),
                    TextField(
                      controller: mobileController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.white, fontFamily: 'Vazir'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: darkGreen,
                        hintText: 'شماره موبایل',
                        hintStyle: TextStyle(fontFamily: 'Vazir', color: lightGreen.withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.phone_android, color: lightGreen),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 70),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: (loading || timerSeconds > 0) ? null : sendOtp,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 6,
                            shadowColor: Colors.green.shade900.withOpacity(0.6),
                            backgroundColor: Colors.transparent, // برای حذف رنگ پیش‌فرض
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)], // گرادیان سبز روشن به تیره
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              child: loading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                    )
                                  : timerSeconds > 0
                                      ? Text(
                                          'ارسال مجدد تا $timerSeconds',
                                          style: TextStyle(fontSize: 16, fontFamily: 'Vazir', color: Colors.white),
                                        )
                                      : Text(
                                          'ارسال کد',
                                          style: TextStyle(fontFamily: 'Vazir', fontSize: 16, color: Colors.white),
                                        ),
                            ),
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
