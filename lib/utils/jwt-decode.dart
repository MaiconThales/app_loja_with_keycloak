import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../models/Auth.dart';

class JwtDecode {
  static Auth? decodeToken(String accessToken) {
    try {
      Auth auth = Auth();

      final jwt = JWT.decode(accessToken);
      final userData = jwt.payload as Map<String, dynamic>;

      auth.setValues(
        accessToken,
        userData['email'],
        userData['sub'],
        DateTime.now().add(Duration(seconds: int.parse(userData['exp'].toString()))),
      );
      return auth;
    } on JWTException catch (e) {
      // TODO gerar notificação de erro
      print('Erro ao decodificar JWT: $e');
      return null;
    }
  }
}
