import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TvSidebarItem {
  final IconData icon;
  final String label;
  final String route;

  const TvSidebarItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class TvSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  static const List<TvSidebarItem> items = [
    TvSidebarItem(icon: Icons.home_rounded, label: 'Trang Chủ', route: '/home'),
    TvSidebarItem(icon: Icons.search_rounded, label: 'Tìm Kiếm', route: '/search'),
    TvSidebarItem(icon: Icons.bookmark_rounded, label: 'Tủ Phim', route: '/library'),
  ];

  const TvSidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF07090E),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00E5FF), Color(0xFF008FB3)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Icon(Icons.tv_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ChillPhim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    'CINEMA TV',
                    style: TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Focus(
                  onFocusChange: (focused) {
                    if (focused) {
                      onItemSelected(index);
                    }
                  },
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.select ||
                         event.logicalKey == LogicalKeyboardKey.enter ||
                         event.logicalKey == LogicalKeyboardKey.gameButtonA ||
                         event.logicalKey == LogicalKeyboardKey.space)) {
                      onItemSelected(index);
                      FocusScope.of(context).nextFocus(); // Di chuyển focus sang vùng nội dung khi bấm OK
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Builder(builder: (context) {
                    final isFocused = Focus.of(context).hasFocus;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isFocused
                            ? const Color(0xFF00E5FF).withOpacity(0.2)
                            : isSelected
                                ? Colors.white.withOpacity(0.08)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color: isFocused || isSelected ? const Color(0xFF00E5FF) : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isFocused || isSelected ? const Color(0xFF00E5FF) : Colors.white60,
                            size: 22,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isFocused || isSelected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: isFocused || isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
