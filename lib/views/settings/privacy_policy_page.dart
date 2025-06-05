import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text(
          '개인정보 처리방침',
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
                    'DeepCare 개인정보 처리방침',
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
                    '1. 수집하는 개인정보 항목',
                    '회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다:\n\n'
                    '• 필수항목: 이름, 생년월일, 성별, 연락처, 이메일\n'
                    '• 선택항목: 주소, 보호자 연락처, 건강정보\n'
                    '• 자동수집항목: IP주소, 쿠키, 서비스 이용기록, 접속 로그',
                  ),
                  _buildSection(
                    '2. 개인정보의 수집 및 이용목적',
                    '회사는 수집한 개인정보를 다음의 목적을 위해 이용합니다:\n\n'
                    '• 서비스 제공에 관한 계약 이행\n'
                    '• 건강 모니터링 및 응급상황 대응\n'
                    '• 보호자 연동 서비스 제공\n'
                    '• 고객 상담 및 불만처리',
                  ),
                  _buildSection(
                    '3. 개인정보의 보유 및 이용기간',
                    '회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 아래와 같이 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다.\n\n'
                    '• 계약 또는 청약철회 등에 관한 기록: 5년\n'
                    '• 대금결제 및 재화 등의 공급에 관한 기록: 5년\n'
                    '• 소비자의 불만 또는 분쟁처리에 관한 기록: 3년',
                  ),
                  _buildSection(
                    '4. 개인정보의 파기절차 및 방법',
                    '회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다:\n\n'
                    '• 파기절차: 이용자가 서비스 가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져 내부 방침 및 관련 법령에 의한 정보보호 사유에 따라 일정 기간 저장된 후 파기됩니다.\n'
                    '• 파기방법: 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.',
                  ),
                  _buildSection(
                    '5. 개인정보 제공 및 공유',
                    '회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다:\n\n'
                    '• 이용자들이 사전에 동의한 경우\n'
                    '• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우',
                  ),
                  _buildSection(
                    '6. 이용자 및 법정대리인의 권리와 행사방법',
                    '이용자 및 법정대리인은 언제든지 등록되어 있는 자신 혹은 만 14세 미만 아동의 개인정보를 조회하거나 수정할 수 있으며, 회사의 개인정보 처리에 동의하지 않는 경우 동의를 거부하거나 가입해지(회원탈퇴)를 요청할 수 있습니다.\n\n'
                    '• 개인정보 조회/수정: 설정 > 프로필 수정 메뉴를 통하여 가능\n'
                    '• 동의 거부: 설정 > 개인정보 처리방침 메뉴를 통하여 가능\n'
                    '• 회원탈퇴: 설정 > 계정 > 회원탈퇴 메뉴를 통하여 가능',
                  ),
                  _buildSection(
                    '7. 개인정보 보호를 위한 안전성 확보 조치',
                    '회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다:\n\n'
                    '• 관리적 조치: 내부관리계획 수립·시행, 정기적 직원 교육\n'
                    '• 기술적 조치: 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 고유식별정보 등의 암호화, 보안프로그램 설치\n'
                    '• 물리적 조치: 전산실, 자료보관실 등의 접근통제',
                  ),
                  _buildSection(
                    '8. 개인정보 보호책임자',
                    '회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 이용자의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n\n'
                    '• 개인정보 보호책임자: 홍길동 (개인정보보호팀)\n'
                    '• 연락처: privacy@deepcare.com, 02-1234-5678',
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