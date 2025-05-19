import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:careapp5_15/screens/notification_page.dart'; // 알림 페이지 import


class SensorDataPage extends StatelessWidget {
  const SensorDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 로고 및 아이콘
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                      IconButton(icon: Icon(Icons.notifications_none),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const NotificationPage()),
                            );
                          }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 상태 카드 + 도넛 차트
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _statusCard(Icons.tag_faces, '최근 대화가 활발하셨어요!'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _donutChartCard(score: 85),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 섹션 타이틀
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('📊 센서 데이터 현황',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
                  Text('2025년 5월 4일(일) 오후 12:00',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),

              // 그래프 3개
              Expanded(
                child: ListView(
                  children: [
                    _sensorChart('온도', '°C', [2, 2, 2, 2, 18, 20, 22]),
                    _sensorChart('습도', '%', [28, 28, 28, 32, 32, 34, 35]),
                    _sensorChart('소음 정도', 'dB', [40, 40, 40, 55, 75, 78, 80]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 상태 카드
  Widget _statusCard(IconData? icon, String text, {String? label}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF), // 아주 연한 핑크색
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 48, color: Colors.pinkAccent.shade100),
          if (icon == null)
            Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent.shade100)),
          const SizedBox(height: 8),
          Text(label ?? text, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // 도넛 차트 카드
  Widget _donutChartCard({required int score}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: 24,
                    sections: [
                      PieChartSectionData(
                        value: score.toDouble(),
                        color: Colors.pinkAccent.shade100,
                        radius: 12,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: (100 - score).toDouble(),
                        color: Colors.pinkAccent.shade100.withOpacity(0.2),
                        radius: 12,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Text('$score점',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text('자택 쾌적도', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // 센서 그래프 카드
  Widget _sensorChart(String label, String unit, List<double> data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ${data.last}$unit',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                          (i) => FlSpot(i.toDouble(), data[i]),
                    ),
                    isCurved: true,
                    color: Colors.pinkAccent,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.pinkAccent.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}