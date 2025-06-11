import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:intl/intl.dart';
import 'package:careapp5_15/services/notification_store_service.dart';
import 'notification_detail_page.dart';

enum NotificationType {
  todo,
  schedule,
  disaster,
  environment,
  carecall,
}

class NotificationItem {
  final DateTime date;
  final NotificationType type;
  final String title;
  final String time;
  final String status;

  NotificationItem({
    required this.date,
    required this.type,
    required this.title,
    required this.time,
    required this.status,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationStoreService _notificationStore = NotificationStoreService();
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await _notificationStore.initialize();
    setState(() {
      _notifications = _notificationStore.notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50], // 전체 배경 연핑크
      appBar: AppBar(
        backgroundColor: Colors.pink[200], // 앱바 배경
        elevation: 0, // 그림자 없음
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 뒤로가기
          onPressed: () => Navigator.pop(context), // 뒤로가기 동작
        ),
        title: const Text('발생내역', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // 타이틀
        centerTitle: true, // 가운데 정렬
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7), // 연회색 배경
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // 위쪽만 둥글게
        ),
        padding: const EdgeInsets.all(20), // 전체 패딩
        child: _notifications.isEmpty
            ? const Center(
                child: Text(
                  '알림이 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  final isNewDay = index == 0 ||
                      !_isSameDay(_notifications[index - 1].date, notification.date);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNewDay) ...[
                        const SizedBox(height: 16),
                        _buildDateHeader(notification.date),
                        const SizedBox(height: 10),
                      ],
                      _buildAlertCard(context, notification),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    String dateText;
    if (_isSameDay(date, now)) {
      dateText = '오늘';
    } else if (_isSameDay(date, yesterday)) {
      dateText = '어제';
    } else {
      dateText = DateFormat('M월 d일 (E)', 'ko_KR').format(date);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        dateText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, NotificationItem notification) {
    final iconData = _getIcon(notification.type);
    final color = _getColor(notification.type);
    final label = _getLabel(notification.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationDetailPage(notification: notification),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            notification.time,
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.todo:
        return Icons.check_circle_rounded;
      case NotificationType.schedule:
        return Icons.event_note_rounded;
      case NotificationType.disaster:
        return Icons.warning_amber_rounded;
      case NotificationType.environment:
        return Icons.eco_rounded;
      case NotificationType.carecall:
        return Icons.phone_in_talk_rounded;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.todo:
        return Colors.blueAccent;
      case NotificationType.schedule:
        return Colors.teal;
      case NotificationType.disaster:
        return Colors.redAccent;
      case NotificationType.environment:
        return Colors.orangeAccent;
      case NotificationType.carecall:
        return Colors.purple;
    }
  }

  String _getLabel(NotificationType type) {
    switch (type) {
      case NotificationType.todo:
        return '할일';
      case NotificationType.schedule:
        return '일정';
      case NotificationType.disaster:
        return '재난';
      case NotificationType.environment:
        return '환경';
      case NotificationType.carecall:
        return '케어콜';
    }
  }
}
