import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:go_router/go_router.dart';
import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';
import '../../widgets/widgets.dart';

class LoginFirebaseScreen1 extends StatefulWidget {
  static const name = 'login_firebase_screen_1';
  const LoginFirebaseScreen1({super.key});

  @override
  State<LoginFirebaseScreen1> createState() => _LoginFirebaseScreen1State();
}

class _LoginFirebaseScreen1State extends State<LoginFirebaseScreen1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String> getUserType(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      final querySnapshotCommerce = await FirebaseFirestore.instance
          .collection('commerce')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'user';
      } else if (querySnapshotCommerce.docs.isNotEmpty) {
        return 'commerce';
      } else {
        return 'not_found'; // Handle user not found scenario
      }
    } catch (err) {
      print(err);
      return 'error';
    }
  }

  void loginUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    /*String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );*/

    final res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      await res;
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        String userType = await getUserType(_emailController.text);
        if (userType == 'user') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProductsScreen(),
            ),
          );
        } else if (userType == 'commerce') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdministrationScreen(),
            ),
          );
        } else {
          print('User not found or error occurred: $userType');
        }
      } else {
        // Handle login failure (e.g., show an error message)
        print('Login failed: $res');
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      // Handle login failure (e.g., show an error message)
      print('Login failed: $error');
    }
  }

  void loginUserWithGoogle() async {
    try {
      final userCredential = await AuthMethods().signInWithGoogle();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ProductsScreen(),
        ),
      );

      // Manejar el éxito del inicio de sesión (e.g., navegar a la pantalla principal)
      print('Usuario inició sesión con Google: ${userCredential.user!.email}');
    } catch (err) {
      // Manejar errores generales (e.g., mostrar mensaje de error)
      print('Error al iniciar sesión con Google: $err');
    }
  }

  void navigateSignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              InputTextField(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              InputTextField(
                textEditingController: _passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                      onPressed: loginUser,
                      child: const Text('Ingresar'),
                    ),
              /* ElevatedButton(
                  onPressed: loginUser, child: const Text('Ingresar')
              ),*/
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: loginUserWithGoogle,
                      child: const Text('Google')),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginPhoneFirebaseScreen(),
                          ),
                        );
                      },
                      child: const Text('Teléfono')),
                ],
              ),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('¿No tienes una cuenta?  '),
                  ),
                  GestureDetector(
                    onTap: navigateSignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
