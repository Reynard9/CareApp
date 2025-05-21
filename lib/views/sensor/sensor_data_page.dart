import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:fl_chart/fl_chart.dart'; // 차트 라이브러리 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:intl/intl.dart'; // 날짜/시간 포맷용
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/sensor_viewmodel.dart';
import 'package:careapp5_15/models/sensor_data.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SensorDataPage extends StatelessWidget { // 센서 데이터 화면 위젯
  const SensorDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorVM = Provider.of<SensorViewModel>(context);
    final sensors = sensorVM.sensors;
    final temp = sensors[0];
    final humid = sensors[1];
    final noise = sensors[2];
    final humidityValue = humid.values.last;
    final now = DateTime.now();
    final formatter = DateFormat('yyyy년 M월 d일(E) a h:mm', 'ko_KR');
    final currentDateTime = formatter.format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF6FAF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 로고 + 검색/알림 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100),
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 1. 상단 상태 카드
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_emotions, size: 48, color: Colors.amber[600]),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        '오늘은 실내가 매우 쾌적해요! ☀️',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // 1-2. 어르신 정서 상태 카드
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Icon(Icons.favorite, size: 48, color: Colors.pink[300]),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        '현재 어르신의 정서 상태는 안정적이에요 😊',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // 2. 센서별 카드 3개
              Row(
                children: [
                  Expanded(child: _sensorCard(Icons.thermostat, '온도', '${temp.values.last.toStringAsFixed(1)}°C', '쾌적', Colors.red)),
                  const SizedBox(width: 12),
                  Expanded(child: _sensorCard(Icons.water_drop, '습도', '${humid.values.last.toStringAsFixed(0)}%', '다소 건조', Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _sensorCard(Icons.volume_up, '소음', '${noise.values.last.toStringAsFixed(1)}dB', '높은 수준', Colors.orange)),
                ],
              ),
              const SizedBox(height: 20),
              // 3. 경고 메시지(습도 게이지 위로 이동)
              const SizedBox(height: 20),
              _warningBox(),
              // 4. 습도 게이지 카드
              _humidityGaugeCard(humidityValue),
              const SizedBox(height: 20),
              // 5. 온도/소음 그래프 추가
              _thermometerGaugeCard(temp.values.last, 0, 40),
              const SizedBox(height: 16),
              _noiseLineChart(noise.values, 50, noise.values.last),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sensorCard(IconData icon, String label, String value, String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(status, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _humidityGaugeCard(double value) {
    // value: 0~100
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.water_drop, color: Colors.blue),
              SizedBox(width: 8),
              Text('습도', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        value: value,
                        color: Colors.amber[200],
                        radius: 22,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 100 - value,
                        color: Colors.grey[200],
                        radius: 22,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${value.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('건조', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('구조', style: TextStyle(color: Colors.grey)),
              Text('하이', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sensorLineChartCard(String label, String unit, List<double> data, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(label == '온도' ? Icons.device_thermostat : Icons.volume_up, color: color),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${data.last.toStringAsFixed(1)}$unit', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
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
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.2),
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

  Widget _thermometerGaugeCard(double value, double min, double max) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.device_thermostat, color: Colors.red),
              const SizedBox(width: 8),
              const Text('온도', style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${value.toStringAsFixed(1)}°C', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 60,
              height: 180,
              child: SfLinearGauge(
                minimum: min,
                maximum: max,
                orientation: LinearGaugeOrientation.vertical,
                showTicks: true,
                showLabels: true,
                axisTrackStyle: const LinearAxisTrackStyle(
                  thickness: 18,
                  edgeStyle: LinearEdgeStyle.bothCurve,
                  color: Color(0xFFF5B5B5),
                  borderColor: Colors.red,
                  borderWidth: 2,
                ),
                barPointers: [
                  LinearBarPointer(
                    value: value,
                    thickness: 18,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    color: Colors.redAccent,
                  ),
                ],
                markerPointers: [
                  LinearWidgetPointer(
                    value: value,
                    position: LinearElementPosition.cross,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${value.toStringAsFixed(1)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
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

  Widget _warningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('[주의] 최근 1시간 소음이 80 dB이상지속됨', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('창문을 닫거나 TV 볼륨을 낮춰보세요', style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noiseLineChart(List<double> data, double threshold, double currentValue) {
    final spots = List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));
    // 파란색 구간과 빨간색 구간 분리
    final blueSpots = <FlSpot>[];
    final redSpots = <FlSpot>[];
    for (var i = 0; i < spots.length; i++) {
      if (spots[i].y <= threshold) {
        blueSpots.add(spots[i]);
      } else {
        if (blueSpots.isNotEmpty && blueSpots.last.y <= threshold) {
          // 경계점 보정(선형 보간)
          final prev = spots[i - 1];
          final curr = spots[i];
          final t = (threshold - prev.y) / (curr.y - prev.y);
          final x = prev.x + (curr.x - prev.x) * t;
          blueSpots.add(FlSpot(x, threshold));
          redSpots.add(FlSpot(x, threshold));
        }
        redSpots.add(spots[i]);
      }
    }
    // 그래프 위젯
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // 카드 왼쪽 상단: 스피커 아이콘 + 소음 텍스트
          Positioned(
            top: 0,
            left: 0,
            child: Row(
              children: const [
                Icon(Icons.volume_up, color: Colors.orange, size: 22),
                SizedBox(width: 6),
                Text('소음', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, right: 0),
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 120,
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, meta) => v % 50 == 0
                            ? Text(v.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 14))
                            : const SizedBox.shrink(),
                        interval: 50,
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    if (blueSpots.isNotEmpty)
                      LineChartBarData(
                        spots: blueSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.10),
                        ),
                        dotData: FlDotData(show: false),
                      ),
                    if (redSpots.isNotEmpty)
                      LineChartBarData(
                        spots: redSpots,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.red.withOpacity(0.10),
                        ),
                        dotData: FlDotData(show: false),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // 우상단 경고 아이콘 + dB 값
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red[400], size: 22),
                const SizedBox(width: 4),
                Text(
                  '${currentValue.toStringAsFixed(1)} dB',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}