import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/main/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 임포트
import 'package:careapp5_15/views/chat/chat_history_page.dart'; // 챗봇 히스토리 페이지 임포트
import 'package:careapp5_15/views/care_call/care_call_schedule_page.dart'; // 정기 안부 케어콜 설정 페이지 임포트

class MenuPage extends StatelessWidget { // 메뉴 화면 위젯
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.phone_in_talk,
        'title': '정기 안부 케어콜 설정',
        'subtitle': '정기적으로 안부 전화를 예약하고 관리하세요',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CareCallSchedulePage()),
          );
        },
      },
      {
        'icon': Icons.history,
        'title': '챗봇 히스토리',
        'subtitle': '이전 대화 기록 보기',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
          );
        },
      },
      {
        'icon': Icons.insert_chart,
        'title': '건강 리포트',
        'subtitle': '건강 상태 리포트 확인',
        'onTap': () {},
      },
      {
        'icon': Icons.sensors,
        'title': '센서 감도 확인 및 설정',
        'subtitle': '센서 감도 조정 및 상태 확인',
        'onTap': () {},
      },
      {
        'icon': Icons.calendar_today,
        'title': '요양보호사 일정',
        'subtitle': '일정과 할일을 한 번에 관리',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CareSchedulePage()),
          );
        },
      },
      {
        'icon': Icons.notifications_active,
        'title': '알림 설정',
        'subtitle': '앱 알림을 관리하세요',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        },
      },
      {
        'icon': Icons.settings,
        'title': '앱 설정',
        'subtitle': '앱 환경을 설정하세요',
        'onTap': () {},
      },
    ];

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
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (context, idx) => const Divider(height: 1, indent: 24, endIndent: 24),
                itemBuilder: (context, idx) {
                  final item = menuItems[idx];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink[50],
                      child: Icon(item['icon'] as IconData, color: Colors.pink),
                    ),
                    title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['subtitle'] as String),
                    onTap: item['onTap'] as void Function(),
                  );
                },
              ),
            ),
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
