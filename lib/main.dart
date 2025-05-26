import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/splash_screen.dart'; // 스플래시 화면 임포트
import 'package:careapp5_15/views/main/main_wrapper.dart'; // 메인 래퍼(네비게이션) 임포트
import 'package:intl/date_symbol_data_local.dart'; // 날짜 포맷 로케일 초기화용
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/sensor_viewmodel.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';
import 'package:careapp5_15/views/auth/login_screen.dart';
import 'package:careapp5_15/views/auth/name_input_screen.dart';
import 'package:careapp5_15/views/auth/qr_scan_page.dart';
import 'package:careapp5_15/views/main/main_screen.dart';

void main() async { // 앱 실행 진입점
  WidgetsFlutterBinding.ensureInitialized(); // 플러터 바인딩 초기화
  await initializeDateFormatting('ko_KR', null); // 날짜/시간 포맷을 한국어로 초기화
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: const CareApp(),
    ),
  ); // CareApp 위젯 실행
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/name-input': (context) => const NameInputScreen(),
        '/qr-scan': (context) {
          final name = ModalRoute.of(context)!.settings.arguments as String?;
          return QRScanPage(name: name ?? '');
        },
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
