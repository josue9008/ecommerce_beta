import 'package:flutter/material.dart';
import 'package:ecommerce_beta/config/router/app_router.dart';
import 'package:ecommerce_beta/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {

  runApp(    
    const ProviderScope(child:MainApp() )
  );
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EcommerceApp',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 7).getTheme()     
    );
  }
}
