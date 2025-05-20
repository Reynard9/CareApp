import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트

class NotificationPage extends StatelessWidget { // 알림 내역 화면 위젯
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // 전체 배경 연핑크
      appBar: AppBar(
        backgroundColor: Colors.pink[200], // 앱바 배경
        elevation: 0, // 그림자 없음
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기
          onPressed: () => Navigator.pop(context), // 뒤로가기 동작
        ),
        title: const Text('발생내역', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // 타이틀
        centerTitle: true, // 가운데 정렬
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7), // 연회색 배경
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // 위쪽만 둥글게
        ),
        padding: const EdgeInsets.all(20), // 전체 패딩
        child: ListView(
          children: [
            const Text('오늘, 5월 7일 (수)', style: TextStyle(fontWeight: FontWeight.bold)), // 날짜 구분
            const SizedBox(height: 10),
            _buildAlertCard(
              icon: 'assets/icons/warning_icon.png',
              title: '움직임 미감지',
              time: '17:11',
              status: '확인중',
            ),
            _buildAlertCard(
              icon: 'assets/icons/humidity_icon.png',
              title: '습도 80% 이상',
              time: '13:05',
              status: '확인완료',
            ),
            const SizedBox(height: 20),
            const Text('어제, 5월 6일 (화)', style: TextStyle(fontWeight: FontWeight.bold)), // 날짜 구분
            const SizedBox(height: 10),
            _buildAlertCard(
              icon: 'assets/icons/nurse_icon.png',
              title: '요양 보호사 방문 예정',
              time: '5월 6일 14:00',
              status: '확인완료',
            ),
            _buildAlertCard(
              icon: 'assets/icons/warning_icon.png',
              title: '소음 발생',
              time: '17:05',
              status: '확인완료',
            ),
            _buildAlertCard(
              icon: 'assets/icons/warning_icon.png',
              title: '소음 발생',
              time: '12:05',
              status: '확인완료',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard({ // 알림 카드 위젯
    required String icon, // 아이콘 경로
    required String title, // 제목
    required String time, // 시간
    required String status, // 상태
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // 아래 여백
      padding: const EdgeInsets.all(16), // 내부 여백
      decoration: BoxDecoration(
        color: Colors.white, // 카드 배경
        borderRadius: BorderRadius.circular(16), // 둥근 테두리
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 20), // 아이콘
              const SizedBox(width: 10), // 여백
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), // 제목
              ),
              Text(
                status, // 상태
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == '확인중' ? Colors.deepPurple : Colors.grey, // 상태별 색상
                ),
              )
            ],
          ),
          const SizedBox(height: 6), // 여백
          Text('발생시간 : $time', style: const TextStyle(fontSize: 12, color: Colors.black87)), // 시간
        ],
      ),
    );
  }
}
