import 'package:careapp5_15/views/main/notification_page.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

enum NotificationType {
  temperature,
  humidity,
  airQuality,
  illuminance,
  ultraviolet,
  rainfall,
  rainfallRate,
  windSpeed,
  windDirection,
  pressure,
  sound,
  unknown,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String status;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.status = '확인중',
  });

  String get time {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  String toJson() {
    return '''
    {
      "id": "$id",
      "title": "$title",
      "message": "$message",
      "timestamp": "${timestamp.toIso8601String()}",
      "type": "${type.toString().split('.').last}",
      "status": "$status"
    }
    ''';
  }

  factory NotificationModel.fromJson(String json) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(
      jsonDecode(json.replaceAll('\n', '').replaceAll('    ', '')),
    );

    return NotificationModel(
      id: data['id'] as String,
      title: data['title'] as String,
      message: data['message'] as String,
      timestamp: DateTime.parse(data['timestamp'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => NotificationType.unknown,
      ),
      status: data['status'] as String? ?? '확인중',
    );
  }
} 