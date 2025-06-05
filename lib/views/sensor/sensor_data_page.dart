import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:careapp5_15/services/api_service.dart';

/// 센서 데이터를 표시하는 페이지 위젯
/// 온도, 습도, 소음 데이터를 그래프로 시각화하고 실시간으로 모니터링
class SensorDataPage extends StatefulWidget {
  final int deviceId;
  
  const SensorDataPage({super.key, required this.deviceId});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  // 데이터 로딩을 위한 Future 객체
  late Future<void> _loadDataFuture;
  // 주기적인 데이터 갱신을 위한 타이머
  Timer? _timer;
  
  // 현재 센서 데이터 값들
  double temperature = 24.0;  // 온도 (섭씨)
  double humidity = 45.0;     // 습도 (%)
  double soundIn = 35.0;      // 소음 (dB)
  
  // 최근 10개의 센서 데이터를 저장하는 리스트
  List<double> temperatureData = [];
  List<double> humidityData = [];
  List<double> soundData = [];
  
  // 더미 데이터 사용 여부 플래그
  bool isUsingDummyData = false;

  /// API에서 센서 데이터를 가져오는 메서드
  Future<void> fetchSensorData() async {
    try {
      final sensors = await ApiService.getSensorList(widget.deviceId);
      
      setState(() {
        // 각 센서 데이터 처리
        for (var sensor in sensors) {
          // 데이터가 없는 경우 "데이터 없음" 표시
          if (sensor.data.isEmpty) {
            switch (sensor.type) {
              case 'temperature':
                temperature = 0;
                temperatureData = [];
                break;
              case 'humidity':
                humidity = 0;
                humidityData = [];
                break;
              case 'sound':
                soundIn = 0;
                soundData = [];
                break;
            }
            continue;
          }
          
          // 최신 데이터로 현재값 업데이트
          final latestData = double.parse(sensor.data.first.data);
          
          switch (sensor.type) {
            case 'temperature':
              temperature = latestData;
              temperatureData = sensor.data
                  .map((d) => double.parse(d.data))
                  .toList();
              break;
            case 'humidity':
              humidity = latestData;
              humidityData = sensor.data
                  .map((d) => double.parse(d.data))
                  .toList();
              break;
            case 'sound':
              soundIn = latestData;
              soundData = sensor.data
                  .map((d) => double.parse(d.data))
                  .toList();
              break;
          }
        }
        
        isUsingDummyData = false;
      });
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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        // API에서 데이터 조회
        await fetchSensorData();
      } catch (e) {
        print('Error in polling: $e');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSensorData();
    _startPolling();
  }

  Future<void> _initializeSensorData() async {
    try {
      // 초기 데이터 로드
      await fetchSensorData();
    } catch (e) {
      print('Error initializing sensor data: $e');
      _useDummyData();
    }
  }

  void _generateDummyData() {
    setState(() {
      // 온도 데이터 생성 (22-26도 범위)
      temperature = 24.0 + (DateTime.now().millisecondsSinceEpoch % 400) / 100;
      temperatureData = List.generate(10, (i) => 24.0 + (i % 4) - 1.5);

      // 습도 데이터 생성 (40-50% 범위)
      humidity = 45.0 + (DateTime.now().millisecondsSinceEpoch % 1000) / 100;
      humidityData = List.generate(10, (i) => 45.0 + (i % 10) - 5);

      // 소음 데이터 생성 (30-45dB 범위)
      soundIn = 35.0 + (DateTime.now().millisecondsSinceEpoch % 1500) / 100;
      soundData = List.generate(10, (i) => 35.0 + (i % 15) - 7.5);

      isUsingDummyData = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // 센서 데이터 수집 중지
    ApiService.stopSensorDataCollection(widget.deviceId).catchError((e) {
      print('Error stopping sensor data collection: $e');
    });
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
    // 데이터가 없는 경우 "데이터 없음" 표시
    final displayValue = value == '0.0°C' || value == '0.0%' || value == '0.0dB' 
        ? '데이터 없음' 
        : value;
    
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
          Text(
            displayValue,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: displayValue == '데이터 없음' ? Colors.grey : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayValue == '데이터 없음' ? '' : status,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 습도 게이지 카드 위젯 생성
  /// 원형 게이지로 현재 습도를 시각화
  Widget _humidityGaugeCard(double value) {
    // 데이터가 없는 경우 "데이터 없음" 표시
    if (value == 0) {
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
              child: Center(
                child: Text(
                  '데이터 없음',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
    // 데이터가 없는 경우 "데이터 없음" 표시
    if (value == 0) {
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
              children: const [
                Icon(Icons.device_thermostat, color: Colors.red),
                SizedBox(width: 8),
                Text('온도', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  '데이터 없음',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
              Icon(Icons.device_thermostat, color: Colors.red[400]),
              const SizedBox(width: 8),
              const Text('온도', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text(
                '${value.toStringAsFixed(1)}°C',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[400], fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 80,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 게이지 바(그라데이션)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ThermometerBarPainter(
                        min: min,
                        max: max,
                        value: value,
                      ),
                    ),
                  ),
                  // 눈금 및 숫자
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (i) {
                        double tickValue = max - (max - min) * i / 4;
                        return Row(
                          children: [
                            const SizedBox(width: 60),
                            Text(
                              tickValue.toInt().toString(),
                              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  // 현재 온도 마커
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 200 * (1 - (value - min) / (max - min)) - 18,
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.red[300]!, Colors.red[700]!],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
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
    // 데이터가 없는 경우 "데이터 없음" 표시
    if (data.isEmpty) {
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
              children: const [
                Icon(Icons.volume_up, color: Colors.orange),
                SizedBox(width: 8),
                Text('소음', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Center(
                child: Text(
                  '데이터 없음',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

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

// 온도 게이지 바 그리기용 커스텀 페인터
class _ThermometerBarPainter extends CustomPainter {
  final double min;
  final double max;
  final double value;
  _ThermometerBarPainter({required this.min, required this.max, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final barRect = Rect.fromLTWH(size.width / 2 - 14, 0, 28, size.height);
    final radius = Radius.circular(14);
    // 전체 바(연한 빨강)
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red[100]!, Colors.red[200]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(barRect);
    canvas.drawRRect(RRect.fromRectAndRadius(barRect, radius), bgPaint);

    // 값에 해당하는 바(진한 빨강)
    final valueHeight = ((value - min) / (max - min)).clamp(0.0, 1.0) * size.height;
    final valueRect = Rect.fromLTWH(size.width / 2 - 14, size.height - valueHeight, 28, valueHeight);
    final valuePaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red[400]!, Colors.red[700]!],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(valueRect);
    canvas.drawRRect(RRect.fromRectAndRadius(valueRect, radius), valuePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}