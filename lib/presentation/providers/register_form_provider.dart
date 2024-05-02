import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:ecommerce_beta/presentation/providers/auth_provider.dart';


//! 3- StateNotifierProvider - consume afuera

final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
  
  //final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  final simulatedRegisternUserCallback = ref.watch(authProvider.notifier).registerUser;
  
  return RegisterFormNotifier(
    // loginUserCallback: loginUserCallback
    loginUserCallback: simulatedRegisternUserCallback
  ); 
});


//! 1- State del provider
class RegisterFormState {
  final bool isPosting; // variable para saber si se encuentra posteando
  final bool isFormPosted; // variable para conocer si la persona intento postearlo, y asi usarlo para mostrar errores
  final bool isValid;
  final String fullName;
  final Email email;
  final Password password;
  //final String phoneNumber;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.fullName = '',
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    //this.phoneNumber = ''
  });

  RegisterFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          String? fullName,
          Email? email,
          Password? password,          
          }) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          fullName: fullName ?? this.fullName,
          email: email ?? this.email,
          password: password ?? this.password,
          //phoneNumber: phoneNumber ?? this.phoneNumber
          );

  @override
  String toString() {
    return '''
    LoginFormState:
      isPosting : $isPosting
      isFormPosted : $isFormPosted
      isValid : $isValid
      fullName: $fullName
      email : $email
      password : $password     
  ''';
  }
}

//! 2- Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  
  //final Function(String, String, String) loginUserCallback;

  final Function(String, String, String) loginUserCallback;

 RegisterFormNotifier({
    required this.loginUserCallback,
  }) : super(RegisterFormState());

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
     //await loginUserCallback(state.email.value, state.phoneNumber, state.password.value);
     await loginUserCallback(state.fullName, state.email.value, state.password.value);

     state = state.copyWith(
        isPosting: false        
    ); 
  }

  _touchEveryField(){    
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      fullName: ' ',
      email: email,
      password: password,
      isValid: Formz.validate([email,password])
    );
  } 

}