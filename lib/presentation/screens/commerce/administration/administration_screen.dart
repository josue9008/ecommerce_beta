import 'dart:io'; // Importa la librería para detectar la plataforma (Android o iOS)

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la interfaz de usuario

// Importa el paquete de permission_handler (comentar y descomentar según sea necesario)
// Se utiliza para solicitar permisos de la cámara en caso de ser necesario para tu plataforma

import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa el paquete para escanear códigos QR

import '../../../widgets/shared/customs/customs.dart'; // Importa tus widgets personalizados

class AdministrationScreen extends StatefulWidget {
  static const name =
      'administration_screen'; // Nombre de la pantalla de administración

  const AdministrationScreen({super.key}); // Constructor

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  String? qrText; // Variable para almacenar el código QR escaneado

  QRViewController? controller; // Controlador para el QRView

  final GlobalKey qrKey =
      GlobalKey(debugLabel: 'QR'); // Clave única para el QRView

  bool showScanner = false; // Bandera para controlar la visibilidad del QRView

  // Bandera para rastrear si se ha escaneado un código QR
  bool _qrScanned = false;

  // Maneja la pausa/reanudación de la cámara al recargar en caliente la aplicación
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera(); // Pausa la cámara en Android
    } else {
      controller?.resumeCamera(); // Reanuda la cámara en iOS
    }
  }

  // Libera el controlador cuando se descarta el widget
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>(); // Clave para el Scaffold

    return Scaffold(
      drawer: SideMenu(
          scaffoldKey: scaffoldKey), // Reemplazar con tu menú lateral real
      appBar: AppBar(
        title:
            const Text('Administrador'), // Título de la barra de la aplicación
        actions: [
          IconButton(
            onPressed:
                () {}, // Manejador del botón de búsqueda (sin funcionalidad por ahora)
            icon: const Icon(Icons.search_rounded), // Icono de búsqueda
          )
        ],
      ),
      body: Stack(
        children: [
          // Reemplaza con tu vista principal de administración
          const Center(child: Text('Eres genial!')), // Mensaje inicial
          Visibility(
            visible:
                showScanner, // Muestra el QRView solo cuando showScanner sea true
            child: Center(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Escanear QR'), // Etiqueta del botón flotante
        icon: const Icon(Icons.qr_code_scanner), // Icono del escáner QR
        onPressed: () {
          setState(() {
            showScanner =
                !showScanner; // Cambia el estado de showScanner para mostrar/ocultar el QRView
            qrText = '';
            _qrScanned = false;
          });
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // Actualiza el controlador del QRView
    setState(() {
      this.controller = controller;
    });

    // Escucha el stream de datos escaneados del QRView
    controller.scannedDataStream.listen((Barcode scanData) {
      // Verifica si qrText ya se actualizó antes de volver a actualizar
      if (!_qrScanned) {
        // Actualiza qrText con el código QR escaneado
        setState(() {
          qrText = scanData.code;
          print('Valor: $qrText');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('QR leído: ${scanData.code}'),
            backgroundColor: Theme.of(context).primaryColor,
          ));
          _qrScanned = true; // Indica que se ha escaneado un código QR
          // Maneja el código QR escaneado aquí (por ejemplo, muestra un diálogo o realiza una acción)
        });
      }
    });
  }
}
