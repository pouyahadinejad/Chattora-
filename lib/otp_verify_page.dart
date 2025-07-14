// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

// class OtpVerifyPage extends StatefulWidget {
//   final String mobile;
//   OtpVerifyPage({required this.mobile});

//   @override
//   State<OtpVerifyPage> createState() => _OtpVerifyPageState();
// }

// class _OtpVerifyPageState extends State<OtpVerifyPage> with CodeAutoFill, SingleTickerProviderStateMixin {
//   final otpController = TextEditingController();
//   bool loading = false;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//     listenForCode();

//     _animationController = AnimationController(
//       vsync: this, 
//       duration: Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
//     );
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
//     );
//     _animationController.forward();
//   }

//   Future<void> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (!status.isGranted) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void dispose() {
//     cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() {
//           otpController.text = extractedCode!;
//         });
//         checkOtp();
//       } else {
//         print('هیچ کدی پیدا نشد!');
//       }
//     }
//   }

//   Future<void> checkOtp() async {
//     if (otpController.text.length != 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لطفا کد را کامل وارد کنید',)),
        
//       );
//       return;
//     }

//     setState(() => loading = true);
//     var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'mobile': widget.mobile, 'token': otpController.text},
//       );

//       if (response.statusCode == 200) {
//         var token = jsonDecode(response.body)['token'];
//         if (token != null) {
//           var box = Hive.box<String>('auth');
//           await box.put('token', token);
//           // await box.put('token', token);
//           await box.put('mobile', widget.mobile);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارتباط')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: TextStyle(fontSize: 22, color: Colors.deepPurple.shade900, fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         color: Colors.deepPurple.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.deepPurple.shade200),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: Text("تایید کد", style: TextStyle(fontFamily: 'Vazir',fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//       ),
//       body: Container(
//          decoration: BoxDecoration(
//             image: DecorationImage(
//             image: AssetImage("assets/ChatGPT Image Jul 7, 2025, 03_58_36 AM.png"),
//             fit: BoxFit.cover, // یا BoxFit.fill یا BoxFit.contain
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'کد تایید ارسال شده به شماره ${widget.mobile}',
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Vazir',
//                       color: Colors.deepPurple.shade700,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 30),
//                   Pinput(
//                     length: 5,
//                     controller: otpController,
//                     androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
//                     defaultPinTheme: defaultPinTheme,
//                     onCompleted: (pin) => checkOtp(),
//                   ),
//                   SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 70),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: loading ? null : checkOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 5,
//                           shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
//                         ),
//                         child: loading
//                             ? SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                               )
//                             : Text('تایید', style: TextStyle(fontFamily: 'Vazir',fontSize: 16,color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

// class OtpVerifyPage extends StatefulWidget {
//   final String mobile;
//   OtpVerifyPage({required this.mobile});

//   @override
//   State<OtpVerifyPage> createState() => _OtpVerifyPageState();
// }

// class _OtpVerifyPageState extends State<OtpVerifyPage> with CodeAutoFill, SingleTickerProviderStateMixin {
//   final Color primaryGreen = Color(0xFF2E7D32);
//   final otpController = TextEditingController();
//   bool loading = false;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//     listenForCode();

//     _animationController = AnimationController(
//       vsync: this, 
//       duration: Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
//     );
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
//     );
//     _animationController.forward();
//   }

//   Future<void> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (!status.isGranted) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void dispose() {
//     cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() {
//           otpController.text = extractedCode!;
//         });
//         checkOtp();
//       } else {
//         print('هیچ کدی پیدا نشد!');
//       }
//     }
//   }

//   Future<void> checkOtp() async {
//     if (otpController.text.length != 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لطفا کد را کامل وارد کنید')),
//       );
//       return;
//     }

//     setState(() => loading = true);
//     var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'mobile': widget.mobile, 'token': otpController.text},
//       );

//       if (response.statusCode == 200) {
//         var token = jsonDecode(response.body)['token'];
//         if (token != null) {
//           var box = Hive.box<String>('auth');
//           await box.put('token', token);
//           await box.put('mobile', widget.mobile);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارتباط')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final defaultPinTheme = PinTheme(
//       width: 56,
//       height: 56,
//       textStyle: TextStyle(fontSize: 22, color: Colors.green.shade900, fontWeight: FontWeight.w600),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.green.shade200),
//       ),
//     );

//         final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Colors.green.shade700, width: 2),
//       color: Colors.green.withOpacity(0.15),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.green.withOpacity(0.2),
//       ),
//     );

//     return Scaffold(
//       backgroundColor:Color(0xFF2E7D32),
//       appBar: AppBar(
//         automaticallyImplyLeading :false,
//         title: Center(child: Text("تایید کد", style: TextStyle(fontFamily: 'Vazir', fontWeight: FontWeight.w600))),
//         backgroundColor: Color(0xFF2E7D32), // سبز تیره
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/ChatGPT Image Jul 13, 2025, 11_46_01 PM.png"),
//             fit: BoxFit.cover,
//              colorFilter: ColorFilter.mode(
//                     primaryGreen.withOpacity(0.3),
//                     BlendMode.srcOver,
//                   ),
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
                  
                    
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 400),
//                       child: Text(
//                         'کد تایید ارسال شده به شماره ${widget.mobile}',
//                         style: theme.textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Vazir',
//                           color: Colors.black87,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
                  
//                   SizedBox(height: 30),
//                   Pinput(
//                     length: 5,
//                     controller: otpController,
//                     androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
//                     defaultPinTheme: defaultPinTheme,
//                  // defaultPinTheme: defaultPinTheme,
//                     focusedPinTheme: focusedPinTheme,
//                     showCursor: true,
//                               animationCurve: Curves.easeInOut,
//           animationDuration: const Duration(milliseconds: 300),
//           // onCompleted: (pin) => print('Entered PIN: $pin'),
//                     submittedPinTheme: submittedPinTheme,
//                     onCompleted: (pin) => checkOtp(),
//                   ),
//                   SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 70),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: loading ? null : checkOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF2E7D32), // سبز تیره
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 5,
//                           shadowColor: Colors.greenAccent.withOpacity(0.5),
//                         ),
//                         child: loading
//                             ? SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                               )
//                             : Text('تایید', style: TextStyle(fontFamily: 'Vazir', fontSize: 16, color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

// class OtpVerifyPage extends StatefulWidget {
//   final String mobile;
//   OtpVerifyPage({required this.mobile});

//   @override
//   State<OtpVerifyPage> createState() => _OtpVerifyPageState();
// }

// class _OtpVerifyPageState extends State<OtpVerifyPage>
//     with CodeAutoFill, SingleTickerProviderStateMixin {
//   final Color primaryGreen = Color(0xFF2E7D32);
//   final otpController = TextEditingController();
//   bool loading = false;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//     listenForCode();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _animationController, curve: Curves.easeOut));
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.easeOut));
//     _animationController.forward();
//   }

//   Future<void> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (!status.isGranted) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void dispose() {
//     cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() {
//           otpController.text = extractedCode!;
//         });
//         checkOtp();
//       } else {
//         print('هیچ کدی پیدا نشد!');
//       }
//     }
//   }

//   Future<void> checkOtp() async {
//     if (otpController.text.length != 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لطفا کد را کامل وارد کنید')),
//       );
//       return;
//     }

//     setState(() => loading = true);
//     var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'mobile': widget.mobile, 'token': otpController.text},
//       );

//       if (response.statusCode == 200) {
//         var token = jsonDecode(response.body)['token'];
//         if (token != null) {
//           var box = Hive.box<String>('auth');
//           await box.put('token', token);
//           await box.put('mobile', widget.mobile);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارتباط')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     /// ⭐ تغییرات فقط اینجاست ⭐
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 68,
//       textStyle: TextStyle(
//         fontSize: 26,
//         color: Colors.green.shade900,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Vazir',
//       ),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.greenAccent.withOpacity(0.4),
//             Colors.white.withOpacity(0.2),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.greenAccent, width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.greenAccent.withOpacity(0.5),
//             blurRadius: 10,
//             spreadRadius: 1,
//             offset: Offset(0, 4),
//           )
//         ],
//         backgroundBlendMode: BlendMode.overlay,
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       gradient: LinearGradient(
//         colors: [
//           Colors.green.shade400.withOpacity(0.8),
//           Colors.greenAccent.withOpacity(0.6),
//         ],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       border: Border.all(
//         color: Colors.green.shade700,
//         width: 3,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.greenAccent.withOpacity(0.7),
//           blurRadius: 15,
//           spreadRadius: 2,
//           offset: Offset(0, 4),
//         )
//       ],
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         gradient: LinearGradient(
//           colors: [
//             Colors.greenAccent.withOpacity(0.3),
//             Colors.white.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: Colors.green.shade300, width: 2),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Color(0xFF2E7D32),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Center(
//             child: Text("تایید کد",
//                 style: TextStyle(
//                     fontFamily: 'Vazir', fontWeight: FontWeight.w600))),
//         backgroundColor: Color(0xFF2E7D32),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 "assets/ChatGPT Image Jul 13, 2025, 11_46_01 PM.png"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               primaryGreen.withOpacity(0.3),
//               BlendMode.srcOver,
//             ),
//           ),
//         ),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'کد تایید ارسال شده به شماره ${widget.mobile}',
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Vazir',
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 30),
//                   Pinput(
//                     length: 5,
//                     controller: otpController,
//                     androidSmsAutofillMethod:
//                         AndroidSmsAutofillMethod.smsUserConsentApi,
//                     defaultPinTheme: defaultPinTheme,
//                     focusedPinTheme: focusedPinTheme,
//                     submittedPinTheme: submittedPinTheme,
//                     showCursor: true,
//                     animationCurve: Curves.easeInOut,
//                     animationDuration: const Duration(milliseconds: 300),
//                     onCompleted: (pin) => checkOtp(),
//                   ),
//                   SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 70),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: loading ? null : checkOtp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF2E7D32),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           elevation: 5,
//                           shadowColor:
//                               Colors.greenAccent.withOpacity(0.5),
//                         ),
//                         child: loading
//                             ? SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                     color: Colors.white, strokeWidth: 3),
//                               )
//                             : Text('تایید',
//                                 style: TextStyle(
//                                     fontFamily: 'Vazir',
//                                     fontSize: 16,
//                                     color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


















////////////////////////////////Nice


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

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

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//     listenForCode();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _animationController, curve: Curves.easeOut));
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.easeOut));
//     _animationController.forward();
//   }

//   Future<void> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (!status.isGranted) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void dispose() {
//     cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() {
//           otpController.text = extractedCode!;
//         });
//         checkOtp();
//       } else {
//         print('هیچ کدی پیدا نشد!');
//       }
//     }
//   }

//   Future<void> checkOtp() async {
//     if (otpController.text.length != 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لطفا کد را کامل وارد کنید')),
//       );
//       return;
//     }

//     setState(() => loading = true);
//     var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'mobile': widget.mobile, 'token': otpController.text},
//       );

//       if (response.statusCode == 200) {
//         var token = jsonDecode(response.body)['token'];
//         if (token != null) {
//           var box = Hive.box<String>('auth');
//           await box.put('token', token);
//           await box.put('mobile', widget.mobile);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارتباط')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
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
//         fontFamily: 'Vazir',
//         fontWeight: FontWeight.w600,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.green.shade300, width: 1.5),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Colors.greenAccent, width: 2),
//       color: Colors.white.withOpacity(0.2),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.green.withOpacity(0.1),
//         border: Border.all(color: Colors.green.shade500, width: 2),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: Column(
//                 // crossAxisAlignment: CrossAxisAlignment.end,
//                 // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   SizedBox(height: 16),
//                   Image.asset(
//                     'assets/image.png',
//                     width: double.infinity,
//                     height: 250,
//                     fit: BoxFit.contain,
//                   ),
//                   SizedBox(height: 150),
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Container(
//                       width: double.infinity,
//                       constraints: BoxConstraints(maxWidth: 400),
//                       padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.white.withOpacity(0.3)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.15),
//                             blurRadius: 20,
//                             offset: Offset(0, 10),
//                           )
//                         ],
//                         backgroundBlendMode: BlendMode.overlay,
//                       ),
//                       child: Column(
//                         // mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         // mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Text(
//                           //   "کد تایید",
//                           //   style: theme.textTheme.headlineSmall?.copyWith(
//                           //     color: Colors.black,
//                           //     fontFamily: 'Vazir',
//                           //     fontWeight: FontWeight.bold,
//                           //   ),
//                           // ),
//                           SizedBox(height: 12),
//                           Text(
//                             'کد تایید ارسال شده به شماره ${widget.mobile}',
//                             // textAlign: TextAlign.center,
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w700,
//                               fontFamily: 'Vazir',
//                               fontSize: 12
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           Pinput(
                            
//                             length: 5,
//                             controller: otpController,
//                             androidSmsAutofillMethod:
//                             AndroidSmsAutofillMethod.smsUserConsentApi,
//                             defaultPinTheme: defaultPinTheme,
//                             focusedPinTheme: focusedPinTheme,
//                             submittedPinTheme: submittedPinTheme,
//                             showCursor: true,
//                             animationCurve: Curves.easeInOut,
//                             animationDuration: const Duration(milliseconds: 300),
//                             onCompleted: (pin) => checkOtp(),
//                           ),
//                           SizedBox(height: 32),
//                           SizedBox(
//                             width: double.infinity,
//                             height: 50,
//                             child: ElevatedButton(
//                               onPressed: loading ? null : checkOtp,
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                                 backgroundColor: Colors.green,
//                                 elevation: 8,
//                                 shadowColor:
//                                     Colors.greenAccent.withOpacity(0.5),
//                               ),
//                               child: loading
//                                   ? CircularProgressIndicator(
//                                       color: Colors.white, strokeWidth: 3)
//                                   : Text(
//                                       "تایید",
//                                       style: theme.textTheme.bodyLarge?.copyWith(
//                               color: Colors.white,
//                               fontFamily: 'Vazir',
//                               fontSize: 15
//                             ),
//                                     ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





















// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:http/http.dart' as http;
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:permission_handler/permission_handler.dart';

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

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     requestSmsPermission();
//     listenForCode();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 700),
//     );
//     _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
//         .animate(CurvedAnimation(
//             parent: _animationController, curve: Curves.easeOut));
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//         parent: _animationController, curve: Curves.easeOut));
//     _animationController.forward();
//   }

//   Future<void> requestSmsPermission() async {
//     var status = await Permission.sms.status;
//     if (!status.isGranted) {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void dispose() {
//     cancel();
//     otpController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   void codeUpdated() {
//     if (code != null) {
//       final regex = RegExp(r'\b\d{5}\b');
//       final match = regex.firstMatch(code!);
//       if (match != null) {
//         final extractedCode = match.group(0);
//         setState(() {
//           otpController.text = extractedCode!;
//         });
//         checkOtp();
//       } else {
//         print('هیچ کدی پیدا نشد!');
//       }
//     }
//   }

//   Future<void> checkOtp() async {
//     if (otpController.text.length != 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('لطفا کد را کامل وارد کنید')),
//       );
//       return;
//     }

//     setState(() => loading = true);
//     var url = Uri.parse('https://payment.vada.ir/api/auth/check-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {'mobile': widget.mobile, 'token': otpController.text},
//       );

//       if (response.statusCode == 200) {
//         var token = jsonDecode(response.body)['token'];
//         if (token != null) {
//           var box = Hive.box<String>('auth');
//           await box.put('token', token);
//           await box.put('mobile', widget.mobile);
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارتباط')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
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
//         fontFamily: 'Vazir',
//         fontWeight: FontWeight.w600,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.green.shade300, width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 2,
//           )
//         ],
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//       border: Border.all(color: Colors.greenAccent, width: 2),
//       color: Colors.white.withOpacity(0.2),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         color: Colors.green.withOpacity(0.1),
//         border: Border.all(color: Colors.green.shade500, width: 2),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                 child: Column(
//                   children: [
//                     /// تصویر بالای صفحه
//                     Image.asset(
//                       "assets/image.png",
//                       width: 200,
//                       fit: BoxFit.contain,
//                     ),
//                     SizedBox(height: 32),

//                     /// Glass Container
//                     Center(
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//                         child: Container(
//                           constraints: BoxConstraints(maxWidth: 400),
//                           padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                               width: 1,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 20,
//                                 offset: Offset(0, 10),
//                               )
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 "کد تایید",
//                                 style: theme.textTheme.headlineSmall?.copyWith(
//                                   color: Colors.green.shade800,
//                                   fontFamily: 'Vazir',
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'کد تایید ارسال شده به شماره:\n${widget.mobile}',
//                                 textAlign: TextAlign.center,
//                                 style: theme.textTheme.bodyLarge?.copyWith(
//                                   color: Colors.green.shade700,
//                                   fontFamily: 'Vazir',
//                                 ),
//                               ),
//                               SizedBox(height: 24),
//                               Pinput(
//                                 length: 5,
//                                 controller: otpController,
//                                 androidSmsAutofillMethod:
//                                     AndroidSmsAutofillMethod.smsUserConsentApi,
//                                 defaultPinTheme: defaultPinTheme,
//                                 focusedPinTheme: focusedPinTheme,
//                                 submittedPinTheme: submittedPinTheme,
//                                 showCursor: true,
//                                 animationCurve: Curves.easeInOut,
//                                 animationDuration: const Duration(milliseconds: 300),
//                                 onCompleted: (pin) => checkOtp(),
//                               ),
//                               SizedBox(height: 32),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 50,
//                                 child: ElevatedButton(
//                                   onPressed: loading ? null : checkOtp,
//                                   style: ElevatedButton.styleFrom(
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12)),
//                                     backgroundColor: Colors.greenAccent,
//                                     elevation: 8,
//                                     shadowColor: Colors.greenAccent.withOpacity(0.5),
//                                   ),
//                                   child: loading
//                                       ? CircularProgressIndicator(
//                                           color: Colors.white, strokeWidth: 3)
//                                       : Text(
//                                           "تایید",
//                                           style: TextStyle(
//                                             fontFamily: 'Vazir',
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.green.shade900,
//                                           ),
//                                         ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




















////////////////////nice
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:permission_handler/permission_handler.dart';

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
    requestSmsPermission();
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

  Future<void> requestSmsPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
  }

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
          'package_name': 'com.vada.karvarz',
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
          'package_name': 'com.vada.karvarz',
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
            fontFamily: 'Vazir',
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
          Navigator.pushReplacementNamed(context, '/home');
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
        fontFamily: 'Vazir',
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
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
                                  fontFamily: 'Vazir',
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
                                    fontFamily: 'Vazir',
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
                                      fontFamily: 'Vazir',
                                      color: Colors.green,
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
                                        Colors.greenAccent.withOpacity(0.5),
                                    disabledForegroundColor:
                                        Colors.white.withOpacity(0.5),
                                    disabledBackgroundColor:
                                        Colors.green.withOpacity(0.3),
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
                                            fontFamily: 'Vazir',
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
    );
  }
}




























// import 'dart:async';
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pinput/pinput.dart';

// class OtpVerifyPage extends StatefulWidget {
//   final String mobile;

//   const OtpVerifyPage({super.key, required this.mobile});

//   @override
//   State<OtpVerifyPage> createState() => _OtpVerifyPageState();
// }

// class _OtpVerifyPageState extends State<OtpVerifyPage>
//     with TickerProviderStateMixin {
//   final otpController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   bool loading = false;
//   int timerSeconds = 0;
//   Timer? timer;

//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _fadeAnimation;

//   final Color primaryGreen = Color(0xFF2E7D32);
//   final Color darkGreen = Color(0xFF1B5E20);
//   final Color lightGreen = Color(0xFFA5D6A7);

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

//     _animationController.forward();

//     startTimer();
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     otpController.dispose();
//     _focusNode.dispose();
//     _animationController.dispose();
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

//   Future<void> sendOtpAgain() async {
//     setState(() => loading = true);

//     var url = Uri.parse('https://payment.vada.ir/api/auth/login-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {
//           'mobile': widget.mobile,
//           'package_name': 'com.vada.karvarz',
//         },
//       );

//       if (response.statusCode == 200) {
//         showSnack('کد جدید ارسال شد');
//         startTimer();
//       } else {
//         var data = jsonDecode(response.body);
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

//     var url = Uri.parse('https://payment.vada.ir/api/auth/verify-otp');

//     try {
//       var response = await http.post(
//         url,
//         headers: {'Accept': 'application/json'},
//         body: {
//           'mobile': widget.mobile,
//           'code': otpController.text,
//           'package_name': 'com.vada.karvarz',
//         },
//       );

//       if (response.statusCode == 200) {
//         showSnack('ورود موفقیت آمیز بود');
//         // TODO: هدایت به صفحه بعدی
//       } else {
//         var data = jsonDecode(response.body);
//         showSnack(data['message'] ?? 'کد تایید اشتباه است');
//       }
//     } catch (e) {
//       showSnack('خطا در ارتباط');
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void showSnack(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             fontFamily: 'Vazir',
//             color: Colors.white,
//             fontSize: 15,
//           ),
//         ),
//         backgroundColor: darkGreen,
//       ),
//     );
//   }

//   BoxDecoration glassBoxDecoration() {
//     return BoxDecoration(
//       color: Colors.white.withOpacity(0.4),
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: Colors.white.withOpacity(0.3)),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 20,
//           offset: Offset(0, 10),
//         )
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           "تأیید کد",
//           style: TextStyle(
//             fontFamily: 'Vazir',
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/image.png',
//                     width: MediaQuery.of(context).size.width,
//                     fit: BoxFit.fitWidth,
//                   ),
//                   SizedBox(height: 30),
//                   Container(
//                     width: double.infinity,
//                     constraints: BoxConstraints(maxWidth: 400),
//                     margin: EdgeInsets.symmetric(horizontal: 24),
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       border:
//                           Border.all(color: Colors.white.withOpacity(0.3)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 20,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'کد ارسال شده به ${widget.mobile} را وارد کنید',
//                               style: theme.textTheme.titleLarge?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Vazir',
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             SizedBox(height: 30),
//                             Pinput(
//                               length: 5,
//                               controller: otpController,
//                               focusNode: _focusNode,
//                               defaultPinTheme: PinTheme(
//                                 width: 50,
//                                 height: 50,
//                                 textStyle: TextStyle(
//                                   fontFamily: 'Vazir',
//                                   fontSize: 20,
//                                   color: Colors.black,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             if (timerSeconds > 0)
//                               Text(
//                                 'ارسال مجدد تا $timerSeconds ثانیه دیگر',
//                                 style: TextStyle(
//                                   fontFamily: 'Vazir',
//                                   color: Colors.black54,
//                                   fontSize: 13,
//                                 ),
//                               )
//                             else
//                               TextButton(
//                                 onPressed: loading ? null : sendOtpAgain,
//                                 child: Text(
//                                   'ارسال مجدد کد',
//                                   style: TextStyle(
//                                     fontFamily: 'Vazir',
//                                     color: Colors.green,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                             SizedBox(height: 30),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 50,
//                               child: ElevatedButton(
//                                 onPressed: loading ? null : verifyOtp,
//                                 style: ElevatedButton.styleFrom(
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(12)),
//                                   elevation: 6,
//                                   shadowColor: Colors.green.shade900
//                                       .withOpacity(0.6),
//                                   backgroundColor: Colors.transparent,
//                                 ),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [primaryGreen, darkGreen],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Center(
//                                     child: loading
//                                         ? SizedBox(
//                                             width: 24,
//                                             height: 24,
//                                             child:
//                                                 CircularProgressIndicator(
//                                               color: Colors.white,
//                                               strokeWidth: 3,
//                                             ),
//                                           )
//                                         : Text(
//                                             'تأیید کد',
//                                             style: TextStyle(
//                                               fontFamily: 'Vazir',
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

