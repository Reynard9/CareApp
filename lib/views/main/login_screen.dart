import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/name_input_screen.dart'; // 이름 입력 화면 임포트
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginScreen extends StatelessWidget { // 로그인 화면 위젯
  const LoginScreen({super.key});

  Future<void> _handleKakaoLogin(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      
      OAuthToken token = isInstalled 
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      // 로그인 성공 시 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      
      // TODO: 사용자 정보 처리 (예: 로컬 저장소에 저장)
      print('카카오 로그인 성공: ${user.kakaoAccount?.profile?.nickname}');
      
      // 이름 입력 화면으로 이동
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NameInputScreen(),
          ),
        );
      }
    } catch (error) {
      print('카카오 로그인 실패: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('카카오 로그인에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              const SizedBox(height: 16),
              const SizedBox(height: 32), // 여백 추가
              GestureDetector(
                onTap: () => _handleKakaoLogin(context),
                child: Image.asset(
                  'assets/images/kakao_logo.png',
                  width: double.infinity,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
