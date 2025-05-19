import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // pubspec.yaml에 table_calendar 추가 필요

class CareSchedulePage extends StatelessWidget {
  const CareSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('CareApp', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이번주 목요일에 방문 예정이에요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // 캘린더
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 방문 일정 카드
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이번주 (목)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text('방문 예정 시간', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      Text('오후 ', style: TextStyle(fontSize: 16)),
                      Text('2:30',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('방문 예정 시간이 되면 알려드릴게요.', style: TextStyle(color: Colors.grey)),
                      const Spacer(),
                      Switch(value: true, onChanged: (v) {}), // 알림 스위치
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('방문 예정 활동', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _activityButton('산책 보조'),
                      const SizedBox(width: 10),
                      _activityButton('식사 준비'),
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

  Widget _activityButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text),
      ),
    );
  }
}
