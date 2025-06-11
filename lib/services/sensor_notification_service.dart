import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:careapp5_15/services/api_service.dart';
import 'package:careapp5_15/services/notification_store_service.dart';
import 'package:careapp5_15/services/notification_banner_service.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:careapp5_15/models/notification.dart';
import 'package:careapp5_15/services/sensor_service.dart';

class SensorNotificationService {
  static final SensorNotificationService _instance = SensorNotificationService._internal();
  factory SensorNotificationService() => _instance;

  final SensorService _sensorService;
  final NotificationBannerService _bannerService;
  final NotificationStoreService _notificationStore;
  final List<String> _excludedRoutes = [
    '/',
    '/login',
    '/name-input',
    '/qr-scan',
  ];

  SensorNotificationService._internal()
      : _sensorService = SensorService(),
        _bannerService = NotificationBannerService(),
        _notificationStore = NotificationStoreService();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
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

  Future<void> initialize(BuildContext context) async {
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

      _sensorService.temperatureStream.listen((temperature) {
        if (temperature > 30) {
          _showNotification(
            context,
            '온도 경고',
            '현재 온도가 ${temperature.toStringAsFixed(1)}°C로 높습니다.',
            NotificationType.temperature,
          );
        } else if (temperature < 10) {
          _showNotification(
            context,
            '온도 경고',
            '현재 온도가 ${temperature.toStringAsFixed(1)}°C로 낮습니다.',
            NotificationType.temperature,
          );
        }
      });

      _sensorService.humidityStream.listen((humidity) {
        if (humidity > 80) {
          _showNotification(
            context,
            '습도 경고',
            '현재 습도가 ${humidity.toStringAsFixed(1)}%로 높습니다.',
            NotificationType.humidity,
          );
        } else if (humidity < 30) {
          _showNotification(
            context,
            '습도 경고',
            '현재 습도가 ${humidity.toStringAsFixed(1)}%로 낮습니다.',
            NotificationType.humidity,
          );
        }
      });

      _sensorService.soundStream.listen((sound) {
        if (sound > 70) {
          _showNotification(
            context,
            '소음 경고',
            '현재 소음이 ${sound.toStringAsFixed(1)}dB로 높습니다.',
            NotificationType.sound,
          );
        }
      });
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
              NotificationType.temperature,
            );
          } else if (latestData > _temperatureMax) {
            print('온도 이상 감지: $latestData°C (최대값: ${_temperatureMax}°C)');
            await _showNotification(
              _monitoringContext!,
              '온도 이상',
              '현재 온도가 ${latestData.toStringAsFixed(1)}°C로 높습니다. 적정 온도는 ${_temperatureMin}~${_temperatureMax}°C입니다.',
              NotificationType.temperature,
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
              NotificationType.humidity,
            );
          } else if (latestData > _humidityMax) {
            print('습도 이상 감지: $latestData% (최대값: ${_humidityMax}%)');
            await _showNotification(
              _monitoringContext!,
              '습도 이상',
              '현재 습도가 ${latestData.toStringAsFixed(1)}%로 높습니다. 적정 습도는 ${_humidityMin}~${_humidityMax}%입니다.',
              NotificationType.humidity,
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
              NotificationType.sound,
            );
          }
        }
      }
    } catch (e) {
      print('센서 데이터 체크 중 오류 발생: $e');
    }
  }

  Future<void> _showNotification(BuildContext context, String title, String message, NotificationType type) async {
    if (_monitoringContext == null) return;

    final notification = await _notificationStore.addNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
    );

    _bannerService.showBanner(_monitoringContext!, notification);
  }

  void dispose() {
    _monitoringContext = null;
  }
} 