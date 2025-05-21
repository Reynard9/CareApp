import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/main_wrapper.dart'; // 메인 래퍼(네비게이션) 임포트

class NameInputScreen extends StatefulWidget { // 이름 입력 화면 위젯
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState(); // 상태 관리
}

class _NameInputScreenState extends State<NameInputScreen> { // 이름 입력 화면 상태
  final TextEditingController _nameController = TextEditingController(); // 이름 입력 컨트롤러

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 키보드 높이 감지

    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      resizeToAvoidBottomInset: false, // 키보드에 의해 화면 밀림 방지
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우 여백
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12), // 상단 여백
                    child: Image.asset(
                      'assets/images/careapp_logo.png',
                      width: 120, // 로고 크기
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40), // 여백
                  const Text(
                    '어르신의', // 안내 문구
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '이름을 적어주세요', // 안내 문구
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40), // 여백
                  TextField(
                    controller: _nameController, // 입력 컨트롤러
                    decoration: const InputDecoration(
                      hintText: '이름', // 힌트
                      hintStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset, // 키보드 바로 위에 붙게
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 배경
                  foregroundColor: Colors.white, // 버튼 글씨
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 라운드 없이 꽉 차게
                  ),
                ),
                onPressed: () {
                  final name = _nameController.text.trim(); // 입력값
                  if (name.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainWrapper(), // 메인 래퍼로 이동
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이름을 입력해주세요')), // 입력 안내
                    );
                  }
                },
                child: const Text('다음', style: TextStyle(fontSize: 16)), // 버튼 텍스트
              ),
            ),
          ),
        ],
      ),
    );
  }
}