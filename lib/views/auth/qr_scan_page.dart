import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      isCameraPermissionGranted = status.isGranted;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        // QR 코드가 스캔되면 홈 화면으로 이동
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraPermissionGranted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('QR 코드 스캔'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '카메라 권한이 필요합니다',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkCameraPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  foregroundColor: Colors.black,
                ),
                child: const Text('권한 요청하기'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR 코드 스캔'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.pink,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'QR 코드를 스캔해주세요',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 