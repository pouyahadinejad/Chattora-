// import 'package:flutter/material.dart';
// import 'package:sidebarx/sidebarx.dart';
// import 'chat_list_page.dart';
// import 'package:otpuivada/auth_service.dart';

// class DrawerWidget extends StatelessWidget {
//   final SidebarXController controller;
//   final String fullName;

//   const DrawerWidget({
//     Key? key,
//     required this.controller,
//     required this.fullName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SidebarX(
//       controller: controller,
//       theme: SidebarXTheme(
//         width: 300, // ✅ عرض Drawer
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.green.shade700,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         hoverColor: Colors.green.shade400,
//         textStyle: const TextStyle(
//           fontFamily: 'Vazir',
//           color: Colors.white,
//         ),
//         selectedTextStyle: const TextStyle(
//           fontFamily: 'Vazir',
//           color: Colors.black,
//         ),
//         selectedItemDecoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//         selectedIconTheme: const IconThemeData(color: Colors.black),
//       ),
//       extendedTheme: const SidebarXTheme(
//         width: 300, // ✅ عرض در حالت باز شده
//       ),
//       headerBuilder: (context, extended) {
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 30),
//               const Icon(Icons.account_circle, size: 60, color: Colors.white),
//               const SizedBox(height: 16),
//               const Text(
//                 'خوش آمدید',
//                 style: TextStyle(
//                   fontFamily: 'Vazir',
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//               Text(
//                 fullName,
//                 style: const TextStyle(
//                   fontFamily: 'Vazir',
//                   fontSize: 16,
//                   color: Colors.white70,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//       items: [
//         SidebarXItem(
//           icon: Icons.chat,
//           label: 'چت',
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const ChatListPage(imagePath: ''),
//               ),
//             );
//           },
//         ),
//         SidebarXItem(
//           icon: Icons.logout,
//           label: 'خروج',
//           onTap: () async {
//             await AuthService.clearToken();
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               '/login',
//               (route) => false,
//             );
//           },
//         ),
//       ],
//     );
//   }
// }













import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'chat_list_page.dart';
import 'auth_service.dart';

class MobileHomePage extends StatefulWidget {
  final String fullName;

  const MobileHomePage({Key? key, required this.fullName}) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  final SidebarXController _controller =
      SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحه اصلی', style: TextStyle(fontFamily: 'Vazir')),
        backgroundColor: Colors.green.shade700,
      ),

      /// 🌟 Drawer شیک برای موبایل
      
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: SafeArea(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: SidebarX(
              controller: _controller,
              theme: SidebarXTheme(
                width: 280,
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(3, 5),
                    )
                  ],
                ),
                hoverColor: Colors.green.shade500,
                textStyle: const TextStyle(
                    fontFamily: 'Vazir', color: Colors.white, fontSize: 15),
                selectedTextStyle: const TextStyle(
                    fontFamily: 'Vazir', color: Colors.black, fontSize: 16),
                selectedItemDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                selectedIconTheme: const IconThemeData(color: Colors.black),
              ),
              headerBuilder: (context, extended) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade600,
                        Colors.green.shade900,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.green),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'خوش آمدید',
                        style: TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Text(
                        widget.fullName,
                        style: const TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 14,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
              items: [
                SidebarXItem(
                  icon: Icons.chat,
                  label: 'چت',
                  onTap: () {
                    Navigator.pop(context); // بستن دراور
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ChatListPage(imagePath: '')),
                    );
                  },
                ),
                SidebarXItem(
                  icon: Icons.logout,
                  label: 'خروج',
                  onTap: () async {
                    Navigator.pop(context); // بستن دراور
                    await AuthService.clearToken();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      /// محتوای اصلی
      body: Center(
        child: Text(
          'به اپلیکیشن خوش آمدید!',
          style: TextStyle(fontSize: 22, fontFamily: 'Vazir'),
        ),
      ),
    );
  }
}
