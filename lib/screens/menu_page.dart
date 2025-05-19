import 'package:flutter/material.dart';
import 'package:careapp5_15/screens/care_schedule_page.dart'; // 요양보호사 일정 페이지 import
import 'package:careapp5_15/screens/notification_page.dart'; // 알림 페이지 import


class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(icon: Icons.chat_bubble_outline, label: '챗봇 대화하기'),
      _MenuItem(icon: Icons.history, label: '챗봇 히스토리'),
      _MenuItem(icon: Icons.insert_chart, label: '건강 리포트'),
      _MenuItem(icon: Icons.sensors, label: '센서 데이터'),
      _MenuItem(icon: Icons.calendar_today, label: '요양보호사 일정'),
      _MenuItem(icon: Icons.notifications_active, label: '알림 설정'),
      _MenuItem(icon: Icons.settings, label: '앱 설정'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.notifications_none),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationPage()),
                            );
                          }),
                      IconButton(icon: Icon(Icons.settings), onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            ListTile(
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text('김세종', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('sejong@sejong.ac.kr'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('계정 설정', style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: menuItems.map((item) => _buildMenuItem(context, item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴 카드 위젯 생성 함수
  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return GestureDetector(
      onTap: () {
        // ✅ 기능별 라우팅 구현
        if (item.label == '요양보호사 일정') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CareSchedulePage()),
          );
        }
        // TODO: 다른 기능도 필요 시 연결 추가
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 32, color: Colors.pink),
            const SizedBox(height: 8),
            Text(item.label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
