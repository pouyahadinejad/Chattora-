


/// --- mobile_input_page.dart ---
import 'package:flutter/material.dart';
import 'otp_verify_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class MobileInputPage extends StatefulWidget {
  @override
  State<MobileInputPage> createState() => _MobileInputPageState();
}

class _MobileInputPageState extends State<MobileInputPage> {
  final mobileController = TextEditingController();
  bool loading = false;
  int timerSeconds = 0;

  void startTimer() {
    setState(() => timerSeconds = 60);
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => timerSeconds--);
      }
    });
  }

  Future<void> sendOtp() async {
    if (mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لطفا شماره موبایل را وارد کنید')),
      );
      return;
    }

    setState(() => loading = true);

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
          SnackBar(content: Text('کد تایید ارسال شد')),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطایی رخ داد')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ورود"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'شماره موبایل',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (loading || timerSeconds > 0) ? null : sendOtp,
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : timerSeconds > 0
                      ? Text('ارسال مجدد تا $timerSeconds')
                      : Text('ارسال کد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: Size(double.infinity, 48),
              ),
            )
          ],
        ),
      ),
    );
  }
}