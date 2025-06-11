import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:careapp5_15/views/main/notification_page.dart';

class NotificationStoreService {
  static final NotificationStoreService _instance = NotificationStoreService._internal();
  factory NotificationStoreService() => _instance;
  NotificationStoreService._internal();

  static const String _storageKey = 'notifications';
  List<NotificationItem> _notifications = [];

  // 알림 목록 가져오기
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  // 읽지 않은 알림 개수 가져오기
  int get unreadCount => _notifications.where((n) => n.status == '확인중').length;

  // 알림 저장소 초기화
  Future<void> initialize() async {
    await _loadNotifications();
  }

  // 알림 저장
  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = _notifications.map((notification) => {
      'date': notification.date.toIso8601String(),
      'type': notification.type.toString(),
      'title': notification.title,
      'time': notification.time,
      'status': notification.status,
    }).toList();
    
    await prefs.setString(_storageKey, jsonEncode(notificationsJson));
  }

  // 알림 로드
  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString(_storageKey);
    
    if (notificationsJson != null) {
      final List<dynamic> decoded = jsonDecode(notificationsJson);
      _notifications = decoded.map((item) => NotificationItem(
        date: DateTime.parse(item['date']),
        type: NotificationType.values.firstWhere(
          (e) => e.toString() == item['type'],
        ),
        title: item['title'],
        time: item['time'],
        status: item['status'],
      )).toList();
    }
  }

  // 새로운 알림 추가
  Future<void> addNotification({
    required NotificationType type,
    required String title,
    String status = '확인중',
  }) async {
    final now = DateTime.now();
    final notification = NotificationItem(
      date: now,
      type: type,
      title: title,
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      status: status,
    );

    _notifications.insert(0, notification); // 새로운 알림을 맨 앞에 추가
    await _saveNotifications();
  }

  // 알림 상태 업데이트
  Future<void> updateNotificationStatus(int index, String status) async {
    if (index >= 0 && index < _notifications.length) {
      final notification = _notifications[index];
      _notifications[index] = NotificationItem(
        date: notification.date,
        type: notification.type,
        title: notification.title,
        time: notification.time,
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
} 