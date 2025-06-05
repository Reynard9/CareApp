import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 센서 데이터 모델
class SensorData {
  final int id;
  final String data;
  final DateTime timestamp;

  SensorData({
    required this.id,
    required this.data,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// 센서 모델
class Sensor {
  final String dependencyType;
  final int dependencyId;
  final String name;
  final String description;
  final String model;
  final String type;
  final String dataName;
  final String dataUnit;
  final String status;
  final String protocol;
  final int id;
  final DateTime createdAt;
  final List<SensorData> data;

  Sensor({
    required this.dependencyType,
    required this.dependencyId,
    required this.name,
    required this.description,
    required this.model,
    required this.type,
    required this.dataName,
    required this.dataUnit,
    required this.status,
    required this.protocol,
    required this.id,
    required this.createdAt,
    required this.data,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      dependencyType: json['dependency_type'],
      dependencyId: json['dependency_id'],
      name: json['name'],
      description: json['description'],
      model: json['model'],
      type: json['type'],
      dataName: json['data_name'],
      dataUnit: json['data_unit'],
      status: json['status'],
      protocol: json['protocol'],
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      data: (json['data'] as List)
          .map((data) => SensorData.fromJson(data))
          .toList(),
    );
  }
}

// 챗봇 메시지 모델
class ChatMessage {
  final int id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      message: json['message'],
      isUser: json['is_user'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ApiService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api-deepcare.thedeeplabs.com';

  // 디바이스 토큰 획득
  static Future<String> getDeviceToken(String deviceToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/device/qr?device_token=$deviceToken'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get device token');
    }
  }

  // 디바이스 등록
  static Future<Map<String, dynamic>> registerDevice({
    required String type,
    required String token,
    required String version,
    required String firmware,
    required String location,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/device'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'type': type,
        'token': token,
        'version': version,
        'firmware': firmware,
        'location': location,
        'status': 'enabled',
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register device');
    }
  }

  // 디바이스 활성화
  static Future<Map<String, dynamic>> activateDevice({
    required String token,
    required String name,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/device/activate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': token,
        'name': name,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to activate device');
    }
  }

  // 디바이스 목록 조회
  static Future<List<Map<String, dynamic>>> getDeviceList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/device/list'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get device list');
    }
  }

  // 센서 목록 조회
  static Future<List<Sensor>> getSensorList(int deviceId) async {
    print('센서 데이터 요청 URL: $baseUrl/api/sensor?dependency_id=$deviceId');
    final response = await http.get(
      Uri.parse('$baseUrl/api/sensor?dependency_id=$deviceId'),
    );

    print('API 응답 상태 코드: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Sensor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get sensor list: ${response.statusCode} - ${response.body}');
    }
  }

  // 챗봇 히스토리 조회
  static Future<List<ChatMessage>> getChatHistory(int deviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/history?device_id=$deviceId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get chat history');
    }
  }

  // 챗봇 메시지 전송
  static Future<ChatMessage> sendChatMessage({
    required int deviceId,
    required String message,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'device_id': deviceId,
        'message': message,
      }),
    );

    if (response.statusCode == 201) {
      return ChatMessage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send chat message');
    }
  }

  // 센서 데이터 저장
  static Future<void> saveSensorData({
    required int sensorId,
    required String data,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sensor/data'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': sensorId,
        'data': data,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save sensor data');
    }
  }

  // 센서 데이터 조회
  static Future<List<SensorData>> getSensorData(int sensorId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/sensor/$sensorId/data'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SensorData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get sensor data');
    }
  }

  // 센서 데이터 수집 시작
  static Future<void> startSensorDataCollection(int deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sensor/start'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'device_id': deviceId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start sensor data collection');
    }
  }

  // 센서 데이터 수집 중지
  static Future<void> stopSensorDataCollection(int deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/sensor/stop'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'device_id': deviceId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to stop sensor data collection');
    }
  }
} 