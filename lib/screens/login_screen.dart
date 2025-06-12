import 'package:flutter/material.dart';
import 'package:productes_app/providers/login_form_provider.dart';
import 'package:productes_app/ui/input_decorations.dart';
import 'package:productes_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 250),
            CardContainer(
              child: Column(children: [
                const SizedBox(height: 10),
                Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _LoginForm(),
                ),
              ]),
            ),
            const SizedBox(height: 50),
            const Text('Crear un nou compte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        //* Campo de correo electrónico
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com', labelText: 'Correo electrónico', prefixIcon: Icons.alternate_email_outlined),
          onChanged: (value) => loginForm.email = value,
          validator: (value) {
            String pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regExp = RegExp(pattern);
            return regExp.hasMatch(value!) ? null : 'No es de tipus correu';
          },
        ),
        const SizedBox(height: 30),
        //* Campo de contraseña
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecorations.authInputDecoration(hintText: '*****', labelText: 'Contraseña', prefixIcon: Icons.lock_outline),
          onChanged: (value) => loginForm.password = value,
          validator: (value) {
            return (value != null && value.length >= 6) ? null : 'La contraseña ha de tener 6 caracteres';
          },
        ),
        const SizedBox(height: 30),
        //* Botón de inicio de sesión
        MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.purple.shade900,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(loginForm.isLoading ? 'Espera' : 'Iniciar sesión', style: const TextStyle(color: Colors.white)),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    //* Deshabilita el teclado
                    FocusScope.of(context).unfocus();
                    if (loginForm.isValidForm()) {
                      loginForm.isLoading = true;
                      //Simula una petición
                      await Future.delayed(const Duration(seconds: 2));
                      loginForm.isLoading = false;
                      Navigator.pushReplacementNamed(context, 'home');
                    }
                  }),
      ]),
    );
  }
}
