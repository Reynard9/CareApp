import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/screens/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/screens/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/screens/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/screens/sensor_data_page.dart'; // 센서 데이터 임포트

class MenuPage extends StatelessWidget { // 메뉴 화면 위젯
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(icon: Icons.chat_bubble_outline, label: '챗봇 대화하기'), // 챗봇 대화
      _MenuItem(icon: Icons.history, label: '챗봇 히스토리'), // 챗봇 히스토리
      _MenuItem(icon: Icons.insert_chart, label: '건강 리포트'), // 건강 리포트
      _MenuItem(icon: Icons.sensors, label: '센서 데이터'), // 센서 데이터
      _MenuItem(icon: Icons.calendar_today, label: '요양보호사 일정'), // 일정
      _MenuItem(icon: Icons.notifications_active, label: '알림 설정'), // 알림 설정
      _MenuItem(icon: Icons.settings, label: '앱 설정'), // 앱 설정
    ];

    int selectedIndex = 2; // 메뉴 인덱스
    void onNavTap(int index) {
      if (index == selectedIndex) return;
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SensorDataPage()),
        );
      } else if (index == 2) {
        // 현재 페이지이므로 아무 동작 없음
      }
    }

    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10), // 상단 여백
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100), // 상단 로고
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.notifications_none),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationPage()), // 알림 페이지 이동
                            );
                          }),
                      IconButton(icon: Icon(Icons.settings), onPressed: () {}), // 설정 아이콘
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1), // 구분선
            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white), // 프로필 아이콘
              ),
              title: const Text('김세종', style: TextStyle(fontWeight: FontWeight.bold)), // 이름
              subtitle: const Text('sejong@sejong.ac.kr'), // 이메일
              trailing: const Icon(Icons.chevron_right), // 화살표
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('계정 설정', style: TextStyle(color: Colors.blue)), // 계정 설정
              ),
            ),
            const SizedBox(height: 20), // 여백
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // 3열
                mainAxisSpacing: 16, // 세로 간격
                crossAxisSpacing: 16, // 가로 간격
                padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우 여백
                children: menuItems.map((item) => _buildMenuItem(context, item)).toList(), // 메뉴 아이템들
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) { // 메뉴 카드 위젯 생성 함수
    return GestureDetector(
      onTap: () {
        if (item.label == '요양보호사 일정') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CareSchedulePage()), // 일정 페이지 이동
          );
        }
        // TODO: 다른 기능도 필요 시 연결 추가
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink[50], // 카드 배경색
          borderRadius: BorderRadius.circular(16), // 둥근 테두리
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            Icon(item.icon, size: 32, color: Colors.pink), // 아이콘
            const SizedBox(height: 8), // 여백
            Text(item.label, textAlign: TextAlign.center), // 메뉴명
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon; // 아이콘
  final String label; // 라벨
  const _MenuItem({required this.icon, required this.label});
}
