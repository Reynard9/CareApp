import 'package:flutter/material.dart';
import 'package:careapp5_15/models/notification.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 상세'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getColor(notification.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIcon(notification.type),
                    color: _getColor(notification.type),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.time,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '알림 내용',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
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
} 