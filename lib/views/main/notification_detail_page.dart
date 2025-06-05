import 'package:flutter/material.dart';
import 'notification_page.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationItem notification;
  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(notification.type);
    final icon = _getIcon(notification.type);
    final label = _getLabel(notification.type);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('알림 상세', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  '발생 시간: ${notification.time}',
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  notification.status == '확인중'
                      ? Icons.hourglass_top_rounded
                      : Icons.check_circle_rounded,
                  color: notification.status == '확인중' ? Colors.deepPurple : Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  notification.status == '확인중' ? '확인중' : '확인완료',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: notification.status == '확인중' ? Colors.deepPurple : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              '알림 상세 내용이 이곳에 표시됩니다. (추후 실제 데이터 연동)',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
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