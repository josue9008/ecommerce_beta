import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:go_router/go_router.dart';

import 'package:ecommerce_beta/presentation/widgets/widgets.dart';
import 'package:ecommerce_beta/presentation/providers/register_form_provider.dart';


class RegisterScreen extends StatelessWidget {
  static const name = 'register_screen';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style:
                        textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              //height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              height: size.height - 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

// class _RegisterForm extends StatelessWidget {
  class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final textStyles = Theme.of(context).textTheme;
    final registerForm = ref.watch(registerFormProvider);
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final repeatPasswordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          //const SizedBox( height: 50 ),
          const Spacer(flex: 2),
          // TODO: se puede colocar Text('Nueva cuenta', style: textStyles.titleMedium ),
          const Spacer(),
          //const SizedBox( height: 50 ),

           const CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.name,           
                  
          ),

          /*TextFormField(
            controller: fullNameController,
            decoration: const InputDecoration(hintText: 'Nombre completo'),
          ),*/
          const SizedBox(height: 30),

          CustomTextFormField(
             label: 'Correo',
             keyboardType: TextInputType.emailAddress,
             onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
             errorMessage: registerForm.isFormPosted ? registerForm.email.errorMessage : null,
           ),

          /*TextFormField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),*/

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChanged,
             errorMessage: registerForm.isFormPosted ? registerForm.password.errorMessage : null,
          ),

          /*TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Contraseña'),
          ),*/

          const SizedBox(height: 30),

          const CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
          ),

          /*TextFormField(
            controller: repeatPasswordController,
            decoration: const InputDecoration(hintText: 'Repita la contraseña'),
          ),*/

          const SizedBox(height: 30),

          SizedBox(
              width: double.infinity,
              height: 40,
              child: CustomFilledButton(
                text: 'Crear',
                buttonColor: Colors.black,
                onPressed: () async {
                 
                  SharedPreferences sp = await SharedPreferences.getInstance();                  
                  sp.setString('fullName', fullNameController.text.toString());
                  sp.setString('email', emailController.text.toString());
                  //sp.setBool('token', true);             
                  sp.setString('role', 'commerce');
                 // sp.setBool('isLogin', true);
                  context.go('/login');
                },
              )),

          const Spacer(flex: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Ingresa aquí'))
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
