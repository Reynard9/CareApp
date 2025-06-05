import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:careapp5_15/services/api_service.dart';

class ElderStatusPage extends StatefulWidget {
  const ElderStatusPage({super.key});

  @override
  State<ElderStatusPage> createState() => _ElderStatusPageState();
}

class _ElderStatusPageState extends State<ElderStatusPage> {
  bool isLoading = true;
  String lastActivityTime = '';
  String currentStatus = '편안함';
  double currentTemp = 0.0;
  double currentHumidity = 0.0;
  double currentAirQuality = 0.0;
  double currentNoise = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      const deviceId = 1;
      final sensors = await ApiService.getSensorList(deviceId);
      
      if (!mounted) return;

      setState(() {
        for (var sensor in sensors) {
          if (sensor.data.isEmpty) continue;
          final rawData = sensor.data.first.data;
          final sensorType = sensor.type.toLowerCase();

          if (sensorType.contains('temp') || sensorType.contains('temperature')) {
            currentTemp = _parseSensorData(rawData);
          } else if (sensorType.contains('humid') || sensorType.contains('humidity')) {
            currentHumidity = _parseSensorData(rawData);
          } else if (sensorType.contains('sound') || sensorType.contains('noise')) {
            currentNoise = _parseSensorData(rawData);
          } else if (sensorType.contains('air') || sensorType.contains('quality')) {
            currentAirQuality = _parseSensorData(rawData);
          }
        }
        
        // 마지막 활동 시간 업데이트
        lastActivityTime = DateFormat('a h:mm', 'ko_KR').format(DateTime.now());
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('데이터를 불러오는데 실패했습니다.')),
      );
    }
  }

  double _parseSensorData(String data) {
    try {
      final cleanData = data.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleanData) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('어르신 상태'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(),
                      const SizedBox(height: 16),
                      _buildEnvironmentSection(),
                      const SizedBox(height: 16),
                      _buildActivityTimeline(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.favorite, color: Colors.green[400]),
              ),
              const SizedBox(width: 12),
              const Text(
                '현재 상태',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '김세종님은 현재 $currentStatus 상태입니다.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '마지막 활동: $lastActivityTime',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '환경 상태',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildEnvironmentCard(
          icon: Icons.device_thermostat,
          title: '온도',
          value: '${currentTemp.toStringAsFixed(1)}°C',
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        _buildEnvironmentCard(
          icon: Icons.water_drop,
          title: '습도',
          value: '${currentHumidity.toStringAsFixed(1)}%',
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildEnvironmentCard(
          icon: Icons.air,
          title: '공기질',
          value: '${currentAirQuality.toStringAsFixed(1)} ㎍/㎥',
          color: Colors.purple,
        ),
        const SizedBox(height: 8),
        _buildEnvironmentCard(
          icon: Icons.volume_up,
          title: '소음',
          value: '${currentNoise.toStringAsFixed(1)} dB',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildEnvironmentCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '오늘의 활동',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildTimelineItem(
          time: '08:00',
          title: '아침 식사',
          description: '김치찌개와 밥을 드셨습니다.',
          icon: Icons.restaurant,
        ),
        _buildTimelineItem(
          time: '09:30',
          title: '약 복용',
          description: '혈압약을 복용하셨습니다.',
          icon: Icons.medication,
        ),
        _buildTimelineItem(
          time: '11:00',
          title: '실내 운동',
          description: '스트레칭과 가벼운 운동을 하셨습니다.',
          icon: Icons.fitness_center,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String time,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue[400], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 