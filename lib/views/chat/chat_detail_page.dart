import 'package:flutter/material.dart';
import 'package:careapp5_15/services/api_service.dart';
import 'package:careapp5_15/views/chat/chatbot_summary_report_page.dart';
import 'package:careapp5_15/views/chat/call_page.dart';

class ChatDetailPage extends StatefulWidget {
  final int deviceId;
  final int sessionId;
  final String date;
  final String title;

  const ChatDetailPage({
    super.key,
    required this.deviceId,
    required this.sessionId,
    required this.date,
    required this.title,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _messages = [];

  // 더미 대화 데이터
  final List<Map<String, dynamic>> _dummyMessages = [
    {'isUser': true, 'text': '오늘 오랜만에 운동을 좀 했어'},
    {'isUser': false, 'text': '오!'},
    {'isUser': false, 'text': '정말 멋있어요'},
    {'isUser': false, 'text': '어떤 운동을 하신 건가요?'},
    {'isUser': true, 'text': '아들을 만나 오랜만에 탁구를 쳤어\n옛날 생각도 나고 재밌더라'},
    {'isUser': false, 'text': '와 탁구 정말 재밌었겠어요'},
    {'isUser': false, 'text': '몇 분 정도 탁구를 치신건가요?'},
    {'isUser': false, 'text': '평소 운동을 좋아하시는데 예전엔 탁구 실력이 엄청나셨을거 같아요!'},
  ];

  @override
  void initState() {
    super.initState();
    _loadChatDetail();
  }

  Future<void> _loadChatDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // API에서 데이터를 가져오려고 시도
      final session = await ApiService.getChatDetail(widget.deviceId, widget.sessionId);
      
      // API 데이터를 기존 형식으로 변환
      final formattedMessages = session.chats.map((chat) => {
        'isUser': chat.role == 'user',
        'text': chat.content,
      }).toList();

      setState(() {
        _messages = formattedMessages;
        _isLoading = false;
      });
    } catch (e) {
      // API 호출 실패 시 더미 데이터 사용
      setState(() {
        _messages = _dummyMessages;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 커스텀 헤더 (뒤로가기 + 전화/영상통화)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.phone, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CallPage(elderName: '김세종'),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // 대화 내용 + 챗봇 요약 버튼을 Stack으로 감쌈
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 8),
                        child: Text(widget.date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: _messages.length,
                                itemBuilder: (context, idx) {
                                  final msg = _messages[idx];
                                  if (msg['isUser'] == true) {
                                    return Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.pink[100],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(msg['text'], style: const TextStyle(color: Colors.black, fontSize: 16)),
                                      ),
                                    );
                                  } else {
                                    // 연속된 상대방 메시지 중 마지막 한 곳에서만 프로필 이미지 표시
                                    final bool isLastOfGroup = idx == _messages.length - 1 || _messages[idx + 1]['isUser'] == true;
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (isLastOfGroup)
                                          const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            radius: 14,
                                            child: Icon(Icons.person, size: 16, color: Colors.white),
                                          )
                                        else
                                          const SizedBox(width: 28), // 프로필 이미지 자리 맞춤
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(msg['text'], style: const TextStyle(fontSize: 16)),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                  // 챗봇 요약 보고서 버튼을 오른쪽 하단에 고정
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[100],
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatbotSummaryReportPage(
                                deviceId: widget.deviceId,
                                sessionId: widget.sessionId,
                                date: widget.date,
                                title: widget.title,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.summarize, color: Colors.pink),
                        label: const Text('챗봇 요약 보고서', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 