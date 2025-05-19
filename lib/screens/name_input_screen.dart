import 'package:flutter/material.dart';
import 'package:careapp5_15/screens/main_wrapper.dart'; // ✅ MainWrapper import

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 키보드 높이 감지

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 로고
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Image.asset(
                      'assets/images/careapp_logo.png',
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '어르신의',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '이름을 적어주세요',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: '이름',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          // 하단 '다음' 버튼
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset, // 키보드 바로 위에 붙게
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 라운드 없이 꽉 차게
                  ),
                ),
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainWrapper(), // ✅ MainWrapper로 이동
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('이름을 입력해주세요')),
                    );
                  }
                },
                child: const Text('다음', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}