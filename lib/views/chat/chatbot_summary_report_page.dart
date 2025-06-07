import 'package:flutter/material.dart'; // 플러터 UI 임포트
import 'package:careapp5_15/services/api_service.dart';
import 'package:careapp5_15/widgets/custom_header.dart';
import 'package:careapp5_15/theme/app_theme.dart';

class ChatbotSummaryReportPage extends StatefulWidget {
  final int deviceId;
  final int sessionId;
  final String date;
  final String title;

  const ChatbotSummaryReportPage({
    super.key,
    required this.deviceId,
    required this.sessionId,
    required this.date,
    required this.title,
  });

  @override
  State<ChatbotSummaryReportPage> createState() => _ChatbotSummaryReportPageState();
}

class _ChatbotSummaryReportPageState extends State<ChatbotSummaryReportPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, String> _status = {};
  Map<String, String> _analysis = {};

  // 더미 데이터
  final Map<String, String> _dummyStatus = {
    '주거환경': '양호',
    '경제상태': '안정',
    '사회적관계': '활발',
    '여가활동': '다양',
    'ADL': '독립',
    'IADL': '보조',
    '목욕': '정상',
    '식사': '정상',
    '배변': '정상',
    '우울': '양호',
    '인지': '정상',
    '망상': '없음',
    '공격성': '없음',
    '환각': '없음',
    '배회': '없음',
    '피로': '양호',
    '시력': '정상',
    '청력': '정상',
  };

  final Map<String, String> _dummyAnalysis = {
    '사용자의 일상': '사용자는 일상에서 아침에 김치찌개를 먹는 것을 선호하고, TV를 보면서 디스트레스를 해소하는 것을 좋아합니다. 또한, 친구들과 놀거나, 드라마를 보는 것을 즐깁니다.',
    '어르신의 상태': '어르신은 대체로 스트레스를 크게 받지 않고 있으며, 특히 드라마 시청을 통해 스트레스 해소에 도움을 받고 있습니다. 자연스러운 대화를 선호하는 것으로 보입니다.',
    '건강 상태': '더욱 상세한 건강 상태를 이해하기 위해서는 추가 정보가 필요합니다. 이는 개인의 건강 상태, 증상, 특정 식사 선호도 등을 포함할 수 있습니다.',
    '건강에 대한 조언': '건강에 대한 조언을 제공하기 위해서는 사용자에게서 더 많은 건강 관련 정보를 받아야 합니다. 이에 따라, 다양한 정보를 통해 사용자의 건강 상태를 분석하고, 맞춤화된 조언을 제공할 수 있습니다.',
  };

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final summary = await ApiService.getChatSummary(widget.deviceId, widget.sessionId);
      
      setState(() {
        _status = summary.status;
        _analysis = summary.analysis;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 분석 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                '생성 일시: ${widget.date}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 10),
            // 로딩 또는 에러 표시
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_error != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '요약 보고서를 불러오는데 실패했습니다.',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadSummary,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    // 가로 스크롤 카드
                    Container(
                      height: 160,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          ..._status.entries.map((entry) {
                            final icon = _getStatusIcon(entry.key);
                            final color = _getStatusColor(entry.key);
                            return _summaryCard(
                              icon: icon,
                              title: entry.key,
                              value: entry.value,
                              color: color,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    // 본문 내용
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            // analysis 맵의 각 항목을 소제목+본문으로 표시
                            ..._analysis.entries.map((entry) => Container(
                              margin: const EdgeInsets.only(bottom: 20),
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
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.pink.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            entry.key,
                                            style: const TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.6,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(String title) {
    switch (title) {
      case '주거환경': return Icons.home;
      case '경제상태': return Icons.account_balance_wallet;
      case '사회적관계': return Icons.people;
      case '여가활동': return Icons.sports_esports;
      case 'ADL': return Icons.accessibility_new;
      case 'IADL': return Icons.cleaning_services;
      case '목욕': return Icons.shower;
      case '식사': return Icons.restaurant;
      case '배변': return Icons.wc;
      case '우울': return Icons.sentiment_dissatisfied;
      case '인지': return Icons.psychology;
      case '망상': return Icons.psychology_alt;
      case '공격성': return Icons.warning;
      case '환각': return Icons.visibility;
      case '배회': return Icons.directions_walk;
      case '피로': return Icons.battery_alert;
      case '시력': return Icons.visibility;
      case '청력': return Icons.hearing;
      default: return Icons.info;
    }
  }

  Color _getStatusColor(String title) {
    switch (title) {
      case '주거환경': return Colors.blue;
      case '경제상태': return Colors.green;
      case '사회적관계': return Colors.purple;
      case '여가활동': return Colors.orange;
      case 'ADL': return Colors.teal;
      case 'IADL': return Colors.indigo;
      case '목욕': return Colors.cyan;
      case '식사': return Colors.amber;
      case '배변': return Colors.brown;
      case '우울': return Colors.deepPurple;
      case '인지': return Colors.pink;
      case '망상': return Colors.red;
      case '공격성': return Colors.redAccent;
      case '환각': return Colors.deepOrange;
      case '배회': return Colors.orangeAccent;
      case '피로': return Colors.lightGreen;
      case '시력': return Colors.blueGrey;
      case '청력': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }
} 