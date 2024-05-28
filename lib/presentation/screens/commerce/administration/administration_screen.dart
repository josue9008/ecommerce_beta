import 'dart:io'; // Importa la librería para detectar la plataforma (Android o iOS)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la interfaz de usuario
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa el paquete para escanear códigos QR

import '../../../../domain/domain.dart';
import '../../../widgets/shared/customs/customs.dart';
import '../commerce.dart'; // Importa tus widgets personalizados
// Importa la página de administración de productos

class AdministrationScreen extends StatefulWidget {
  static const name = 'administration_screen'; // Nombre de la pantalla de administración

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
  bool _qrScanned =
      false; // Bandera para rastrear si se ha escaneado un código QR
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int selectedIndex = 0; // Índice para controlar la pantalla seleccionada
  String? commerceId; // Variable para almacenar el commerceId

  // Lista de pantallas a mostrar en el Stack
 /* final List<Widget> _screens = [
    const AdministratorCampaign(), // Añade la página de administración de productos
  ];*/

  // Lista de pantallas a mostrar en el Stack
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

    Future<void> _initializeScreens() async {
    commerceId = await _getcurrentCommerceId();
    if (commerceId != null) {
      setState(() {
        _screens = [
          AdministratorCampaign(commerceId: commerceId!), // Pasa el commerceId a la pantalla
        ];
      });
    }
  }

  // Función para obtener el ID del comercio actual
  Future<String?> _getcurrentCommerceId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

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
      key: scaffoldKey,
      drawer: SideMenu(
        scaffoldKey: scaffoldKey,
        userType: 'COMERCIO',
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      appBar: AppBar(
        title:
            const Text('Administrador'), // Título de la barra de la aplicación
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              setState(() {
                showScanner =
                    !showScanner; // Cambia el estado de showScanner para mostrar/ocultar el QRView
                qrText = '';
                _qrScanned = false;
              });
            },
          ),
          IconButton(
            onPressed:
                () {}, // Manejador del botón de búsqueda (sin funcionalidad por ahora)
            icon: const Icon(Icons.search_rounded), // Icono de búsqueda
          )
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: _screens,
          ),
          AnimatedOpacity(
            opacity: showScanner ? 1.0 : 0.0, // Controla la opacidad
            duration:
                const Duration(milliseconds: 1000), // Duración de la animación
            child: Visibility(
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
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // Actualiza el controlador del QRView
    setState(() {
      this.controller = controller;
    });

    // Escucha el stream de datos escaneados del QRView
    controller.scannedDataStream.listen((Barcode scanData) async {
      // Verifica si qrText ya se actualizó antes de volver a actualizar
      if (!_qrScanned) {
        // Actualiza qrText con el código QR escaneado
        setState(() {
          qrText = scanData.code;
          _qrScanned = true; // Indica que se ha escaneado un código QR
          // Maneja el código QR escaneado aquí (por ejemplo, muestra un diálogo o realiza una acción)
        });

        // Obtiene el ID del comercio actual
        final currentCommerceId = await _getcurrentCommerceId();

        if (currentCommerceId != null) {
          final userEmail = qrText;
          final commerceDocRef =
              _firestore.collection('commerce').doc(currentCommerceId);
          final commerceDocSnapshot = await commerceDocRef.get();

          if (commerceDocSnapshot.exists) {
            final commerceData =
                CommerceData.fromJson(commerceDocSnapshot.data()!);
            final existingUser = commerceData.userPointsList
                .any((up) => up.userEmail == userEmail);

            if (existingUser) {
              final updatedUserPointsList = [...commerceData.userPointsList];
              final existingUserPoints = updatedUserPointsList
                  .firstWhere((up) => up.userEmail == userEmail);
              existingUserPoints.awardedPoints += 10;

              await commerceDocRef.update({
                'userPointsList':
                    updatedUserPointsList.map((up) => up.toJson()).toList(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Se han adicionado 10 puntos más a $userEmail en este comercio'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } else {
              final updatedUserPointsList = [...commerceData.userPointsList];
              updatedUserPointsList.add(
                  UserPoints(userEmail: userEmail ?? '', awardedPoints: 10));

              await commerceDocRef.update({
                'userPointsList':
                    updatedUserPointsList.map((up) => up.toJson()).toList(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Se han adicionado 10 puntos a $userEmail en este comercio'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
          }
        }
      }
    });
  }
}
