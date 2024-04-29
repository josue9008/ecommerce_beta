import 'package:flutter/material.dart';

class CheckAuthStatusScreen extends StatelessWidget {
  static const name = 'checkauthstatus_screen';
  const CheckAuthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}