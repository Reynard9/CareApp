import 'package:flutter/material.dart';
import 'package:careapp5_15/views/chat/chatbot_summary_report_page.dart'; // 챗봇 요약 보고서 페이지 임포트
import 'package:careapp5_15/views/chat/call_page.dart';

class ChatDetailPage extends StatelessWidget {
  final String date;
  final String title;
  const ChatDetailPage({super.key, required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    // 더미 대화 데이터
    final List<Map<String, dynamic>> messages = [
      {'isUser': true, 'text': '오늘 오랜만에 운동을 좀 했어'},
      {'isUser': false, 'text': '오!'},
      {'isUser': false, 'text': '정말 멋있어요'},
      {'isUser': false, 'text': '어떤 운동을 하신 건가요?'},
      {'isUser': true, 'text': '아들을 만나 오랜만에 탁구를 쳤어\n옛날 생각도 나고 재밌더라'},
      {'isUser': false, 'text': '와 탁구 정말 재밌었겠어요'},
      {'isUser': false, 'text': '몇 분 정도 탁구를 치신건가요?'},
      {'isUser': false, 'text': '평소 운동을 좋아하시는데 예전엔 탁구 실력이 엄청나셨을거 같아요!'},
    ];

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
                        child: Text(date, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: messages.length,
                          itemBuilder: (context, idx) {
                            final msg = messages[idx];
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
                              final bool isLastOfGroup = idx == messages.length - 1 || messages[idx + 1]['isUser'] == true;
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
                              builder: (context) => ChatbotSummaryReportPage(date: date, title: title),
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