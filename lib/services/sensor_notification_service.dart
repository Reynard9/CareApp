import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:careapp5_15/services/api_service.dart';
import 'package:careapp5_15/services/notification_store_service.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:flutter/material.dart';

class SensorNotificationService {
  static final SensorNotificationService _instance = SensorNotificationService._internal();
  factory SensorNotificationService() => _instance;
  SensorNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final NotificationStoreService _notificationStore = NotificationStoreService();
  Timer? _monitoringTimer;
  bool _isMonitoring = false;
  int _deviceId = 1; // 기본 디바이스 ID

  // 센서 임계값 기본값
  double _temperatureMin = 18.0;  // 온도 최소값
  double _temperatureMax = 28.0;  // 온도 최대값
  double _humidityMin = 40.0;     // 습도 최소값
  double _humidityMax = 60.0;     // 습도 최대값
  double _noiseThreshold = 70.0;  // 소음 임계값 (소음은 최대값만 필요)

  // 알림 채널 ID
  static const String _channelId = 'sensor_alerts';
  static const String _channelName = '센서 알림';
  static const String _channelDescription = '센서 데이터 이상 감지 시 알림';

  BuildContext? _monitoringContext;

  Future<void> initialize() async {
    print('알림 서비스 초기화 시작');
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notifications.initialize(initSettings);
      print('알림 플러그인 초기화 결과: $initialized');
      
      await _loadThresholds();
      print('알림 서비스 초기화 완료');
    } catch (e) {
      print('알림 서비스 초기화 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<void> _loadThresholds() async {
    final prefs = await SharedPreferences.getInstance();
    _temperatureMin = prefs.getDouble('temperature_min') ?? 18.0;
    _temperatureMax = prefs.getDouble('temperature_max') ?? 28.0;
    _humidityMin = prefs.getDouble('humidity_min') ?? 40.0;
    _humidityMax = prefs.getDouble('humidity_max') ?? 60.0;
    _noiseThreshold = prefs.getDouble('noise_threshold') ?? 70.0;
    print('임계값 로드 완료: 온도(${_temperatureMin}~${_temperatureMax}°C), 습도(${_humidityMin}~${_humidityMax}%), 소음(${_noiseThreshold}dB)');
  }

  Future<void> updateThresholds({
    double? temperatureMin,
    double? temperatureMax,
    double? humidityMin,
    double? humidityMax,
    double? noise,
  }) async {
    if (temperatureMin != null) _temperatureMin = temperatureMin;
    if (temperatureMax != null) _temperatureMax = temperatureMax;
    if (humidityMin != null) _humidityMin = humidityMin;
    if (humidityMax != null) _humidityMax = humidityMax;
    if (noise != null) _noiseThreshold = noise;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('temperature_min', _temperatureMin);
    await prefs.setDouble('temperature_max', _temperatureMax);
    await prefs.setDouble('humidity_min', _humidityMin);
    await prefs.setDouble('humidity_max', _humidityMax);
    await prefs.setDouble('noise_threshold', _noiseThreshold);
    print('임계값 업데이트 완료: 온도(${_temperatureMin}~${_temperatureMax}°C), 습도(${_humidityMin}~${_humidityMax}%), 소음(${_noiseThreshold}dB)');
  }

  Future<void> startMonitoring(BuildContext context) async {
    print('센서 모니터링 시작');
    _isMonitoring = true;
    _monitoringContext = context;
    
    while (_isMonitoring) {
      await _checkSensorData();
      await Future.delayed(const Duration(minutes: 1));
    }
  }

  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    print('센서 모니터링 중지');
  }

  Future<void> _checkSensorData() async {
    if (_monitoringContext == null) {
      print('모니터링 컨텍스트가 없습니다.');
      return;
    }

    try {
      print('센서 데이터 체크 시작');
      print('현재 임계값: 온도(${_temperatureMin}~${_temperatureMax}°C), 습도(${_humidityMin}~${_humidityMax}%), 소음(${_noiseThreshold}dB)');
      
      final sensors = await ApiService.getSensorList(_deviceId);
      print('조회된 센서 수: ${sensors.length}');
      
      for (var sensor in sensors) {
        if (sensor.data.isEmpty) {
          print('${sensor.type} 센서에 데이터가 없습니다.');
          continue;
        }
        
        final latestData = double.parse(sensor.data.first.data);
        final sensorType = sensor.type.toLowerCase();
        print('센서 정보:');
        print('- 타입: ${sensor.type}');
        print('- 데이터: $latestData');
        print('- 단위: ${sensor.dataUnit}');
        
        // 온도 센서 체크
        if (sensorType.contains('temp') || sensorType.contains('temperature')) {
          print('온도 센서 체크: $latestData°C');
          if (latestData < _temperatureMin) {
            print('온도 이상 감지: $latestData°C (최소값: ${_temperatureMin}°C)');
            await _showNotification(
              _monitoringContext!,
              '온도 이상',
              '현재 온도가 ${latestData.toStringAsFixed(1)}°C로 낮습니다. 적정 온도는 ${_temperatureMin}~${_temperatureMax}°C입니다.',
              NotificationType.environment,
            );
          } else if (latestData > _temperatureMax) {
            print('온도 이상 감지: $latestData°C (최대값: ${_temperatureMax}°C)');
            await _showNotification(
              _monitoringContext!,
              '온도 이상',
              '현재 온도가 ${latestData.toStringAsFixed(1)}°C로 높습니다. 적정 온도는 ${_temperatureMin}~${_temperatureMax}°C입니다.',
              NotificationType.environment,
            );
          }
        }
        // 습도 센서 체크
        else if (sensorType.contains('humid') || sensorType.contains('humidity')) {
          print('습도 센서 체크: $latestData%');
          if (latestData < _humidityMin) {
            print('습도 이상 감지: $latestData% (최소값: ${_humidityMin}%)');
            await _showNotification(
              _monitoringContext!,
              '습도 이상',
              '현재 습도가 ${latestData.toStringAsFixed(1)}%로 낮습니다. 적정 습도는 ${_humidityMin}~${_humidityMax}%입니다.',
              NotificationType.environment,
            );
          } else if (latestData > _humidityMax) {
            print('습도 이상 감지: $latestData% (최대값: ${_humidityMax}%)');
            await _showNotification(
              _monitoringContext!,
              '습도 이상',
              '현재 습도가 ${latestData.toStringAsFixed(1)}%로 높습니다. 적정 습도는 ${_humidityMin}~${_humidityMax}%입니다.',
              NotificationType.environment,
            );
          }
        }
        // 소음 센서 체크
        else if (sensorType.contains('sound') || sensorType.contains('noise')) {
          print('소음 센서 체크: $latestData dB');
          if (latestData > _noiseThreshold) {
            print('소음 이상 감지: $latestData dB (임계값: ${_noiseThreshold} dB)');
            await _showNotification(
              _monitoringContext!,
              '소음 이상',
              '현재 소음이 ${latestData.toStringAsFixed(1)}dB로 높습니다. 적정 소음은 ${_noiseThreshold}dB 이하입니다.',
              NotificationType.environment,
            );
          }
        }
      }
    } catch (e) {
      print('센서 데이터 체크 중 오류 발생: $e');
    }
  }

  Future<void> _showNotification(BuildContext context, String title, String body, NotificationType type) async {
    print('알림 발송 시도: $title - $body');
    try {
      // 로컬 알림 표시
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecond,
        title,
        body,
        details,
      );

      // 알림 저장소에 알림 추가
      await _notificationStore.addNotification(
        type: type,
        title: title,
      );

      print('알림 발송 성공');
    } catch (e) {
      print('알림 발송 중 오류 발생: $e');
    }
  }
} 