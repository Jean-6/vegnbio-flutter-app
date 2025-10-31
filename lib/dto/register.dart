

import 'dart:convert';

import 'package:vegnbio/dto/role.dart';

class RegisterRequest{

  final String username;
  final String email;
  final String password;
  final String source; // "web" ou "mobile"
  final String? userType; // "supplier" ou "customer" si mobile

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.source,
    this.userType,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'username': username,
      'email': email,
      'password': password,
      'source': source,
    };

    if (userType != null) {
      data['userType'] = userType!;
    }

    return data;
  }

  String toRawJson() => json.encode(toJson());
}

class RegisterResponse{
  final String id;
  final String username;
  final String email;
  final List<Role> roles;
  final bool isVerified;
  final bool isActive;
  final String token;

  RegisterResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.isVerified,
    required this.isActive,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e))
          .toList() ??
          [],
      isVerified: json['verified'] ?? false,
      isActive: json['active'] ?? true,
      token: json['token'] ?? '',
    );
  }

  static RegisterResponse fromRawJson(String str) =>
      RegisterResponse.fromJson(json.decode(str));

}