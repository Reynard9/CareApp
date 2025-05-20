import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/screens/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/screens/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/screens/sensor_data_page.dart'; // 센서 데이터 임포트
import 'package:careapp5_15/screens/menu_page.dart'; // 메뉴 임포트

class ChatHistoryPage extends StatelessWidget { // 챗봇 히스토리 확인 페이지
  const ChatHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 챗봇 히스토리 데이터
    final List<Map<String, String>> chatHistory = [
      {
        'date': '2024-12-27 03:36',
        'title': 'TV 시청과 스트레스 해소 대화',
      },
      {
        'date': '2024-11-17 12:30',
        'title': '어르신의 건강과 피로에 대한 대화',
      },
      {
        'date': '2024-11-17 12:08',
        'title': '일상적인 대화를 나누는 어르신',
      },
      {
        'date': '2024-11-17 06:55',
        'title': '일상적인 대화와 건강 상태 점검',
      },
      {
        'date': '2024-11-17 06:47',
        'title': '자연 속 산책과 가족과의 대화',
      },
      {
        'date': '2024-11-14 20:40',
        'title': '식사 사운자 간 기분과 스트레스 이야기',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: const [
                  Icon(Icons.flag, color: Colors.pink),
                  SizedBox(width: 8),
                  Text('챗봇 히스토리 확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final item = chatHistory[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['date']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 6),
                        Text(item['title']!, style: const TextStyle(fontSize: 16, color: Colors.pink, fontWeight: FontWeight.w600)),
                      ],
                    ),
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