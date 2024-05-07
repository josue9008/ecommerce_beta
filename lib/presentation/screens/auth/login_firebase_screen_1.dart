import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      Navigator.of(context).push(
        MaterialPageRoute(         
          builder: (context) => const ProductsScreen(),
        ),
      );
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
              ElevatedButton(
                  onPressed: loginUser, child: const Text('Ingresar')),
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
