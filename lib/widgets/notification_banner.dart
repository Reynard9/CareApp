import 'package:flutter/material.dart';
import 'package:careapp5_15/models/notification.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:careapp5_15/services/notification_banner_service.dart';

class NotificationBanner extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onDismiss;
  final VoidCallback onClose;

  const NotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onClose,
  });

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onDismiss,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(widget.notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationIcon(widget.notification.type),
                    color: _getNotificationColor(widget.notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.notification.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: widget.onClose,
                  color: Colors.grey[400],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
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

  Color _getNotificationColor(NotificationType type) {
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