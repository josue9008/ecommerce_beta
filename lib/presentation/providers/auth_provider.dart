import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_beta/infrastructure/infrastructure.dart';
import '../../domain/domain.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository}) : super(AuthState());

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

  void registerUser(String email, String phoneNumber, String password) async {}

  void checkAuthStatus() async {}

  void _setLoggedUser(User user) {
    // TODO: se necesita guardar el token fisicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticaded,
      //errorMessage:''
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: limpiar token

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
      {this.authStatus = AuthStatus
          .checking, // Al iniciar es checking porque no se sabe si se encuentra autenticado o no
      this.user,
      this.errorMessage = ''});

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
