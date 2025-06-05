import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          '이용약관',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DeepCare 서비스 이용약관',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '최종 수정일: 2024년 3월 15일',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    '제1조 (목적)',
                    '본 약관은 DeepCare(이하 "회사")가 제공하는 서비스의 이용과 관련하여 회사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.',
                  ),
                  _buildSection(
                    '제2조 (정의)',
                    '1. "서비스"란 회사가 제공하는 모든 서비스를 의미합니다.\n2. "이용자"란 회사의 서비스를 이용하는 회원을 말합니다.',
                  ),
                  _buildSection(
                    '제3조 (서비스의 제공)',
                    '회사는 다음과 같은 서비스를 제공합니다:\n1. 건강 모니터링 서비스\n2. 응급 상황 알림 서비스\n3. 보호자 연동 서비스\n4. 기타 회사가 정하는 서비스',
                  ),
                  _buildSection(
                    '제4조 (서비스 이용)',
                    '1. 서비스 이용은 회사의 업무상 또는 기술상 특별한 지장이 없는 한 연중무휴, 1일 24시간을 원칙으로 합니다.\n2. 회사는 시스템 정기점검, 증설 및 교체를 위해 서비스를 일시 중단할 수 있습니다.',
                  ),
                  _buildSection(
                    '제5조 (개인정보보호)',
                    '1. 회사는 관련법령이 정하는 바에 따라 이용자의 개인정보를 보호하기 위해 노력합니다.\n2. 개인정보의 보호 및 사용에 대해서는 관련법 및 회사의 개인정보처리방침이 적용됩니다.',
                  ),
                  _buildSection(
                    '제6조 (이용자의 의무)',
                    '1. 이용자는 관계법령, 본 약관의 규정, 이용안내 및 주의사항 등 회사가 통지하는 사항을 준수하여야 합니다.\n2. 이용자는 회사의 명시적인 동의가 없는 한 서비스의 이용권한을 타인에게 양도, 증여할 수 없습니다.',
                  ),
                  _buildSection(
                    '제7조 (책임제한)',
                    '1. 회사는 천재지변, 전쟁, 기간통신사업자의 서비스 중지 등 불가항력적인 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.\n2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대해 책임을 지지 않습니다.',
                  ),
                  _buildSection(
                    '제8조 (분쟁해결)',
                    '1. 회사와 이용자 간 발생한 분쟁은 상호 협의하여 해결합니다.\n2. 협의가 이루어지지 않을 경우, 관련법령 및 상관례에 따릅니다.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
} 