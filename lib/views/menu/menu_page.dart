import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/main/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 임포트
import 'package:careapp5_15/views/care_call/care_call_schedule_page.dart'; // 정기 안부 케어콜 설정 페이지 임포트
import 'package:careapp5_15/views/settings/app_settings_page.dart'; // 앱 설정 페이지 임포트
import 'package:careapp5_15/views/settings/notification_settings_page.dart'; // 알림 설정 페이지 임포트
import 'package:careapp5_15/views/settings/sensor_sensitivity_page.dart'; // 센서 감도 설정 페이지 임포트
import 'package:careapp5_15/views/health/health_report_page.dart'; // 건강 리포트 페이지 임포트
import 'package:careapp5_15/views/profile/profile_page.dart'; // 프로필 페이지 임포트
import 'package:careapp5_15/widgets/notification_badge.dart';
import 'package:careapp5_15/services/notification_store_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final NotificationStoreService _notificationStore = NotificationStoreService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    await _notificationStore.initialize();
    if (mounted) {
      setState(() {
        _unreadCount = _notificationStore.unreadCount;
      });
    }
  }

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
        'icon': Icons.insert_chart,
        'title': '건강 리포트',
        'subtitle': '건강 상태 리포트 확인',
        'color': const Color(0xFF6C5CE7),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HealthReportPage()),
          );
        },
      },
      {
        'icon': Icons.sensors,
        'title': '센서 감도 확인 및 설정',
        'subtitle': '센서 감도 조정 및 상태 확인',
        'color': const Color(0xFFFFD93D),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SensorSensitivityPage()),
          );
        },
      },
      {
        'icon': Icons.calendar_today,
        'title': '일정 관리',
        'subtitle': '일정과 할 일을 한 번에 관리',
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
            MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
          );
        },
      },
      {
        'icon': Icons.settings,
        'title': '앱 설정',
        'subtitle': '앱 환경을 설정하세요',
        'color': const Color(0xFF636E72),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AppSettingsPage()),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/careapp_logo.png', width: 100),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.notifications_none, color: Colors.black),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const NotificationPage()),
                                      );
                                      await _loadUnreadCount();
                                    },
                                  ),
                                  if (_unreadCount > 0)
                                    Positioned(
                                      right: -4,
                                      top: -4,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          _unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.black),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AppSettingsPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        },
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
