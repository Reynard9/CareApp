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
        'color': const Color(0xFFFF6B6B),
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
        'color': const Color(0xFF4ECDC4),
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
        'color': const Color(0xFF6C5CE7),
        'onTap': () {},
      },
      {
        'icon': Icons.sensors,
        'title': '센서 감도 확인 및 설정',
        'subtitle': '센서 감도 조정 및 상태 확인',
        'color': const Color(0xFFFFD93D),
        'onTap': () {},
      },
      {
        'icon': Icons.calendar_today,
        'title': '요양보호사 일정',
        'subtitle': '일정과 할일을 한 번에 관리',
        'color': const Color(0xFF00B894),
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
        'color': const Color(0xFFE17055),
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
        'color': const Color(0xFF636E72),
        'onTap': () {},
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/careapp_logo.png', width: 100),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: Color(0xFF2D3436)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Color(0xFF2D3436)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, color: Color(0xFF4ECDC4), size: 38),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '김세종',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'sejong@sejong.ac.kr',
                                  style: TextStyle(
                                    color: Color(0xFF636E72),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        '서비스',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = menuItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: item['onTap'] as void Function(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: (item['color'] as Color).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF2D3436),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle'] as String,
                                        style: const TextStyle(
                                          color: Color(0xFF636E72),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: menuItems.length,
                ),
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
