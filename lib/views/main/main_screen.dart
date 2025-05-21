import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:intl/intl.dart'; // 날짜/시간 포맷용
import 'package:careapp5_15/views/chat/chat_history_page.dart'; // 챗봇 이력 페이지 임포트

class MainScreen extends StatefulWidget { // 메인 홈 화면 위젯
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); // 상태 관리
}

class _MainScreenState extends State<MainScreen> { // 메인 홈 화면 상태
  String _currentDateTime = ''; // 현재 날짜/시간 문자열

  @override
  void initState() {
    super.initState();
    _updateDateTime(); // 날짜/시간 초기화
    Future.delayed(const Duration(minutes: 1), _updateDateTime); // 1분마다 갱신
  }

  void _updateDateTime() { // 현재 날짜/시간을 포맷팅해서 저장
    final now = DateTime.now();
    final formatter = DateFormat('yyyy년 M월 d일(E) a h:mm', 'ko_KR');
    setState(() {
      _currentDateTime = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20), // 좌우 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            SafeArea( // 상단 status bar와 겹치지 않게
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100), // 상단 로고
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}), // 검색 아이콘
                      IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationPage()), // 알림 페이지 이동
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // 여백
            const Text(
              '안녕하세요,\n김세종 보호자님!', // 인사말
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('무엇을 도와드릴까요?', style: TextStyle(fontSize: 16)), // 안내 문구
            const SizedBox(height: 12),
            _statusGroupBox([
              _statusRow('assets/icons/alert_icon.png', '현재 김세종님은 편안하신 상태에요!'), // 상태 카드
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CareSchedulePage()), // 일정 페이지 이동
                  );
                },
                child: _statusRow('assets/icons/calendar_check_icon.png', '요양 보호사 방문 일정 확인하기!'),
              ),
            ]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('스마트 홈 센서', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 센서 타이틀
                Text(_currentDateTime, style: const TextStyle(fontSize: 12, color: Colors.grey)), // 현재 날짜/시간
              ],
            ),
            const SizedBox(height: 12),
            _sensorGroupBox([
              _sensorRow('assets/icons/air_quality_icon.png', '공기질 양호'),
              _sensorRow('assets/icons/sound_icon.png', '소음 발생 없음'),
              _sensorRow('assets/icons/temp_humidity_icon.png', '온도 18°C\n습도 40%'),
            ]),
            const SizedBox(height: 24),
            const Text('최근 챗봇 이력', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 챗봇 이력 타이틀
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('어 오늘 아침 먹었어'), // 챗봇 대화 예시
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 12,
                        child: Icon(Icons.person, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '김치찌개 맛있으셨겠어요. 혹시\n요즘 스트레스를 많이 느끼시나요, 어르신?', // 챗봇 답변 예시
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusGroupBox(List<Widget> children) { // 상태 카드 그룹 박스
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF), // 연한 핑크 배경
        borderRadius: BorderRadius.circular(16), // 둥근 테두리
        border: Border.all(color: Colors.black12, width: 0.5), // 테두리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) {
            return children[index ~/ 2]; // 상태 위젯
          } else {
            return const Divider(height: 1); // 구분선
          }
        }),
      ),
    );
  }

  Widget _statusRow(String iconPath, String text) { // 상태 한 줄 위젯
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Image.asset(iconPath, width: 32, height: 32), // 아이콘
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sensorGroupBox(List<Widget> children) { // 센서 카드 그룹 박스
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) {
            return children[index ~/ 2];
          } else {
            return const Divider(height: 1);
          }
        }),
      ),
    );
  }

  Widget _sensorRow(String iconPath, String text) { // 센서 한 줄 위젯
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Image.asset(iconPath, width: 28, height: 28, color: Colors.pink), // 센서 아이콘
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}