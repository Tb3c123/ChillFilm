import 'package:flutter/material.dart';
import '../../core/utils/device_util.dart';
import '../widgets/tv_sidebar.dart';
import '../widgets/mobile_bottom_nav.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'library/library_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    DeviceUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    final isTv = DeviceUtil.isTv(context);

    // Chế độ Android TV Leanback với Sidebar
    if (isTv) {
      return Scaffold(
        backgroundColor: const Color(0xFF030508),
        body: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Row(
            children: [
              TvSidebar(
                selectedIndex: _currentIndex,
                onItemSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: _screens,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Chế độ Tablet & Mobile (Hỗ trợ Cảm ứng Touch-first toàn diện)
    return Scaffold(
      backgroundColor: const Color(0xFF030508),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MobileBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
