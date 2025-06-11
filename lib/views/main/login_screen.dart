import 'package:flutter/material.dart'; // 플러터 UI 프레임워크 임포트
import 'package:careapp5_15/views/main/name_input_screen.dart'; // 이름 입력 화면 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 로고
                Image.asset(
                  'assets/images/carecall_logo.png',
                  width: 240,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 5),
                // 안내 문구
                const Text(
                  'AI 케어콜로\n안심하고 돌봄을 누리세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '당신의 일상에 든든한 돌봄을 더합니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                // 카카오 로그인 버튼 (코드+이미지)
                InkWell(
                  onTap: () {}, // TODO: 카카오 로그인 함수 연결
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 320,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE812),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 12),
                          child: Image.asset(
                            'assets/images/kakao_logo.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        const Text(
                          '카카오 계정으로 1초 만에 시작하기',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 네이버 로그인 버튼 (코드+이미지)
                InkWell(
                  onTap: () {}, // TODO: 네이버 로그인 함수 연결
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 320,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF03C75A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 12),
                          child: Image.asset(
                            'assets/images/naver_logo.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        const Text(
                          '네이버 계정으로 시작하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // 구분선
                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('또는', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
                  ],
                ),
                const SizedBox(height: 20),
                // 아이디 입력
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('아이디', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    hintText: '아이디를 입력해주세요',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 18),
                // 비밀번호 입력
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pwController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호를 입력해주세요',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NameInputScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0B0B0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('로그인', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 18),
                // 하단 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('회원가입', style: TextStyle(color: Colors.grey)),
                    ),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('아이디 찾기', style: TextStyle(color: Colors.grey)),
                    ),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('비밀번호 찾기', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
