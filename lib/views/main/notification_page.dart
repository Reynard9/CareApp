import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:intl/intl.dart';
import 'package:careapp5_15/services/notification_store_service.dart';
import 'package:careapp5_15/models/notification.dart';
import 'notification_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationStoreService _notificationStore = NotificationStoreService();
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _notificationStore.getNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '오늘';
    } else if (difference.inDays == 1) {
      return '어제';
    } else {
      return '${date.year}년 ${date.month}월 ${date.day}일';
    }
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _formatDate(date),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.temperature:
        return Icons.thermostat;
      case NotificationType.humidity:
        return Icons.water_drop;
      case NotificationType.airQuality:
        return Icons.air;
      case NotificationType.illuminance:
        return Icons.light_mode;
      case NotificationType.ultraviolet:
        return Icons.wb_sunny;
      case NotificationType.rainfall:
        return Icons.grain;
      case NotificationType.rainfallRate:
        return Icons.water;
      case NotificationType.windSpeed:
        return Icons.air;
      case NotificationType.windDirection:
        return Icons.explore;
      case NotificationType.pressure:
        return Icons.speed;
      case NotificationType.sound:
        return Icons.volume_up;
      case NotificationType.unknown:
        return Icons.notifications;
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.temperature:
        return Colors.red;
      case NotificationType.humidity:
        return Colors.blue;
      case NotificationType.airQuality:
        return Colors.green;
      case NotificationType.illuminance:
        return Colors.amber;
      case NotificationType.ultraviolet:
        return Colors.purple;
      case NotificationType.rainfall:
        return Colors.blue;
      case NotificationType.rainfallRate:
        return Colors.blue;
      case NotificationType.windSpeed:
        return Colors.cyan;
      case NotificationType.windDirection:
        return Colors.cyan;
      case NotificationType.pressure:
        return Colors.orange;
      case NotificationType.sound:
        return Colors.pink;
      case NotificationType.unknown:
        return Colors.grey;
    }
  }

  String _getLabel(NotificationType type) {
    switch (type) {
      case NotificationType.temperature:
        return '온도';
      case NotificationType.humidity:
        return '습도';
      case NotificationType.airQuality:
        return '공기질';
      case NotificationType.illuminance:
        return '조도';
      case NotificationType.ultraviolet:
        return '자외선';
      case NotificationType.rainfall:
        return '강수량';
      case NotificationType.rainfallRate:
        return '강수확률';
      case NotificationType.windSpeed:
        return '풍속';
      case NotificationType.windDirection:
        return '풍향';
      case NotificationType.pressure:
        return '기압';
      case NotificationType.sound:
        return '소음';
      case NotificationType.unknown:
        return '알림';
    }
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
                  final showDateHeader = index == 0 ||
                      !_isSameDay(
                        _notifications[index - 1].timestamp,
                        notification.timestamp,
                      );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        _buildDateHeader(notification.timestamp),
                      _buildAlertCard(context, notification),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, NotificationModel notification) {
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
}
