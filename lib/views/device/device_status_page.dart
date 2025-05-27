import 'package:flutter/material.dart';

class DeviceStatusPage extends StatelessWidget {
  const DeviceStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 로고 + 뒤로가기 버튼
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/images/careapp_logo.png', width: 100),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 24),
              // 페이지 제목
              const Text(
                '디바이스 상태',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '현재 연결된 디바이스의 상태를 확인할 수 있습니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 32),
              // 디바이스 상태 카드
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.devices,
                            color: Colors.pink[400],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          '연결된 디바이스',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildStatusItem(
                      icon: Icons.info_outline,
                      title: '디바이스 버전',
                      value: 'v1.2.3',
                      color: Colors.blue,
                    ),
                    const Divider(height: 32),
                    _buildStatusItem(
                      icon: Icons.update,
                      title: '펌웨어 버전',
                      value: 'v2.0.1',
                      color: Colors.green,
                    ),
                    const Divider(height: 32),
                    _buildStatusItem(
                      icon: Icons.sensors,
                      title: '센서 데이터',
                      value: '정상 작동',
                      color: Colors.green,
                      isStatus: true,
                    ),
                    const Divider(height: 32),
                    _buildStatusItem(
                      icon: Icons.wifi,
                      title: '연결 상태',
                      value: '연결됨',
                      color: Colors.green,
                      isStatus: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 디바이스 변경하기 버튼
              GestureDetector(
                onTap: () {
                  // TODO: 디바이스 변경 로직 또는 페이지 이동
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, color: Colors.pink),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          '디바이스 변경하기',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // 마지막 업데이트 시간
              Center(
                child: Text(
                  '마지막 업데이트: ${DateTime.now().toString().substring(0, 16)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isStatus = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
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
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
} 