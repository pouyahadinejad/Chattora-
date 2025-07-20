
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:otpuivada/chat_list_page.dart';
import 'package:otpuivada/home_screen.dart';

class ExtractedTextPage extends StatelessWidget {
  final String text;

  const ExtractedTextPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final Box<String> authBox = Hive.box<String>('auth');
    final mobileNumber = authBox.get('mobile');
    return Scaffold(
      appBar: AppBar(title: const Text('متن استخراج‌شده'), backgroundColor: Colors.green,automaticallyImplyLeading: false,
),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                   onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatListPage(initialMessage:text ),
                        ),
                      );
                    },
                    child: const Text('تأیید', style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTextPage(initialText: text),
                        ),
                      ).then((editedText) {
                        if (editedText != null) {
                          Navigator.pop(context, editedText);
                        }
                      });
                    },
                    child: const Text('ویرایش', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}