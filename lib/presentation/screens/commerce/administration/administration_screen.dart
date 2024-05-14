import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../widgets/shared/customs/customs.dart';

class AdministrationScreen extends StatefulWidget {
  static const name = 'administration_screen';

  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  String? qrText; // To store the scanned QR code data
  QRViewController? controller; // To control the QRView
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Unique key for QRView

  // Handle camera resume/pause for hot reload
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else {
      controller?.resumeCamera();
    }
  }

  // Dispose of the controller when the widget is disposed
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey), // Replace with your actual drawer
      appBar: AppBar(
        title: const Text('Administrador'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          // Replace with your main administration view
          const Center(child: Text('Eres genial!')),
          // QRView widget positioned on top
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Escanear QR'),
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: () async {
          // Request camera permission (optional)
          // Uncomment if needed for your platform
          // await Permission.camera.request();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Escanear Código QR'),
                content: QRView(
                  key: qrKey, // Ensure key matches
                  onQRViewCreated: _onQRViewCreated,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    
    controller.scannedDataStream.listen((Barcode scanData) {
      setState(() {
        qrText = scanData.code;
        print('$qrText');
      });
    });
  }
}

