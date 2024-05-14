import 'package:flutter/material.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';

class ProductsScreen extends StatelessWidget {
  static const name = 'products_screen';

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final _qrDataController = TextEditingController(); // Controlador del TextField

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Generar QR'),
        icon: const Icon(Icons.qr_code),
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Ingresa el contenido del código QR'),
              content: TextField(
                controller: _qrDataController, // Usar el controlador
                decoration: const InputDecoration(
                  hintText: 'URL, email, etc.',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Aceptar'); // Simular clic en "Aceptar"
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );

          if (result == 'Aceptar') {
            // Get QR data from user
            final qrData = _qrDataController.text; // Obtener el valor del controlador

            if (qrData.isNotEmpty) {
              // Show QR code dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Código QR'),
                  content: QRCode(qrData: qrData),
                    actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Cerrar el diálogo del QR
                        _qrDataController.clear(); // Limpiar el valor del controlador
                      },
                      child: const Text('Cerrar'),
                    ),
                  ], // Pasar datos QR al widget
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Eres genial!'));
  }
}
