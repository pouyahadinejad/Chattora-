import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otpuivada/auth_service.dart';

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

      setState(() {
          if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          
          // اگر پاسخ مستقیم یک آرایه است
          if (data is List) {
            setState(() {
              messages = List<Map<String, dynamic>>.from(data);
            });
          } 
          // اگر پاسخ یک شی است که پیام‌ها در کلید 'data' است
          else if (data is Map && data.containsKey('data')) {
            setState(() {
              messages = List<Map<String, dynamic>>.from(data['data']);
            });
          }
                }}
);
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


Future<void> sendMessage() async {
  final text = messageController.text.trim();
  if (text.isEmpty) return;

  setState(() => loading = true);

  final token = AuthService.getToken();
  print('TOKEN => $token');

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
        'package_name' : 'com.vada.drive'
      },
      body: jsonEncode({
        'body': text,
      }),
    );

    print('SEND STATUS => ${response.statusCode}');
    print('SEND BODY => ${response.body}');

      if (response.statusCode == 200) {
        messageController.clear();
        var data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            for (var msg in data.reversed) {
              messages.insert(0, msg);
            }
          });
  } else {
    await fetchChats();
  }
}

    else {
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
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(
          "چت",
          style: TextStyle(fontFamily: 'Vazir'),
        ),
        backgroundColor: Colors.deepPurple,
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
                        reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        var item = messages[index];

                        final isMine = item['from'] == 0; // یا هر شرطی که تو بک‌اند هست

                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isMine ? Colors.deepPurple.shade400 : Colors.grey.shade300,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: isMine ? Radius.circular(12) : Radius.circular(0),
                                bottomRight: isMine ? Radius.circular(0) : Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              item['body'] ?? '',
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 16,
                                color: isMine ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }

                       ),
          ),
          Padding(
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
                ElevatedButton(
                  onPressed: loading ? null : sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
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
          )
        ],
      ),
    );
  }
}
