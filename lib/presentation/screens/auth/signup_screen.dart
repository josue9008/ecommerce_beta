//import 'package:ecommerce_beta/presentation/widgets/shared/customs/customs.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/infrastructure.dart';
import '../../widgets/widgets.dart';

import 'package:ecommerce_beta/presentation/screens/screens.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  late String _selectedType = 'COMERCIO'; // Valor inicial seleccionado

  // Lista de opciones para el dropdown
  final List<String> _typeOptions = ['COMERCIO', 'CLIENTE'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    //_bioController.dispose();
    super.dispose();
  }

  void navigateLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginFirebaseScreen1(),
    ));
  }

  void showSnackbar(String message, backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void registerUser() async {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      String resp = await AuthMethods().registerUser(
          email: _emailController.text,
          password: _passwordController.text,
          userName: _nameController.text,
          userType: _selectedType
          //bio: _bioController.text,
          );

      setState(() {
        _isLoading = false; // Show loading indicator
      });

      if (resp == 'success') {
        showSnackbar('Usuario creado satisfactoriamente!',
            Theme.of(context).primaryColor);
        Navigator.of(context).push(
          MaterialPageRoute(
            //builder: (context) => const LoginScreen(),
            builder: (context) => const LoginFirebaseScreen1(),
          ),
        );
      } else {
        showSnackbar('Usuario no creado: $resp', Colors.red);
      }
    }

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(flex: 2, child: Container()),
            DropdownButtonFormField<String>(
              value: _selectedType, // Valor seleccionado inicialmente
              items: _typeOptions
                  .map((String type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (String? newType) {
                setState(() {
                  _selectedType = newType!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Usuario',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
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
            InputTextField(
                textEditingController: _nameController,
                hintText: 'Nombre',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),

            /*InputTextField(
              textEditingController: _bioController,
              hintText: 'Bio',
              textInputType: TextInputType.text              
            ),*/
            const SizedBox(
              height: 24,
            ),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : ElevatedButton(
                    onPressed: registerUser, 
                    child: const Text('Registar')
              ),
            Flexible(flex: 2, child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('¿Ya tienes una cuenta?  '),
                ),
                GestureDetector(
                  onTap: navigateLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
