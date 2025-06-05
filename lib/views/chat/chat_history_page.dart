import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/main/main_screen.dart'; // 홈 화면 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 임포트
import 'package:careapp5_15/views/menu/menu_page.dart'; // 메뉴 임포트
import 'package:careapp5_15/views/chat/chat_detail_page.dart'; // 챗봇 상세 페이지 임포트
import 'package:careapp5_15/services/api_service.dart';

class ChatHistoryPage extends StatefulWidget {
  final int deviceId;

  const ChatHistoryPage({
    super.key,
    required this.deviceId,
  });

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, String>> _chatHistory = [];

  // 더미 데이터
  final List<Map<String, String>> _dummyData = [
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

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // API에서 데이터를 가져오려고 시도
      final messages = await ApiService.getChatHistory(widget.deviceId);
      
      // API 데이터를 기존 형식으로 변환
      final formattedHistory = messages.map((msg) => {
        'date': msg.timestamp.toString().substring(0, 16),
        'title': msg.message,
      }).toList();

      setState(() {
        _chatHistory = formattedHistory;
        _isLoading = false;
      });
    } catch (e) {
      // API 호출 실패 시 더미 데이터 사용
      setState(() {
        _chatHistory = _dummyData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/careapp_logo.png', width: 100),
            Row(
              children: [
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
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        final item = _chatHistory[index];
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
                            margin: const EdgeInsets.only(bottom: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFFEEBED),
                                radius: 26,
                                child: const Icon(Icons.chat_bubble, color: Color(0xFFF06292), size: 28),
                              ),
                              title: Text(
                                item['date']!,
                                style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 28),
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