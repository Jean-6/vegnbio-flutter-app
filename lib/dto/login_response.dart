import '../domain/model/Role.dart';

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
    return LoginResponse(
        id:json['_id'] ?? json['id'],
        username: json['username'],
        email: json['email'],
        roles: (json['roles'] as List<dynamic>)
            .map((r) => Role.fromJson(r))
            .toList(),
        token: json['token']);
  }



}
