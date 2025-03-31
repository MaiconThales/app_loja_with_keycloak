import 'package:app_loja_keycloak/pages/auth/auth_page.dart';
import 'package:app_loja_keycloak/pages/home/home_page.dart';
import 'package:app_loja_keycloak/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthServices auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.error != null) {
          return const Scaffold(body: Center(child: Text('Ocorreu um erro!')));
        } else {
          print("Validar conteudo: ${auth.isAuth}");
          return auth.isAuth ? HomePage() : AuthPage();
        }
      },
    );
  }
}
