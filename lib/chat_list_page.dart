// // nice

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otpuivada/auth_service.dart';
import 'package:otpuivada/ocrpdf.dart';
import 'package:otpuivada/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  late final AutoScrollController _scrollController;
  final TextEditingController messageController = TextEditingController();
  List<types.Message> messages = [];
  bool loading = false;
  int sentMessageCount = 0;
  final int maxFreeMessages = 145;
  bool _showScrollToBottomButton = false;
  final types.User _user = const types.User(id: 'user');
  final types.User _bot = const types.User(id: 'bot');
  ////////////////////////
@override
void initState() {
  _scrollController = AutoScrollController();
  super.initState();
  _scrollController.addListener(_handleScrollPosition);
  
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await loadSentMessageCount();
    await loadMessagesFromLocal();
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
    _scrollController.dispose();
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

  Future<void> incrementSentMessageCount() async {
    final prefs = await SharedPreferences.getInstance();
    sentMessageCount++;
    await prefs.setInt('sentMessageCount', sentMessageCount);
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
////////////////////////////////////////////////////////////////
                      setState(() {
          messages = loadedMessages.where((m) => 
             m is types.Message && 
             (m is! types.TextMessage || m.text.trim().isNotEmpty)
           ).toList();
         });
        /////////////////////////////////////////////////////////////////////////
        // setState(() {
        //   messages = loadedMessages;
        //   loadedMessages.removeWhere((m) => m is! types.Message || (m is types.TextMessage && m.text.trim().isEmpty));

        // });
        
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

    final token = AuthService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
    final cleaned = cleanOcrText(messageText);
    final prompt = buildPrompt(cleaned);

    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'package_name': 'com.vada.drive',
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
/////////////////////////////////////////////////////////////////////////////
        if (chatResponse != null ) {
        // if (chatResponse != null ) {
//////////////////////////////////////////////////////////////////////////////
          final botMessage = types.TextMessage(
            author: _bot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
            text: chatResponse,
          );

          setState(() {
            messages = [botMessage, ...messages];
          });
///////////////////////////////////////////////////////////////////
        //  await incrementSentMessageCount();
         // await _saveMessagesToLocal();
          //////////////////////////////////////////////////////////
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

  void showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('محدودیت پیام'),
        content: Text('شما به حداکثر تعداد پیام رایگان رسیدید. برای ادامه لطفاً اشتراک تهیه کنید.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subscription');
            },
            child: Text('خرید اشتراک'),
          ),
        ],
      ),
    );
  }

  // void showRemainingMessagesDialog() {
  //   final remaining = maxFreeMessages - sentMessageCount;
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text('اطلاعات اشتراک'),
  //       content: Text(
  //         remaining > 0
  //             ? 'شما $remaining پیام رایگان دیگر دارید.'
  //             : 'پیام‌های رایگان شما تمام شده است.',
  //         style: TextStyle(fontFamily: 'Vazir'),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('باشه'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void showRemainingMessagesDialog() {
  final remaining = maxFreeMessages - sentMessageCount;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
          SizedBox(width: 8),
          Text(
            'اطلاعات اشتراک',
            style: TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            remaining > 0 ? Icons.check_circle : Icons.block,
            color: remaining > 0 ? Colors.green : Colors.red,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            remaining > 0
                ? 'شما $remaining پیام رایگان دیگر دارید'
                : 'پیام‌های رایگان شما تمام شده است.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Vazir',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Center(
            child: Text(
              'باشه',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
         onWillPop: () async => false, // یعنی نذار بک بزنن
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //   leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          automaticallyImplyLeading: false,
          title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
          backgroundColor: Colors.green,
          actions: [
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   onPressed: () async {
            //     await AuthService.clearToken();
            //     Navigator.pushReplacementNamed(context, '/login');
            //   },
            // ),
            IconButton(
              icon: Icon(Icons.workspace_premium),
              tooltip: 'اطلاعات اشتراک',
              onPressed: showRemainingMessagesDialog,
            ),
          ],
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
                          primaryColor: Colors.green,
                          secondaryColor: Colors.green.shade100,
                          inputBackgroundColor: Colors.white,
                          inputTextColor: Colors.black,
                          inputTextDecoration: InputDecoration(
                            hintText: 'پیام خود را بنویسید...',
                            hintStyle: TextStyle(fontFamily: 'Vazir'),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          backgroundColor: Colors.white,
                          receivedMessageBodyTextStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Vazir',
                            fontSize: 16,
                          ),
                          sentMessageBodyTextStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Vazir',
                            fontSize: 16,
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
                                child: TextField(
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    hintText: 'پیام خود را بنویسید...',
                                    hintStyle: TextStyle(fontFamily: 'Vazir'),
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
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.document_scanner),
                                color: Colors.green,
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
                                  backgroundColor: Colors.green,
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
                  // if (_showScrollToBottomButton)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 80),
                  //     child: Align(
                  //       alignment: Alignment.bottomRight
                  //       ,
                  //       child: FloatingActionButton(
                  //         mini: true,
                  //         backgroundColor: Colors.green,
                  //         child: Icon(Icons.arrow_downward, color: Colors.white),
                  //         onPressed: _scrollToBottom,
                  //       ),
                  //     ),
                  //   ),
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
                          backgroundColor: Colors.green,
                          child: Icon(Icons.arrow_downward, color: Colors.white),
                          onPressed: _scrollToBottom,
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
//   List<types.Message> _messages = [];
//   bool _loading = false;
//   int _sentMessageCount = 0;
//   final int _maxFreeMessages = 45;
//   bool _showScrollToBottomButton = false;
//   final types.User _user = const types.User(id: 'user');
//   final types.User _bot = const types.User(id: 'bot');

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = AutoScrollController();
//     _scrollController.addListener(_handleScrollPosition);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadSentMessageCount();
//       await _loadMessagesFromLocal();
//       _checkLoginAndFetch();

//       if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//         final text = widget.initialMessage!.trim();
//         messageController.text = text;
//         Future.microtask(() => _handleSendPressed(types.PartialText(text: text)));
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     messageController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && _messages.isNotEmpty) {
//       _scrollController.scrollToIndex(
//         _messages.length - 0,
//         duration: const Duration(milliseconds: 300),
//         preferPosition: AutoScrollPosition.begin,
//       );
//     }
//   }

//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final position = _scrollController.position;
//       setState(() {
//         _showScrollToBottomButton = position.pixels < position.maxScrollExtent + 100;
//       });
//     }
//   }

//   Future<void> _loadSentMessageCount() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _sentMessageCount = prefs.getInt('sentMessageCount') ?? 0;
//     });
//   }

//   Future<void> incrementSentMessageCount() async {
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
//       try {
//         final loadedMessages = <types.Message>[];
        
//         for (final jsonString in jsonList) {
//           try {
//             final json = jsonDecode(jsonString);
//             if (json is Map<String, dynamic>) {
//               if (json['author'] == null) {
//                 final isMine = json['from'] == 0;
//                 loadedMessages.add(types.TextMessage(
//                   author: isMine ? _user : _bot,
//                   createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
//                   id: json['id']?.toString() ?? DateTime.now().toString(),
//                   text: json['body']?.toString() ?? '',
//                 ));
//               } else {
//                 loadedMessages.add(types.Message.fromJson(json));
//               }
//             }
//           } catch (e) {
//             print('Error parsing message: $e');
//           }
//         }
        
//         setState(() {
//           _messages = loadedMessages.where((m) => 
//             m is types.Message && 
//             (m is! types.TextMessage || m.text.trim().isNotEmpty)
//           ).toList();
//         });
        
//         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//       } catch (e) {
//         print('Error loading messages: $e');
//       }
//     }
//   }

//   Future<void> _checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }

//   String _cleanOcrText(String text) {
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

//   String _buildPrompt(String rawText) {
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
//     _sendMessage(text: message.text);
//   }

//   Future<void> _sendMessage({required String text}) async {
//     final messageText = text.trim();
//     if (messageText.isEmpty) return;
    
//     if (_sentMessageCount >= _maxFreeMessages) {
//       _showUpgradeDialog();
//       return;
//     }

//     setState(() => _loading = true);

//     final userMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//       text: messageText,
//     );

//     setState(() {
//       _messages = [..._messages, userMessage];
//     });
    
//     _scrollToBottom();
//     // messageController.clear();////////////////////

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = _cleanOcrText(messageText);
//     final prompt = _buildPrompt(cleaned);

//     try {
//       final response = await http.post(
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
//         final data = jsonDecode(response.body);
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

//         if (chatResponse != null && chatResponse.isNotEmpty) {
//           final botMessage = types.TextMessage(
//             author: _bot,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
//             text: chatResponse,
//           );

//           setState(() {
//             _messages = [..._messages, botMessage];
//           });
          
//           await incrementSentMessageCount();
//           await _saveMessagesToLocal();

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
//             chatResponse: chatResponse,
//             chatId: chatId ?? '', 
//             time: DateTime.now().toString(),
//           ));

//           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorData['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _loading = false);
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
//       backgroundColor: Colors.white,
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
//             onPressed: _showRemainingMessagesDialog,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: Chat(
//                       messages: _messages.reversed.toList(),
//                       onSendPressed: _handleSendPressed,
//                       user: _user,
//                       scrollController: _scrollController,
//                       scrollPhysics: const BouncingScrollPhysics(),
//                       theme: DefaultChatTheme(
//                         primaryColor: Colors.green,
//                         secondaryColor: Colors.green.shade100,
//                         inputBackgroundColor: Colors.white,
//                         inputTextColor: Colors.black,
//                         inputTextDecoration: InputDecoration(
//                           hintText: 'پیام خود را بنویسید...',
//                           hintStyle: TextStyle(fontFamily: 'Vazir'),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                         ),
//                         backgroundColor: Colors.white,
//                         receivedMessageBodyTextStyle: TextStyle(
//                           color: Colors.black,
//                           fontFamily: 'Vazir',
//                           fontSize: 16,
//                         ),
//                         sentMessageBodyTextStyle: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Vazir',
//                           fontSize: 16,
//                         ),
//                       ),
//                       customBottomWidget: Container(
//                         color: Colors.white,
//                         padding: const EdgeInsets.all(12),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: messageController,
//                                 decoration: InputDecoration(
//                                   hintText: 'پیام خود را بنویسید...',
//                                   hintStyle: TextStyle(fontFamily: 'Vazir'),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade100,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 14,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             IconButton(
//                               icon: Icon(Icons.document_scanner),
//                               color: Colors.green,
//                               tooltip: 'ارسال متن از عکس یا PDF',
//                               onPressed: () async {
//                                 final extractedText = await Navigator.push<String>(
//                                   context,
//                                   MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                                 );

//                                 if (extractedText != null && extractedText.trim().isNotEmpty) {
//                                   messageController.text = extractedText;
//                                 }
//                               },
//                             ),
//                             ElevatedButton(
//                               onPressed: _loading
//                                   ? null
//                                   : () {
//                                       _sendMessage(text: messageController.text);
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               ),
//                               child: _loading
//                                   ? SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                   : Icon(Icons.send, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (_showScrollToBottomButton)
//               Positioned(
//                 bottom: 80,
//                 right: 20,
//                 child: FloatingActionButton(
//                   mini: true,
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.arrow_downward, color: Colors.white),
//                   onPressed: _scrollToBottom,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// ///test3

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
//   final int maxFreeMessages = 145;
//   bool _showScrollToBottomButton = false;
//   final types.User _user = const types.User(id: 'user');
//   final types.User _bot = const types.User(id: 'bot');

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = AutoScrollController();
//     _scrollController.addListener(_handleScrollPosition);

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await loadSentMessageCount();
//       await loadMessagesFromLocal();
//       checkLoginAndFetch();

//       if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
//         final text = widget.initialMessage!.trim();
//         messageController.text = text;
//         Future.microtask(() => _handleSendPressed(types.PartialText(text: text)));
//       }
//     });
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
//         messages.length - 1,
//         duration: const Duration(milliseconds: 300),
//         preferPosition: AutoScrollPosition.end,
//       );
//     }
//   }

//   void _handleScrollPosition() {
//     if (_scrollController.hasClients) {
//       final position = _scrollController.position;
//       setState(() {
//         _showScrollToBottomButton = position.pixels < position.maxScrollExtent - 100;
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
//     setState(() {
//       sentMessageCount++;
//     });
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
//         final loadedMessages = <types.Message>[];
        
//         for (final jsonString in jsonList) {
//           try {
//             final json = jsonDecode(jsonString);
//             if (json is Map<String, dynamic>) {
//               if (json['author'] == null) {
//                 final isMine = json['from'] == 0;
//                 loadedMessages.add(types.TextMessage(
//                   author: isMine ? _user : _bot,
//                   createdAt: json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
//                   id: json['id']?.toString() ?? DateTime.now().toString(),
//                   text: json['body']?.toString() ?? '',
//                 ));
//               } else {
//                 loadedMessages.add(types.Message.fromJson(json));
//               }
//             }
//           } catch (e) {
//             print('Error parsing message: $e');
//           }
//         }
        
//         setState(() {
//           messages = loadedMessages.where((m) => 
//             m is types.Message && 
//             (m is! types.TextMessage || m.text.trim().isNotEmpty)
//           ).toList();
//         });
        
//         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//       } catch (e) {
//         print('Error loading messages: $e');
//       }
//     }
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
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
//       messages = [...messages, userMessage];
//     });
    
//     _scrollToBottom();
//     messageController.clear();

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     final url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
//     final cleaned = cleanOcrText(messageText);
//     final prompt = buildPrompt(cleaned);

//     try {
//       final response = await http.post(
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
//         final data = jsonDecode(response.body);
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

//         if (chatResponse != null && chatResponse.isNotEmpty) {
//           final botMessage = types.TextMessage(
//             author: _bot,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
//             text: chatResponse,
//           );

//           setState(() {
//             messages = [...messages, botMessage];
//           });
          
//           await incrementSentMessageCount();
//           await saveMessagesToLocal();

//           await HistoryStorage.addItem(HistoryItem(
//             imagePath: widget.imagePath,
//             userMessage: cleaned.isNotEmpty ? cleaned : 'پیامی وارد نشده',
//             chatResponse: chatResponse,
//             chatId: chatId ?? '', 
//             time: DateTime.now().toString(),
//           ));

//           WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorData['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام: ${e.toString()}')),
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
//       backgroundColor: Colors.white,
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
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: Chat(
//                       messages: messages,
//                       onSendPressed: _handleSendPressed,
//                       user: _user,
//                       scrollController: _scrollController,
//                       scrollPhysics: const BouncingScrollPhysics(),
//                       theme: DefaultChatTheme(
//                         primaryColor: Colors.green,
//                         secondaryColor: Colors.green.shade100,
//                         inputBackgroundColor: Colors.white,
//                         inputTextColor: Colors.black,
//                         inputTextDecoration: InputDecoration(
//                           hintText: 'پیام خود را بنویسید...',
//                           hintStyle: TextStyle(fontFamily: 'Vazir'),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                         ),
//                         backgroundColor: Colors.white,
//                         receivedMessageBodyTextStyle: TextStyle(
//                           color: Colors.black,
//                           fontFamily: 'Vazir',
//                           fontSize: 16,
//                         ),
//                         sentMessageBodyTextStyle: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Vazir',
//                           fontSize: 16,
//                         ),
//                       ),
//                       customBottomWidget: Container(
//                         color: Colors.white,
//                         padding: const EdgeInsets.all(12),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: messageController,
//                                 decoration: InputDecoration(
//                                   hintText: 'پیام خود را بنویسید...',
//                                   hintStyle: TextStyle(fontFamily: 'Vazir'),
//                                   filled: true,
//                                   fillColor: Colors.grey.shade100,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   contentPadding: EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 14,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             IconButton(
//                               icon: Icon(Icons.document_scanner),
//                               color: Colors.green,
//                               tooltip: 'ارسال متن از عکس یا PDF',
//                               onPressed: () async {
//                                 final extractedText = await Navigator.push<String>(
//                                   context,
//                                   MaterialPageRoute(builder: (_) => OCRPdfApp()),
//                                 );

//                                 if (extractedText != null && extractedText.trim().isNotEmpty) {
//                                   messageController.text = extractedText;
//                                 }
//                               },
//                             ),
//                             ElevatedButton(
//                               onPressed: loading
//                                   ? null
//                                   : () {
//                                       sendMessage(text: messageController.text);
//                                     },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               ),
//                               child: loading
//                                   ? SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                   : Icon(Icons.send, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (_showScrollToBottomButton)
//               Positioned(
//                 bottom: 80,
//                 right: 20,
//                 child: FloatingActionButton(
//                   mini: true,
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.arrow_downward, color: Colors.white),
//                   onPressed: _scrollToBottom,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }