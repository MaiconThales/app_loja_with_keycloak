import 'package:app_loja_keycloak/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    logout() {
      AuthServices auth = Provider.of(context, listen: false);
      auth.logout();
      Navigator.of(context).pushReplacementNamed(AppRoutes.authOrHome);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: logout,
          ),
        ],
      ),
      body: const Center(child: Text('Tela home')),
    );
  }
}
