//! 1- State del provider

import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class LoginFormState {
  final bool isPosting; // variable para saber si se encuentra posteando
  final bool
      isFormPosted; // variable para conocer si la persona intento postearlo, y asi usarlo para mostrar errores
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Email? email,
          Password? password}) =>
      LoginFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting : $isPosting
      isFormPosted : $isFormPosted
      isValid : $isValid
      email : $email
      password : $password
  ''';
  }
}

//! 2- Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

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

  onFormSubmit(){
     _touchEveryField();

     if( !state.isValid ) return;

     print(state);
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

//! 3- StateNotifierProvider - consume afuera

final LoginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier(); 
});