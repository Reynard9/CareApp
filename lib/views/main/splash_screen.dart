import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트

class SplashScreen extends StatefulWidget { // 스플래시 화면 위젯
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState(); // 상태 관리
}

class _SplashScreenState extends State<SplashScreen> { // 스플래시 화면 상태
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () { // 2초 후 이동
      Navigator.pushReplacementNamed(context, '/login'); // 로그인 화면으로 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/carecall_logo.png',
              width: 250, // 로고 크기
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'DeepLabs.Co',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
