import 'package:flutter/material.dart'; // 플러터 UI 임포트

class CareCallSchedulePage extends StatefulWidget {
  const CareCallSchedulePage({super.key});

  @override
  State<CareCallSchedulePage> createState() => _CareCallSchedulePageState();
}

class _CareCallSchedulePageState extends State<CareCallSchedulePage> {
  List<bool> selectedDays = [true, false, false, false, false, false, false]; // 요일 선택 상태
  TimeOfDay callTime = const TimeOfDay(hour: 10, minute: 0); // 통화 시간
  String selectedTarget = '김세종 어르신'; // 대상
  List<String> questions = ['건강은 어떠세요?', '식사는 하셨어요?']; // 질문 리스트
  bool alarmOn = true; // 알림 여부
  String alarmTime = '10분 전'; // 알림 시간
  bool featureEnabled = true; // 기능 활성화

  final List<String> dayLabels = ['일', '월', '화', '수', '목', '금', '토'];
  final List<String> alarmOptions = ['10분 전', '30분 전', '1시간 전'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // 전체 배경 밝은 회색
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/images/careapp_logo.png', height: 30), // CareApp 로고
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 400,
                  margin: const EdgeInsets.all(18),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.calendar_today, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('반복 주기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (i) => _buildDayButton(i)), // 요일 버튼
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.access_time, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('통화 시간', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatTime(callTime), style: const TextStyle(fontSize: 16)),
                                const Icon(Icons.chevron_right, color: Colors.black38),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.phone, color: Colors.black54),
                            SizedBox(width: 8),
                            Text('대상 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Text(selectedTarget, style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: [
                            ...questions.map((q) => Chip(
                                  label: Text(q, style: const TextStyle(fontSize: 15)),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black12),
                                  ),
                                )),
                            ActionChip(
                              label: const Text('추가', style: TextStyle(color: Colors.pink)),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.pink),
                              ),
                              onPressed: _addQuestion,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.notifications, color: Colors.black54),
                            const SizedBox(width: 8),
                            const Text('알림 받기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Spacer(),
                            Switch(
                              value: alarmOn,
                              onChanged: (v) => setState(() => alarmOn = v),
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        if (alarmOn) ...[
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _pickAlarmTime,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(alarmTime, style: const TextStyle(fontSize: 16)),
                                  const Icon(Icons.chevron_right, color: Colors.black38),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text('기능 활성화', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                            onPressed: () {},
                            child: const Text('저장하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(int i) {
    return GestureDetector(
      onTap: () => setState(() => selectedDays[i] = !selectedDays[i]),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selectedDays[i] ? Colors.pink : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selectedDays[i] ? Colors.pink : Colors.black12),
        ),
        child: Center(
          child: Text(
            dayLabels[i],
            style: TextStyle(
              color: selectedDays[i] ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: callTime,
    );
    if (picked != null) setState(() => callTime = picked);
  }

  void _addQuestion() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('질문 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '질문을 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => questions.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  void _pickAlarmTime() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: alarmOptions.map((opt) => ListTile(
          title: Text(opt),
          onTap: () => Navigator.pop(context, opt),
        )).toList(),
      ),
    );
    if (picked != null) setState(() => alarmTime = picked);
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? '오전' : '오후';
    return '$period $hour:${t.minute.toString().padLeft(2, '0')}';
  }
} 