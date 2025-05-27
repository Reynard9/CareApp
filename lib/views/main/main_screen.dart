import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/device/device_status_page.dart';
import 'package:intl/intl.dart'; // 날짜/시간 포맷용
import 'package:careapp5_15/views/chat/chat_history_page.dart'; // 챗봇 이력 페이지 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 페이지 임포트
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';

class MainScreen extends StatefulWidget { // 메인 홈 화면 위젯
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); // 상태 관리
}

class _MainScreenState extends State<MainScreen> { // 메인 홈 화면 상태
  String _currentDateTime = ''; // 현재 날짜/시간 문자열

  @override
  void initState() {
    super.initState();
    _updateDateTime(); // 날짜/시간 초기화
    Future.delayed(const Duration(minutes: 1), _updateDateTime); // 1분마다 갱신
  }

  void _updateDateTime() { // 현재 날짜/시간을 포맷팅해서 저장
    final now = DateTime.now();
    final formatter = DateFormat('yyyy년 M월 d일(E) a h:mm', 'ko_KR');
    setState(() {
      _currentDateTime = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<UserViewModel>().userName;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: innerBoxIsScrolled ? Colors.white : const Color(0xFFF7F7F7),
              elevation: innerBoxIsScrolled ? 1 : 0,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/careapp_logo.png', width: 100),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, color: innerBoxIsScrolled ? Colors.black87 : Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_none, color: innerBoxIsScrolled ? Colors.black87 : Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '안녕하세요,\n${userName} 보호자님!', // 인사말
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('무엇을 도와드릴까요?', style: TextStyle(fontSize: 17)), // 안내 문구
                    const SizedBox(height: 12),
                    _statusGroupBox([
                      _statusRow(Icons.health_and_safety, '현재 김세종님은 편안하신 상태에요!'),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CareSchedulePage()),
                          );
                        },
                        child: _statusRow(Icons.event_note, '요양 보호사 방문 일정 확인하기!'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DeviceStatusPage()),
                          );
                        },
                        child: _statusRow(Icons.monitor_heart, '현재 디바이스 상태 확인하기!'),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 0),
                      child: Builder(
                        builder: (context) {
                          final now = DateTime.now();
                          final formatter = DateFormat('yyyy년 M월 d일(E) a h:mm', 'ko_KR');
                          final nowStr = formatter.format(now);
                          final currentNoise = 48.0; // 예시값, 실제 데이터로 교체 가능
                          final currentAirQuality = 32.0; // 공기질 예시값
                          final currentTemp = 18.0; // 온도 예시값
                          final currentHumidity = 35.0; // 습도 예시값
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('스마트 홈 센서', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text(
                                    nowStr,
                                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _sensorStatusCard(
                                icon: Icons.align_vertical_bottom,
                                iconColor: Colors.pink[200]!,
                                title: '공기질 양호',
                                subtitle: '${currentAirQuality.toStringAsFixed(1)} ㎍/㎥',
                                bgColor: Colors.pink[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.volume_up,
                                iconColor: Colors.blue[400]!,
                                title: '소음 발생 없음',
                                subtitle: '${currentNoise.toStringAsFixed(1)} dB',
                                bgColor: Colors.blue[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.device_thermostat,
                                iconColor: Colors.orange[400]!,
                                title: '온도',
                                subtitle: '${currentTemp.toStringAsFixed(1)}°C',
                                bgColor: Colors.orange[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.water_drop,
                                iconColor: Colors.blue[300]!,
                                title: '습도',
                                subtitle: '${currentHumidity.toStringAsFixed(1)}%',
                                bgColor: Colors.blue[50]!,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('최근 챗봇 이력', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatHistoryPage()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.black12.withOpacity(0.06)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  color: Colors.pink[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('어 오늘 아침 먹었어'), // 챗봇 대화 예시
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 12,
                                  child: Icon(Icons.person, size: 14, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      '김치찌개 맛있으셨겠어요. 혹시\n요즘 스트레스를 많이 느끼시나요, 어르신?', // 챗봇 답변 예시
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusGroupBox(List<Widget> children) { // 상태 카드 그룹 박스
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) {
            return children[index ~/ 2];
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: Colors.grey[200],
                thickness: 1,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _statusRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28, color: Colors.pink[400]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF2D3436),
                height: 1.3,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
        ],
      ),
    );
  }

  Widget _sensorStatusCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}