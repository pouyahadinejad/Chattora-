import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:otpuivada/PaymentWebView%20.dart';
import 'package:otpuivada/auth_service.dart';
import 'package:otpuivada/history_page.dart';
import 'package:otpuivada/ocrpdf.dart';
import 'package:otpuivada/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
//  ویجت کارت اشتراک با انیمیشن


class AnimatedPlanCard extends StatefulWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onTap;

  const AnimatedPlanCard({required this.plan, required this.onTap});

  @override
  _AnimatedPlanCardState createState() => _AnimatedPlanCardState();
}

class _AnimatedPlanCardState extends State<AnimatedPlanCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      child: Transform.scale(
        scale: _isPressed ? 0.98 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // آیکون ساده
                    Icon(Icons.workspace_premium, 
                        color: const Color(0xFF2E7D32), size: 20),
                    const SizedBox(width: 12),
                    
                    // اطلاعات اصلی
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.plan['title'] ?? 'پلن پیشفرض',
                            style: const TextStyle(
                              fontFamily: 'Kalameh',
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          //  Text(
                          //   '۱۵۰,۰۰۰ تومان',
                          //   style: TextStyle(
                          //     fontFamily: 'Kalameh',
                          //     fontSize: 10,
                          //     color: Colors.red[800],
                          //     decoration: TextDecoration.lineThrough,
                          //     decorationColor: Colors.red,
                          //     decorationThickness: 2,
                          //   ),
                          // ),
                          Text(
                          '${widget.plan['price'] ?? '0'} تومان',
                           style: const TextStyle(
                            fontFamily: 'Kalameh',
                            color: Colors.black
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        ],
                      ),
                    ),
                    
                    // قیمت و دکمه
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'خرید اشتراک',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_left_rounded,color: Colors.white,)
                            ],
                          ),
                          
                         ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class ChatListPage extends StatefulWidget {
  final String? initialMessage;
  final String imagePath;

  const ChatListPage({
    Key? key,
    this.initialMessage,     
    required this.imagePath,
  }) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool _hasActiveSubscription = false;
  String  _subscriptionStatus = 'عدم اشتراک';
  late BuildContext _context;
  late final AutoScrollController _scrollController;
  final TextEditingController messageController = TextEditingController();
  List<types.Message> messages = [];
  bool loading = false;
  int sentMessageCount = 0;
  final int maxFreeMessages = 1;
  bool _showScrollToBottomButton = false;
  final types.User _user = const types.User(id: 'user');
  final types.User _bot = const types.User(id: 'bot');

@override
void initState() {
    checkSubscriptionStatus();
  // هر 5 دقیقه وضعیت اشتراک را چک کنید
  Timer.periodic(Duration(minutes: 5), (_) => checkSubscriptionStatus());
  _scrollController = AutoScrollController();
  super.initState();
  _scrollController.addListener(_handleScrollPosition);
  
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await loadSentMessageCount();
    await loadMessagesFromLocal();
    // await loadChatId();
    checkLoginAndFetch();
    
    // این بخش را فقط یک بار و با تاخیر اجرا کنید
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      final text = widget.initialMessage!.trim();
      messageController.text = text;
      await Future.delayed(const Duration(milliseconds: 300));
      _handleSendPressed(types.PartialText(text: text));
    }
  });
}

  @override
  void dispose() {
    // _scrollController.dispose();///////////////////////////////////////
    messageController.dispose();
    super.dispose();
  }
////////////////////////////
  void _scrollToBottom() {
    if (_scrollController.hasClients && messages.isNotEmpty) {
      _scrollController.scrollToIndex(
        0,
        duration: const Duration(milliseconds: 300),
        preferPosition: AutoScrollPosition.begin,
      );
    }
  }
  void setOcrData(String message, String imagePath) {
  if (!mounted) return;
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ChatListPage(
        initialMessage: message,
        imagePath: imagePath,
      ),
    ),
  );
}

  void _handleScrollPosition() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      setState(() {
        _showScrollToBottomButton = position.pixels > position.minScrollExtent + 100;
      });
    }
  }

  Future<void> loadSentMessageCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
    });
  }
//////////////////////////////
Future<bool> checkUserHasSubscription() async {
  final token = AuthService.getToken();
  if (token == null) return false;

  try {
    final response = await http.get(
      Uri.parse('https://payment.vada.ir/api/status?package_name=com.vada.ielts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status'] == true;
    }
    return false;
  } catch (e) {
    print('Error checking subscription: $e');
    return false;
  }
}
///////////////////////////////////
Future<void> purchaseSubscription(int productId) async {
  final token = AuthService.getToken();
  if (token == null) {
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  try {
    // 1. دریافت لینک درگاه پرداخت
    final paymentUrl = await _getPaymentUrl(token, productId);
    if (paymentUrl == null) throw 'خطا در دریافت درگاه پرداخت';

    // 2. باز کردن صفحه پرداخت
    final paymentSuccess = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebView(
          paymentUrl: paymentUrl,
          callbackUrlScheme: 'ielts', // باید با scheme تعریف شده در native مطابقت داشته باشد
        ),
      ),
    );

    // 3. بررسی نتیجه پرداخت
    if (paymentSuccess == true) {
      // 4. تاخیر برای اطمینان از ثبت پرداخت در سرور
      await Future.delayed(Duration(seconds: 2));
      
      // 5. بروزرسانی وضعیت اشتراک
      final hasSubscription = await checkSubscriptionStatus();
      
      if (hasSubscription) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('اشتراک با موفقیت فعال شد')),
        );
      } else {
        throw 'اشتراک فعال نشد. لطفاً چند دقیقه دیگر بررسی کنید';
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

Future<String?> _getPaymentUrl(String token, int productId) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://payment.vada.ir/api/zarinpal/gateway'),
  );
  request.headers.addAll({'Authorization': 'Bearer $token'});
  request.fields.addAll({
    'description': 'خرید اشتراک اپلیکیشن آیلتس',
    'product_id': productId.toString(),
  });

  final response = await request.send();
  final responseData = await response.stream.bytesToString();
  final jsonResponse = jsonDecode(responseData);

  if (response.statusCode == 200) {
    return jsonResponse['url'];
  }
  return null;
}
Future<List<Map<String, dynamic>>> fetchSubscriptionPlans() async {
  final token = AuthService.getToken();
  if (token == null) return [];

  final url = Uri.parse('https://payment.vada.ir/api/package-names/com.vada.ielts/products');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    return [];
  }
}
Future<String?> initiatePurchase({required int productId}) async {
  final token = AuthService.getToken();
  if (token == null) return null;

  final uri = Uri.parse('https://payment.vada.ir/api/zarinpal/gateway');
  final request = http.MultipartRequest('POST', uri)
    ..fields['description'] = 'خرید اشتراک از اپ'
    ..fields['product_id'] = productId.toString()
    ..headers['Authorization'] = 'Bearer $token';

  final response = await request.send();

  if (response.statusCode == 200) {
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);
    return data['url']; // لینک درگاه پرداخت
  } else {
    return null;
  }
}
// @override
// void dispose() {
//   // لغو درخواست در حال انجام هنگام از بین رفتن ویجت
//   _subscriptionRequest?.abort();
//   super.dispose();
// }
// متغیر برای مدیریت درخواست
http.Request? _subscriptionRequest;

Future<bool> checkSubscriptionStatus() async {
  if (!mounted) return false; // بررسی اولیه قبل از شروع عملیات

  final token = AuthService.getToken();
  if (token == null) {
    if (mounted) {
      setState(() {
        _hasActiveSubscription = false;
        _subscriptionStatus = 'ورود نکرده‌اید';
      });
    }
    return false;
  }

  try {
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
    
    _subscriptionRequest = http.Request(
      'GET', 
      Uri.parse('https://payment.vada.ir/api/status?package_name=com.vada.ielts')
    );
    _subscriptionRequest!.headers.addAll(headers);

    final response = await _subscriptionRequest!.send();
    final responseBody = await response.stream.bytesToString();

    if (!mounted) return false; // بررسی مجدد قبل از به‌روزرسانی وضعیت

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final hasSubscription = data['products'] != null && 
        (data['products'] as List).isNotEmpty;

      if (mounted) {
        setState(() {
          _hasActiveSubscription = hasSubscription;
          _subscriptionStatus = hasSubscription ? 'اشتراک فعال' : 'بدون اشتراک';
        });
      }

      if (hasSubscription && mounted) {
        await resetSentMessageCount();
      }

      return hasSubscription;
    } else {
      print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      if (mounted) {
        setState(() {
          _hasActiveSubscription = false;
          _subscriptionStatus = 'خطا در بررسی وضعیت';
        });
      }
      return false;
    }
  } catch (e) {
    print('Subscription check error: $e');
    if (mounted) {
      setState(() {
        _hasActiveSubscription = false;
        _subscriptionStatus = 'خطا در اتصال';
      });
    }
    return false;
  }
}

// @override
// void dispose() {
//   // لغو درخواست در حال انجام هنگام از بین رفتن ویجت
//   _subscriptionRequest?.abort();
//   super.dispose();
// }
// Future<bool> checkSubscriptionStatus() async {
//   final token = AuthService.getToken();
//   if (token == null) {
//     setState(() {
//       _hasActiveSubscription = false;
//       _subscriptionStatus = 'ورود نکرده‌اید';
//     });
//     return false;
//   }

//   try {
//     final headers = {
//       'Authorization': 'Bearer $token',
//       'Accept': 'application/json',
//     };
    
//     final request = http.Request(
//       'GET', 
//       Uri.parse('https://payment.vada.ir/api/status?package_name=com.vada.ielts')
//     );
//     request.headers.addAll(headers);

//     final response = await request.send();
//     final responseBody = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       final data = jsonDecode(responseBody);
//       final hasSubscription = data['products'] != null && 
//         (data['products'] as List).isNotEmpty;

//       setState(() {
//         _hasActiveSubscription = hasSubscription;
//         _subscriptionStatus = hasSubscription ? 'اشتراک فعال' : 'بدون اشتراک';
//       });

//       // اگر اشتراک فعال است، تعداد پیام‌ها را ریست کنید
//       if (hasSubscription) {
//         await resetSentMessageCount();
//       }

//       return hasSubscription;
//     } else {
//       print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
//       setState(() {
//         _hasActiveSubscription = false;
//         _subscriptionStatus = 'خطا در بررسی وضعیت';
//       });
//       return false;
//     }
//   } catch (e) {
//     print('Subscription check error: $e');
//     setState(() {
//       _hasActiveSubscription = false;
//       _subscriptionStatus = 'خطا در اتصال';
//     });
//     return false;
//   }
// }

/////////////
//   // برای ذخیره chat_id
// Future<void> saveChatId(String id) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('chat_id', id);
//   setState(() {
//     chatId = id;
//   });
// }

// // برای خواندن chat_id
// Future<String?> loadChatId() async {
//   final prefs = await SharedPreferences.getInstance();
//   final id = prefs.getString('chat_id');
//   setState(() {
//     chatId = id;
//   });
//   return id;
// }
Future<void> resetSentMessageCount() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    sentMessageCount = 0;
    prefs.setInt('sentMessageCount', 0);
  });
}
Future<void> incrementSentMessageCount() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    sentMessageCount++;
    prefs.setInt('sentMessageCount', sentMessageCount);
  });
}

  Future<void> saveMessagesToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('chatMessages', jsonList);
  }

  Future<void> loadMessagesFromLocal() async {
    
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('chatMessages');
    
    if (jsonList != null) {
      try {
        final loadedMessages = <types.Message>[];
        
        for (final jsonString in jsonList) {
          try {
            final json = jsonDecode(jsonString);
            if (json is Map<String, dynamic>) {
              // تبدیل پیام‌های قدیمی به فرمت جدید
              if (json['author'] == null) {
                final isMine = json['from'] == 0;
                loadedMessages.add(types.TextMessage(
                  author: isMine ? _user : _bot,
                  createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
                  id: json['id']?.toString() ?? DateTime.now().toString(),
                  text: json['body']?.toString() ?? '',
                ));
              } else {
                loadedMessages.add(types.Message.fromJson(json));
              }
            }
          } catch (e) {
            print('Error parsing message: $e');
          }
        }

        setState(() {
          messages = loadedMessages.where((m) => 
             m is types.Message && 
             (m is! types.TextMessage || m.text.trim().isNotEmpty)
           ).toList();
         });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      } catch (e) {
        print('Error loading messages: $e');
      }
    }
  }

  Future<void> checkLoginAndFetch() async {
    if (!AuthService.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
  }

  String cleanOcrText(String text) {
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('rd ike', "I'd like")
        .replaceAll('neighbours.', 'neighbours?')
        .replaceAll('questions.', 'questions?')
        .replaceAll('ask each other', 'ask each other questions')
        .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
        .replaceAll('Can didate', 'Candidate')
        .trim();
  }

  String buildPrompt(String rawText) {
    return '''
You are taking the IELTS Life Skills A1 Speaking and Listening test.

Below are questions from Phase 1a and Phase 1b of the exam.
Please respond to all of them as if you are a candidate in the test.
Keep your answers simple, realistic, and appropriate for A1 level English.

Questions:
$rawText

Start answering now.
''';
  }

  void _handleSendPressed(types.PartialText message) {
    sendMessage(text: message.text);
  }

    Future<void> sendMessage({required String text}) async {
      final messageText = text.trim();
      if (messageText.isEmpty) return;

      if (loading) return;
  // بررسی وضعیت اشتراک
  final hasSubscription = await checkUserHasSubscription();
      if (!hasSubscription && sentMessageCount >= maxFreeMessages) {
        showUpgradeDialog();
        return;
      }
      if (sentMessageCount >= maxFreeMessages) {
        showUpgradeDialog();
        return;
      }

    setState(() => loading = true);

  final userMessage = types.TextMessage(
    author: _user,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    id: 'user_${DateTime.now().millisecondsSinceEpoch}',
    text: messageText,
  );

  setState(() {
    messages = [userMessage, ...messages];
  });
    
    _scrollToBottom();
      // فقط اگر اشتراک ندارد، تعداد پیام‌ها را افزایش دهید
  if (!hasSubscription) {
    await incrementSentMessageCount();
  }

    final token = AuthService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.ielts');
    final cleaned = cleanOcrText(messageText);
    final prompt = buildPrompt(cleaned);

    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'package_name': 'com.vada.ielts',
        },
        body: jsonEncode({
          'body': prompt,
          'title': 'آزمون آیلتس',
        }),
      );

      if (response.statusCode == 200) {
        messageController.clear();
        var data = jsonDecode(response.body);

        String? chatResponse;
        String? chatId;

        if (data is Map && data.containsKey('body')) {
          chatResponse = data['body'];
          chatId = data['id']?.toString();
        } else if (data is List && data.isNotEmpty) {
          final lastItem = data.last;
          chatResponse = lastItem['body'];
          chatId = lastItem['id']?.toString();
        }
        if (chatResponse != null ) {
          final botMessage = types.TextMessage(
            author: _bot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
            text: chatResponse,
          );

          setState(() {
            messages = [botMessage, ...messages];
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          await incrementSentMessageCount();
          await saveMessagesToLocal();
          await HistoryStorage.addItem(HistoryItem(
            imagePath: widget.imagePath,
            userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
            chatResponse: chatResponse.isNotEmpty ? chatResponse : 'بدون پاسخ',
            chatId: chatId ?? '', time: '',
          ));
        }
      } else {
        var data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در ارسال پیام')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

bool isRtlText(String text) {
  // تشخیص متن فارسی/عربی بر اساس محدوده Unicode
  final rtlRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
  return rtlRegex.hasMatch(text);
}

  void showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('محدودیت پیام',style: TextStyle(fontFamily: 'Kalameh'),),
        content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.',style: TextStyle(fontFamily: 'Kalameh'),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('انصراف',style: TextStyle(color: Colors.black,fontFamily: 'Kalameh'),),
          ),
          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
            onPressed: () {
              Navigator.pop(context);
                showSubscriptionPlans();
             
            },
            child: Text('خرید اشتراک',style: TextStyle(color: Colors.black,fontFamily: 'Kalameh'),),
          ),
        ],
      ),
    );
  }
  
  Future<void> showSubscriptionPlans() async {
  final hasSubscription = await checkUserHasSubscription();
  if (hasSubscription) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('شما هم اکنون اشتراک فعال دارید')),
    );
    return;
  }

  final plans = await fetchSubscriptionPlans();
  if (plans.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('دریافت لیست اشتراک‌ها با خطا مواجه شد')),
    );
    return;
  }
     showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync:Scaffold.of(context) ,
    ),
    builder: (context) => GestureDetector(
      onTap: () {}, // جلوگیری از بسته شدن با کلیک روی محتوا
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF1F8E9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
              'برای استفاده از امکانات برنامه باید اشتراک تهیه بکنید ',   
                style: TextStyle( fontFamily: 'Kalameh',
                    fontSize: 14,
                    color: Colors.black,),
                            ),
              const SizedBox(height: 16),
              
              // Plans List
              ...plans.map((plan) => AnimatedPlanCard(
                plan: plan,
                onTap: () => initiatePurchaseAndPay(plan['id']),
              )).toList(),
              
              const SizedBox(height: 16),
                          ],
          ),
        ),
      ),
    ),
  );
}

//

Future<void> initiatePurchaseAndPay(int productId) async {
  try {
    final paymentUrl = await initiatePurchase(productId: productId);
    if (paymentUrl == null) throw 'خطا در دریافت درگاه پرداخت';

    final paymentSuccess = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentWebView(
          paymentUrl: paymentUrl,
          callbackUrlScheme: 'ielts',
        ),
      ),
    );

    if (paymentSuccess == true) {
      // تاخیر برای اطمینان از ثبت پرداخت در سرور
      await Future.delayed(Duration(seconds: 2));
      
      // بررسی مجدد وضعیت اشتراک
      final hasSubscription = await checkSubscriptionStatus();
      
      if (hasSubscription) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('اشتراک با موفقیت فعال شد!')),
        );
      } else {
        throw 'اشتراک فعال نشد. لطفاً چند دقیقه دیگر بررسی کنید';
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

void showRemainingMessagesDialog() {
  // محاسبه پیام‌های باقیمانده با مدیریت بهتر حالت‌ها
  final remainingMessageText = _hasActiveSubscription
      ? 'نامحدود'
      : maxFreeMessages > sentMessageCount
          ? '${maxFreeMessages - sentMessageCount} پیام باقیمانده'
          : 'پیام رایگان تمام شده';

  // استایل‌های مشترک
  const titleStyle = TextStyle(
    fontFamily: 'Kalameh',
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  const contentStyle = TextStyle(
    fontFamily: 'Kalameh',
    fontSize: 16,
    color: Colors.black87,
  );

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl, // جهت متن راست به چپ
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor:Color(0xFFF1F8E9),
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.workspace_premium, 
                  color: Colors.green, 
                  size: 28),
              const SizedBox(width: 8),
              const Text('اطلاعات اشتراک', style: titleStyle),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _hasActiveSubscription 
                  ? Icons.check_circle 
                  : maxFreeMessages > sentMessageCount 
                      ? Icons.info 
                      : Icons.error_outline,
              color: _hasActiveSubscription
                  ? Colors.green  
                  : maxFreeMessages > sentMessageCount
                      ? const Color.fromARGB(255, 5, 145, 77)
                      : Color.fromARGB(255, 3, 104, 55),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _hasActiveSubscription
                  ? 'شما اشتراک فعال دارید و می‌توانید بدون محدودیت پیام ارسال کنید'
                  : maxFreeMessages > sentMessageCount
                      ? 'تعداد پیام‌های رایگان باقیمانده: $remainingMessageText'
                      : 'پیام‌های رایگان شما تمام شده است\nبرای ادامه می‌توانید اشتراک تهیه کنید',
              textAlign: TextAlign.center,
              style: contentStyle,
            ),
            if (!_hasActiveSubscription) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                showSubscriptionPlans();
                },
                child: const Text(
                  'خرید اشتراک',
                  style: TextStyle(
                    fontFamily: 'Kalameh',
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'متوجه شدم',
              style: TextStyle(
                fontFamily: 'Kalameh',
                color: Color(0xFF2E7D32),
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
     _context = context;  // ذخیره context
       final hasParentNavigation = context.findAncestorWidgetOfExactType<Scaffold>()?.bottomNavigationBar != null;
  return WillPopScope(
    onWillPop: () async {
      // وقتی کاربر دکمه بازگشت را میزند، به صفحه اصلی برمی‌گردد
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OCRPdfApp()),
      );
      return false;
    },
      child: SafeArea(
        child: Scaffold(
          // drawer: Container(color: Colors.green,),
          // backgroundColor: Colors.green,
appBar: AppBar(
  backgroundColor: Color(0xFF2E7D32),
  automaticallyImplyLeading: false,
  // backgroundColor: const Color(0xFF2E7D32),
  // systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
  //   statusBarColor: const Color(0xFF2E7D32),
  // ),
  title: Container(
    width: double.infinity, // عرض کامل
    child: Stack(
      alignment: Alignment.center, // تراز وسط اصلی
      children: [
        // وضعیت اشتراک (سمت راست)
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _hasActiveSubscription 
                  ? Color.fromARGB(255, 37, 100, 40)
                  : const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _hasActiveSubscription ? 'اشتراک فعال' : 'بدون اشتراک',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Kalameh',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        
        // عنوان دقیقاً وسط
        const Text(
          "چت",
          style: TextStyle(
            fontFamily: 'Kalameh',
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        
        // آیکون اشتراک (سمت چپ)
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.workspace_premium, size: 24),
            color: Colors.white,
            onPressed: showRemainingMessagesDialog,
          ),
        ),
      ],
    ),
  ),
  elevation: 0,
  centerTitle: false,
   // غیرفعال کردن centerTitle پیشفرض
),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Chat(
                          
                          messages: messages,
                             // messages: messages.reversed.toList(),
                          onSendPressed: _handleSendPressed,
                          user: _user,
                          scrollController: _scrollController,
                          scrollPhysics: const BouncingScrollPhysics(),
                          theme: DefaultChatTheme(
                            
                            // fontFamily: 'Kalameh',
                            primaryColor: Colors.green.withOpacity(0.2),
                            secondaryColor: Colors.grey.withOpacity(0.2),
                            inputBackgroundColor: Colors.white,
                            inputTextColor: Colors.black,
                            inputTextDecoration: InputDecoration(
                              hintText: 'پیام خود را بنویسید...',
                              hintStyle: TextStyle(fontFamily: 'Kalameh',fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            backgroundColor: Color(0xFFF1F8E9),
                            receivedMessageBodyTextStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Kalameh',
                              fontSize: 14,
                            ),
                            sentMessageBodyTextStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Kalameh',
                              fontSize: 14,
                            ),
                            // receivedMessageBodyColor: Colors.grey.shade200,
                            // sentMessageBodyColor: Colors.green,
                            // borderRadius: 12,
                          ),
                          customBottomWidget: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: TextField(
                                    controller: messageController,
                                    textDirection: messageController.text.isNotEmpty 
                                        ? isRtlText(messageController.text) 
                                          ? TextDirection.rtl 
                                          : TextDirection.ltr
                                        : null,
                                    decoration: InputDecoration(
                                      hintText: 'پیام خود را بنویسید...',
                                      hintStyle: TextStyle(fontFamily: 'Kalameh', fontSize: 14),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      setState(() {}); // برای به روزرسانی جهت متن
                                    },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.document_scanner),
                                  color: Color(0xFF2E7D32),
                                  tooltip: 'ارسال متن از عکس یا PDF',
                                  onPressed: () async {
                                    final extractedText = await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(builder: (_) => OCRPdfApp()),
                                    );
                      
                      
                                      if (extractedText != null && extractedText.trim().isNotEmpty) {
                                      // messageController.text = extractedText;
                                       setState(() {
                                        messageController.text = extractedText;
                                         final ocrMessage = types.TextMessage(
                                          author: _user,
                                          createdAt: DateTime.now().millisecondsSinceEpoch,
                                          id: 'ocr_${DateTime.now().millisecondsSinceEpoch}',
                                          text: extractedText,
                                        );
                                        messages = [ocrMessage, ...messages];
                                      });
                                    }},),
                                  ElevatedButton(
                                   onPressed: loading
                                      ? null
                                      : () {
                                          sendMessage(text: messageController.text);
                                         },
                                   style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF2E7D32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: loading
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(Icons.send, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        
                  ],
                ),
                      if (_showScrollToBottomButton)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 90,right: 18),
                        // padding: EdgeInsets.all(80),
                        child: Align(
                          alignment: Alignment.bottomRight
                          ,
                          child: FloatingActionButton(
                            // mini: true,
                            backgroundColor: Color(0xFF2E7D32),
                            child: Icon(Icons.arrow_downward, color: Colors.white),
                            onPressed: _scrollToBottom,
                          ),
                        ),
                      ),
              ],
            ),
          ),
            // اینجا BottomNavigationBar را اضافه می‌کنیم
            bottomNavigationBar: hasParentNavigation ? null : _buildBottomNavigationBar(context),
        ),
      ), 
    );
  }
}
Widget _buildBottomNavigationBar(BuildContext context) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'خانه',
            isActive: false,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => OCRPdfApp()),
              );
            },
            primaryColor: Colors.green,
          ),
          _BottomNavItem(
            icon: Icons.history,
            activeIcon: Icons.history_rounded,
            label: 'تاریخچه',
            isActive: false,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HistoryPage()),
              );
            },
            primaryColor: Colors.green,
          ),
          _BottomNavItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_rounded,
            label: 'چت',
            isActive: true, // این صفحه فعلیه
            onTap: null,
            primaryColor: Colors.green,
          ),
        ],
      ),
    ),
  );
  
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final Color primaryColor;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? primaryColor.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? primaryColor : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Kalameh',
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? primaryColor : Colors.grey.shade600,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
   }
}