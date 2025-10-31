import 'dart:convert';

import 'role.dart';

class LoginResponse{

  final String id;
  final String username;
  final String email;
  final List<Role> roles;
  final String token;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.token
  });

  factory LoginResponse.fromJson(Map<String,dynamic> json){

    dynamic rolesRaw = json['roles'];
    List<dynamic> rolesJson = [];

    if (rolesRaw is List) {
      rolesJson = rolesRaw;
    }
    else if (rolesRaw is String) {
      try {
        rolesJson = jsonDecode(rolesRaw);
      } catch (e) {
        rolesJson = [];
      }
    }

    return LoginResponse(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      roles: rolesJson.map((r) => Role.fromJson(r)).toList(),
      token: json['token'] ?? '',
    );
    /*return LoginResponse(
        id:json['_id'] ?? json['id'],
        username: json['username'],
        email: json['email'],
        roles: (json['roles'] as List<dynamic>)
            .map((r) => Role.fromJson(r))
            .toList(),
        token: json['token']);*/
  }


  @override
  String toString() {
    // TODO: implement toString
    return '''
    {
    "id":  "$id",
    "username": "$username",
    "email": "$email",
    "roles": "$roles",
    "token": "$token"
     }
     ''';
  }



}
