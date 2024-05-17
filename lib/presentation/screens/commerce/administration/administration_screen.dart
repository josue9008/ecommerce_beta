import 'dart:io'; // Importa la librería para detectar la plataforma (Android o iOS)

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la interfaz de usuario
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importa el paquete de permission_handler (comentar y descomentar según sea necesario)
// Se utiliza para solicitar permisos de la cámara en caso de ser necesario para tu plataforma

import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa el paquete para escanear códigos QR

import '../../../../domain/domain.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentCommerceId = '';  

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
          Visibility(
            visible:
                !showScanner,
            child: Center(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: (FirebaseAuth.instance.currentUser?.uid != null)
                    ? _firestore
                        .collection('commerce')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots()
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final commerceData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final commerceDataObject =
                        CommerceData.fromJson(commerceData);
                    return FittedBox(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Correo')),
                          DataColumn(label: Text('Puntos Acumulados')),
                        ],
                        rows: commerceDataObject.userPointsList
                            .map((userPoints) => DataRow(cells: [
                                  DataCell(Text(userPoints.userEmail)),
                                  DataCell(Text(
                                      userPoints.awardedPoints.toString())),
                                ]))
                            .toList(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
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
