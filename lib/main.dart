import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ecommerce_beta/config/config.dart';
import 'package:ecommerce_beta/presentation/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  //options: const FirebaseOptions(apiKey: 'AIzaSyAKrOH-VEG5w1v-MYXAncS6dY00sz9w4M4', appId: '1:933668294266:android:f80fc8d91253714508f5c3', messagingSenderId: '933668294266', projectId: 'flutter-ecommerce-fb692')
);
  await Environment.initEnvironment();
  runApp(
    const ProviderScope(child: MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
  
    
    return MaterialApp(
      title: 'EcommerceApp',      
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 7).getTheme(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
       /* if(snapshot.connectionState == ConnectionState.active) {
          if(snapshot.hasData){
            return const ProductsScreen();
          } else if( snapshot.hasError ){
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
        }*/

       if( snapshot.connectionState == ConnectionState.waiting ){
        return const Center(
          child: CircularProgressIndicator(),
        );       
       } 
       return const AppTutorialScreen();
       //return const LoginFirebaseScreen1();
         /* if(snapshot.hasData){
            return const ProductsScreen();
          } 
         return const LoginFirebaseScreen1(); */
         //return const AuthFirebaseScreen(); 
      },
    ),   
    );
  } 
}
/*class MainApp extends ConsumerWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    //final appRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'EcommerceApp',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 7).getTheme()     
    );
  } 
}*/