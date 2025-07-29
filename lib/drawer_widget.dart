// // import 'package:flutter/material.dart';
// // import 'package:sidebarx/sidebarx.dart';
// // import 'chat_list_page.dart';
// // import 'package:otpuivada/auth_service.dart';

// // class DrawerWidget extends StatelessWidget {
// //   final SidebarXController controller;
// //   final String fullName;

// //   const DrawerWidget({
// //     Key? key,
// //     required this.controller,
// //     required this.fullName,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return SidebarX(
// //       controller: controller,
// //       theme: SidebarXTheme(
// //         width: 300, // ✅ عرض Drawer
// //         margin: const EdgeInsets.all(10),
// //         decoration: BoxDecoration(
// //           color: Colors.green.shade700,
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         hoverColor: Colors.green.shade400,
// //         textStyle: const TextStyle(
// //           fontFamily: 'Vazir',
// //           color: Colors.white,
// //         ),
// //         selectedTextStyle: const TextStyle(
// //           fontFamily: 'Vazir',
// //           color: Colors.black,
// //         ),
// //         selectedItemDecoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         selectedIconTheme: const IconThemeData(color: Colors.black),
// //       ),
// //       extendedTheme: const SidebarXTheme(
// //         width: 300, // ✅ عرض در حالت باز شده
// //       ),
// //       headerBuilder: (context, extended) {
// //         return Padding(
// //           padding: const EdgeInsets.all(24),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 30),
// //               const Icon(Icons.account_circle, size: 60, color: Colors.white),
// //               const SizedBox(height: 16),
// //               const Text(
// //                 'خوش آمدید',
// //                 style: TextStyle(
// //                   fontFamily: 'Vazir',
// //                   fontSize: 18,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               Text(
// //                 fullName,
// //                 style: const TextStyle(
// //                   fontFamily: 'Vazir',
// //                   fontSize: 16,
// //                   color: Colors.white70,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //       items: [
// //         SidebarXItem(
// //           icon: Icons.chat,
// //           label: 'چت',
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (_) => const ChatListPage(imagePath: ''),
// //               ),
// //             );
// //           },
// //         ),
// //         SidebarXItem(
// //           icon: Icons.logout,
// //           label: 'خروج',
// //           onTap: () async {
// //             await AuthService.clearToken();
// //             Navigator.pushNamedAndRemoveUntil(
// //               context,
// //               '/login',
// //               (route) => false,
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }













// import 'package:flutter/material.dart';
// import 'package:sidebarx/sidebarx.dart';
// import 'chat_list_page.dart';
// import 'auth_service.dart';

// class MobileHomePage extends StatefulWidget {
//   final String fullName;

//   const MobileHomePage({Key? key, required this.fullName}) : super(key: key);

//   @override
//   State<MobileHomePage> createState() => _MobileHomePageState();
// }

// class _MobileHomePageState extends State<MobileHomePage> {
//   final SidebarXController _controller =
//       SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('صفحه اصلی', style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green.shade700,
//       ),

//       /// 🌟 Drawer شیک برای موبایل
      
//       drawer: Drawer(
//         backgroundColor: Colors.transparent,
//         child: SafeArea(
//           child: ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topRight: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//             child: SidebarX(
//               controller: _controller,
//               theme: SidebarXTheme(
//                 width: 280,
//                 margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade800,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(3, 5),
//                     )
//                   ],
//                 ),
//                 hoverColor: Colors.green.shade500,
//                 textStyle: const TextStyle(
//                     fontFamily: 'Vazir', color: Colors.white, fontSize: 15),
//                 selectedTextStyle: const TextStyle(
//                     fontFamily: 'Vazir', color: Colors.black, fontSize: 16),
//                 selectedItemDecoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 iconTheme: const IconThemeData(color: Colors.white),
//                 selectedIconTheme: const IconThemeData(color: Colors.black),
//               ),
//               headerBuilder: (context, extended) {
//                 return Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.green.shade600,
//                         Colors.green.shade900,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CircleAvatar(
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.person, size: 40, color: Colors.green),
//                       ),
//                       const SizedBox(height: 12),
//                       const Text(
//                         'خوش آمدید',
//                         style: TextStyle(
//                             fontFamily: 'Vazir',
//                             fontSize: 16,
//                             color: Colors.white),
//                       ),
//                       Text(
//                         widget.fullName,
//                         style: const TextStyle(
//                             fontFamily: 'Vazir',
//                             fontSize: 14,
//                             color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               items: [
//                 SidebarXItem(
//                   icon: Icons.chat,
//                   label: 'چت',
//                   onTap: () {
//                     Navigator.pop(context); // بستن دراور
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const ChatListPage(imagePath: '')),
//                     );
//                   },
//                 ),
//                 SidebarXItem(
//                   icon: Icons.logout,
//                   label: 'خروج',
//                   onTap: () async {
//                     Navigator.pop(context); // بستن دراور
//                     await AuthService.clearToken();
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, '/login', (route) => false);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),

//       /// محتوای اصلی
//       body: Center(
//         child: Text(
//           'به اپلیکیشن خوش آمدید!',
//           style: TextStyle(fontSize: 22, fontFamily: 'Vazir'),
//         ),
//       ),
//     );
//   }
// }

























////////////////////////////for chat\
// //نهایی 
// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// import 'package:otpuivada/storage_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatListPage extends StatefulWidget {
//   final String? initialMessage;
//   final String imagePath;

//   const ChatListPage({
//     Key? key,
//     this.initialMessage,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];
//   bool loading = false;
//   int sentMessageCount = 0;
//   final int maxFreeMessages = 45;
//   bool _showScrollToBottomButton = false; // حالت نمایش دکمه

//   // تابع اسکرول به پایین
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//     @override
//   void dispose() {
//     _scrollController.removeListener(_handleScrollPosition);
//     _scrollController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkLoginAndFetch();
//     loadSentMessageCount();
//     loadMessagesFromLocal();

//     // اضافه کردن لیسنر برای تشخیص موقعیت اسکرول
//     _scrollController.addListener(_handleScrollPosition);

//     if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//       final text = widget.initialMessage!.trim();
//       messageController.text = text;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         sendMessage(text: text);
//       });
//     }
//   }
//     // تابع جدید برای مدیریت نمایش دکمه
//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final maxScroll = _scrollController.position.maxScrollExtent;
//       final currentScroll = _scrollController.position.pixels;
      
//       setState(() {
//         _showScrollToBottomButton = currentScroll < maxScroll - 100;
//       });
//     }
//   }
  
//   Future<void> loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> incrementSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     sentMessageCount++;
//     await prefs.setInt('sentMessageCount', sentMessageCount);
//   }

//   Future<void> saveMessagesToLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = messages.map((m) => jsonEncode(m)).toList();
//     await prefs.setStringList('chatMessages', jsonList);
//   }

//   Future<void> loadMessagesFromLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('chatMessages');
//     if (jsonList != null) {
//       setState(() {
//         messages = jsonList.map((m) => jsonDecode(m) as Map<String, dynamic>).toList();
//       });
//       // اسکرول خودکار پس از بارگذاری پیام‌ها
//       WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//   }

//   String cleanOcrText(String text) {
//     return text
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('rd ike', "I'd like")
//         .replaceAll('neighbours.', 'neighbours?')
//         .replaceAll('questions.', 'questions?')
//         .replaceAll('ask each other', 'ask each other questions')
//         .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
//         .replaceAll('Can didate', 'Candidate')
//         .trim();
//   }

//   String buildPrompt(String rawText) {
//     return '''
// You are taking the IELTS Life Skills A1 Speaking and Listening test.

// Below are questions from Phase 1a and Phase 1b of the exam.
// Please respond to all of them as if you are a candidate in the test.
// Keep your answers simple, realistic, and appropriate for A1 level English.

// Questions:
// $rawText

// Start answering now.
// ''';
//   }

//   Future<void> sendMessage({required String text}) async {
//     final messageText = text.trim();
//     if (messageText.isEmpty) return;

//     if (sentMessageCount >= maxFreeMessages) {
//       showUpgradeDialog();
//       return;
//     }

//     setState(() => loading = true);

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = cleanOcrText(messageText);
//     final prompt = buildPrompt(cleaned);

//     try {
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'package_name': 'com.vada.drive',
//         },
//         body: jsonEncode({
//           'body': prompt,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         Map<String, dynamic>? chatData;

//         setState(() {
//           if (data is Map && data.containsKey('body')) {
//             chatData = Map<String, dynamic>.from(data);
//             messages.add(chatData!);
//           } else if (data is List && data.isNotEmpty) {
//             messages.addAll(List<Map<String, dynamic>>.from(data));
//             chatData = messages.last;
//           }
//         });

//         // اسکرول خودکار پس از اضافه کردن پیام جدید
//         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//         await incrementSentMessageCount();
//         await saveMessagesToLocal();

//         if (chatData != null) {
//           final userMessage = cleaned;
//           final chatResponse = chatData?['body'] ?? '';
//           final chatId = chatData?['id'].toString() ?? '';

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: userMessage.isNotEmpty ? userMessage : 'پیامی وارد نشده',
//             chatResponse: chatResponse.isNotEmpty ? chatResponse : 'بدون پاسخ',
//             chatId: chatId,
//           ));
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('محدودیت پیام'),
//         content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('انصراف'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/subscription');
//             },
//             child: Text('خرید اشتراک'),
//           ),
//         ],
//       ),
//     );
//   }

//   void showRemainingMessagesDialog() {
//     final remaining = maxFreeMessages - sentMessageCount;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('اطلاعات اشتراک'),
//         content: Text(
//           remaining > 0
//               ? 'شما $remaining پیام رایگان دیگر دارید.'
//               : 'پیام‌های رایگان شما تمام شده است.',
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('باشه'),
//           ),
//         ],
//       ),
//     );
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.workspace_premium),
//             tooltip: 'اطلاعات اشتراک',
//             onPressed: showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: loading
//                     ? Center(child: LoadingAnimationWidget.staggeredDotsWave(
//                       color: Colors.green,
//                       size: 60,
//                     ),)
//                     : messages.isEmpty
//                         ? Center(child: Text('هیچ پیامی وجود ندارد', style: TextStyle(fontFamily: 'Vazir')))
//                         : ListView.builder(
//                             controller: _scrollController,
//                             itemCount: messages.length,
//                             itemBuilder: (_, index) {
//                               var item = messages[index];
//                               final body = (item['body'] ?? '').trim();
//                               if (body.isEmpty) return SizedBox.shrink();
//                               final isMine = item['from'] == 0;

//                               return Align(
//                                 alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//                                 child: Container(
//                                   constraints: BoxConstraints(
//                                       maxWidth: MediaQuery.of(context).size.width * 0.75),
//                                   margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//                                   padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                                   decoration: BoxDecoration(
//                                     color: isMine ? Colors.green.shade600 : Colors.green.shade100,
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(16),
//                                       topRight: Radius.circular(16),
//                                       bottomLeft: isMine ? Radius.circular(16) : Radius.zero,
//                                       bottomRight: isMine ? Radius.zero : Radius.circular(16),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     item['body'] ?? '',
//                                     style: TextStyle(
//                                       fontFamily: 'Vazir',
//                                       fontSize: 16,
//                                       color: isMine ? Colors.white : Colors.green.shade900,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         expands: false,
//                         textInputAction: TextInputAction.newline,
//                         maxLines: 1,
//                         minLines: 1,
//                         controller: messageController,
//                         decoration: InputDecoration(
//                           hintText: 'پیام خود را بنویسید...',
//                           hintStyle: TextStyle(fontFamily: 'Vazir'),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8),
//                     IconButton(
//                       icon: Icon(Icons.document_scanner),
//                       color: Colors.green,
//                       tooltip: 'ارسال متن از عکس یا PDF',
//                       onPressed: () async {
//                         final extractedText = await Navigator.push<String>(
//                           context,
//                           MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                         );

//                         if (extractedText != null && extractedText.trim().isNotEmpty) {
//                           messageController.text = extractedText;
//                         }
//                       },
//                     ),
//                     ElevatedButton(
//                       onPressed: loading
//                           ? null
//                           : () {
//                               sendMessage(text: messageController.text);
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: loading
//                           ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Icon(Icons.send, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // دکمه اسکرول به پایین
//           if (_showScrollToBottomButton)
//             Positioned(
//               bottom: 80, // بالاتر از فیلد ورودی متن
//               right: 20,
//               child: FloatingActionButton(
//                 mini: true,
//                 backgroundColor: Colors.green,
//                 child: Icon(Icons.arrow_downward, color: Colors.white),
//                 onPressed: _scrollToBottom,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }









// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// import 'package:otpuivada/storage_helper.dart';

// class ChatListPage extends StatefulWidget {
//   final String? initialMessage;
//   final String imagePath;

//   const ChatListPage({Key? key, this.initialMessage, required this.imagePath}) : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   List<types.Message> _messages = [];
//   final types.User _user = types.User(id: 'user');
//   bool _loading = false;
//   int _sentMessageCount = 0;
//   final int _maxFreeMessages = 45;

//   @override
//   void initState() {
//     super.initState();
//     checkLoginAndFetch();
//     _loadSentMessageCount();
//     _loadMessagesFromLocal();

//     if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//       final text = widget.initialMessage!.trim();
//       _handleSendPressed(types.PartialText(text: text));
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//   }

//   Future<void> _loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> _incrementSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     _sentMessageCount++;
//     await prefs.setInt('sentMessageCount', _sentMessageCount);
//   }

//   Future<void> _saveMessagesToLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = _messages.map((m) => jsonEncode(m.toJson())).toList();
//     await prefs.setStringList('chatMessages', jsonList);
//   }

//   Future<void> _loadMessagesFromLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('chatMessages');
//     if (jsonList != null) {
// setState(() {
//   _messages = jsonList
//     .map((m) {
//       final decoded = jsonDecode(m);
//       if (decoded is Map<String, dynamic>) {
//         return types.TextMessage.fromJson(decoded);
//       } else {
//         return null; // اگر داده معتبر نیست، null برگردان
//       }
//     })
//     .where((msg) => msg != null)  // nullها رو حذف کن
//     .cast<types.TextMessage>()    // به نوع مناسب تبدیل کن
//     .toList();
// });

//     }
//   }

//   void _showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('محدودیت پیام'),
//         content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('انصراف'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/subscription');
//             },
//             child: Text('خرید اشتراک'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRemainingMessagesDialog() {
//     final remaining = _maxFreeMessages - _sentMessageCount;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('اطلاعات اشتراک'),
//         content: Text(remaining > 0
//             ? 'شما $remaining پیام رایگان دیگر دارید.'
//             : 'پیام‌های رایگان شما تمام شده است.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('باشه'),
//           ),
//         ],
//       ),
//     );
//   }

//   String cleanOcrText(String text) {
//     return text
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('rd ike', "I'd like")
//         .replaceAll('neighbours.', 'neighbours?')
//         .replaceAll('questions.', 'questions?')
//         .replaceAll('ask each other', 'ask each other questions')
//         .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
//         .replaceAll('Can didate', 'Candidate')
//         .trim();
//   }

//   String buildPrompt(String rawText) {
//     return '''
// You are taking the IELTS Life Skills A1 Speaking and Listening test.

// Below are questions from Phase 1a and Phase 1b of the exam.
// Please respond to all of them as if you are a candidate in the test.
// Keep your answers simple, realistic, and appropriate for A1 level English.

// Questions:
// $rawText

// Start answering now.
// ''';
//   }

//   Future<void> _handleSendPressed(types.PartialText message) async {
//     if (_sentMessageCount >= _maxFreeMessages) {
//       _showUpgradeDialog();
//       return;
//     }

//     final text = message.text.trim();
//     if (text.isEmpty) return;

//     final userMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: text,
//     );

//     setState(() {
//       _messages.insert(0, userMessage);
//       _loading = true;
//     });

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final cleaned = cleanOcrText(text);
//     final prompt = buildPrompt(cleaned);

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'body': prompt,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         String responseBody = '';

//         if (data is Map && data.containsKey('body')) {
//           responseBody = data['body'] ?? '';
//         } else if (data is List && data.isNotEmpty) {
//           responseBody = data.last['body'] ?? '';
//         }

//         final botMessage = types.TextMessage(
//           author: types.User(id: 'bot'),
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           text: responseBody,
//         );

//         setState(() {
//           _messages.insert(0, botMessage);
//         });

//         await _incrementSentMessageCount();
//         await _saveMessagesToLocal();

//         await HistoryStorage.addItem(HistoryItem(
//           imagePath: widget.imagePath,
//           userMessage: cleaned,
//           chatResponse: responseBody,
//           chatId: data['id'].toString(),
//         ));
//       }
//     } catch (e) {
//       print('Send error: $e');
//     } finally {
//       setState(() => _loading = false);
//     }
//   }
//     Widget _buildCustomInput() {
//     final controller = TextEditingController();

//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, -1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.document_scanner),
//             tooltip: 'OCR',
//             onPressed: () async {
//               final extractedText = await Navigator.push<String>(
//                 context,
//                 MaterialPageRoute(builder: (_) => OCRPdfApp()),
//               );

//               if (extractedText != null && extractedText.trim().isNotEmpty) {
//                 controller.text = extractedText;
//               }
//             },
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: 'پیام خود را بنویسید...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           ElevatedButton(
//             onPressed: _loading
//                 ? null
//                 : () {
//                     _handleSendPressed(types.PartialText(text: controller.text));
//                     controller.clear();
//                   },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Icon(Icons.send, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('چت', style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.workspace_premium),
//             tooltip: 'اطلاعات اشتراک',
//             onPressed: _showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Chat(
//             messages: _messages,
//             onSendPressed: _handleSendPressed,
//             user: _user,
//             showUserAvatars: true,
//             showUserNames: true,
//             l10n: ChatL10nFa(), // ترجمه فارسی
//              customBottomWidget: _buildCustomInput(),
//             // inputOptions: InputOptions(
//             //   inputToolbarPadding: EdgeInsets.symmetric(horizontal: 8),
//             //   leading: [
//             //     IconButton(
//             //       icon: Icon(Icons.document_scanner),
//             //       tooltip: 'OCR',
//             //       onPressed: () async {
//             //         final extractedText = await Navigator.push<String>(
//             //           context,
//             //           MaterialPageRoute(builder: (_) => OCRPdfApp()),
//             //         );

//             //         if (extractedText != null && extractedText.trim().isNotEmpty) {
//             //           _handleSendPressed(types.PartialText(text: extractedText));
//             //         }
//             //       },
//             //     )
//             //   ],
//             // ),
//           ),
//           if (_loading)
//             Positioned.fill(
//               child: Center(
//                 child: CircularProgressIndicator(color: Colors.green),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }


// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// import 'package:otpuivada/storage_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatListPage extends StatefulWidget {
//   final String? initialMessage;
//   final String imagePath;

//   const ChatListPage({
//     Key? key,
//     this.initialMessage,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController messageController = TextEditingController();
//   List<types.Message> messages = [];
//   bool loading = false;
//   int sentMessageCount = 0;
//   final int maxFreeMessages = 45;
//   bool _showScrollToBottomButton = false;
//   final types.User _user = const types.User(id: 'user');
//   final types.User _bot = const types.User(id: 'bot');

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_handleScrollPosition);
//     _scrollController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkLoginAndFetch();
//     loadSentMessageCount();
//     loadMessagesFromLocal();

//     _scrollController.addListener(_handleScrollPosition);

//     if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//       final text = widget.initialMessage!.trim();
//       messageController.text = text;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         sendMessage(text: text);
//       });
//     }
//   }

//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final maxScroll = _scrollController.position.maxScrollExtent;
//       final currentScroll = _scrollController.position.pixels;
      
//       setState(() {
//         _showScrollToBottomButton = currentScroll < maxScroll - 100;
//       });
//     }
//   }
  
//   Future<void> loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> incrementSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     sentMessageCount++;
//     await prefs.setInt('sentMessageCount', sentMessageCount);
//   }

//   Future<void> saveMessagesToLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
//     await prefs.setStringList('chatMessages', jsonList);
//   }

//   Future<void> loadMessagesFromLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('chatMessages');
//     if (jsonList != null) {
//       setState(() {
//         messages = jsonList.map((m) => types.Message.fromJson(jsonDecode(m))).toList();
//       });
//       WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//   }

//   String cleanOcrText(String text) {
//     return text
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('rd ike', "I'd like")
//         .replaceAll('neighbours.', 'neighbours?')
//         .replaceAll('questions.', 'questions?')
//         .replaceAll('ask each other', 'ask each other questions')
//         .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
//         .replaceAll('Can didate', 'Candidate')
//         .trim();
//   }

//   String buildPrompt(String rawText) {
//     return '''
// You are taking the IELTS Life Skills A1 Speaking and Listening test.

// Below are questions from Phase 1a and Phase 1b of the exam.
// Please respond to all of them as if you are a candidate in the test.
// Keep your answers simple, realistic, and appropriate for A1 level English.

// Questions:
// $rawText

// Start answering now.
// ''';
//   }

//   Future<void> sendMessage({required String text}) async {
//     final messageText = text.trim();
//     if (messageText.isEmpty) return;

//     if (sentMessageCount >= maxFreeMessages) {
//       showUpgradeDialog();
//       return;
//     }

//     setState(() => loading = true);

//     // Add user message first
//     final userMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: DateTime.now().toString(),
//       text: messageText,
//     );

//     setState(() {
//       messages = [...messages, userMessage];
//     });
//     _scrollToBottom();

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = cleanOcrText(messageText);
//     final prompt = buildPrompt(cleaned);

//     try {
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'package_name': 'com.vada.drive',
//         },
//         body: jsonEncode({
//           'body': prompt,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         String? chatResponse;
//         String? chatId;

//         if (data is Map && data.containsKey('body')) {
//           chatResponse = data['body'];
//           chatId = data['id']?.toString();
//         } else if (data is List && data.isNotEmpty) {
//           final lastItem = data.last;
//           chatResponse = lastItem['body'];
//           chatId = lastItem['id']?.toString();
//         }

//         if (chatResponse != null) {
//           final botMessage = types.TextMessage(
//             author: _bot,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: DateTime.now().toString(),
//             text: chatResponse,
//           );

//           setState(() {
//             messages = [...messages, botMessage];
//           });
//           _scrollToBottom();

//           await incrementSentMessageCount();
//           await saveMessagesToLocal();

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
//             chatResponse: chatResponse.isNotEmpty ? chatResponse : 'بدون پاسخ',
//             chatId: chatId ?? '',
//           ));
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('محدودیت پیام'),
//         content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('انصراف'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/subscription');
//             },
//             child: Text('خرید اشتراک'),
//           ),
//         ],
//       ),
//     );
//   }

//   void showRemainingMessagesDialog() {
//     final remaining = maxFreeMessages - sentMessageCount;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('اطلاعات اشتراک'),
//         content: Text(
//           remaining > 0
//               ? 'شما $remaining پیام رایگان دیگر دارید.'
//               : 'پیام‌های رایگان شما تمام شده است.',
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('باشه'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleSendPressed(types.PartialText message) {
//     sendMessage(text: message.text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.workspace_premium),
//             tooltip: 'اطلاعات اشتراک',
//             onPressed: showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(

//             child: Directionality(
//               textDirection: TextDirection.ltr,
//               child: Chat(
//                 messages: messages,
//                 onSendPressed: _handleSendPressed,
//                 user: _user,
//                 theme: DefaultChatTheme(
//                   primaryColor: Colors.green,
//                   secondaryColor: Colors.green.shade100,
//                   inputBackgroundColor: Colors.white,
//                   inputTextColor: Colors.black,
//                   inputTextDecoration: InputDecoration(
//                     hintText: 'پیام خود را بنویسید...',
//                     hintStyle: TextStyle(fontFamily: 'Vazir'),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                 ),
//                 customBottomWidget: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: messageController,
//                           decoration: InputDecoration(
//                             hintText: 'پیام خود را بنویسید...',
//                             hintStyle: TextStyle(fontFamily: 'Vazir'),
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       IconButton(
//                         icon: Icon(Icons.document_scanner),
//                         color: Colors.green,
//                         tooltip: 'ارسال متن از عکس یا PDF',
//                         onPressed: () async {
//                           final extractedText = await Navigator.push<String>(
//                             context,
//                             MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                           );
              
//                           if (extractedText != null && extractedText.trim().isNotEmpty) {
//                             messageController.text = extractedText;
//                           }
//                         },
//                       ),
//                       ElevatedButton(
//                         onPressed: loading
//                             ? null
//                             : () {
//                                 sendMessage(text: messageController.text);
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: loading
//                             ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Icon(Icons.send, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
                
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }











// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// import 'package:otpuivada/storage_helper.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatListPage extends StatefulWidget {
//   final String? initialMessage;
//   final String imagePath;

//   const ChatListPage({
//     Key? key,
//     this.initialMessage,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   late final AutoScrollController _scrollController;
//   // final ScrollController _scrollController = ScrollController();
//   final TextEditingController messageController = TextEditingController();
//   List<types.Message> messages = [];
//   bool loading = false;
//   int sentMessageCount = 0;
//   final int maxFreeMessages = 45;
//   bool _showScrollToBottomButton = false;
//   final types.User _user = const types.User(id: 'user');
//   final types.User _bot = const types.User(id: 'bot');

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && messages.isNotEmpty) {
//       _scrollController.scrollToIndex(
//         0, // اسکرول به اولین آیتم (پایین لیست)
//         duration: const Duration(milliseconds: 300),
//         preferPosition: AutoScrollPosition.begin,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_handleScrollPosition);
//     _scrollController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//      _scrollController = AutoScrollController();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await migrateOldMessages();
//       checkLoginAndFetch();
//       loadSentMessageCount();
//       loadMessagesFromLocal();
//     });

//     if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//       final text = widget.initialMessage!.trim();
//       messageController.text = text;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         sendMessage(text: text);
//       });
//     }
//   }

//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final minScroll = _scrollController.position.minScrollExtent;
//       final currentScroll = _scrollController.position.pixels;
      
//       setState(() {
//         _showScrollToBottomButton = currentScroll > minScroll + 100;
//       });
//     }
//   }

//   Future<void> migrateOldMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final oldMessages = prefs.getStringList('chatMessages');
    
//     if (oldMessages != null) {
//       final newMessages = <types.Message>[];
      
//       for (final oldMessage in oldMessages) {
//         try {
//           final json = jsonDecode(oldMessage);
//           if (json is Map<String, dynamic>) {
//             final isMine = json['from'] == 0;
//             newMessages.add(types.TextMessage(
//               author: isMine ? _user : _bot,
//               createdAt: DateTime.now().millisecondsSinceEpoch,
//               id: json['id']?.toString() ?? DateTime.now().toString(),
//               text: json['body']?.toString() ?? '',
//             ));
//           }
//         } catch (e) {
//           print('Error migrating message: $e');
//         }
//       }
      
//       await prefs.remove('chatMessages');
//       if (newMessages.isNotEmpty) {
//         await prefs.setStringList('chatMessages', 
//           newMessages.map((m) => jsonEncode(m.toJson())).toList());
//       }
//     }
//   }
  
//   Future<void> loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> incrementSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     sentMessageCount++;
//     await prefs.setInt('sentMessageCount', sentMessageCount);
//   }

//   Future<void> saveMessagesToLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
//     await prefs.setStringList('chatMessages', jsonList);
//   }

//   Future<void> loadMessagesFromLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('chatMessages');
    
//     if (jsonList != null) {
//       try {
//         final loadedMessages = jsonList.map((jsonString) {
//           final json = jsonDecode(jsonString);
//           if (json is! Map<String, dynamic>) {
//             throw FormatException('Invalid message format');
//           }
//           return types.Message.fromJson(json);
//         }).toList();
        
//         setState(() {
//           messages = loadedMessages;
//         });
        
//         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//       } catch (e) {
//         print('Error loading messages: $e');
//         await prefs.remove('chatMessages');
//       }
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//   }

//   String cleanOcrText(String text) {
//     return text
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('rd ike', "I'd like")
//         .replaceAll('neighbours.', 'neighbours?')
//         .replaceAll('questions.', 'questions?')
//         .replaceAll('ask each other', 'ask each other questions')
//         .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
//         .replaceAll('Can didate', 'Candidate')
//         .trim();
//   }

//   String buildPrompt(String rawText) {
//     return '''
// You are taking the IELTS Life Skills A1 Speaking and Listening test.

// Below are questions from Phase 1a and Phase 1b of the exam.
// Please respond to all of them as if you are a candidate in the test.
// Keep your answers simple, realistic, and appropriate for A1 level English.

// Questions:
// $rawText

// Start answering now.
// ''';
//   }

//   void _handleSendPressed(types.PartialText message) {
//     sendMessage(text: message.text);
//   }

//   Future<void> sendMessage({required String text}) async {
//     final messageText = text.trim();
//     if (messageText.isEmpty) return;

//     if (sentMessageCount >= maxFreeMessages) {
//       showUpgradeDialog();
//       return;
//     }

//     setState(() => loading = true);

//     // اضافه کردن پیام کاربر با اسکرول خودکار
//     final userMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//       text: messageText,
//     );

//     setState(() {
//       messages = [...messages, userMessage];
//     });
    
//     _scrollToBottom();

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = cleanOcrText(messageText);
//     final prompt = buildPrompt(cleaned);

//     try {
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'package_name': 'com.vada.drive',
//         },
//         body: jsonEncode({
//           'body': prompt,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         String? chatResponse;
//         String? chatId;

//         if (data is Map && data.containsKey('body')) {
//           chatResponse = data['body'];
//           chatId = data['id']?.toString();
//         } else if (data is List && data.isNotEmpty) {
//           final lastItem = data.last;
//           chatResponse = lastItem['body'];
//           chatId = lastItem['id']?.toString();
//         }

//         if (chatResponse != null) {
//           final botMessage = types.TextMessage(
//             author: _bot,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
//             text: chatResponse,
//           );

//           setState(() {
//             messages = [...messages, botMessage];
//           });
          
//           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//           await incrementSentMessageCount();
//           await saveMessagesToLocal();

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
//             chatResponse: chatResponse.isNotEmpty ? chatResponse : 'بدون پاسخ',
//             chatId: chatId ?? '',
//           ));
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('محدودیت پیام'),
//         content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('انصراف'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/subscription');
//             },
//             child: Text('خرید اشتراک'),
//           ),
//         ],
//       ),
//     );
//   }

//   void showRemainingMessagesDialog() {
//     final remaining = maxFreeMessages - sentMessageCount;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('اطلاعات اشتراک'),
//         content: Text(
//           remaining > 0
//               ? 'شما $remaining پیام رایگان دیگر دارید.'
//               : 'پیام‌های رایگان شما تمام شده است.',
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('باشه'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.workspace_premium),
//             tooltip: 'اطلاعات اشتراک',
//             onPressed: showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Chat(
//                 messages: messages,
//                 onSendPressed: _handleSendPressed,
//                 user: _user,
//                 scrollController: _scrollController,
//                 scrollPhysics: const BouncingScrollPhysics(),
//                 theme: DefaultChatTheme(
//                   primaryColor: Colors.green,
//                   secondaryColor: Colors.green.shade100,
//                   inputBackgroundColor: Colors.white,
//                   inputTextColor: Colors.black,
//                   inputTextDecoration: InputDecoration(
//                     hintText: 'پیام خود را بنویسید...',
//                     hintStyle: TextStyle(fontFamily: 'Vazir'),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                 ),
//                 customBottomWidget: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: messageController,
//                           decoration: InputDecoration(
//                             hintText: 'پیام خود را بنویسید...',
//                             hintStyle: TextStyle(fontFamily: 'Vazir'),
//                             filled: true,
//                             fillColor: Colors.white,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8),
//                       IconButton(
//                         icon: Icon(Icons.document_scanner),
//                         color: Colors.green,
//                         tooltip: 'ارسال متن از عکس یا PDF',
//                         onPressed: () async {
//                           final extractedText = await Navigator.push<String>(
//                             context,
//                             MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                           );

//                           if (extractedText != null && extractedText.trim().isNotEmpty) {
//                             messageController.text = extractedText;
//                           }
//                         },
//                       ),
//                       ElevatedButton(
//                         onPressed: loading
//                             ? null
//                             : () {
//                                 sendMessage(text: messageController.text);
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: loading
//                             ? SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Icon(Icons.send, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // دکمه اسکرول به پایین برای پیام‌های قدیمی
//           if (_showScrollToBottomButton)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 80),
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: FloatingActionButton(
//                   mini: true,
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.arrow_downward, color: Colors.white),
//                   onPressed: _scrollToBottom,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:http/http.dart' as http;
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// import 'package:otpuivada/storage_helper.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';

// class ChatListPage extends StatefulWidget {
//   final String? initialMessage;
//   final String imagePath;

//   const ChatListPage({
//     Key? key,
//     this.initialMessage,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   late final AutoScrollController _scrollController;
//   final TextEditingController messageController = TextEditingController();
//   List<types.Message> messages = [];
//   bool loading = false;
//   int sentMessageCount = 0;
//   final int maxFreeMessages = 45;
//   bool _showScrollToBottomButton = false;
//   final types.User _user = const types.User(id: 'user');
//   final types.User _bot = const types.User(id: 'bot');

//   @override
//   void initState() {
//     _scrollController = AutoScrollController();
//     super.initState();
//     _scrollController.addListener(_handleScrollPosition);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await migrateOldMessages();
//       checkLoginAndFetch();
//       loadSentMessageCount();
//       loadMessagesFromLocal();
//     });

//     if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//       final text = widget.initialMessage!.trim();
//       messageController.text = text;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         sendMessage(text: text);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && messages.isNotEmpty) {
//       _scrollController.scrollToIndex(
//         0,
//         duration: const Duration(milliseconds: 300),
//         preferPosition: AutoScrollPosition.begin,
//       );
//     }
//   }

//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final position = _scrollController.position;
//       setState(() {
//         _showScrollToBottomButton = position.pixels > position.minScrollExtent + 100;
//       });
//     }
//   }

//   Future<void> migrateOldMessages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final oldMessages = prefs.getStringList('chatMessages');
    
//     if (oldMessages != null) {
//       final newMessages = <types.Message>[];
      
//       for (final oldMessage in oldMessages) {
//         try {
//           final json = jsonDecode(oldMessage);
//           if (json is Map<String, dynamic>) {
//             final isMine = json['from'] == 0;
//             newMessages.add(types.TextMessage(
//               author: isMine ? _user : _bot,
//               createdAt: DateTime.now().millisecondsSinceEpoch,
//               id: json['id']?.toString() ?? DateTime.now().toString(),
//               text: json['body']?.toString() ?? '',
//             ));
//           }
//         } catch (e) {
//           print('Error migrating message: $e');
//         }
//       }
      
//       await prefs.remove('chatMessages');
//       if (newMessages.isNotEmpty) {
//         await prefs.setStringList('chatMessages', 
//           newMessages.map((m) => jsonEncode(m.toJson())).toList());
//       }
//     }
//   }

//   Future<void> loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> incrementSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     sentMessageCount++;
//     await prefs.setInt('sentMessageCount', sentMessageCount);
//   }

//   Future<void> saveMessagesToLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
//     await prefs.setStringList('chatMessages', jsonList);
//   }

//   Future<void> loadMessagesFromLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('chatMessages');
    
//     if (jsonList != null) {
//       try {
//         final loadedMessages = jsonList.map((jsonString) {
//           final json = jsonDecode(jsonString);
//           if (json is! Map<String, dynamic>) {
//             throw FormatException('Invalid message format');
//           }
//           return types.Message.fromJson(json);
//         }).toList();
        
//         setState(() {
//           messages = loadedMessages;
//         });
        
//         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//       } catch (e) {
//         print('Error loading messages: $e');
//         await prefs.remove('chatMessages');
//       }
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }
//   }

//   String cleanOcrText(String text) {
//     return text
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .replaceAll('rd ike', "I'd like")
//         .replaceAll('neighbours.', 'neighbours?')
//         .replaceAll('questions.', 'questions?')
//         .replaceAll('ask each other', 'ask each other questions')
//         .replaceAll('Wth draw eye contact', 'Withdraw eye contact')
//         .replaceAll('Can didate', 'Candidate')
//         .trim();
//   }

//   String buildPrompt(String rawText) {
//     return '''
// You are taking the IELTS Life Skills A1 Speaking and Listening test.

// Below are questions from Phase 1a and Phase 1b of the exam.
// Please respond to all of them as if you are a candidate in the test.
// Keep your answers simple, realistic, and appropriate for A1 level English.

// Questions:
// $rawText

// Start answering now.
// ''';
//   }

//   void _handleSendPressed(types.PartialText message) {
//     sendMessage(text: message.text);
//   }

//   Future<void> sendMessage({required String text}) async {
//     final messageText = text.trim();
//     if (messageText.isEmpty) return;

//     if (sentMessageCount >= maxFreeMessages) {
//       showUpgradeDialog();
//       return;
//     }

//     setState(() => loading = true);

//     final userMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//       text: messageText,
//     );

//     setState(() {
//       messages = [userMessage, ...messages]; // اضافه کردن پیام جدید به ابتدای لیست
//     });
    
//     _scrollToBottom();

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = cleanOcrText(messageText);
//     final prompt = buildPrompt(cleaned);

//     try {
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'package_name': 'com.vada.drive',
//         },
//         body: jsonEncode({
//           'body': prompt,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         String? chatResponse;
//         String? chatId;

//         if (data is Map && data.containsKey('body')) {
//           chatResponse = data['body'];
//           chatId = data['id']?.toString();
//         } else if (data is List && data.isNotEmpty) {
//           final lastItem = data.last;
//           chatResponse = lastItem['body'];
//           chatId = lastItem['id']?.toString();
//         }

//         if (chatResponse != null) {
//           final botMessage = types.TextMessage(
//             author: _bot,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
//             text: chatResponse,
//           );

//           setState(() {
//             messages = [botMessage, ...messages]; // اضافه کردن پاسخ به ابتدای لیست
//           });
          
//           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

//           await incrementSentMessageCount();
//           await saveMessagesToLocal();

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
//             chatResponse: chatResponse.isNotEmpty ? chatResponse : 'بدون پاسخ',
//             chatId: chatId ?? '',
//           ));
//         }
//       } else {
//         var data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام')),
//       );
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   void showUpgradeDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('محدودیت پیام'),
//         content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('انصراف'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/subscription');
//             },
//             child: Text('خرید اشتراک'),
//           ),
//         ],
//       ),
//     );
//   }

//   void showRemainingMessagesDialog() {
//     final remaining = maxFreeMessages - sentMessageCount;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('اطلاعات اشتراک'),
//         content: Text(
//           remaining > 0
//               ? 'شما $remaining پیام رایگان دیگر دارید.'
//               : 'پیام‌های رایگان شما تمام شده است.',
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('باشه'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // تغییر رنگ پس‌زمینه به سفید
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.workspace_premium),
//             tooltip: 'اطلاعات اشتراک',
//             onPressed: showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Chat(
//                   messages: messages,
//                   onSendPressed: _handleSendPressed,
//                   user: _user,
//                   scrollController: _scrollController,
//                   scrollPhysics: const BouncingScrollPhysics(),
//                   theme: DefaultChatTheme(
//                     primaryColor: Colors.green,
//                     secondaryColor: Colors.green.shade100,
//                     inputBackgroundColor: Colors.white,
//                     inputTextColor: Colors.black,
//                     inputTextDecoration: InputDecoration(
//                       hintText: 'پیام خود را بنویسید...',
//                       hintStyle: TextStyle(fontFamily: 'Vazir'),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                     ),
//                     backgroundColor: Colors.white, // رنگ پس‌زمینه چت
//                     receivedMessageBodyTextStyle: TextStyle(
//                       color: Colors.black,
//                       fontFamily: 'Vazir',
//                     ),
//                     sentMessageBodyTextStyle: TextStyle(
//                       color: Colors.white,
//                       fontFamily: 'Vazir',
//                     ),
//                   ),
//                   customBottomWidget: Container(
//                     color: Colors.white,
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: messageController,
//                             decoration: InputDecoration(
//                               hintText: 'پیام خود را بنویسید...',
//                               hintStyle: TextStyle(fontFamily: 'Vazir'),
//                               filled: true,
//                               fillColor: Colors.grey.shade100,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         IconButton(
//                           icon: Icon(Icons.document_scanner),
//                           color: Colors.green,
//                           tooltip: 'ارسال متن از عکس یا PDF',
//                           onPressed: () async {
//                             final extractedText = await Navigator.push<String>(
//                               context,
//                               MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                             );

//                             if (extractedText != null && extractedText.trim().isNotEmpty) {
//                               messageController.text = extractedText;
//                             }
//                           },
//                         ),
//                         ElevatedButton(
//                           onPressed: loading
//                               ? null
//                               : () {
//                                   sendMessage(text: messageController.text);
//                                 },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: loading
//                               ? SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : Icon(Icons.send, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

