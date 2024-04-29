import 'package:ecommerce_beta/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';

//! 3- StateNotifierProvider - consume afuera

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  
  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  ); 
});


//! 1- State del provider
class LoginFormState {
  final bool isPosting; // variable para saber si se encuentra posteando
  final bool isFormPosted; // variable para conocer si la persona intento postearlo, y asi usarlo para mostrar errores
  final bool isValid;
  final Email email;
  final Password password;
  final String phoneNumber;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phoneNumber = ''
  });

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password,
          String? phoneNumber
          }) =>
      LoginFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password,
          phoneNumber: phoneNumber ?? this.phoneNumber);

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting : $isPosting
      isFormPosted : $isFormPosted
      isValid : $isValid
      email : $email
      password : $password
      phoneNumber: $phoneNumber
  ''';
  }
}

//! 2- Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  
  final Function(String, String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }) : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }

  onFormSubmit() async {
     _touchEveryField();

     state = state.copyWith(
        isPosting: true
    );

     if( !state.isValid ) return;
     await loginUserCallback(state.email.value, state.phoneNumber, state.password.value);

     state = state.copyWith(
        isPosting: false        
    );   
  }

  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email,password])
    );
  } 

}