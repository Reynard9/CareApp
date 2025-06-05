import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';
import 'package:careapp5_15/views/settings/terms_page.dart';
import 'package:careapp5_15/views/settings/privacy_policy_page.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  String _selectedLanguage = '한국어';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '앱 설정',
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
          _buildProfileSection(),
          const SizedBox(height: 24),
          _buildSection(
            title: '일반',
            children: [
              _buildSettingItem(
                icon: Icons.dark_mode,
                title: '다크 모드',
                subtitle: '어두운 테마로 전환합니다',
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                    activeColor: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
              _buildSettingItem(
                icon: Icons.language,
                title: '언어',
                subtitle: '앱 언어를 변경합니다',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    items: ['한국어', 'English'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLanguage = newValue;
                        });
                      }
                    },
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4ECDC4)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '알림',
            children: [
              _buildSettingItem(
                icon: Icons.notifications,
                title: '알림 활성화',
                subtitle: '푸시 알림을 받습니다',
                trailing: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isNotificationEnabled = value;
                      });
                    },
                    activeColor: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '계정',
            children: [
              _buildSettingItem(
                icon: Icons.person,
                title: '프로필 수정',
                subtitle: '개인 정보를 수정합니다',
                onTap: () {
                  // 프로필 수정 페이지로 이동
                },
              ),
              _buildSettingItem(
                icon: Icons.logout,
                title: '로그아웃',
                subtitle: '계정에서 로그아웃합니다',
                onTap: () {
                  // 로그아웃 처리
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '정보',
            children: [
              _buildSettingItem(
                icon: Icons.info,
                title: '앱 버전',
                subtitle: '현재 버전: 1.0.0',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '최신 버전',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              _buildSettingItem(
                icon: Icons.description,
                title: '이용약관',
                subtitle: '서비스 이용 약관을 확인합니다',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsPage()),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.privacy_tip,
                title: '개인정보 처리방침',
                subtitle: '개인정보 수집 및 이용에 대한 안내',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
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
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF4ECDC4), size: 38),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '김세종',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'sejong@sejong.ac.kr',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // 프로필 수정 페이지로 이동
            },
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
} 