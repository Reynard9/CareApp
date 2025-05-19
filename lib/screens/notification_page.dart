import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('발생내역', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text('오늘, 5월 7일 (수)', style: TextStyle(fontWeight: FontWeight.bold)),
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
            const Text('어제, 5월 6일 (화)', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildAlertCard({
    required String icon,
    required String title,
    required String time,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == '확인중' ? Colors.deepPurple : Colors.grey,
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          Text('발생시간 : $time', style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
