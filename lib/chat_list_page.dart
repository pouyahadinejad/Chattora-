// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:otpuivada/auth_service.dart';

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
// Future<void> fetchChats() async {
//   setState(() {
//     loading = true;
//   });

//   final token = AuthService.getToken();
//   if (token == null || token.isEmpty) {
//     Navigator.pushReplacementNamed(context, '/login');
//     return;
//   }

//   var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

//   try {
//     var response = await http.get(
//       url,
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);

//       setState(() {
//           if (response.statusCode == 200) {
//           var data = jsonDecode(response.body);
          
//           // اگر پاسخ مستقیم یک آرایه است
//           if (data is List) {
//             setState(() {
//               messages = List<Map<String, dynamic>>.from(data);
//             });
//           } 
//           // اگر پاسخ یک شی است که پیام‌ها در کلید 'data' است
//           else if (data is Map && data.containsKey('data')) {
//             setState(() {
//               messages = List<Map<String, dynamic>>.from(data['data']);
//             });
//           }
//                 }}
// );
//     } else {
//       print('Error loading chats: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching chats: $e');
//   } finally {
//     setState(() {
//       loading = false;
//     });
//   }
// }


// Future<void> sendMessage() async {
//   final text = messageController.text.trim();
//   if (text.isEmpty) return;

//   setState(() => loading = true);

//   final token = AuthService.getToken();
//   print('TOKEN => $token');

//   if (token == null || token.isEmpty) {
//     Navigator.pushReplacementNamed(context, '/login');
//     return;
//   }

//   var url = Uri.parse('https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');
 
//   try {
//     var response = await http.post(
//       url,
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//         'package_name' : 'com.vada.drive'
//       },
//       body: jsonEncode({
//         'body': text,
//       }),
//     );

//     print('SEND STATUS => ${response.statusCode}');
//     print('SEND BODY => ${response.body}');

//       if (response.statusCode == 200) {
//         messageController.clear();
//         var data = jsonDecode(response.body);

//         if (data is List && data.isNotEmpty) {
//           setState(() {
//             for (var msg in data.reversed) {
//               messages.insert(0, msg);
//             }
//           });
//   } else {
//     await fetchChats();
//   }
// }

//     else {
//       var data = jsonDecode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//       );
//     }
//   } catch (e) {
//     print('Error sending message: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('خطا در ارسال پیام')),
//     );
//   } finally {
//     setState(() => loading = false);
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade50,
//       appBar: AppBar(
//         title: Text(
//           "چت",
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         backgroundColor: Colors.deepPurple,
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
//                         reverse: true,
//                       itemCount: messages.length,
//                       itemBuilder: (_, index) {
//                         var item = messages[index];

//                         final isMine = item['from'] == 0; // یا هر شرطی که تو بک‌اند هست

//                         return Align(
//                           alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//                             margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: isMine ? Colors.deepPurple.shade400 : Colors.grey.shade300,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(12),
//                                 topRight: Radius.circular(12),
//                                 bottomLeft: isMine ? Radius.circular(12) : Radius.circular(0),
//                                 bottomRight: isMine ? Radius.circular(0) : Radius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               item['body'] ?? '',
//                               style: TextStyle(
//                                 fontFamily: 'Vazir',
//                                 fontSize: 16,
//                                 color: isMine ? Colors.white : Colors.black87,
//                               ),
//                             ),
//                           ),
//                         );
//                       }

//                        ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'پیام خود را بنویسید...',
//                       hintStyle: TextStyle(fontFamily: 'Vazir'),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: loading ? null : sendMessage,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   child: loading
//                       ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : Icon(Icons.send, color: Colors.white),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }














///////////////////////=>nice














import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:otpuivada/auth_service.dart';
import 'package:otpuivada/ocrpdf.dart';

class ChatListPage extends StatefulWidget {
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
    final text = messageController.text.trim();
    if (text.isEmpty) return;

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
          'body': text,
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
      // IconButton(
      //   icon: Icon(Icons.document_scanner),
      //   color: Colors.green,
      //   tooltip: 'ارسال متن از عکس یا PDF',
      //   onPressed: () async {
      //     final extractedText = await Navigator.push<String>(
      //       context,
      //       MaterialPageRoute(builder: (_) => OCRPdfApp()),
      //     );

      //     if (extractedText != null && extractedText.trim().isNotEmpty) {
      //       messageController.text = extractedText;
      //     }
      //   },
      // ),
      Expanded(
        child: TextField(
          expands: false,
          textInputAction: TextInputAction.newline,
          maxLines:3,
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
          }
        },
      ),
            ElevatedButton(
          onPressed: loading
              ? null
              : () {
                  sendMessage(text: '');
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












// // Full merged chat page with flutter_chat_ui and OCR functionality
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:uuid/uuid.dart';
// import 'package:otpuivada/auth_service.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   final picker = ImagePicker();
//   final currentUser = types.User(id: 'me');
//   final botUser = types.User(id: 'bot');
//   List<types.Message> messages = [];

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
//         List<Map<String, dynamic>> chatList = [];

//         if (data is List) {
//           chatList = List<Map<String, dynamic>>.from(data);
//         } else if (data is Map && data.containsKey('data')) {
//           chatList = List<Map<String, dynamic>>.from(data['data']);
//         }

//         final chatMessages = chatList.map((item) {
//           final isMine = item['from'] == 0;
//           return types.TextMessage(
//             author: isMine ? currentUser : botUser,
//             createdAt: DateTime.now().millisecondsSinceEpoch,
//             id: const Uuid().v4(),
//             text: item['body'] ?? '',
//           );
//         }).toList();

//         setState(() => messages = chatMessages.reversed.toList());
//       }
//     } catch (e) {
//       print('Error fetching chats: $e');
//     }
//   }

//   Future<void> sendMessage(String text) async {
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
//         body: jsonEncode({'body': text}),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         setState(() {
//           messages.insert(
//             0,
//             types.TextMessage(
//               author: currentUser,
//               createdAt: DateTime.now().millisecondsSinceEpoch,
//               id: const Uuid().v4(),
//               text: text,
//             ),
//           );

//           if (data is List && data.isNotEmpty) {
//             for (var msg in data) {
//               messages.insert(
//                 0,
//                 types.TextMessage(
//                   author: botUser,
//                   createdAt: DateTime.now().millisecondsSinceEpoch,
//                   id: const Uuid().v4(),
//                   text: msg['body'] ?? '',
//                 ),
//               );
//             }
//           }
//         });
//       } else {
//         final data = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'ارسال پیام ناموفق بود')),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطا در ارسال پیام')),
//       );
//     }
//   }

//   Future<void> handleImageSelection() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile == null) return;

//     final inputImage = InputImage.fromFilePath(pickedFile.path);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

//     String extractedText = recognizedText.text.trim();
//     if (extractedText.isEmpty) extractedText = 'متنی در تصویر یافت نشد';

//     setState(() {
//       messages.insert(
//         0,
//         types.ImageMessage(
//           author: currentUser,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           name: pickedFile.name,
//           size: File(pickedFile.path).lengthSync(),
//           uri: pickedFile.path,
//         ),
//       );
//       messages.insert(
//         0,
//         types.TextMessage(
//           author: botUser,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//           id: const Uuid().v4(),
//           text: extractedText,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("چت", style: TextStyle(fontFamily: 'Vazir')),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.photo),
//             onPressed: handleImageSelection,
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           )
//         ],
//       ),
//       body: Chat(
//         messages: messages,
//         onSendPressed: (msg) => sendMessage(msg.text),
//         user: currentUser,
//         theme: DefaultChatTheme(
//           primaryColor: Colors.green,
//           secondaryColor: Colors.green.shade50,
//           inputBackgroundColor: Colors.white,
//           inputTextColor: Colors.black,
//           receivedMessageBodyTextStyle: TextStyle(
//             color: Colors.green.shade900,
//             fontFamily: 'Vazir',
//           ),
//           sentMessageBodyTextStyle: TextStyle(
//             color: Colors.white,
//             fontFamily: 'Vazir',
//           ),
//         ),
//       ),
//     );
//   }
// }

























// import 'dart:convert';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import 'package:otpuivada/auth_service.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   final _uuid = Uuid();

//   /// حالا نوع Message هست، نه فقط TextMessage
//   List<types.Message> messages = [];

//   bool loading = false;

//   final types.User user = types.User(id: '0', firstName: 'شما');
//   final types.User botUser = types.User(id: 'bot', firstName: 'بات');

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

//         List<Map<String, dynamic>> fetchedMessages = [];

//         if (data is List) {
//           fetchedMessages = List<Map<String, dynamic>>.from(data);
//         } else if (data is Map && data.containsKey('data')) {
//           fetchedMessages = List<Map<String, dynamic>>.from(data['data']);
//         }

//         setState(() {
//           messages = fetchedMessages
//               .map((msg) => types.TextMessage(
//                     id: _uuid.v4(),
//                     author: msg['from'] == 0 ? user : botUser,
//                     text: msg['body'] ?? '',
//                     createdAt: DateTime.now().millisecondsSinceEpoch,
//                   ))
//               .toList();
//         });
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

//   Future<void> sendMessage(types.PartialText message) async {
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
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'body': message.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data is List && data.isNotEmpty) {
//           for (var msg in data) {
//             final textMsg = types.TextMessage(
//               author: botUser,
//               id: _uuid.v4(),
//               text: msg['body'] ?? '',
//               createdAt: DateTime.now().millisecondsSinceEpoch,
//             );
//             setState(() {
//               messages.insert(0, textMsg);
//             });
//           }
//         }

//         final myMsg = types.TextMessage(
//           author: user,
//           id: _uuid.v4(),
//           text: message.text,
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//         );
//         setState(() {
//           messages.insert(0, myMsg);
//         });
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

//   Future<void> sendImageMessage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);

//     if (result != null && result.files.single.path != null) {
//       final filePath = result.files.single.path!;
//       final file = File(filePath);

//       /// شبیه‌سازی آپلود به سرور
//       await Future.delayed(Duration(seconds: 2));

//       // اینجا فرض کن عکس رو آپلود کردی و لینکش رو داری
//       final imageUrl = 'https://via.placeholder.com/400x300.png?text=Uploaded';

//       final imageMsg = types.ImageMessage(
//         author: user,
//         id: _uuid.v4(),
//         name: result.files.single.name,
//         size: file.lengthSync(),
//         uri: imageUrl,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//       );

//       setState(() {
//         messages.insert(0, imageMsg);
//       });

//       // OCR
//       final ocrText = await extractTextFromImage(filePath);

//       if (ocrText.isNotEmpty) {
//         final botMsg = types.TextMessage(
//           author: botUser,
//           id: _uuid.v4(),
//           text: 'متن شناسایی‌شده از عکس:\n$ocrText',
//           createdAt: DateTime.now().millisecondsSinceEpoch,
//         );

//         setState(() {
//           messages.insert(0, botMsg);
//         });
//       }
//     }
//   }

//   Future<String> extractTextFromImage(String filePath) async {
//     // فعلاً شبیه‌سازی شده
//     await Future.delayed(Duration(seconds: 1));
//     return "این متن نمونه OCR است.";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           'چت',
//           style: TextStyle(fontFamily: 'Vazir'),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.image),
//             onPressed: loading ? null : sendImageMessage,
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await AuthService.clearToken();
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : Chat(
//               messages: messages,
//               onSendPressed: sendMessage,
//               user: user,
//               theme: DefaultChatTheme(
//                 primaryColor: Colors.green,
//                 secondaryColor: Colors.green.shade100,
//                 inputBackgroundColor: Colors.white,
//                 inputTextColor: Colors.black,
//                 sentMessageBodyTextStyle: TextStyle(
//                   color: Colors.white,
//                   fontFamily: 'Vazir',
//                   fontSize: 16,
//                 ),
//                 receivedMessageBodyTextStyle: TextStyle(
//                   color: Colors.green.shade900,
//                   fontFamily: 'Vazir',
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//     );
//   }
// }
















// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import 'package:otpuivada/auth_service.dart';
// import 'package:otpuivada/ocrpdf.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   List<types.Message> messages = [];
//   bool loading = false;

//   /// کاربر لاگین شده (خود ما)
//   final types.User currentUser = types.User(id: '0'); // from==0 یعنی پیام خودمونه

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

//     var url = Uri.parse(
//         'https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

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

//         List<dynamic> rawMessages;
//         if (data is List) {
//           rawMessages = data;
//         } else if (data is Map && data.containsKey('data')) {
//           rawMessages = data['data'];
//         } else {
//           rawMessages = [];
//         }
// final loadedMessages = rawMessages
//     .map<types.Message?>((item) {
//       final body = (item['body'] ?? '').trim();
//       if (body.isEmpty) return null;

//       final isMine = item['from'] == 0;

//       return types.TextMessage(
//         id: const Uuid().v4(),
//         author: isMine ? currentUser : types.User(id: '1'),
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         text: body,
//       );
//     })
//     .whereType<types.Message>()
//     .toList();


//         setState(() {
//           messages = loadedMessages.reversed.toList();
//         });
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
//     if (text.trim().isEmpty) return;

//     setState(() {
//       loading = true;
//     });

//     final token = AuthService.getToken();
//     if (token == null || token.isEmpty) {
//       Navigator.pushReplacementNamed(context, '/login');
//       return;
//     }

//     var url = Uri.parse(
//         'https://chat.vsrv.ir/api/chats?package_name=com.vada.drive');

//     try {
//       var response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'body': text,
//           'title': 'آزمون آیلتس',
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);

//         if (data is List && data.isNotEmpty) {
//           for (var item in data) {
//             final body = (item['body'] ?? '').trim();
//             if (body.isEmpty) continue;

//             final isMine = item['from'] == 0;

//             final msg = types.TextMessage(
//               id: const Uuid().v4(),
//               author: isMine ? currentUser : types.User(id: '1'),
//               createdAt: DateTime.now().millisecondsSinceEpoch,
//               text: body,
//             );

//             setState(() {
//               messages.insert(0, msg);
//             });
//           }
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
//       setState(() {
//         loading = false;
//       });
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
//       body: loading
//           ? Center(child: CircularProgressIndicator())
//           : Chat(
//               messages: messages,
//               user: currentUser,
//               theme: DefaultChatTheme(
//                 inputBackgroundColor: Colors.white,
//                 inputTextStyle: TextStyle(
//                   fontFamily: 'Vazir',
//                   fontSize: 16,
//                 ),
//                 primaryColor: Colors.green.shade600,
//                 secondaryColor: Colors.green.shade100,
//                 receivedMessageBodyTextStyle: TextStyle(
//                   fontFamily: 'Vazir',
//                   color: Colors.green.shade900,
//                   fontSize: 16,
//                 ),
//                 sentMessageBodyTextStyle: TextStyle(
//                   fontFamily: 'Vazir',
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//               onSendPressed: (partialMessage) {
//                 final text = (partialMessage as types.PartialText).text;
//                 sendMessage(text: text);
//               },
//               customBottomWidget: _buildCustomInput(context),
//             ),
//     );
//   }

//   Widget _buildCustomInput(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.document_scanner, color: Colors.green),
//             onPressed: () async {
//               final extractedText = await Navigator.push<String>(
//                 context,
//                 MaterialPageRoute(builder: (_) => OCRPdfApp()),
//               );

//               if (extractedText != null && extractedText.trim().isNotEmpty) {
//                 sendMessage(text: extractedText);
//               }
//             },
//           ),
//           Expanded(
//             child: TextField(
//               maxLines: 5,
//               minLines: 1,
//               textInputAction: TextInputAction.newline,
//               decoration: InputDecoration(
//                 hintText: 'پیام خود را بنویسید...',
//                 hintStyle: TextStyle(fontFamily: 'Vazir'),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               ),
//               onSubmitted: (text) {
//                 if (text.trim().isNotEmpty) {
//                   sendMessage(text: text);
//                 }
//               },
//             ),
//           ),
//           SizedBox(width: 8),
//           loading
//               ? CircularProgressIndicator(strokeWidth: 2)
//               : IconButton(
//                   icon: Icon(Icons.send, color: Colors.green),
//                   onPressed: () {
//                     // نیازی نیست اینجا چیزی بنویسی چون onSendPressed کارش رو میکنه
//                   },
//                 )
//         ],
//       ),
//     );
//   }
// }
