import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/services/sensor_notification_service.dart';
import 'package:careapp5_15/views/main/splash_screen.dart';
import 'package:careapp5_15/views/main/login_screen.dart';
import 'package:careapp5_15/views/auth/name_input_screen.dart';
import 'package:careapp5_15/views/auth/qr_scan_page.dart';
import 'package:careapp5_15/views/main/main_wrapper.dart'; // 메인 래퍼(네비게이션) 임포트
import 'package:careapp5_15/views/main/main_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // 날짜 포맷 로케일 초기화용
import 'package:provider/provider.dart';
import 'package:careapp5_15/viewmodels/sensor_viewmodel.dart';
import 'package:careapp5_15/viewmodels/user_viewmodel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:careapp5_15/views/main/notification_page.dart';
import 'package:careapp5_15/views/main/notification_detail_page.dart';
import 'package:careapp5_15/models/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  await dotenv.load(fileName: ".env");
  
  final notificationService = SensorNotificationService();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MyApp(notificationService: notificationService),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SensorNotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareApp',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
        '/home': (context) => const MainWrapper(),
      },
      builder: (context, child) {
        // 알림 서비스 초기화
        notificationService.initialize(context);
        return child!;
      },
    );
  }
}

class _AppHome extends StatefulWidget {
  final SensorNotificationService notificationService;
  const _AppHome({required this.notificationService});

  @override
  State<_AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<_AppHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          // SplashScreen에서 시작, 이후 자동 이동
          widget.notificationService.startMonitoring(context);
          return const SplashScreen();
        },
      ),
    );
  }
}
