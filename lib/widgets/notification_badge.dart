import 'package:flutter/material.dart';
import 'package:careapp5_15/services/notification_store_service.dart';

class NotificationBadge extends StatefulWidget {
  final Color? badgeColor;
  final Color? textColor;
  final double size;
  final VoidCallback? onTap;

  const NotificationBadge({
    super.key,
    this.badgeColor,
    this.textColor,
    this.size = 24,
    this.onTap,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  final NotificationStoreService _notificationStore = NotificationStoreService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    await _notificationStore.initialize();
    setState(() {
      _unreadCount = _notificationStore.unreadCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
        _loadUnreadCount(); // 알림 페이지로 이동할 때 카운트 갱신
      },
      child: Stack(
        children: [
          Icon(
            Icons.notifications_none,
            color: Colors.black,
            size: widget.size,
          ),
          if (_unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: widget.badgeColor ?? Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: widget.size * 0.5,
                  minHeight: widget.size * 0.5,
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: widget.size * 0.4,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 