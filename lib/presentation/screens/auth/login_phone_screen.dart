import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';

class LoginPhoneFirebaseScreen extends StatefulWidget {
  static const name = 'login_phone_firebase';
  const LoginPhoneFirebaseScreen({super.key});

  @override
  State<LoginPhoneFirebaseScreen> createState() =>
      _LoginPhoneFirebaseScreenState();
}

class _LoginPhoneFirebaseScreenState extends State<LoginPhoneFirebaseScreen> {
  TextEditingController _phoneController = TextEditingController();
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
                  textEditingController: _phoneController,
                  hintText: 'Phone',
                  textInputType: TextInputType.number),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: _phoneController.text.toString(),
                      verificationCompleted:(PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationid, int? resendToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                               OTPScreen(verificationid: verificationid),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationid) {});
                },
                child: const Text('Verificar numero telefonico'),
              ),
              Flexible(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
