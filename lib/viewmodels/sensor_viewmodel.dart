import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class SensorViewModel extends ChangeNotifier {
  List<SensorData> _sensors = [
    SensorData(label: '온도', unit: '°C', values: [22, 22.1, 22.2, 22.3, 22.5, 22.7, 22.8]),
    SensorData(label: '습도', unit: '%', values: [35, 36, 37, 38, 39, 40, 41]),
    SensorData(label: '소음 정도', unit: 'dB', values: [30, 35, 40, 38, 45, 50, 48, 55, 60, 58, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110]),
  ];

  List<SensorData> get sensors => _sensors;

  // 추후 네트워크/DB 연동 시 fetch/update 메서드 추가 가능
} 