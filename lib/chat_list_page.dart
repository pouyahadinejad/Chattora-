// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';
// // import 'home_screen.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   final TextEditingController messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];
//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     checkLoginAndFetch();
//   }

//   Future<void> checkLoginAndFetch() async {
//     if (!AuthService.isLoggedIn()) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     await fetchChats();
//   }

//   Future<void> fetchChats() async {
//     setState(() {
//       loading = true;
//     });

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

//     try {
//       var response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data is List) {
//           setState(() {
//             messages = List<Map<String, dynamic>>.from(data);
//           });
//         } else if (data is Map && data.containsKey('data')) {
//           setState(() {
//             messages = List<Map<String, dynamic>>.from(data['data']);
//           });
//         }
//       } else {
//         print('Error loading chats: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching chats: $e');
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   Future<void> sendMessage({required String text}) async {
//     final text = messageController.text.trim();
//     if (text.isEmpty) return;

//     setState(() => loading = true);

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

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
//           'body': text,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         if (data is List && data.isNotEmpty) {
//           setState(() {
//             for (var msg in data) {
//               messages.add(msg);
//             }
//           });
//         } else {
//           await fetchChats();
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         title: Text(
//           "چت",
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: loading
//                 ? Center(child: CircularProgressIndicator())
//                 : messages.isEmpty
//                     ? Center(
//                         child: Text(
//                           'هیچ پیامی وجود ندارد',
//                           style: TextStyle(fontFamily: 'Vazir'),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: messages.length,
//                         itemBuilder: (_, index) {
//                           var item = messages[index];
//                          final body = (item['body'] ?? '').trim();

//                          if (body.isEmpty) return SizedBox.shrink();
//                           final isMine = item['from'] == 0;

//                           return Align(
//                             alignment:
//                                 isMine ? Alignment.centerRight : Alignment.centerLeft,
//                             child: Container(
//                               constraints: BoxConstraints(
//                                   maxWidth:
//                                       MediaQuery.of(context).size.width * 0.75),
//                               margin:
//                                   EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 10),
//                               decoration: BoxDecoration(
//                                 color: isMine
//                                     ? Colors.green.shade600
//                                     : Colors.green.shade100,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(16),
//                                   topRight: Radius.circular(16),
//                                   bottomLeft:
//                                       isMine ? Radius.circular(16) : Radius.zero,
//                                   bottomRight:
//                                       isMine ? Radius.zero : Radius.circular(16),
//                                 ),
//                               ),
//                               child: Text(
//                                 item['body'] ?? '',
//                                 style: TextStyle(
//                                   fontFamily: 'Vazir',
//                                   fontSize: 16,
//                                   color:
//                                       isMine ? Colors.white : Colors.green.shade900,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
// Padding(
//   padding: const EdgeInsets.all(12),
//   child: Row(
//     children: [
//       // IconButton(
//       //   icon: Icon(Icons.document_scanner),
//       //   color: Colors.green,
//       //   tooltip: 'ارسال متن از عکس یا PDF',
//       //   onPressed: () async {
//       //     final extractedText = await Navigator.push<String>(
//       //       context,
//       //       MaterialPageRoute(builder: (_) => OCRPdfApp()),
//       //     );

//       //     if (extractedText != null && extractedText.trim().isNotEmpty) {
//       //       messageController.text = extractedText;
//       //     }
//       //   },
//       // ),
//       Expanded(
//         child: TextField(
//           expands: false,
//           textInputAction: TextInputAction.newline,
//           maxLines:3,
//           minLines: 1,
//           controller: messageController,
//           decoration: InputDecoration(
//             hintText: 'پیام خود را بنویسید...',
//             hintStyle: TextStyle(fontFamily: 'Vazir'),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           ),
//         ),
//       ),
//       SizedBox(width: 8),
//             IconButton(
//         icon: Icon(Icons.document_scanner),
//         color: Colors.green,
//         tooltip: 'ارسال متن از عکس یا PDF',
//         onPressed: () async {
//           final extractedText = await Navigator.push<String>(
//             context,
//             MaterialPageRoute(builder: (_) => OCRPdfApp()),
//           );

//           if (extractedText != null && extractedText.trim().isNotEmpty) {
//             messageController.text = extractedText;
//           }
//         },
//       ),
//             ElevatedButton(
//           onPressed: loading
//               ? null
//               : () {
//                   sendMessage(text: '');
//                 },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//           ),
//           child: loading
//               ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : Icon(Icons.send, color: Colors.white),
//         ),

//     ],
//   ),
// ),

//         ],
//       ),
//     );
//   }
// }





















import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otpuivada/auth_service.dart';
import 'package:otpuivada/ocrpdf.dart';

class ChatListPage extends StatefulWidget {
  final String? initialMessage;
  const ChatListPage({Key? key, this.initialMessage}) : super(key: key);
  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool loading = false;
@override
void initState() {
  super.initState();
  checkLoginAndFetch();

  // اگر initialMessage داشتیم، اون رو بفرست
  if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
    final text = widget.initialMessage!.trim();
    messageController.text = text;
    // ارسال خودکار پیام
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendMessage(text: text);
    });
  }
}


  Future<void> checkLoginAndFetch() async {
    if (!AuthService.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    await fetchChats();
  }

  Future<void> fetchChats() async {
    setState(() {
      loading = true;
    });

    final token = AuthService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            messages = List<Map<String, dynamic>>.from(data);
          });
        } else if (data is Map && data.containsKey('data')) {
          setState(() {
            messages = List<Map<String, dynamic>>.from(data['data']);
          });
        }
      } else {
        print('Error loading chats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chats: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> sendMessage({required String text}) async {
    final messageText = text.trim();
    if (messageText.isEmpty) return;

    setState(() => loading = true);

    final token = AuthService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

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
          'body': messageText,
          'title': 'آزمون آیلتس',
        }),
      );

      if (response.statusCode == 200) {
        messageController.clear();
        var data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            for (var msg in data) {
              messages.add(msg);
            }
          });
        } else {
          await fetchChats();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text(
          "چت",
          style: TextStyle(fontFamily: 'Vazir'),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.clearToken();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'هیچ پیامی وجود ندارد',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (_, index) {
                          var item = messages[index];
                          final body = (item['body'] ?? '').trim();

                          if (body.isEmpty) return SizedBox.shrink();
                          final isMine = item['from'] == 0;

                          return Align(
                            alignment:
                                isMine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75),
                              margin:
                                  EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.green.shade600
                                    : Colors.green.shade100,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft:
                                      isMine ? Radius.circular(16) : Radius.zero,
                                  bottomRight:
                                      isMine ? Radius.zero : Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                item['body'] ?? '',
                                style: TextStyle(
                                  fontFamily: 'Vazir',
                                  fontSize: 16,
                                  color:
                                      isMine ? Colors.white : Colors.green.shade900,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    expands: false,
                    textInputAction: TextInputAction.newline,
                    maxLines: 2,
                    minLines: 1,
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'پیام خود را بنویسید...',
                      hintStyle: TextStyle(fontFamily: 'Vazir'),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      messageController.text = extractedText;
                      // اگر میخوای مستقیم ارسال بشه، خط بعدی رو فعال کن:
                      // await sendMessage(text: extractedText);
                    }
                  },
                ),
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
        ],
      ),
    );
  }
}
