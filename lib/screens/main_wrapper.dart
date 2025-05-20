import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/screens/main_screen.dart'; // 메인 화면 임포트
import 'package:careapp5_15/screens/sensor_data_page.dart'; // 센서 데이터 화면 임포트
import 'package:careapp5_15/screens/menu_page.dart'; // 메뉴 화면 임포트
import 'package:careapp5_15/screens/chat_history_page.dart'; // 챗봇 히스토리 페이지 임포트

class MainWrapper extends StatefulWidget { // 하단 네비게이션 래퍼 위젯
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState(); // 상태 관리
}

class _MainWrapperState extends State<MainWrapper> { // 네비게이션 상태
  int _selectedIndex = 0; // 현재 선택된 인덱스

  final List<Widget> _pages = const [
    MainScreen(),         // 홈 화면
    SensorDataPage(),     // 센서 데이터
    MenuPage(),           // 메뉴
    ChatHistoryPage(),    // 챗봇 히스토리
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // 현재 선택된 인덱스
        selectedItemColor: Colors.pink, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 비선택 아이템 색상
        backgroundColor: Colors.white, // 배경색
        elevation: 8, // 그림자
        onTap: _onItemTapped, // 탭 클릭 시 함수 호출
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''), // 홈
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''), // 센서
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''), // 메뉴
        ],
      ),
    );
  }
}
