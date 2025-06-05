import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;
import 'package:careapp5_15/views/main/main_wrapper.dart';

class QRScanPage extends StatefulWidget {
  final String name;
  const QRScanPage({super.key, required this.name});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isCameraPermissionGranted = false;
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(_animationController);
    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      developer.log('Camera permission status: $status');
      setState(() {
        isCameraPermissionGranted = status.isGranted;
        if (!status.isGranted) {
          errorMessage = '카메라 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.';
        }
      });
    } catch (e) {
      developer.log('Error requesting camera permission: $e');
      setState(() {
        errorMessage = '카메라 권한 요청 중 오류가 발생했습니다.';
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      developer.log('QR Code scanned: ${scanData.code}');
      if (scanData.code != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    }, onError: (error) {
      developer.log('Error scanning QR code: $error');
      setState(() {
        errorMessage = 'QR 코드 스캔 중 오류가 발생했습니다.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 인사 + 일러스트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.pink[100]!,
                    Colors.pink[50]!,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink[100]!.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        size: 100,
                        color: Colors.pink[300],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.name} 보호자님',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '디바이스의 QR코드를 스캔해 \n인증을 완료해주세요',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // QR 스캔 박스
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 글래스모피즘 효과 배경
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          width: 320,
                          height: 360,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Container(
                        width: 320,
                        height: 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: isCameraPermissionGranted
                            ? Stack(
                                children: [
                                  QRView(
                                    key: qrKey,
                                    onQRViewCreated: _onQRViewCreated,
                                    overlay: QrScannerOverlayShape(
                                      borderColor: Colors.pink[300]!,
                                      borderRadius: 18,
                                      borderLength: 40,
                                      borderWidth: 8,
                                      cutOutSize: 240,
                                    ),
                                  ),
                                  // 컬러 애니메이션 스캔 라인
                                  AnimatedBuilder(
                                    animation: _scanLineAnimation,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: 60 + 180 * _scanLineAnimation.value,
                                        left: 40,
                                        right: 40,
                                        child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.pink[300]!,
                                                Colors.purple[200]!,
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt, size: 48, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      errorMessage ?? '카메라 권한이 필요합니다.',
                                      style: const TextStyle(color: Colors.black54, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => openAppSettings(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pink[200],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text('설정에서 권한 허용하기', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 하단 안내
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'QR코드가 인식되지 않나요?',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '빛 반사, 카메라 초점, QR코드 손상 여부를 확인해 주세요.\n문제가 계속된다면 고객센터로 문의해 주세요.',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 건너뛰기 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainWrapper()),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  '건너뛰기',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 