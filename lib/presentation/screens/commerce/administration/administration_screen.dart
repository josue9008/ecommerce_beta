import 'dart:io'; // Importa la librería para detectar la plataforma (Android o iOS)

import 'package:flutter/material.dart'; // Importa el paquete de Flutter para la interfaz de usuario
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart'; // Importa el paquete para escanear códigos QR

import '../../../../domain/domain.dart';
import '../../../widgets/shared/customs/customs.dart';
import '../commerce.dart'; // Importa tus widgets personalizados

class AdministrationScreen extends StatefulWidget {
  static const name = 'administration_screen'; // Nombre de la pantalla de administración

  const AdministrationScreen({super.key}); // Constructor

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? qrText; // Variable para almacenar el código QR escaneado
  QRViewController? controller; // Controlador para el QRView
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // Clave única para el QRView
  bool showScanner = false; // Bandera para controlar la visibilidad del QRView
  bool _qrScanned = false; // Bandera para rastrear si se ha escaneado un código QR 
  int selectedIndex = 0; // Índice para controlar la pantalla seleccionada
  String? commerceId; // Variable para almacenar el commerceId
  String? userName; // Variable para almacenar el nombre del usuario

  // Lista de pantallas a mostrar en el Stack
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  Future<void> _initializeScreens() async {
    commerceId = await _getCurrentCommerceId();
    await _getUserName(); // Obtiene el nombre del usuario al inicializar la pantalla
    if (commerceId != null) {
      setState(() {
        _screens = [
          AdministratorCampaign(commerceId: commerceId!), // Pasa el commerceId a la pantalla
        ];
      });
    }
  }

  // Función para obtener el ID del comercio actual
  Future<String?> _getCurrentCommerceId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  // Función para obtener el nombre del usuario actual
  Future<void> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('commerce').doc(user.uid).get(); // Asegúrate de que la colección sea la correcta
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['username']; // Asegúrate de que el campo sea el correcto
        });
      }
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

    return WillPopScope(
      onWillPop: () async {
         if (showScanner) {
          // Si el escáner QR está abierto, ciérralo y muestra el diálogo de confirmación después de 1 segundo
          setState(() {
            showScanner = false;
            _qrScanned = false;
            controller?.stopCamera();
          });
          
          // Esperar 1 segundo antes de mostrar el diálogo de confirmación
          await Future.delayed(Duration(seconds: 1));

          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('¿Deseas salir de la aplicación?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Sí'),
                  ),
                ],
              );
            },
          );

          if (shouldExit == true) {
            if (Platform.isAndroid) {
              SystemNavigator.pop(); // Cierra la aplicación en Android
            } else if (Platform.isIOS) {
              exit(0); // Cierra la aplicación en iOS
            }
            return true; // Permitir que el botón de retroceso cierre la pantalla
          } else {
            return false; // Evitar que el botón de retroceso cierre la pantalla
          }
        } else {
          // Si el escáner QR no está abierto, muestra el diálogo de confirmación para salir
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('¿Deseas salir de la aplicación?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Sí'),
                  ),
                ],
              );
            },
          );

          if (shouldExit == true) {
            if (Platform.isAndroid) {
              SystemNavigator.pop(); // Cierra la aplicación en Android
            } else if (Platform.isIOS) {
              exit(0); // Cierra la aplicación en iOS
            }
            return true; // Permitir que el botón de retroceso cierre la pantalla
          } else {
            return false; // Evitar que el botón de retroceso cierre la pantalla
          }
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: SideMenu(
          scaffoldKey: scaffoldKey,
          userType: 'COMERCIO',
          onDestinationSelected: (int index) {
            setState(() {
              // Cerrar el lector QR si está abierto
              if (showScanner) {
                controller?.stopCamera();
                showScanner = false;
                _qrScanned = false;
              }
              selectedIndex = index;
            });
          },
        ),
        appBar: AppBar(
          title: Text(
            _getFirstName(userName) ?? 'Comercio',
          ), // Muestra el primer nombre del usuario o 'Administrador' si no está disponible
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                setState(() {
                  showScanner = !showScanner; // Cambia el estado de showScanner para mostrar/ocultar el QRView
                  qrText = '';
                  _qrScanned = false;
                });
              },
            ),
            IconButton(
              onPressed: () {}, // Manejador del botón de búsqueda (sin funcionalidad por ahora)
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
              duration: const Duration(milliseconds: 1000), // Duración de la animación
              child: Visibility(
                visible: showScanner, // Muestra el QRView solo cuando showScanner sea true
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
      ),
    );
  }

  String? _getFirstName(String? fullName) {
    if (fullName == null) {
      return null;
    }
    final names = fullName.split(' ');
    return names.isNotEmpty ? names[0] : null;
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
          showScanner = false; // Oculta el escáner QR
        });

        // Obtiene el ID del comercio actual
        final currentCommerceId = await _getCurrentCommerceId();

        if (currentCommerceId != null) {
          final userEmail = qrText;
          final commerceDocRef = _firestore.collection('commerce').doc(currentCommerceId);
          final commerceDocSnapshot = await commerceDocRef.get();

          if (commerceDocSnapshot.exists) {
            final commerceData = CommerceData.fromJson(commerceDocSnapshot.data()!);
            final existingUser = commerceData.userPointsList.any((up) => up.userEmail == userEmail);

            if (existingUser) {
              final updatedUserPointsList = [...commerceData.userPointsList];
              final existingUserPoints = updatedUserPointsList.firstWhere((up) => up.userEmail == userEmail);
              existingUserPoints.awardedPoints += 10;

              await commerceDocRef.update({
                'userPointsList': updatedUserPointsList.map((up) => up.toJson()).toList(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Se han adicionado 10 puntos más a $userEmail en este comercio'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } else {
              final updatedUserPointsList = [...commerceData.userPointsList];
              updatedUserPointsList.add(UserPoints(userEmail: userEmail ?? '', awardedPoints: 10));

              await commerceDocRef.update({
                'userPointsList': updatedUserPointsList.map((up) => up.toJson()).toList(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Se han adicionado 10 puntos a $userEmail en este comercio'),
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
