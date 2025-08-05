// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class PaymentWebView extends StatefulWidget {
//   final String paymentUrl;
//   final String? callbackUrlScheme;

//   const PaymentWebView({
//     Key? key,
//     required this.paymentUrl,
//     this.callbackUrlScheme = 'ielts', // باید با scheme تعریف شده در AndroidManifest.xml و Info.plist مطابقت داشته باشد
//   }) : super(key: key);

//   @override
//   State<PaymentWebView> createState() => _PaymentWebViewState();
// }

// class _PaymentWebViewState extends State<PaymentWebView> {
//   late final WebViewController _controller;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             setState(() => _isLoading = progress < 100);
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             // مدیریت URL بازگشت
//             if (request.url.startsWith('${widget.callbackUrlScheme}://')) {
//               final uri = Uri.parse(request.url);
//               final success = uri.queryParameters['status'] == '1';
              
//               Navigator.pop(context, success);
//               return NavigationDecision.prevent;
//             }
            
//             // برای حالت‌های دیگر پرداخت
//             if (request.url.contains('/success') || 
//                 request.url.contains('status=1')) {
//               Navigator.pop(context, true);
//               return NavigationDecision.prevent;
//             }
            
//             if (request.url.contains('/cancel') || 
//                 request.url.contains('status=0')) {
//               Navigator.pop(context, false);
//               return NavigationDecision.prevent;
//             }
            
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.paymentUrl));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('درگاه پرداخت'),
//         leading: IconButton(
//           icon: Icon(Icons.close),
//           onPressed: () => Navigator.pop(context, false),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String? callbackUrlScheme;

  const PaymentWebView({
    Key? key,
    required this.paymentUrl,
    this.callbackUrlScheme = 'ielts',
  }) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  final Color _primaryColor = const Color(0xFF2E7D32); // رنگ سبز تیره
  final Color _backgroundColor = const Color(0xFFF5F5F5); // رنگ خاکستری روشن برای بک‌گراند

  @override
  void initState() {
    super.initState();
    _setupSystemUI();
    _initializeWebViewController();
  }

  void _setupSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: _primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _backgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(_backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() => _isLoading = progress < 100);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('${widget.callbackUrlScheme}://')) {
              final uri = Uri.parse(request.url);
              final success = uri.queryParameters['status'] == '1';
              Navigator.pop(context, success);
              return NavigationDecision.prevent;
            }
            
            if (request.url.contains('/success') || 
                request.url.contains('status=1')) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            
            if (request.url.contains('/cancel') || 
                request.url.contains('status=0')) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'درگاه پرداخت',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: _primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    super.dispose();
  }
}