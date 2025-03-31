import 'package:app_loja_keycloak/services/auth-services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum/auth_mode.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final List<String> _options = ['pt-BR', 'en'];
  final Map<String, String> _authData = {
    'username': '',
    'password': '',
    'email': '',
    'locale': '',
  };

  String? _selectedOption;
  AuthMode _authMode = AuthMode.login;

  bool _isLogin() => _authMode == AuthMode.login;

  void _switchAuthMode() {
    setState(
      () =>
          _isLogin() ? _authMode = AuthMode.signup : _authMode = AuthMode.login,
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    AuthServices auth = Provider.of<AuthServices>(context, listen: false);
    try {
      if (_isLogin()) {
        Map<String, dynamic> result = await auth.login(
          _authData['username']!,
          _authData['password']!,
        );
        if (!result['success']) {
          _showErrorDialog('${result['message']} - ${result['statusCode']}');
        }
      } else {
        _authData['locale'] = _selectedOption!;
        Map<String, dynamic> result = await auth.createUser(
          _authData['username']!,
          _authData['email']!,
          _authData['password']!,
          _authData['locale']!,
        );
        if (!result['success']) {
          _showErrorDialog('${result['message']} - ${result['statusCode']}');
        }
      }
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado');
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Ocorreu um erro'),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                keyboardType: TextInputType.text,
                onSaved: (value) => _authData['username'] = value ?? '',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username inválido';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                keyboardType: TextInputType.text,
                onSaved: (value) => _authData['password'] = value ?? '',
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Senha inválida';
                  }
                  return null;
                },
              ),
            ),
            if (!_isLogin()) ...[
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar senha'),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator:
                      _isLogin()
                          ? null
                          : (value) {
                            final password = value ?? '';

                            if (password != _passwordController.text) {
                              return 'As senhas são diferentes';
                            }
                            return null;
                          },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _authData['email'] = value ?? '',
                  validator: (value) {
                    final email = value ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
              ),
              DropdownButton<String>(
                //menuWidth: (double.infinity - 20),
                value: _selectedOption,
                hint: const Text(
                  'Selecione o idioma',
                  textAlign: TextAlign.center,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                items:
                    _options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _submit,
              child: Text(
                _authMode == AuthMode.login ? 'Entrar' : 'Criar usuário',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _switchAuthMode,
              child: Text(
                _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
