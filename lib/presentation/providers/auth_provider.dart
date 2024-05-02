import 'package:ecommerce_beta/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImp();

  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(
      String email, String phoneNumber, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, phoneNumber, password);
      _setLoggedUser(user);
    } //on WrongCredentials {
    on CustomError catch (e) {
      logout(e.message);
      //logout('Credenciales no son correctas');
    } /*on ConnectionTimeout{
      logout('Timeout');
    }*/
    catch (e) {
      logout('Error no controlado');
    }
    //final user = await authRepository.login(email, phoneNumber, password);
    //state = state.copyWith(user:user, authStatus: AuthStatus.authenticaded);
  }

  

  Future<void> simulatedLoginUser(
      String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final storedEmail = await keyValueStorageService.getValue<String>('email');    

    if (storedEmail == null || storedEmail != email)  return;  
   final user = await authRepository.simulatedLogin(email, password);
     _setLoggedUser(user);
   
   
   /*else{
    
     final user = await authRepository.simulatedLogin(email, password);
     _setLoggedUser(user);
   }*/
    
  }

  void registerUser(String fullName,String email,String password) async {}

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if( token == null ) return logout();

     try {
        final user = await authRepository.checkAuthStatus(token);
        _setLoggedUser(user);
     } catch (e) {
        logout();
     }

  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    //await keyValueStorageService.setKeyValue('token', '1222222');
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticaded,
      errorMessage: '',
    );   
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.nonAuthenticaded,
        user: null,
        errorMessage: errorMessage);
  }
}

// ignore: slash_for_doc_comments
/**
 AuthStatus
 checking: esta revisando si el token es valido o no, verificar si se encuentra autenticado o no
 */
enum AuthStatus { checking, authenticaded, nonAuthenticaded }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking, // Al iniciar es checking porque no se sabe si se encuentra autenticado o no
      this.user,
      this.errorMessage = ''
      }
  );

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}