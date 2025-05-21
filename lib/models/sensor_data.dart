class SensorData {
  final String label; // 센서명
  final String unit; // 단위
  final List<double> values; // 최근 데이터 리스트

  SensorData({required this.label, required this.unit, required this.values});
} 