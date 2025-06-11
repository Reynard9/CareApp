import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/care_schedule_page.dart'; // 요양보호사 일정 페이지 임포트
import 'package:careapp5_15/views/main/notification_page.dart'; // 알림 페이지 임포트
import 'package:careapp5_15/views/device/device_status_page.dart';
import 'package:intl/intl.dart'; // 날짜/시간 포맷용
import 'package:careapp5_15/views/chat/chat_history_page.dart'; // 챗봇 이력 페이지 임포트
import 'package:careapp5_15/views/sensor/sensor_data_page.dart'; // 센서 데이터 페이지 임포트
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';
import 'package:careapp5_15/services/api_service.dart';
import 'dart:async';
import 'package:careapp5_15/views/status/elder_status_page.dart';
import 'package:careapp5_15/services/notification_store_service.dart';

class MainScreen extends StatefulWidget { // 메인 홈 화면 위젯
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState(); // 상태 관리
}

class _MainScreenState extends State<MainScreen> { // 메인 홈 화면 상태
  String _currentDateTime = ''; // 현재 날짜/시간 문자열

  // 센서 데이터 상태 변수 추가
  double currentNoise = 0.0;
  double currentAirQuality = 0.0;
  double currentTemp = 0.0;
  double currentHumidity = 0.0;
  bool isSensorLoading = true;

  // 최근 챗봇 이력 상태 변수 추가
  List<Map<String, dynamic>> _latestFullMessages = [];
  bool _isChatLoading = true;
  final ScrollController _chatScrollController = ScrollController();

  final NotificationStoreService _notificationStore = NotificationStoreService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _updateDateTime(); // 날짜/시간 초기화
    Future.delayed(const Duration(minutes: 1), _updateDateTime); // 1분마다 갱신
    _fetchSensorData();
    // 30초마다 센서 데이터 갱신
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchSensorData();
    });
    _fetchLatestChats();
    _loadUnreadCount();
  }

  void _updateDateTime() { // 현재 날짜/시간을 포맷팅해서 저장
    final now = DateTime.now();
    final formatter = DateFormat('yyyy년 M월 d일(E) a h:mm', 'ko_KR');
    setState(() {
      _currentDateTime = formatter.format(now);
    });
  }

  Future<void> _fetchSensorData() async {
    try {
      const deviceId = 1;
      print('디바이스 ID: $deviceId로 센서 데이터 요청 중...');
      final sensors = await ApiService.getSensorList(deviceId);
      
      if (sensors.isEmpty) {
        print('받은 센서 데이터가 없습니다.');
        setState(() {
          isSensorLoading = false;
        });
        return;
      }

      print('\n=== 센서 데이터 상세 정보 ===');
      for (var sensor in sensors) {
        print('센서 정보:');
        print('- 타입: ${sensor.type}');
        print('- 이름: ${sensor.name}');
        print('- 데이터 이름: ${sensor.dataName}');
        print('- 데이터 단위: ${sensor.dataUnit}');
        print('- 데이터 개수: ${sensor.data.length}');
        if (sensor.data.isNotEmpty) {
          print('- 첫 번째 데이터: ${sensor.data.first.data}');
        }
        print('------------------------');
      }
      print('========================\n');
      
      if (!mounted) return;
      
      setState(() {
        for (var sensor in sensors) {
          if (sensor.data.isEmpty) {
            print('${sensor.type} 센서에 데이터가 없습니다.');
            continue;
          }

          final rawData = sensor.data.first.data;
          print('${sensor.type} 센서 원본 데이터: $rawData');

          // 센서 타입에 따라 적절한 데이터 처리
          final sensorType = sensor.type.toLowerCase();
          print('처리할 센서 타입: $sensorType');

          if (sensorType.contains('temp') || sensorType.contains('temperature')) {
            currentTemp = _parseSensorData(rawData);
            print('온도 데이터 처리 결과: $currentTemp');
          } else if (sensorType.contains('humid') || sensorType.contains('humidity')) {
            currentHumidity = _parseSensorData(rawData);
            print('습도 데이터 처리 결과: $currentHumidity');
          } else if (sensorType.contains('sound') || sensorType.contains('noise')) {
            currentNoise = _parseSensorData(rawData);
            print('소음 데이터 처리 결과: $currentNoise');
          } else if (sensorType.contains('air') || sensorType.contains('quality')) {
            currentAirQuality = _parseSensorData(rawData);
            print('공기질 데이터 처리 결과: $currentAirQuality');
          } else {
            print('알 수 없는 센서 타입: ${sensor.type}');
          }
        }
        isSensorLoading = false;
      });
    } catch (e, stackTrace) {
      print('센서 데이터 가져오기 실패: $e');
      print('스택 트레이스: $stackTrace');
      if (!mounted) return;
      setState(() {
        isSensorLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('센서 데이터를 불러오는데 실패했습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _fetchLatestChats() async {
    setState(() {
      _isChatLoading = true;
    });
    try {
      const deviceId = 1;
      final sessions = await ApiService.getLatestChatSessions(deviceId);
      if (sessions.isNotEmpty) {
        final session = sessions.first;
        // 첫 메시지는 제외 (대화 시작 명령어)
        final messages = session.chats
            .skip(1)
            .map((chat) => {
              'isUser': chat.role == 'user',
              'text': chat.content,
            })
            .toList();
        setState(() {
          _latestFullMessages = messages;
          _isChatLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_chatScrollController.hasClients) {
            _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent);
          }
        });
      } else {
        setState(() {
          _latestFullMessages = [];
          _isChatLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _latestFullMessages = [];
        _isChatLoading = false;
      });
    }
  }

  Future<void> _loadUnreadCount() async {
    await _notificationStore.initialize();
    if (mounted) {
      setState(() {
        _unreadCount = _notificationStore.unreadCount;
      });
    }
  }

  // 센서 데이터 파싱 헬퍼 함수
  double _parseSensorData(String data) {
    try {
      print('파싱 시도하는 데이터: $data');
      // 쉼표나 공백으로 구분된 숫자 처리
      final cleanData = data.replaceAll(RegExp(r'[^\d.-]'), '');
      print('정제된 데이터: $cleanData');
      final value = double.tryParse(cleanData);
      if (value != null) {
        print('데이터 파싱 성공: $value');
        return value;
      }
      print('데이터 파싱 실패: null 반환');
    } catch (e) {
      print('데이터 파싱 중 예외 발생: $e');
    }
    return 0.0;
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
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.notifications_none, color: innerBoxIsScrolled ? Colors.black87 : Colors.black),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                                );
                                await _loadUnreadCount();
                              },
                            ),
                            if (_unreadCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 14,
                                    minHeight: 14,
                                  ),
                                  child: Text(
                                    _unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ElderStatusPage()),
                          );
                        },
                        child: _statusRow(Icons.health_and_safety, '현재 김세종님은 편안하신 상태에요!'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CareSchedulePage()),
                          );
                        },
                        child: _statusRow(Icons.event_note, '어르신의 일정 확인 및 관리하기!'),
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
                                subtitle: isSensorLoading ? '로딩중...' : '${currentAirQuality.toStringAsFixed(1)} ㎍/㎥',
                                bgColor: Colors.pink[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.volume_up,
                                iconColor: Colors.blue[400]!,
                                title: '소음 발생 없음',
                                subtitle: isSensorLoading ? '로딩중...' : '${currentNoise.toStringAsFixed(1)} dB',
                                bgColor: Colors.blue[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.device_thermostat,
                                iconColor: Colors.orange[400]!,
                                title: '온도',
                                subtitle: isSensorLoading ? '로딩중...' : '${currentTemp.toStringAsFixed(1)}°C',
                                bgColor: Colors.orange[50]!,
                              ),
                              const SizedBox(height: 10),
                              _sensorStatusCard(
                                icon: Icons.water_drop,
                                iconColor: Colors.blue[300]!,
                                title: '습도',
                                subtitle: isSensorLoading ? '로딩중...' : '${currentHumidity.toStringAsFixed(1)}%',
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
                    Container(
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
                          if (_isChatLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (!_isChatLoading && _latestFullMessages.isEmpty)
                            const Center(
                              child: Text('아직 챗봇 대화 내역이 없습니다', style: TextStyle(color: Colors.grey, fontSize: 14)),
                            ),
                          if (!_isChatLoading && _latestFullMessages.isNotEmpty)
                            SizedBox(
                              height: 180,
                              child: Scrollbar(
                                controller: _chatScrollController,
                                thumbVisibility: true,
                                child: ListView.builder(
                                  controller: _chatScrollController,
                                  itemCount: _latestFullMessages.length,
                                  itemBuilder: (context, idx) {
                                    final msg = _latestFullMessages[idx];
                                    if (msg['isUser'] == true) {
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.pink[100],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(msg['text'] ?? '', style: const TextStyle(color: Colors.black)),
                                        ),
                                      );
                                    } else {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(Icons.person, color: Colors.black54, size: 26),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(bottom: 8),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(msg['text'] ?? '', style: const TextStyle(color: Colors.black)),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
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