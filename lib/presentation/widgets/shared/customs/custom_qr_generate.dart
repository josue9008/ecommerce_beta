import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Importar paquete qr_flutter

class QRCode extends StatelessWidget {
  final String qrData; // Dato QR a codificar

  const QRCode({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Relación de aspecto 1:1 (cuadrado)
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto, 
        size: 250, 
        gapless: false,
      ),
    );
  }
}