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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  late String _selectedType = 'COMERCIO'; // Valor inicial seleccionado

  // Lista de opciones para el dropdown
  final List<String> _typeOptions = ['COMERCIO', 'CLIENTE'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void navigateLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginFirebaseScreen1(),
    ));
  }

  void showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool validateEmail(String email) {
    const pattern =
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$'; // Simple regex pattern for email validation
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    void registerUser() async {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackbar('Las contraseñas no coinciden', Colors.red);
        setState(() {
          _isLoading = false; // Hide loading indicator if passwords do not match
        });
        return;
      }

      if (!validateEmail(_emailController.text)) {
        showSnackbar('El email proporcionado no tiene el formato correcto', Colors.red);
        setState(() {
          _isLoading = false; // Hide loading indicator if email format is incorrect
        });
        return;
      }

      String resp = await AuthMethods().registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _nameController.text,
        userType: _selectedType,
      );

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (resp == 'success') {
        showSnackbar('Usuario creado satisfactoriamente!', Theme.of(context).primaryColor);
        Navigator.of(context).push(
          MaterialPageRoute(
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
                textInputType: TextInputType.emailAddress,
                 prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 24,
              ),
              InputTextField(
                textEditingController: _passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,
                prefixIcon: const Icon(Icons.password),
              ),
              const SizedBox(
                height: 24,
              ),
              InputTextField(
                textEditingController: _confirmPasswordController,
                hintText: 'Confirmar Password',
                textInputType: TextInputType.text,
                isPass: true,
                prefixIcon: const Icon(Icons.password),
              ),
              const SizedBox(
                height: 24,
              ),
              InputTextField(
                textEditingController: _nameController,
                hintText: 'Nombre',
                textInputType: TextInputType.text,
                prefixIcon: const Icon(Icons.business_center),
              ),
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                height: 10,
              ),
              _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                      onPressed: registerUser, child: const Text('Registrar')),
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
        ),
      ),
    );
  }
}
