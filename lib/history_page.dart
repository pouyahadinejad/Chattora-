import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otpuivada/chat_list_page.dart';
import 'package:otpuivada/ocrpdf.dart';
import 'dart:io';
import 'package:otpuivada/storage_helper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';



class HistoryPage extends StatefulWidget {
  
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late BuildContext _context;
  List<HistoryItem> items = [];
  bool isLoading = false;
  bool isDeleting = false;
  

  // رنگ‌های اختصاصی
  final Color primaryColor = const Color(0xFF2E7D32);
  final Color secondaryColor = const Color(0xFF81C784);
  final Color backgroundColor = const Color(0xFFF1F8E9);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF263238);
  final Color errorColor = const Color(0xFFE57373);
  


  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => isLoading = true);
    final loadedItems = await HistoryStorage.getItems();
    setState(() {
      items = loadedItems;
      isLoading = false;
    });
  }
  

String formatDate(String iso) {
  final dateTime = DateTime.tryParse(iso);
  if (dateTime == null) return '';
  return '${dateTime.year}/${_twoDigits(dateTime.month)}/${_twoDigits(dateTime.day)}  '
         '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');






  Future<void> _deleteItem(String imagePath) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف آیتم', style: TextStyle(fontFamily: 'Kalameh')),
        content: const Text('آیا از حذف این مورد اطمینان دارید؟', 
            style: TextStyle(fontFamily: 'Kalameh')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Kalameh')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Kalameh')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isDeleting = true);
      await HistoryStorage.removeItem(imagePath);
      setState(() {
        items.removeWhere((item) => item.imagePath == imagePath);
        isDeleting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('آیتم با موفقیت حذف شد', 
              style: TextStyle(fontFamily: 'Kalameh')),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _deleteAllItems() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف همه تاریخچه', style: TextStyle(fontFamily: 'Kalameh')),
        content: const Text('آیا می‌خواهید تمام تاریخچه را پاک کنید؟', 
            style: TextStyle(fontFamily: 'Kalameh')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف', style: TextStyle(fontFamily: 'Kalameh')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف همه', style: TextStyle(fontFamily: 'Kalameh')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => isLoading = true);
      await HistoryStorage.clearAll();
      setState(() {
        items.clear();
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تمام تاریخچه حذف شد', 
              style: TextStyle(fontFamily: 'Kalameh')),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
  bool isEnglish(String text) {
  final regex = RegExp(r'^[\x00-\x7F]+$');
  return regex.hasMatch(text);
}


  void _showDetails(HistoryItem item) {
    // final dateFormat = DateFormat('yyyy/MM/dd - HH:mm');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
  //              systemOverlayStyle: SystemUiOverlayStyle(
  //   statusBarColor: Colors.green.shade50,
  //   statusBarIconBrightness: Brightness.dark,
  // ),
              title: Center(child: const Text('جزئیات تاریخچه', style: TextStyle(fontFamily: 'Kalameh'))),
              backgroundColor: primaryColor,
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.vertical(
              //     bottom: Radius.circular(20),
              //   ),
              // ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // تصویر
                  if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(item.imagePath),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // اطلاعات تاریخچه
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatListPage(imagePath: '',)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            // color: Colors.blue,
                            child: const Text('برو به صفحه چت', style: TextStyle(fontFamily: 'Kalameh',color: Colors.black,fontSize: 15)),
                          ),
                          Icon(CupertinoIcons.chat_bubble_2,color: Colors.green,)
                        ],
                      ),
                    )
          
                    ),
                  // ),
                  
                  const SizedBox(height: 24),
                  
                  // سوال کاربر
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سوال شما:',
                          style: TextStyle(
                            fontFamily: 'Kalameh',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: isEnglish(item.userMessage) ? TextDirection.ltr : TextDirection.rtl,
                          child: Text(
                            item.userMessage,
                            style: TextStyle(
                              fontFamily: 'Kalameh',
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // پاسخ چت
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),  
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'پاسخ:',
                          style: TextStyle(
                            fontFamily: 'Kalameh',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: isEnglish(item.userMessage) ? TextDirection.ltr : TextDirection.rtl,
                          child: Text(
                            item.chatResponse,
                            style: TextStyle(
                              fontFamily: 'Kalameh',
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //  SizedBox(height: 4),
                  //        Text(
                  //               formatDate(item.time), // نمایش تاریخ و ساعت
                  //               style: TextStyle(color: Colors.grey, fontSize: 12),
                  //             ),
          
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item) {
    //  _context = context;  // ذخیره context
    //    final hasParentNavigation = context.findAncestorWidgetOfExactType<Scaffold>()?.bottomNavigationBar != null;
    // // final dateFormat = DateFormat('yyyy/MM/dd - HH:mm');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // تصویر
          if (item.imagePath.isNotEmpty && File(item.imagePath).existsSync())
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.file(
                File(item.imagePath),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          
          // محتوای کارت
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تاریخ و زمان
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: textColor.withOpacity(0.5)),
                    const SizedBox(width: 4),
                    Text(
                      '',
                      // dateFormat.format(DateTime.parse(item.timestamp)),
                      style: TextStyle(
                        fontFamily: 'Kalameh',
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // سوال کاربر
                Text(
                  'سوال:',
                  style: TextStyle(
                    fontFamily: 'Kalameh',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.userMessage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Kalameh',
                    color: textColor,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // پاسخ چت
                Text(
                  'پاسخ:',
                  style: TextStyle(
                    fontFamily: 'Kalameh',
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // textDirection: TextDirection.ltr,
                  item.chatResponse,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Kalameh',
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // دکمه‌های عملیاتی
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _showDetails(item),
                      child: const Text(
                        'مشاهده جزئیات',
                        style: TextStyle(fontFamily: 'Kalameh'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: errorColor,
                      ),
                      onPressed: () => _deleteItem(item.imagePath),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'تاریخچه‌ای یافت نشد',
            style: TextStyle(
              fontFamily: 'Kalameh',
              fontSize: 18,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'پردازش‌های شما اینجا نمایش داده می‌شود',
            style: TextStyle(
              fontFamily: 'Kalameh',
              fontSize: 14,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
         _context = context;  // ذخیره context
       final hasParentNavigation = context.findAncestorWidgetOfExactType<Scaffold>()?.bottomNavigationBar != null;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          //  systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarColor: Colors.green.shade50,
          //   statusBarIconBrightness: Brightness.dark,
          // ),
          title: const Text('تاریخچه پردازش‌ها', style: TextStyle(fontFamily: 'Kalameh',color: Colors.white,fontSize: 14
          )),
          backgroundColor: primaryColor,
          centerTitle: true,
          // shape: const RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(20),
          //   ),
          // ),
          actions: [
            if (items.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: _deleteAllItems,
                tooltip: 'حذف همه تاریخچه',
              ),
          ],
        ),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: primaryColor,
                  size: 80,
                ),
              )
            : items.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: items.map(_buildHistoryItem).toList(),
                    ),
                  ),
                   bottomNavigationBar: hasParentNavigation ? null : _buildBottomNavigationBar(context),
      ),
    );
  }
}

Widget _buildBottomNavigationBar(BuildContext context) {
  return Container(
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
          isActive: true,
          onTap:null,
          primaryColor: Colors.green,
        ),
        _BottomNavItem(
          icon: Icons.chat_bubble_outline,
          activeIcon: Icons.chat_rounded,
          label: 'چت',
          isActive: false, 
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ChatListPage(imagePath: '',)),
            );
          },
          primaryColor: Colors.green,
        ),
      ],
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
