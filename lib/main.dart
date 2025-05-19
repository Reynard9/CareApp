import 'package:flutter/material.dart';
import 'package:careapp5_15/screens/splash_screen.dart'; // SplashScreen import
import 'package:careapp5_15/screens/main_wrapper.dart'; // MainWrapper import
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const CareApp());
}

class CareApp extends StatelessWidget {
  const CareApp({super.key});

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
      home: const SplashScreen(), // 앱 시작 시 SplashScreen부터 보여줌
    );
  }
}
