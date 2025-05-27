import 'package:flutter/material.dart'; // 플러터 UI 임포트

class ChatbotSummaryReportPage extends StatelessWidget {
  final String date;
  final String title;
  const ChatbotSummaryReportPage({super.key, required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // 배경색 변경
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 헤더 (CareApp 로고/텍스트, 뒤로가기, 우측 아이콘)
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
                title, // 대화 제목
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
                '생성 일시: $date', // 생성 일시
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 10),
            // 가로 스크롤 카드
            Container(
              height: 160,
              margin: const EdgeInsets.only(bottom: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _summaryCard(
                    icon: Icons.home,
                    title: '주거환경',
                    value: '양호',
                    color: Colors.blue,
                  ),
                  _summaryCard(
                    icon: Icons.account_balance_wallet,
                    title: '경제상태',
                    value: '안정',
                    color: Colors.green,
                  ),
                  _summaryCard(
                    icon: Icons.people,
                    title: '사회적관계',
                    value: '활발',
                    color: Colors.purple,
                  ),
                  _summaryCard(
                    icon: Icons.sports_esports,
                    title: '여가활동',
                    value: '다양',
                    color: Colors.orange,
                  ),
                  _summaryCard(
                    icon: Icons.accessibility_new,
                    title: 'ADL',
                    value: '독립',
                    color: Colors.teal,
                  ),
                  _summaryCard(
                    icon: Icons.cleaning_services,
                    title: 'IADL',
                    value: '보조',
                    color: Colors.indigo,
                  ),
                  _summaryCard(
                    icon: Icons.shower,
                    title: '목욕',
                    value: '정상',
                    color: Colors.cyan,
                  ),
                  _summaryCard(
                    icon: Icons.restaurant,
                    title: '식사',
                    value: '정상',
                    color: Colors.amber,
                  ),
                  _summaryCard(
                    icon: Icons.wc,
                    title: '배변',
                    value: '정상',
                    color: Colors.brown,
                  ),
                  _summaryCard(
                    icon: Icons.sentiment_dissatisfied,
                    title: '우울',
                    value: '양호',
                    color: Colors.deepPurple,
                  ),
                  _summaryCard(
                    icon: Icons.psychology,
                    title: '인지',
                    value: '정상',
                    color: Colors.pink,
                  ),
                  _summaryCard(
                    icon: Icons.psychology_alt,
                    title: '망상',
                    value: '없음',
                    color: Colors.red,
                  ),
                  _summaryCard(
                    icon: Icons.warning,
                    title: '공격성',
                    value: '없음',
                    color: Colors.redAccent,
                  ),
                  _summaryCard(
                    icon: Icons.visibility,
                    title: '환각',
                    value: '없음',
                    color: Colors.deepOrange,
                  ),
                  _summaryCard(
                    icon: Icons.directions_walk,
                    title: '배회',
                    value: '없음',
                    color: Colors.orangeAccent,
                  ),
                  _summaryCard(
                    icon: Icons.battery_alert,
                    title: '피로',
                    value: '양호',
                    color: Colors.lightGreen,
                  ),
                  _summaryCard(
                    icon: Icons.visibility,
                    title: '시력',
                    value: '정상',
                    color: Colors.blueGrey,
                  ),
                  _summaryCard(
                    icon: Icons.hearing,
                    title: '청력',
                    value: '정상',
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            // 본문 내용 (섹션별 분홍색 소제목 + 본문)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8),
                    Text('사용자의 일상', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('사용자는 일상에서 아침에 김치찌개를 먹는 것을 선호하고, TV를 보면서 디스트레스를 해소하는 것을 좋아합니다. 또한, 친구들과 놀거나, 드라마를 보는 것을 즐깁니다.', style: TextStyle(fontSize: 15)),
                    SizedBox(height: 14),
                    Text('어르신의 상태', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('어르신은 대체로 스트레스를 크게 받지 않고 있으며, 특히 드라마 시청을 통해 스트레스 해소에 도움을 받고 있습니다. 자연스러운 대화를 선호하는 것으로 보입니다.', style: TextStyle(fontSize: 15)),
                    SizedBox(height: 14),
                    Text('건강 상태', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('더욱 상세한 건강 상태를 이해하기 위해서는 추가 정보가 필요합니다. 이는 개인의 건강 상태, 증상, 특정 식사 선호도 등을 포함할 수 있습니다.', style: TextStyle(fontSize: 15)),
                    SizedBox(height: 14),
                    Text('건강에 대한 조언', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 2),
                    Text('건강에 대한 조언을 제공하기 위해서는 사용자에게서 더 많은 건강 관련 정보를 받아야 합니다. 이에 따라, 다양한 정보를 통해 사용자의 건강 상태를 분석하고, 맞춤화된 조언을 제공할 수 있습니다.', style: TextStyle(fontSize: 15, color: Colors.pink)),
                  ],
                ),
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
} 