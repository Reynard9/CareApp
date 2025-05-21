import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/login_screen.dart'; // 로그인 화면 임포트

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // 로그인 화면으로 이동
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      body: Center(
        child: Image.asset(
          'assets/images/carecall_logo.png',
          width: 180, // 로고 크기
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
