import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/domain.dart';
import 'dart:io'; // Importa la librería para detectar la plataforma (Android o iOS)
import 'package:flutter/services.dart';

class ProductsScreen extends StatefulWidget {
  static const name = 'products_screen';
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AuthMethods _firebaseService = AuthMethods();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CommerceData> _commerceData = [];
  String? userName;
  bool _isLoading = false;
  final List<List<Color>> _gradientColors = [
    [Colors.teal[100]!, Colors.teal[300]!],
    [Colors.blue[100]!, Colors.blue[300]!],
    [Colors.green[100]!, Colors.green[300]!],
    [Colors.orange[100]!, Colors.orange[300]!],
    [Colors.purple[100]!, Colors.purple[300]!],
    [Colors.red[100]!, Colors.red[300]!],
    [Colors.yellow[100]!, Colors.yellow[300]!],
  ];

  @override
  void initState() {
    super.initState();
    _loadCommerceData();
    _loadUserName();
  }

  Future<void> _loadCommerceData() async {
    setState(() {
      _isLoading = true;
    });
    final commerceData = await _firebaseService.getCommerceData();
    setState(() {
      _commerceData = commerceData;
      _isLoading = false;
    });
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('user').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['username'];
        });
      }
    }
  }

  Future<int> _getAccumulatedPoints(String userUid, String campaignName) async {
    final commerceQuerySnapshot = await _firestore.collection('commerce').get();
    int totalPoints = 0;

    for (final commerceDoc in commerceQuerySnapshot.docs) {
      final commerceData = CommerceData.fromJson(commerceDoc.data());
      final userPoints = commerceData.userPointsList.firstWhere(
        (up) => up.userUid == userUid && up.campaignName == campaignName,
        orElse: () => UserPoints(
            userUid: userUid, awardedPoints: 0, campaignName: campaignName),
      );

      totalPoints += userPoints.awardedPoints;

      // Debugging messages
      print('Commerce Data: ${commerceData.toJson()}');
      print('User UID: $userUid');
      print('Campaign Name: $campaignName');
      print('User Points: ${userPoints.awardedPoints}');
    }

    return totalPoints;
  }

  void _showCampaignsModal(BuildContext context, CommerceData commerceData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commerceData.userName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: commerceData.campaigns.length,
                    itemBuilder: (context, index) {
                      final campaign = commerceData.campaigns[index];
                      final gradientColors =
                          _gradientColors[index % _gradientColors.length];

                      return FutureBuilder<int>(
                        future: _getAccumulatedPoints(
                            FirebaseAuth.instance.currentUser!.uid,
                            campaign.campaignName),
                        builder: (context, snapshot) {
                          final points = snapshot.data ?? 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0, top: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            campaign.campaignName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.qr_code),
                                          onPressed: () async {
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            if (user != null) {
                                              final qrData = '''
                                                UID: ${user.uid}
                                                Comercio: ${commerceData.userName}
                                                Campaña: ${campaign.campaignName}
                                              ''';
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content:
                                                      QRCode(qrData: qrData),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0, bottom: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Duración: ${campaign.duration} días',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Objetivos: ${campaign.pointsQuantity} puntos',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Puntos Acumulados: $points',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshCommerceData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadCommerceData();
    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> _getCurrentCommerceId() async {
    // Implementa la lógica para obtener el ID del comercio actual
    // Esto puede ser mediante SharedPreferences, un servicio, etc.
    return 'currentCommerceId';
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
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
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: SideMenu(
          scaffoldKey: scaffoldKey,
          userType: 'CLIENTE',
          onDestinationSelected: (int index) {
            // Manejar la lógica de navegación aquí
            if (index == 0) {
              // Navegar a la pantalla de inicio
            } else if (index == 1) {
              // Navegar a la pantalla de administrar productos
            }
          },
        ),
        appBar: AppBar(
          title: Text(userName ?? 'Usuario'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshCommerceData,
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _commerceData.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ListView.builder(
                        itemCount: _commerceData
                            .where((commerceData) =>
                                commerceData.campaigns.isNotEmpty)
                            .length,
                        itemBuilder: (context, index) {
                          final commerceData = _commerceData
                              .where((commerceData) =>
                                  commerceData.campaigns.isNotEmpty)
                              .toList()[index];
                          final gradientColors =
                              _gradientColors[index % _gradientColors.length];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Campañas del Comercio',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        commerceData.userName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.info_outline,
                                  color: Colors.teal[900],
                                  size: 30,
                                ),
                                onTap: () =>
                                    _showCampaignsModal(context, commerceData),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
