import 'package:app_loja_keycloak/pages/auth/auth_or_home_page.dart';
import 'package:app_loja_keycloak/pages/home/home_page.dart';
import 'package:app_loja_keycloak/services/auth-services.dart';
import 'package:app_loja_keycloak/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthServices())],
      child: MaterialApp(
        title: 'App Loja',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (context) => const AuthOrHomePage(),
          AppRoutes.home: (context) => const HomePage(),
        },
      ),
    );
  }
}
