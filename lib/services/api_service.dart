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
  final int sessionId;
  final int userId;
  final int idx;
  final String role;
  final String content;
  final String? emotion;
  final bool end;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.idx,
    required this.role,
    required this.content,
    this.emotion,
    required this.end,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sessionId: json['session_id'],
      userId: json['user_id'],
      idx: json['idx'],
      role: json['role'],
      content: json['content'],
      emotion: json['emotion'],
      end: json['end'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// 챗봇 세션 모델
class ChatSession {
  final int id;
  final int eventId;
  final int userId;
  final String title;
  final String context;
  final List<String> keywords;
  final List<ChatMessage> chats;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.title,
    required this.context,
    required this.keywords,
    required this.chats,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      eventId: json['event_id'],
      userId: json['user_id'],
      title: json['title'],
      context: json['context'],
      keywords: List<String>.from(json['keywords']),
      chats: (json['chats'] as List).map((chat) => ChatMessage.fromJson(chat)).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class SelectionItem {
  final String type;
  final String displayName;
  final bool good;
  final bool average;
  final bool poor;

  SelectionItem({
    required this.type,
    required this.displayName,
    required this.good,
    required this.average,
    required this.poor,
  });

  factory SelectionItem.fromJson(Map<String, dynamic> json) {
    return SelectionItem(
      type: json['type'],
      displayName: json['display_name'],
      good: json['good'],
      average: json['average'],
      poor: json['poor'],
    );
  }

  String get statusValue {
    if (good) return '양호';
    if (average) return '보통';
    if (poor) return '없음';
    return '없음';
  }
}

class DiseaseSummary {
  final String disease;
  final String cause;
  final String prevention;
  final String source;

  DiseaseSummary({
    required this.disease,
    required this.cause,
    required this.prevention,
    required this.source,
  });

  factory DiseaseSummary.fromJson(Map<String, dynamic> json) {
    return DiseaseSummary(
      disease: json['disease'],
      cause: json['cause'],
      prevention: json['prevention'],
      source: json['source'],
    );
  }
}

class ChatSummary {
  final int sessionId;
  final int userId;
  final String type;
  final int date;
  final int duration;
  final List<SelectionItem> selection;
  final String? deviceSummary;
  final DiseaseSummary? diseaseSummary;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSummary({
    required this.sessionId,
    required this.userId,
    required this.type,
    required this.date,
    required this.duration,
    required this.selection,
    this.deviceSummary,
    this.diseaseSummary,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    return ChatSummary(
      sessionId: json['session_id'],
      userId: json['user_id'],
      type: json['type'],
      date: json['date'],
      duration: json['duration'],
      selection: (json['selection'] as List)
          .map((e) => SelectionItem.fromJson(e))
          .toList(),
      deviceSummary: json['device_summary'],
      diseaseSummary: json['disease_summary'] != null
          ? DiseaseSummary.fromJson(json['disease_summary'])
          : null,
      summary: json['summary'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // 카드에 표시할 값 추출 (없음이면 제외)
  Map<String, String> get status {
    final map = <String, String>{};
    for (final item in selection) {
      final value = item.statusValue;
      if (value != '없음') {
        map[item.displayName] = value;
      }
    }
    return map;
  }

  // 분석/조언 등 텍스트 추출
  Map<String, String> get analysis {
    final map = <String, String>{};
    if (summary != null) map['상담 요약'] = summary!;
    if (deviceSummary != null) map['IoT 센서 요약'] = deviceSummary!;
    if (diseaseSummary != null) {
      map['질환 정보'] = diseaseSummary!.disease;
      map['질환 원인'] = diseaseSummary!.cause;
      map['예방 및 관리'] = diseaseSummary!.prevention;
    }
    return map;
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'https://api-deepcare.thedeeplabs.com';
  static int get sessionId => int.tryParse(dotenv.env['SESSION_ID'] ?? '39') ?? 39;

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

  // 센서 데이터 조회 메서드
  static Future<List<Sensor>> getSensorList(int deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sensor?dependency_id=$deviceId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Sensor.fromJson(json)).toList();
      } else {
        print('센서 데이터 조회 실패: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('센서 데이터 조회 중 오류 발생: $e');
      return [];
    }
  }

  // 챗봇 세션 목록 조회
  static Future<List<ChatSession>> getChatHistory(int deviceId) async {
    print('[CHAT] 챗봇 세션 목록 요청 URL: $baseUrl/api/chat/sessions?device_id=$deviceId');
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/sessions?device_id=$deviceId'),
    );

    print('[CHAT] API 응답 상태 코드: ${response.statusCode}');
    print('[CHAT] API 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatSession.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('챗봇 세션 API 엔드포인트를 찾을 수 없습니다. 백엔드 개발자에게 문의해주세요.');
    } else {
      throw Exception('Failed to get chat sessions: ${response.statusCode} - ${response.body}');
    }
  }

  // 최근 대화 내역 조회 (메인 페이지용)
  static Future<List<ChatSession>> getLatestChatSessions(int deviceId) async {
    print('[CHAT] 최근 대화 내역 요청 URL: $baseUrl/api/chat/sessions?device_id=$deviceId&is_latest=true');
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/sessions?device_id=$deviceId&is_latest=true'),
    );

    print('[CHAT] API 응답 상태 코드: ${response.statusCode}');
    print('[CHAT] API 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ChatSession.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('최근 대화 내역 API 엔드포인트를 찾을 수 없습니다. 백엔드 개발자에게 문의해주세요.');
    } else {
      throw Exception('Failed to get latest chat sessions: ${response.statusCode} - ${response.body}');
    }
  }

  // 챗봇 상세 대화 조회
  static Future<ChatSession> getChatDetail(int deviceId, int sessionId) async {
    print('[CHAT] 챗봇 상세 대화 요청 URL: $baseUrl/api/chat/sessions/$sessionId?device_id=$deviceId');
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/sessions/$sessionId?device_id=$deviceId'),
    );

    print('[CHAT] API 응답 상태 코드: ${response.statusCode}');
    print('[CHAT] API 응답 내용: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ChatSession.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('챗봇 상세 대화 API 엔드포인트를 찾을 수 없습니다. 백엔드 개발자에게 문의해주세요.');
    } else {
      throw Exception('Failed to get chat detail: ${response.statusCode} - ${response.body}');
    }
  }

  // 챗봇 메시지 전송
  static Future<ChatMessage> sendChatMessage({
    required int deviceId,
    required String message,
  }) async {
    print('[CHAT] 챗봇 메시지 전송 요청 URL: $baseUrl/api/chat/send');
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'device_id': deviceId,
        'message': message,
      }),
    );

    print('[CHAT] API 응답 상태 코드: ${response.statusCode}');
    print('[CHAT] API 응답 내용: ${response.body}');

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

  // 챗봇 요약 보고서 조회
  static Future<ChatSummary> getChatSummary(int deviceId, int sessionId) async {
    try {
      print('[CHAT] 챗봇 요약 보고서 요청 URL: $baseUrl/api/report/sessions/$sessionId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/report/sessions/$sessionId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[CHAT] API 응답 상태 코드: ${response.statusCode}');
      print('[CHAT] API 응답 내용: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatSummary.fromJson(data);
      } else {
        throw Exception('Failed to load chat summary: ${response.statusCode}');
      }
    } catch (e) {
      print('[CHAT] 챗봇 요약 보고서 요청 실패: $e');
      throw Exception('Failed to load chat summary: $e');
    }
  }
} 