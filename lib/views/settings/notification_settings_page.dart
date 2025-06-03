import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isAllNotificationsEnabled = true;
  bool _isCareCallEnabled = true;
  bool _isHealthReportEnabled = true;
  bool _isSensorAlertEnabled = true;
  bool _isScheduleEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '알림 설정',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSection(
            title: '알림 관리',
            children: [
              _buildSettingItem(
                icon: Icons.notifications_active,
                title: '모든 알림',
                subtitle: '모든 알림을 한 번에 켜고 끕니다',
                trailing: _buildCustomSwitch(
                  value: _isAllNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isAllNotificationsEnabled = value;
                      if (!value) {
                        _isCareCallEnabled = false;
                        _isHealthReportEnabled = false;
                        _isSensorAlertEnabled = false;
                        _isScheduleEnabled = false;
                      } else {
                        _isCareCallEnabled = true;
                        _isHealthReportEnabled = true;
                        _isSensorAlertEnabled = true;
                        _isScheduleEnabled = true;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '알림 유형',
            children: [
              _buildSettingItem(
                icon: Icons.phone_in_talk,
                title: '케어콜 알림',
                subtitle: '정기 안부 케어콜 관련 알림',
                trailing: _buildCustomSwitch(
                  value: _isCareCallEnabled,
                  onChanged: _isAllNotificationsEnabled
                      ? (value) {
                          setState(() {
                            _isCareCallEnabled = value;
                          });
                        }
                      : null,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.insert_chart,
                title: '건강 리포트 알림',
                subtitle: '건강 상태 리포트 관련 알림',
                trailing: _buildCustomSwitch(
                  value: _isHealthReportEnabled,
                  onChanged: _isAllNotificationsEnabled
                      ? (value) {
                          setState(() {
                            _isHealthReportEnabled = value;
                          });
                        }
                      : null,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.sensors,
                title: '센서 알림',
                subtitle: '센서 이상 감지 시 알림',
                trailing: _buildCustomSwitch(
                  value: _isSensorAlertEnabled,
                  onChanged: _isAllNotificationsEnabled
                      ? (value) {
                          setState(() {
                            _isSensorAlertEnabled = value;
                          });
                        }
                      : null,
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.calendar_today,
                title: '일정 알림',
                subtitle: '요양보호사 일정 관련 알림',
                trailing: _buildCustomSwitch(
                  value: _isScheduleEnabled,
                  onChanged: _isAllNotificationsEnabled
                      ? (value) {
                          setState(() {
                            _isScheduleEnabled = value;
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '알림 방식',
            children: [
              _buildSettingItem(
                icon: Icons.vibration,
                title: '진동',
                subtitle: '알림 수신 시 진동',
                trailing: _buildCustomSwitch(
                  value: _isVibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isVibrationEnabled = value;
                    });
                  },
                ),
              ),
              _buildDivider(),
              _buildSettingItem(
                icon: Icons.volume_up,
                title: '소리',
                subtitle: '알림 수신 시 소리',
                trailing: _buildCustomSwitch(
                  value: _isSoundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isSoundEnabled = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF2E8B84)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '알림 설정',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '원하는 알림을 선택적으로 받아보세요',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF636E72),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF4ECDC4), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 56,
      endIndent: 20,
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4ECDC4),
        activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.4),
        inactiveThumbColor: Colors.grey[300],
        inactiveTrackColor: Colors.grey[200],
      ),
    );
  }
} 