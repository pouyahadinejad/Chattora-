import 'package:flutter/material.dart';
import 'package:otpuivada/chat_list_page.dart';
import 'package:otpuivada/ocrpdf.dart';
class EditTextPage extends StatefulWidget {
  final String initialText;
  final String imagePath;

  const EditTextPage({super.key, required this.initialText, required this.imagePath});

  @override
  State<EditTextPage> createState() => _EditTextPageState();
}
class _EditTextPageState extends State<EditTextPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش متن'), backgroundColor: Colors.orange, automaticallyImplyLeading: false),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'متن را ویرایش کنید...',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatListPage(initialMessage: _controller.text, imagePath: widget.imagePath),
                  ),
                );
              },
              child: const Text('ارسال به چت', style: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}