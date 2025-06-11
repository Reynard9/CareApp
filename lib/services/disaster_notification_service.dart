import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:careapp5_15/services/notification_store_service.dart';
import 'package:careapp5_15/models/notification.dart';

class DisasterNotificationService {
  static final DisasterNotificationService _instance = DisasterNotificationService._internal();
  factory DisasterNotificationService() => _instance;
  DisasterNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final NotificationStoreService _notificationStore = NotificationStoreService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    print('재난 알림 서비스 초기화 시작');
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
      print('재난 알림 플러그인 초기화 결과: $initialized');
      
      await _notificationStore.initialize();
      _isInitialized = true;
      print('재난 알림 서비스 초기화 완료');
    } catch (e) {
      print('재난 알림 서비스 초기화 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<void> showDisasterNotification() async {
    print('재난 알림 표시 시작');
    if (!_isInitialized) {
      print('재난 알림 서비스가 초기화되지 않았습니다. 초기화를 시도합니다.');
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'disaster_channel',
        '재난 알림',
        channelDescription: '재난 및 안전 관련 알림을 제공합니다',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF4ECDC4),
        enableLights: true,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 알림 저장소에 알림 추가
      final notification = await _notificationStore.addNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '폭염주의보 발령',
        message: '현재 기온이 33도 이상으로 올라가 폭염주의보가 발령되었습니다. 실외 활동을 자제하고 충분한 수분을 섭취하세요.',
        type: NotificationType.unknown,
      );

      // 로컬 알림 표시
      await _notifications.show(
        0,
        notification.title,
        notification.message,
        details,
      );

      print('재난 알림 표시 완료');
    } catch (e) {
      print('재난 알림 표시 중 오류 발생: $e');
      rethrow;
    }
  }

  Future<void> showTemperatureNotification(double temperature) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'temperature_channel',
      '온도 알림',
      channelDescription: '온도 관련 알림을 제공합니다',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFF6B6B),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String message = '';
    if (temperature >= 33.0) {
      message = '현재 기온이 ${temperature.toStringAsFixed(1)}°C로 매우 높습니다. 실외 활동을 자제하고 충분한 수분을 섭취하세요.';
    } else if (temperature <= 18.0) {
      message = '현재 기온이 ${temperature.toStringAsFixed(1)}°C로 매우 낮습니다. 실내 온도를 적절히 조절하고 따뜻하게 지내세요.';
    }

    if (message.isNotEmpty) {
      await _notifications.show(
        1,
        '온도 알림',
        message,
        details,
      );
    }
  }

  Future<void> showHumidityNotification(double humidity) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'humidity_channel',
      '습도 알림',
      channelDescription: '습도 관련 알림을 제공합니다',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF4ECDC4),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String message = '';
    if (humidity >= 60.0) {
      message = '현재 습도가 ${humidity.toStringAsFixed(1)}%로 매우 높습니다. 실내 환기를 자주 하시고 제습기를 사용하세요.';
    } else if (humidity <= 40.0) {
      message = '현재 습도가 ${humidity.toStringAsFixed(1)}%로 매우 낮습니다. 가습기를 사용하거나 물을 자주 마시세요.';
    }

    if (message.isNotEmpty) {
      await _notifications.show(
        2,
        '습도 알림',
        message,
        details,
      );
    }
  }

  Future<void> showNoiseNotification(double noise) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'noise_channel',
      '소음 알림',
      channelDescription: '소음 관련 알림을 제공합니다',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFFFFD93D),
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (noise >= 70.0) {
      await _notifications.show(
        3,
        '소음 알림',
        '현재 소음이 ${noise.toStringAsFixed(1)}dB로 매우 높습니다. 소음의 원인을 확인하고 필요한 조치를 취하세요.',
        details,
      );
    }
  }
} 