class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }


  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
    "username":"username",
    "password":"password"
    }''';
  }

}