import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 센서 데이터를 표시하는 페이지 위젯
/// 온도, 습도, 소음 데이터를 그래프로 시각화하고 실시간으로 모니터링
class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  // 데이터 로딩을 위한 Future 객체
  late Future<void> _loadDataFuture;
  // 주기적인 데이터 갱신을 위한 타이머
  Timer? _timer;
  
  // 현재 센서 데이터 값들 (더미 데이터로 초기화)
  double temperature = 24.0;  // 온도 (섭씨)
  double humidity = 45.0;     // 습도 (%)
  double soundIn = 35.0;      // 소음 (dB)
  
  // 최근 10개의 센서 데이터를 저장하는 리스트 (더미 데이터로 초기화)
  List<double> temperatureData = [24.0, 25.0, 24.0, 23.0, 24.0, 25.0, 26.0, 25.0, 24.0, 24.0];
  List<double> humidityData = [45.0, 46.0, 47.0, 45.0, 44.0, 45.0, 46.0, 45.0, 44.0, 45.0];
  List<double> soundData = [35.0, 40.0, 38.0, 42.0, 35.0, 37.0, 39.0, 36.0, 38.0, 35.0];
  
  // 더미 데이터 사용 여부 플래그
  bool isUsingDummyData = false;

  /// API에서 센서 데이터를 가져오는 메서드
  Future<void> fetchSensorData() async {
    try {
      // 환경 변수에서 API URL 가져오기
      final url = Uri.parse(dotenv.env['API_SENSOR_URL']!);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 응답 데이터 파싱
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('Sensor Data: $data');

        setState(() {
          // 센서 데이터 업데이트
          temperature = (data[0]['data']['temperature']['in'] as num).toDouble();
          humidity = (data[0]['data']['humidty']['in'] as num).toDouble();
          soundIn = (data[0]['data']['sound_in'] as num).toDouble();

          // 데이터 리스트 관리 (최대 10개 유지)
          if (temperatureData.length > 10) {
            temperatureData.removeAt(0);
            humidityData.removeAt(0);
            soundData.removeAt(0);
          }
          
          // 새로운 데이터 추가
          temperatureData.add(temperature);
          humidityData.add(humidity);
          soundData.add(soundIn);
          isUsingDummyData = false;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        _useDummyData();
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      _useDummyData();
    }
  }

  /// API 호출 실패 시 더미 데이터를 사용하는 메서드
  void _useDummyData() {
    if (!isUsingDummyData) {
      setState(() {
        // 더미 데이터로 업데이트
        temperature = 24.0;
        humidity = 45.0;
        soundIn = 35.0;
        
        // 더미 데이터 리스트 업데이트
        temperatureData = [24.0, 25.0, 24.0, 23.0, 24.0, 25.0, 26.0, 25.0, 24.0, 24.0];
        humidityData = [45.0, 46.0, 47.0, 45.0, 44.0, 45.0, 46.0, 45.0, 44.0, 45.0];
        soundData = [35.0, 40.0, 38.0, 42.0, 35.0, 37.0, 39.0, 36.0, 38.0, 35.0];
        
        isUsingDummyData = true;
      });
    }
  }

 /// 주기적으로 센서 데이터를 갱신하는 타이머 시작
  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchSensorData();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/careapp_logo.png', width: 100),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.black),
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  // 더미 데이터 사용 시 경고 메시지
              if (isUsingDummyData)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[800]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '센서 데이터를 불러오는 중입니다. 현재 더미 데이터가 표시됩니다.',
                          style: TextStyle(color: Colors.orange[800]),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
                  
                  // 1. 상단 상태 카드 - 실내 환경 상태 표시
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
                  
                  // 2. 센서별 카드 3개 - 온도, 습도, 소음 현재값 표시
              Row(
                children: [
                  Expanded(child: _sensorCard(Icons.thermostat, '온도', '${temperature.toStringAsFixed(1)}°C', '쾌적', Colors.red)),
                  const SizedBox(width: 12),
                  Expanded(child: _sensorCard(Icons.water_drop, '습도', '${humidity.toStringAsFixed(0)}%', '다소 건조', Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _sensorCard(Icons.volume_up, '소음', '${soundIn.toStringAsFixed(1)}dB', '높은 수준', Colors.orange)),
                ],
              ),
              const SizedBox(height: 20),
                  
                  // 3. 경고 메시지 - 소음 주의 표시
              const SizedBox(height: 20),
              _warningBox(),
                  
                  // 4. 습도 게이지 카드 - 원형 게이지로 습도 표시
              _humidityGaugeCard(humidity),
              const SizedBox(height: 20),
                  
                  // 5. 온도/소음 그래프 - 온도 게이지와 소음 라인 차트
              _thermometerGaugeCard(temperature, 0, 40),
              const SizedBox(height: 16),
              _noiseLineChart(soundData, 50, soundIn),
            ],
          ),
        ),
          ),
        ],
      ),
    );
  }

  /// 센서 카드 위젯 생성
  /// 각 센서의 현재값과 상태를 표시하는 카드
  /// @param icon - 센서 종류를 나타내는 아이콘 (예: 온도계, 물방울, 스피커)
  /// @param label - 센서의 이름 (예: '온도', '습도', '소음')
  /// @param value - 현재 측정값 (예: '24.5°C', '45%', '35.0dB')
  /// @param status - 현재 상태 설명 (예: '쾌적', '다소 건조', '높은 수준')
  /// @param color - 카드의 테마 색상 (예: 빨간색, 파란색, 주황색)
  Widget _sensorCard(IconData icon, String label, String value, String status, Color color) {
    return Container(                                                     // 카드의 외부 컨테이너
      padding: const EdgeInsets.symmetric(vertical: 20),                  // 상하 20픽셀의 내부 여백
      decoration: BoxDecoration(                                          // 카드의 시각적 스타일
        color: Colors.white,                                              // 흰색 배경
        borderRadius: BorderRadius.circular(18),                          // 18픽셀의 둥근 모서리
      ),
      child: Column(                                                     // 세로 방향으로 요소들을 배치
        mainAxisAlignment: MainAxisAlignment.center,                      // 세로 중앙 정렬
        children: [
          Icon(icon, color: color, size: 28),                            // 센서 아이콘 (28픽셀 크기)
          const SizedBox(height: 8),                                      // 8픽셀 간격
          Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87)),  // 센서 이름 (15픽셀 크기)
          const SizedBox(height: 8),                                      // 8픽셀 간격
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),  // 측정값 (22픽셀 크기, 굵게)
          const SizedBox(height: 4),                                      // 4픽셀 간격
          Text(status, style: const TextStyle(fontSize: 13, color: Colors.grey)),  // 상태 텍스트 (13픽셀 크기, 회색)
        ],
      ),
    );
  }

  /// 습도 게이지 카드 위젯 생성
  /// 원형 게이지로 현재 습도를 시각화
  Widget _humidityGaugeCard(double value) {
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
                // 원형 게이지 차트
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
                // 중앙 값 표시
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

  /// 센서 라인 차트 카드 위젯 생성
  /// 시간에 따른 센서 데이터 변화를 라인 차트로 표시
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

  /// 온도 게이지 카드 위젯 생성
  /// 수직 게이지로 현재 온도를 시각화
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

  /// 경고 메시지 박스 위젯 생성
  /// 소음 수준이 높을 때 경고 메시지 표시
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

  /// 소음 라인 차트 위젯 생성
  /// 시간에 따른 소음 데이터를 라인 차트로 표시하고 임계값을 기준으로 색상 구분
  Widget _noiseLineChart(List<double> data, double threshold, double currentValue) {
    // 데이터 포인트 생성
    final spots = List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));
    
    // 임계값을 기준으로 파란색(정상)과 빨간색(주의) 구간 분리
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
                    // 정상 구간 (파란색)
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
                    // 주의 구간 (빨간색)
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