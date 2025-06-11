import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:careapp5_15/models/notification.dart';

class NotificationStoreService {
  static final NotificationStoreService _instance = NotificationStoreService._internal();
  factory NotificationStoreService() => _instance;
  NotificationStoreService._internal();

  static const String _storageKey = 'notifications';
  List<NotificationModel> _notifications = [];

  // 알림 목록 가져오기
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  // 읽지 않은 알림 개수 가져오기
  int get unreadCount => _notifications.where((n) => n.status == '확인중').length;

  // 알림 저장소 초기화
  Future<void> initialize() async {
    await _loadNotifications();
  }

  // 알림 저장
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = _notifications.map((notification) => notification.toJson()).toList();
    
    await prefs.setStringList(_storageKey, notificationsJson);
  }

  // 알림 로드
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getStringList(_storageKey) ?? [];
    
    _notifications = notificationsJson.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // 새로운 알림 추가
  Future<NotificationModel> addNotification({
    required String id,
    required String title,
    required String message,
    required NotificationType type,
  }) async {
    final notification = NotificationModel(
      id: id,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );

    _notifications.insert(0, notification); // 새로운 알림을 맨 앞에 추가
    await _saveNotifications();
    return notification;
  }

  // 알림 상태 업데이트
  Future<void> updateNotificationStatus(String id, String status) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = _notifications[index];
      _notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        type: notification.type,
        status: status,
      );
      await _saveNotifications();
    }
  }

  // 알림 삭제
  Future<void> deleteNotification(int index) async {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      await _saveNotifications();
    }
  }

  Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<List<NotificationModel>> getNotifications() async {
    await _loadNotifications();
    return List.unmodifiable(_notifications);
  }
} 