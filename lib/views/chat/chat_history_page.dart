import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/main/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 임포트
import 'package:careapp5_15/views/menu/menu_page.dart'; // 메뉴 임포트
import 'package:careapp5_15/views/chat/chat_detail_page.dart'; // 챗봇 상세 페이지 임포트

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
        'date': '2024-12-19 13:20',
        'title': '어르신의 건강과 피로에 대한 대화',
      },
      {
        'date': '2024-11-17 06:55',
        'title': '일상적인 대화와 건강 상태 점검',
      },
      {
        'date': '2024-11-16 07:47',
        'title': '자연 속 산책과 기족과의 대화',
      },
      {
        'date': '2024-11-10 10:20',
        'title': '식사 사이로 간 기분과 스트레스 이야기',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // 전체 배경 밝은 회색
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7), // AppBar 배경도 밝은 회색으로 통일
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
                  Icon(Icons.flag, color: Colors.pink), // 상단 아이콘
                  SizedBox(width: 8),
                  Text('챗봇 히스토리 확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.pink)), // 상단 제목
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // 리스트 패딩
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  final item = chatHistory[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailPage(
                            date: item['date']!,
                            title: item['title']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18), // 카드 간격
                      decoration: BoxDecoration(
                        color: Colors.white, // 카드 배경 흰색
                        borderRadius: BorderRadius.circular(20), // 모서리 둥글게
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), // 카드 내부 패딩
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFEEBED), // 연분홍 배경
                          radius: 26,
                          child: const Icon(Icons.chat_bubble, color: Color(0xFFF06292), size: 28), // 말풍선 아이콘
                        ),
                        title: Text(
                          item['date']!, // 날짜/시간
                          style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500), // 날짜 스타일
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item['title']!, // 대화 제목
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // 제목 스타일(조금 작게)
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28), // 오른쪽 화살표
                      ),
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