import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';

class OTPScreen extends StatefulWidget {
  String verificationid;

  OTPScreen({super.key, required this.verificationid});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _otpController = TextEditingController();
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
                  textEditingController: _otpController,
                  hintText: 'Phone',
                  textInputType: TextInputType.number),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                   PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                    verificationId: widget.verificationid, 
                    smsCode: _otpController.text.toString()
                  );
                  //FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
                     FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AdministrationScreen(),
                          ),
                        )                  
                  });    
                  } catch (ex) {
                    print(ex.toString());
                  }
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
