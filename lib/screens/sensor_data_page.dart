import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:fl_chart/fl_chart.dart'; // 차트 라이브러리 임포트
import 'package:careapp5_15/screens/notification_page.dart'; // 알림 페이지 임포트
import 'package:intl/intl.dart'; // 날짜/시간 포맷용

class SensorDataPage extends StatefulWidget { // 센서 데이터 화면 위젯
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState(); // 상태 관리
}

class _SensorDataPageState extends State<SensorDataPage> { // 센서 데이터 화면 상태
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8), // 좌우/상하 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100), // 상단 로고
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.search), onPressed: () {}), // 검색 아이콘
                      IconButton(icon: Icon(Icons.notifications_none),
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
              const SizedBox(height: 16), // 여백
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _statusCard(Icons.tag_faces, '최근 대화가 활발하셨어요!'), // 상태 카드
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 140,
                      child: _donutChartCard(score: 85), // 도넛 차트 카드
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('📊 센서 데이터 현황',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)), // 센서 데이터 타이틀
                  Text(_currentDateTime,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)), // 현재 날짜/시간
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _sensorChart('온도', '°C', [2, 2, 2, 2, 18, 20, 22]), // 온도 그래프
                    _sensorChart('습도', '%', [28, 28, 28, 32, 32, 34, 35]), // 습도 그래프
                    _sensorChart('소음 정도', 'dB', [40, 40, 40, 55, 75, 78, 80]), // 소음 그래프
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard(IconData? icon, String text, {String? label}) { // 상태 카드 위젯
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF), // 아주 연한 핑크색
        borderRadius: BorderRadius.circular(16), // 둥근 테두리
        border: Border.all(color: Colors.grey.withOpacity(0.2)), // 테두리
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 48, color: Colors.pinkAccent.shade100), // 아이콘
          if (icon == null)
            Text(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pinkAccent.shade100)), // 텍스트
          const SizedBox(height: 8),
          Text(label ?? text, textAlign: TextAlign.center), // 상태 텍스트
        ],
      ),
    );
  }

  Widget _donutChartCard({required int score}) { // 도넛 차트 카드 위젯
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)), // 점수 텍스트
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Text('자택 쾌적도', style: TextStyle(fontSize: 12)), // 설명 텍스트
        ],
      ),
    );
  }

  Widget _sensorChart(String label, String unit, List<double> data) { // 센서 그래프 카드 위젯
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pinkAccent)), // 센서명 및 값
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false), // 터치 비활성화
                gridData: FlGridData(show: false), // 그리드 숨김
                titlesData: FlTitlesData(show: false), // 타이틀 숨김
                borderData: FlBorderData(show: false), // 테두리 숨김
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                          (i) => FlSpot(i.toDouble(), data[i]), // 데이터 포인트
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