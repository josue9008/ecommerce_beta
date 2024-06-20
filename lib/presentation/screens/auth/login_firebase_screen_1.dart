import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';
import '../../widgets/widgets.dart';
import 'package:animate_do/animate_do.dart';

class LoginFirebaseScreen1 extends StatefulWidget {
  static const name = 'login_firebase_screen_1';
  const LoginFirebaseScreen1({Key? key}) : super(key: key);

  @override
  State<LoginFirebaseScreen1> createState() => _LoginFirebaseScreen1State();
}

class _LoginFirebaseScreen1State extends State<LoginFirebaseScreen1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  double _containerHeight = 0;
  String _errorMessage = '';
  bool _showErrorMessage = false;

  void updateContainerHeight(bool isKeyboardVisible) {
    setState(() {
      _containerHeight = isKeyboardVisible ? 0 : 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    updateContainerHeight(isKeyboardVisible);

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
                    ? const SizedBox.shrink()
                    : Column(
                        key: UniqueKey(),
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                FadeInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: const Text(
                                    "Bienvenido",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _containerHeight,
                  curve: Curves.easeInOut,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: isKeyboardVisible ? 30 : 60,
                          ),
                          AnimatedOpacity(
                            opacity: _showErrorMessage ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: _showErrorMessage
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error,
                                            color: Colors.red),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _errorMessage,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(135, 206, 250, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
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
                                            color: Colors.grey.shade200),
                                      ),
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
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: _isLoading
                                ? Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.blue.shade300,
                                          Colors.blue.shade400,
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.blue.shade300,
                                          Colors.blue.shade400,
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: loginUser,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                      ),
                                      child: const Text(
                                        "Ingresar",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 1800),
                                  child: _isGoogleLoading
                                      ? Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue.shade200,
                                                Colors.blue.shade300,
                                                Colors.blue.shade400,
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue.shade200,
                                                Colors.blue.shade300,
                                                Colors.blue.shade400,
                                              ],
                                            ),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: loginUserWithGoogle,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40,
                                                      vertical: 15),
                                            ),
                                            child: const Text(
                                              "Google",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: FadeInUp(
                                  duration: const Duration(milliseconds: 1900),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade200,
                                          Colors.blue.shade300,
                                          Colors.blue.shade400,
                                        ],
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPhoneFirebaseScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15),
                                      ),
                                      child: const Text(
                                        "Teléfono",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "No tienes una cuenta?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: navigateSignup,
                                child: const Text(
                                  " Regístrate",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(
                                        0xff1e81b0), // Color personalizado
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: isKeyboardVisible ? 30 : 100,
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
      _isLoading = true; // Show loading indicator for normal login
      _errorMessage = ''; // Clear previous error message
      _showErrorMessage = false;
    });

    final res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      await res;
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
          setState(() {
            _isLoading = false; // Hide loading indicator if user not found
            _errorMessage = 'Usuario o contraseña incorrecta, verifique';
            _showErrorMessage = true;
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _showErrorMessage = false; // Hide the error message smoothly
            });
          });
        }
      } else {
        setState(() {
          _isLoading = false; // Hide loading indicator
          _errorMessage = 'Usuario o contraseña incorrecta, verifique';
          _showErrorMessage = true;
        });
        FocusScope.of(context).unfocus(); // Hide the keyboard
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showErrorMessage = false; // Hide the error message smoothly
          });
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Hide loading indicator
        _errorMessage = 'Usuario o contraseña incorrecta, verifique!';
        _showErrorMessage = true;
      });
      FocusScope.of(context).unfocus(); // Hide the keyboard
      print('Login failed: $error');
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _showErrorMessage = false; // Hide the error message smoothly
        });
      });
    }
  }

  Future<void> loginUserWithGoogle() async {
    setState(() {
      _isGoogleLoading = true; // Show loading indicator for Google login
      _errorMessage = ''; // Clear previous error message
      _showErrorMessage = false;
    });

    try {
      final userCredential = await AuthMethods().signInWithGoogle(context);

      final String email = userCredential.user!.email!;
      final String userType = await getUserType(email);

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
        setState(() {
          _isGoogleLoading = false; // Hide loading indicator if user not found
          _errorMessage = 'Usuario o contraseña incorrecta, verifique';
          _showErrorMessage = true;
        });
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showErrorMessage = false; // Hide the error message smoothly
          });
        });
      }
    } catch (err) {
      print('Error al iniciar sesión con Google: $err');
      setState(() {
        _isGoogleLoading = false; // Hide loading indicator
        _errorMessage = 'Error al iniciar sesión con Google, intente de nuevo';
        _showErrorMessage = true;
      });
      FocusScope.of(context).unfocus(); // Hide the keyboard
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _showErrorMessage = false; // Hide the error message smoothly
        });
      });
    }
  }

  void navigateSignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }
}
