import 'package:flutter/material.dart';

class MobileBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MobileBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF07090E),
      selectedItemColor: const Color(0xFF00E5FF),
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Trang Chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Tìm Kiếm'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Tủ Phim'),
      ],
    );
  }
}
