import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:careapp5_15/services/disaster_notification_service.dart';

class DeveloperModePage extends StatefulWidget {
  const DeveloperModePage({super.key});

  @override
  State<DeveloperModePage> createState() => _DeveloperModePageState();
}

class _DeveloperModePageState extends State<DeveloperModePage> {
  final DisasterNotificationService _notificationService = DisasterNotificationService();
  bool _isNotificationScheduled = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeNotificationService();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _initializeNotificationService() async {
    try {
      print('개발자 모드: 알림 서비스 초기화 시작');
      await _notificationService.initialize();
      print('개발자 모드: 알림 서비스 초기화 완료');
    } catch (e) {
      print('개발자 모드: 알림 서비스 초기화 중 오류 발생: $e');
    }
  }

  Future<void> _triggerDisasterNotification() async {
    if (!_isNotificationScheduled) {
      if (mounted) {
        setState(() {
          _isNotificationScheduled = true;
        });
      }
      
      try {
        print('개발자 모드: 재난 알림 트리거 시작');
        await _notificationService.showDisasterNotification();
        print('개발자 모드: 재난 알림 트리거 완료');
      } catch (e) {
        print('개발자 모드: 재난 알림 트리거 중 오류 발생: $e');
      } finally {
        if (!_isDisposed && mounted) {
          setState(() {
            _isNotificationScheduled = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        title: const Text('개발자 모드', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildDeveloperCard(
            title: '재난문자 알림 발생',
            subtitle: '5초 후 재난문자 알림이 발생합니다.',
            onTap: _triggerDisasterNotification,
            isProcessing: _isNotificationScheduled,
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isProcessing = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: isProcessing ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isProcessing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
} 