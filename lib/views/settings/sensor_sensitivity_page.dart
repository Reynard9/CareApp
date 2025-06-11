import 'package:flutter/material.dart';
import 'package:careapp5_15/services/sensor_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorSensitivityPage extends StatefulWidget {
  const SensorSensitivityPage({super.key});

  @override
  State<SensorSensitivityPage> createState() => _SensorSensitivityPageState();
}

class _SensorSensitivityPageState extends State<SensorSensitivityPage> {
  final SensorNotificationService _notificationService = SensorNotificationService();
  
  // 센서 감도 설정값
  double _temperatureMin = 18.0;
  double _temperatureMax = 28.0;
  double _humidityMin = 40.0;
  double _humidityMax = 60.0;
  double _noiseThreshold = 70.0;

  // 센서별 아이콘과 색상
  final Map<String, IconData> _sensorIcons = {
    'temperature': Icons.thermostat,
    'humidity': Icons.water_drop,
    'noise': Icons.volume_up,
  };

  final Map<String, Color> _sensorColors = {
    'temperature': const Color(0xFFFF6B6B),
    'humidity': const Color(0xFF4ECDC4),
    'noise': const Color(0xFFFFD93D),
  };

  @override
  void initState() {
    super.initState();
    _loadThresholds();
  }

  Future<void> _loadThresholds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _temperatureMin = prefs.getDouble('temperature_min') ?? 18.0;
      _temperatureMax = prefs.getDouble('temperature_max') ?? 28.0;
      _humidityMin = prefs.getDouble('humidity_min') ?? 40.0;
      _humidityMax = prefs.getDouble('humidity_max') ?? 60.0;
      _noiseThreshold = prefs.getDouble('noise_threshold') ?? 70.0;
    });
  }

  Future<void> _saveThresholds() async {
    await _notificationService.updateThresholds(
      temperatureMin: _temperatureMin,
      temperatureMax: _temperatureMax,
      humidityMin: _humidityMin,
      humidityMax: _humidityMax,
      noise: _noiseThreshold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '센서 감도 설정',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildRangeCard(
            title: '온도 범위',
            minValue: _temperatureMin,
            maxValue: _temperatureMax,
            min: 15.0,
            max: 35.0,
            unit: '°C',
            icon: _sensorIcons['temperature']!,
            color: _sensorColors['temperature']!,
            onMinChanged: (value) {
              setState(() {
                _temperatureMin = value;
                if (_temperatureMin > _temperatureMax) {
                  _temperatureMax = _temperatureMin;
                }
              });
              _saveThresholds();
            },
            onMaxChanged: (value) {
              setState(() {
                _temperatureMax = value;
                if (_temperatureMax < _temperatureMin) {
                  _temperatureMin = _temperatureMax;
                }
              });
              _saveThresholds();
            },
          ),
          const SizedBox(height: 16),
          _buildRangeCard(
            title: '습도 범위',
            minValue: _humidityMin,
            maxValue: _humidityMax,
            min: 20.0,
            max: 90.0,
            unit: '%',
            icon: _sensorIcons['humidity']!,
            color: _sensorColors['humidity']!,
            onMinChanged: (value) {
              setState(() {
                _humidityMin = value;
                if (_humidityMin > _humidityMax) {
                  _humidityMax = _humidityMin;
                }
              });
              _saveThresholds();
            },
            onMaxChanged: (value) {
              setState(() {
                _humidityMax = value;
                if (_humidityMax < _humidityMin) {
                  _humidityMin = _humidityMax;
                }
              });
              _saveThresholds();
            },
          ),
          const SizedBox(height: 16),
          _buildThresholdCard(
            title: '소음 임계값',
            value: _noiseThreshold,
            min: 30.0,
            max: 100.0,
            unit: 'dB',
            icon: _sensorIcons['noise']!,
            color: _sensorColors['noise']!,
            onChanged: (value) {
              setState(() {
                _noiseThreshold = value;
              });
              _saveThresholds();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C5CE7).withOpacity(0.1),
            const Color(0xFFA8E6CF).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6C5CE7).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF6C5CE7),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '센서 감도 설정 안내',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '각 센서의 적정 범위를 설정하여 이상 상황을 감지할 수 있습니다. 설정된 범위를 벗어나면 알림이 발송됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF636E72),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeCard({
    required String title,
    required double minValue,
    required double maxValue,
    required double min,
    required double max,
    required String unit,
    required IconData icon,
    required Color color,
    required ValueChanged<double> onMinChanged,
    required ValueChanged<double> onMaxChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '최소값',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF636E72),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: color,
                              inactiveTrackColor: color.withOpacity(0.2),
                              thumbColor: color,
                              overlayColor: color.withOpacity(0.1),
                              valueIndicatorColor: color,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            child: Slider(
                              value: minValue,
                              min: min,
                              max: max,
                              divisions: ((max - min) * 10).round(),
                              label: '${minValue.toStringAsFixed(1)}$unit',
                              onChanged: onMinChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '최대값',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF636E72),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: color,
                              inactiveTrackColor: color.withOpacity(0.2),
                              thumbColor: color,
                              overlayColor: color.withOpacity(0.1),
                              valueIndicatorColor: color,
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            child: Slider(
                              value: maxValue,
                              min: min,
                              max: max,
                              divisions: ((max - min) * 10).round(),
                              label: '${maxValue.toStringAsFixed(1)}$unit',
                              onChanged: onMaxChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '최소: ${minValue.toStringAsFixed(1)}$unit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        '최대: ${maxValue.toStringAsFixed(1)}$unit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required IconData icon,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: color,
                    inactiveTrackColor: color.withOpacity(0.2),
                    thumbColor: color,
                    overlayColor: color.withOpacity(0.1),
                    valueIndicatorColor: color,
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: ((max - min) * 10).round(),
                    label: '${value.toStringAsFixed(1)}$unit',
                    onChanged: onChanged,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '임계값: ${value.toStringAsFixed(1)}$unit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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