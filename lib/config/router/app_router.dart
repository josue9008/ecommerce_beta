//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:ecommerce_beta/presentation/providers/auth_provider.dart';
//import 'package:ecommerce_beta/config/router/app_router_notifier.dart';
import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
      GoRoute(
        path: '/',
        name: AppTutorialScreen.name,
        builder: (context, state) => const AppTutorialScreen(),
      ),
      GoRoute(
      path: '/splash',
      name: CheckAuthStatusScreen.name,
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/loginfirebase',
      name: AuthFirebaseScreen.name,
      builder: (context, state) => const AuthFirebaseScreen(),
    ),
    GoRoute(
      path: '/loginfirebase1',
      name: LoginFirebaseScreen1.name,
      builder: (context, state) => const LoginFirebaseScreen1(),
    ),
     GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ), 
    GoRoute(
      path: '/product',
      name: ProductsScreen.name,
      builder: (context, state) => const ProductsScreen(),
    ),
    ], 
);


/*final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return  GoRouter(
    initialLocation: '/',
    refreshListenable: goRouterNotifier  ,
    routes: [
      GoRoute(
        path: '/',
        name: AppTutorialScreen.name,
        builder: (context, state) => const AppTutorialScreen(),
      ),
      GoRoute(
      path: '/splash',
      name: CheckAuthStatusScreen.name,
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login-firebase',
      name: AuthFirebaseScreen.name,
      builder: (context, state) => const AuthFirebaseScreen(),
    ),
     GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ), 
    GoRoute(
      path: '/product',
      name: ProductsScreen.name,
      builder: (context, state) => const ProductsScreen(),
    ),
    ],  
    redirect: (context, state) {
      // print(state.subloc); state.subloc no funciona para la version que se encuentra trabajando
       final isGoingTo = state.location;// state.subloc 
       final authStatus = goRouterNotifier.authStatus;

       if( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;
       if (authStatus == AuthStatus.nonAuthenticaded) {
        if( isGoingTo == '/login' || isGoingTo == '/register') return null;
        return null;          
       }

       if( authStatus == AuthStatus.authenticaded ){
         if( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash' ) return '/';        
       }

       // Aqui se puede comprobobar segun el rol ir a la pantalla correspondiente.
       
      return null;
    },
  );
  //return goRouter;
}
);*/