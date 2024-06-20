import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'custom_filled_button.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';

class SideMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userType;
  final ValueChanged<int> onDestinationSelected;

  const SideMenu({
    Key? key,
    required this.scaffoldKey,
    required this.userType,
    required this.onDestinationSelected,
  }) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await auth.signOut();
               Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginFirebaseScreen1(),
            ),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Saludos', style: textStyles.titleMedium),
            accountEmail: Text('Usuario', style: textStyles.titleLarge),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Inicio'),
            onTap: () {
              onDestinationSelected(0);
              scaffoldKey.currentState?.closeDrawer();
            },
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text('Configuración', style: TextStyle(fontSize: 16)),
          ),
         /* ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ajustes'),
            onTap: () {
              onDestinationSelected(2);
              scaffoldKey.currentState?.closeDrawer();
            },
          ),*/
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
