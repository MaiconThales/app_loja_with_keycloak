import 'dart:async';

class Auth {
  String? _accessToken;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _accessToken != null && isValid;
  }

  String? get accessToken {
    return isAuth ? _accessToken : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  DateTime? get expiryDate {
    return isAuth ? _expiryDate : null;
  }

  void setValues(
    String accessToken,
    String email,
    String userId,
    DateTime expiryDate,
  ) {
    _accessToken = accessToken;
    _email = email;
    _userId = userId;
    _expiryDate = expiryDate;
  }
}
