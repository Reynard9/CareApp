import 'package:flutter/material.dart';

class HealthReportPage extends StatelessWidget {
  const HealthReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('건강 리포트', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 설명
            const Text(
              '최근 건강 상태와 주요 지표를 확인하세요.',
              style: TextStyle(fontSize: 16, color: Color(0xFF636E72)),
            ),
            const SizedBox(height: 20),

            // 최근 건강 상태 요약 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.health_and_safety, color: Colors.pink, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Text('최근 건강 상태', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildHealthIndicator('심박수', '72', 'BPM', Icons.favorite, Colors.red),
                  _buildHealthIndicator('혈압', '120/80', 'mmHg', Icons.speed, Colors.blue),
                  _buildHealthIndicator('체온', '36.5', '°C', Icons.thermostat, Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 건강 리포트 목록
            const Text('건강 리포트 목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            _buildReportItem(
              '주간 건강 리포트',
              '2024년 3월 2주차',
              Icons.calendar_today,
              Colors.green,
              '전반적으로 건강 상태가 양호합니다.',
            ),
            _buildReportItem(
              '월간 건강 리포트',
              '2024년 3월',
              Icons.calendar_month,
              Colors.blue,
              '규칙적인 운동과 식사가 건강에 도움이 되고 있습니다.',
            ),
            _buildReportItem(
              '건강 상담 리포트',
              '2024년 3월 15일',
              Icons.medical_services,
              Colors.purple,
              '의사 상담 결과, 현재 건강 상태는 양호합니다.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(String title, String value, String unit, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text(
                '$value $unit',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(String title, String date, IconData icon, Color color, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(date, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onPressed: () {
                  // 리포트 상세 보기
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF636E72)),
          ),
        ],
      ),
    );
  }
} 