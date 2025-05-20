import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/screens/name_input_screen.dart'; // 이름 입력 화면 임포트

class LoginScreen extends StatelessWidget { // 로그인 화면 위젯
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(); // 이메일 입력 컨트롤러

    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16), // 전체 패딩
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
            children: [
              const SizedBox(height: 30), // 여백
              Image.asset(
                'assets/images/carecall_logo.png',
                width: 120, // 로고 크기
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16), // 여백
              const Text(
                '계정을 만들어 주세요!', // 안내 문구
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8), // 여백
              const Text(
                '이 앱에 등록하기 위해 이메일을 입력해주세요.', // 안내 문구
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24), // 여백
              TextField(
                controller: emailController, // 입력 컨트롤러
                decoration: InputDecoration(
                  hintText: 'email@domain.com', // 힌트
                  border: OutlineInputBorder(), // 테두리
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink), // 포커스 시 테두리 색
                  ),
                ),
                keyboardType: TextInputType.emailAddress, // 이메일 키보드
              ),
              const SizedBox(height: 16), // 여백
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼 배경
                    foregroundColor: Colors.white, // 버튼 글씨
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NameInputScreen(), // 이름 입력 화면으로 이동
                      ),
                    );
                  },
                  child: const Text('Continue'), // 버튼 텍스트
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
