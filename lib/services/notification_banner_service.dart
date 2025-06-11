import 'package:flutter/material.dart';
import 'package:careapp5_15/models/notification.dart';
import 'package:careapp5_15/widgets/notification_banner.dart';
import 'package:careapp5_15/views/main/notification_detail_page.dart';

class NotificationBannerService {
  static final NotificationBannerService _instance = NotificationBannerService._internal();
  factory NotificationBannerService() => _instance;

  OverlayEntry? _overlayEntry;
  bool _isVisible = false;
  bool _isShowing = false;

  NotificationBannerService._internal();

  void showBanner(BuildContext context, NotificationModel notification) {
    if (_isVisible) {
      hideBanner();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: NotificationBanner(
          notification: notification,
          onDismiss: () {
            hideBanner();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationDetailPage(notification: notification),
              ),
            );
          },
          onClose: hideBanner,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
    _isShowing = true;

    Future.delayed(const Duration(seconds: 5), () {
      if (_isShowing) {
        hideBanner();
      }
    });
  }

  void hideBanner() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
    _isShowing = false;
  }
} 