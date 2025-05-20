import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/screens/splash_screen.dart'; // 스플래시 화면 임포트
import 'package:careapp5_15/screens/main_wrapper.dart'; // 메인 래퍼(네비게이션) 임포트
import 'package:intl/date_symbol_data_local.dart'; // 날짜 포맷 로케일 초기화용

void main() async { // 앱 실행 진입점
  WidgetsFlutterBinding.ensureInitialized(); // 플러터 바인딩 초기화
  await initializeDateFormatting('ko_KR', null); // 날짜/시간 포맷을 한국어로 초기화
  runApp(const CareApp()); // CareApp 위젯 실행
}

class CareApp extends StatelessWidget { // 앱 전체를 감싸는 위젯
  const CareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      title: 'CareApp', // 앱 이름
      theme: ThemeData(
        fontFamily: 'Pretendard', // 전체 폰트
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // 색상 테마
        useMaterial3: true, // 머티리얼3 사용
      ),
      home: const SplashScreen(), // 앱 시작 시 SplashScreen부터 보여줌
    );
  }
}
