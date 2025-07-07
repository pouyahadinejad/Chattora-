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

class _OtpVerifyPageState extends State<OtpVerifyPage> with CodeAutoFill, SingleTickerProviderStateMixin {
  final otpController = TextEditingController();
  bool loading = false;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    requestSmsPermission();
    listenForCode();

    _animationController = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    );
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
    cancel();
    otpController.dispose();
    _animationController.dispose();
    super.dispose();
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
        checkOtp();
      } else {
        print('هیچ کدی پیدا نشد!');
      }
    }
  }

  Future<void> checkOtp() async {
    if (otpController.text.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لطفا کد را کامل وارد کنید',)),
        
      );
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
          // await box.put('token', token);
          await box.put('mobile', widget.mobile);
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'کد نادرست است')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارتباط')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 22, color: Colors.deepPurple.shade900, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text("تایید کد", style: TextStyle(fontFamily: 'Vazir',fontWeight: FontWeight.w600)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
         decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/ChatGPT Image Jul 7, 2025, 03_58_36 AM.png"),
            fit: BoxFit.cover, // یا BoxFit.fill یا BoxFit.contain
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'کد تایید ارسال شده به شماره ${widget.mobile}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazir',
                      color: Colors.deepPurple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Pinput(
                    length: 5,
                    controller: otpController,
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (pin) => checkOtp(),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : checkOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 5,
                          shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
                        ),
                        child: loading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              )
                            : Text('تایید', style: TextStyle(fontFamily: 'Vazir',fontSize: 16,color: Colors.white)),
                      ),
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
}
