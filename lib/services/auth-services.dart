import 'dart:async';
import 'dart:convert';

import 'package:app_loja_keycloak/utils/constants.dart';
import 'package:app_loja_keycloak/utils/jwt-decode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/store.dart';
import '../models/Auth.dart';

class AuthServices with ChangeNotifier {
  Auth auth = Auth();

  bool get isAuth {
    return auth.isAuth;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("${Constants.serverIP}/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      Auth? auth = JwtDecode.decodeToken(body['access_token']);
      if (auth != null) {
        Store.saveMap('userData', {
          'token': auth.accessToken,
          'email': auth.email,
          'userId': auth.userId,
          'expiryDate': auth.expiryDate!.toIso8601String(),
        });

        notifyListeners();

        return {'success': true, 'message': 'Login realizado com sucesso.'};
      } else {
        return {
          'success': false,
          'message': 'Login error ao tentar decodificar o token!',
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Usuário ou senha inválidos!',
        'statusCode': response.statusCode,
      };
    }
  }

  Future<Map<String, dynamic>> createUser(
    String username,
    String email,
    String password,
    String locale,
  ) async {
    final response = await http.post(
      Uri.parse("${Constants.serverIP}/users/create"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "nameGroup": "operation",
        "locale": locale,
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': response.body};
    } else {
      return response.statusCode == 401
          ? {
            'success': false,
            'message': 'Seu usuário não tem permissão para criar usuários!',
            'statusCode': response.statusCode,
          }
          : {
            'success': false,
            'message': response.body,
            'statusCode': response.statusCode,
          };
    }
  }

  Future<void> tryAutoLogin() async {
    if (auth.isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    auth.setValues(
      userData['token'],
      userData['email'],
      userData['userId'],
      expiryDate,
    );

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    auth = Auth();
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });

    _logoutKeycloak();
  }

  void _logoutKeycloak() {
    http.post(
      Uri.parse("${Constants.serverIP}/logout"),
      headers: {'Content-Type': 'application/json'},
    );
  }

  void _clearLogoutTimer() {
    auth.logoutTimer?.cancel();
    auth.logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = auth.expiryDate?.difference(DateTime.now()).inSeconds;
    auth.logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
