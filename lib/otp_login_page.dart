import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'otp_verify_page.dart';

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

  final Color primaryGreen = Color(0xFF2E7D32);
  final Color darkGreen = Color(0xFF1B5E20);
  final Color lightGreen = Color(0xFFA5D6A7);

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

    _focusNode.addListener(() {
      setState(() {
        showLabel = !_focusNode.hasFocus;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
      _showSnackBar('لطفا شماره موبایل را وارد کنید');
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
          // 'package_name': 'com.vada.karvarz',
          'package_name': 'com.vada.ielts',
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar('کد تایید ارسال شد');
        startTimer();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerifyPage(mobile: mobileController.text),
          ),
        );
      } else {
        var data = jsonDecode(response.body);
        _showSnackBar(data['message'] ?? 'خطا در ارسال کد');
      }
    } catch (e) {
      print(e);
      _showSnackBar('خطایی رخ داد');
    } finally {
      setState(() => loading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Kalameh',
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        backgroundColor: darkGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop:()async{
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              

              automaticallyImplyLeading: false,
                
              title: Text(
                "ورود",
                style: TextStyle(
                  fontFamily: 'Kalameh',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0xFF2E7D32),
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(children: [ Image.asset(
                              'assets/image.png',
                              width: constraints.maxWidth,
                              // height: 220,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(height: 30),
                            _buildGlassContainer(theme)
                             ],);
                      }
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
    BoxDecoration glassBoxDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.4),
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

  Widget _buildGlassContainer(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400),
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      // decoration: glassBoxDecoration(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child:
       ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLabel)
                Text(
                  'شماره موبایل خود را وارد کنید',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kalameh',
                    color: Colors.black,
                    fontSize: 14
                  ),
                  // textAlign: TextAlign.end,
                ),
              if (showLabel) SizedBox(height: 30),
              TextField(
                controller: mobileController,
                focusNode: _focusNode,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Kalameh',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.3),
                  hintText: 'شماره موبایل',
                  hintStyle: TextStyle(
                    fontFamily: 'Kalameh',
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.phone_android, color: Colors.green),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (loading || timerSeconds > 0) ? null : sendOtp,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    shadowColor:Color(0xFF2E7D32),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGreen, darkGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: loading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : timerSeconds > 0
                              ? Text(
                                  'ارسال مجدد تا $timerSeconds',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Kalameh',
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'ارسال کد',
                                  style: TextStyle(
                                    fontFamily: 'Kalameh',
                                    fontSize: 16,
                                    color: Colors.white,
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
    );
  }
}
