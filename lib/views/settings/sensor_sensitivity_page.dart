import 'package:flutter/material.dart';

class SensorSensitivityPage extends StatefulWidget {
  const SensorSensitivityPage({super.key});

  @override
  State<SensorSensitivityPage> createState() => _SensorSensitivityPageState();
}

class _SensorSensitivityPageState extends State<SensorSensitivityPage> {
  // 센서 감도 설정값
  double _temperatureThreshold = 30.0;  // 온도 임계값
  double _humidityThreshold = 60.0;     // 습도 임계값
  double _noiseThreshold = 70.0;        // 소음 임계값
  double _motionSensitivity = 0.7;      // 동작 감지 감도
  double _lightSensitivity = 0.5;       // 조도 감지 감도

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
        children: [
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSection(
            title: '온도 센서',
            children: [
              _buildSliderItem(
                icon: Icons.thermostat,
                title: '온도 임계값',
                subtitle: '${_temperatureThreshold.toStringAsFixed(1)}°C',
                value: _temperatureThreshold,
                min: 15.0,
                max: 35.0,
                divisions: 40,
                onChanged: (value) {
                  setState(() {
                    _temperatureThreshold = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '습도 센서',
            children: [
              _buildSliderItem(
                icon: Icons.water_drop,
                title: '습도 임계값',
                subtitle: '${_humidityThreshold.toStringAsFixed(0)}%',
                value: _humidityThreshold,
                min: 30.0,
                max: 90.0,
                divisions: 60,
                onChanged: (value) {
                  setState(() {
                    _humidityThreshold = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '소음 센서',
            children: [
              _buildSliderItem(
                icon: Icons.volume_up,
                title: '소음 임계값',
                subtitle: '${_noiseThreshold.toStringAsFixed(0)}dB',
                value: _noiseThreshold,
                min: 30.0,
                max: 100.0,
                divisions: 70,
                onChanged: (value) {
                  setState(() {
                    _noiseThreshold = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '동작 감지',
            children: [
              _buildSliderItem(
                icon: Icons.directions_walk,
                title: '동작 감지 감도',
                subtitle: '${(_motionSensitivity * 100).toStringAsFixed(0)}%',
                value: _motionSensitivity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _motionSensitivity = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '조도 센서',
            children: [
              _buildSliderItem(
                icon: Icons.light_mode,
                title: '조도 감지 감도',
                subtitle: '${(_lightSensitivity * 100).toStringAsFixed(0)}%',
                value: _lightSensitivity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    _lightSensitivity = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSaveButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF2E8B84)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings_input_component,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '센서 감도 설정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '각 센서의 감도와 임계값을 조절하세요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF636E72),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF4ECDC4), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF4ECDC4),
              inactiveTrackColor: const Color(0xFF4ECDC4).withOpacity(0.2),
              thumbColor: const Color(0xFF4ECDC4),
              overlayColor: const Color(0xFF4ECDC4).withOpacity(0.1),
              valueIndicatorColor: const Color(0xFF4ECDC4),
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: subtitle,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () {
          // TODO: 설정 저장 로직 구현
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('센서 감도 설정이 저장되었습니다'),
              backgroundColor: Color(0xFF4ECDC4),
            ),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4ECDC4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '설정 저장',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 