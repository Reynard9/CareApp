import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:table_calendar/table_calendar.dart'; // 캘린더 라이브러리 임포트

class CareSchedulePage extends StatelessWidget { // 요양보호사 일정 화면 위젯
  const CareSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      appBar: AppBar(
        title: const Text('CareApp', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // 타이틀
        backgroundColor: Colors.white, // 앱바 배경
        elevation: 0, // 그림자 없음
        leading: BackButton(color: Colors.black), // 뒤로가기
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // 전체 패딩
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            const Text('이번주 목요일에 방문 예정이에요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // 안내 문구
            const SizedBox(height: 12), // 여백

            // 캘린더
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12), // 테두리
                borderRadius: BorderRadius.circular(12), // 둥근 테두리
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1), // 시작 날짜
                lastDay: DateTime.utc(2030, 12, 31), // 끝 날짜
                focusedDay: DateTime.now(), // 오늘 날짜
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true), // 헤더 스타일
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle), // 오늘 표시
                ),
              ),
            ),

            const SizedBox(height: 20), // 여백

            // 방문 일정 카드
            Container(
              padding: const EdgeInsets.all(16), // 내부 패딩
              decoration: BoxDecoration(
                color: Colors.grey[100], // 카드 배경
                borderRadius: BorderRadius.circular(12), // 둥근 테두리
                border: Border.all(color: Colors.black12), // 테두리
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  const Text('이번주 (목)', style: TextStyle(fontWeight: FontWeight.bold)), // 요일
                  const SizedBox(height: 8), // 여백
                  Row(
                    children: const [
                      Text('방문 예정 시간', style: TextStyle(color: Colors.grey)), // 안내
                      Spacer(),
                      Text('오후 ', style: TextStyle(fontSize: 16)), // 시간
                      Text('2:30',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)), // 시간
                    ],
                  ),
                  const SizedBox(height: 8), // 여백
                  Row(
                    children: [
                      const Text('방문 예정 시간이 되면 알려드릴게요.', style: TextStyle(color: Colors.grey)), // 안내
                      const Spacer(),
                      Switch(value: true, onChanged: (v) {}), // 알림 스위치
                    ],
                  ),
                  const SizedBox(height: 12), // 여백
                  const Text('방문 예정 활동', style: TextStyle(fontWeight: FontWeight.bold)), // 안내
                  const SizedBox(height: 8), // 여백
                  Row(
                    children: [
                      _activityButton('산책 보조'), // 활동 버튼
                      const SizedBox(width: 10), // 여백
                      _activityButton('식사 준비'), // 활동 버튼
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityButton(String text) { // 활동 버튼 위젯
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100], // 버튼 배경
          foregroundColor: Colors.black, // 버튼 글씨
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // 둥근 테두리
        ),
        child: Text(text), // 버튼 텍스트
      ),
    );
  }
}
