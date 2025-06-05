import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/main_screen.dart'; // 메인 화면 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 화면 임포트
import 'package:careapp5_15/views/menu/menu_page.dart'; // 메뉴 화면 임포트
import 'package:careapp5_15/views/chat/chat_history_page.dart';

class MainWrapper extends StatefulWidget { // 하단 네비게이션 래퍼 위젯
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState(); // 상태 관리
}

class _MainWrapperState extends State<MainWrapper> { // 네비게이션 상태
  int _selectedIndex = 0; // 현재 선택된 인덱스

  final List<Widget> _pages = const [
    MainScreen(),
    SensorDataPage(deviceId: 1),
    ChatHistoryPage(deviceId: 1),
    MenuPage(),
  ];

  void _onItemTapped(int index) { // 네비게이션 탭 클릭 시
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // 현재 선택된 화면만 보여줌
        children: _pages, // 각 페이지 리스트
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 5),
              spreadRadius: 1,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: '홈',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.bar_chart_rounded,
                  label: '센서',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.chat_rounded,
                  label: '챗봇',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.menu_rounded,
                  label: '메뉴',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.pink[400] : Colors.grey[400],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.pink[400],
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
