import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/auth/qr_scan_page.dart'; // QR 스캔 페이지 임포트
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';

class NameInputScreen extends StatefulWidget { // 이름 입력 화면 위젯
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState(); // 상태 관리
}

class _NameInputScreenState extends State<NameInputScreen> { // 이름 입력 화면 상태
  final TextEditingController _nameController = TextEditingController(); // 이름 입력 컨트롤러
  bool _showError = false;

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
                    onChanged: (value) {
                      if (_showError && value.trim().isNotEmpty) {
                        setState(() {
                          _showError = false;
                        });
                      }
                    },
                  ),
                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFE0E6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Color(0xFFFFB3C6)),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.error_outline, color: Color(0xFFD72660)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '이름을 입력하세요',
                                style: TextStyle(
                                  color: Color(0xFFD72660),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset,
            child: SizedBox(
              width: double.infinity,
              height: 72,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    setState(() {
                      _showError = false;
                    });
                    context.read<UserViewModel>().setUserName(name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScanPage(name: name),
                      ),
                    );
                  } else {
                    setState(() {
                      _showError = true;
                    });
                  }
                },
                child: const Text('다음', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}