import 'package:flutter/material.dart';
import '../../../infrastructure/infrastructure.dart';
import '../../widgets/widgets.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
      showSnackbar(
          'El email proporcionado no tiene el formato correcto', Colors.red);
      setState(() {
        _isLoading =
            false; // Hide loading indicator if email format is incorrect
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
      showSnackbar(
          'Usuario creado satisfactoriamente!', Theme.of(context).primaryColor);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginFirebaseScreen1(),
        ),
      );
    } else {
      showSnackbar('Usuario no creado: $resp', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detecta si el teclado está visible
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.blue.shade200,
                Colors.blue.shade300,
                Colors.blue.shade400,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isKeyboardVisible
                    ? SizedBox.shrink()
                    : Column(
                        key: UniqueKey(),
                        children: [
                          const SizedBox(height: 80),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: const Text(
                                    "Registro",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      // <-- Añadir SingleChildScrollView aquí
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: isKeyboardVisible ? 20 : 30),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.blue.shade200.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value:
                                          _selectedType, // Valor seleccionado inicialmente
                                      items: _typeOptions
                                          .map((String type) =>
                                              DropdownMenuItem<String>(
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
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: InputTextField(
                                      textEditingController: _emailController,
                                      hintText: 'Email',
                                      textInputType: TextInputType.emailAddress,
                                      prefixIcon: const Icon(Icons.email),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: InputTextField(
                                      textEditingController:
                                          _passwordController,
                                      hintText: 'Password',
                                      textInputType: TextInputType.text,
                                      isPass: true,
                                      prefixIcon: const Icon(Icons.password),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: InputTextField(
                                      textEditingController:
                                          _confirmPasswordController,
                                      hintText: 'Confirmar Password',
                                      textInputType: TextInputType.text,
                                      isPass: true,
                                      prefixIcon: const Icon(Icons.password),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200)),
                                    ),
                                    child: InputTextField(
                                      textEditingController: _nameController,
                                      hintText: 'Nombre',
                                      textInputType: TextInputType.text,
                                      prefixIcon:
                                          const Icon(Icons.business_center),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: registerUser,
                              height: 40,
                              color: Colors.blue
                                  .shade400, // Cambia este color para contraste
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : const Text(
                                        "Registrar",
                                        style: TextStyle(
                                          color: Colors
                                              .white, // Color del texto en el botón
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("Ya tienes cuenta?",
                                    style: TextStyle(color: Colors.grey[700])),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: navigateLogin,
                                  child: const Text(
                                    " Inicia Sesión",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .blue, // Color del texto del enlace
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
