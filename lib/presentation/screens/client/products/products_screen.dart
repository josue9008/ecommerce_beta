import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';


class ProductsScreen extends StatelessWidget {
  
  static const name = 'products_screen';

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
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