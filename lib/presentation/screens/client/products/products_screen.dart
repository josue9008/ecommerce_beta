import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../domain/domain.dart';

class ProductsScreen extends StatefulWidget {
  static const name = 'products_screen';
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final AuthMethods _firebaseService = AuthMethods();
  List<CommerceData> _commerceData = [];

  @override
  void initState() {
    super.initState();
    _loadCommerceData();
  }

  Future<void> _loadCommerceData() async {
    final commerceData = await _firebaseService.getCommerceData();
    setState(() {
      _commerceData = commerceData;
    });
  }

  Widget _buildCampaignCard(Campaign campaign) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                campaign.campaignName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Duración: ${campaign.duration} días',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Cantidad de puntos: ${campaign.pointsQuantity}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Condiciones especiales: ${campaign.specialsConditions}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8.0)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
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
        title: const Text('Productos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: _commerceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _commerceData
                  .where((commerceData) => commerceData.campaigns.isNotEmpty)
                  .length,
              itemBuilder: (context, index) {
                final commerceData = _commerceData
                    .where((commerceData) => commerceData.campaigns.isNotEmpty)
                    .toList()[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commerceData.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: commerceData.campaigns.length,
                          itemBuilder: (context, campaignIndex) {
                            final campaign = commerceData.campaigns[campaignIndex];
                            return _buildCampaignCard(campaign);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Generar QR'),
        icon: const Icon(Icons.qr_code),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final qrData = user.email;
            if (qrData != null) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: QRCode(qrData: qrData),
                ),
              );
            }
          }
        },
      ),
    );
  }
}