

import 'Role.dart';

class User{
  final String id;
  final String username;
  final String email;
  final List<Role> roles;

  User({required this.id,
    required this.username,
    required this.email,
    required this.roles
  });

  factory User.fromJson(Map<String,dynamic> json){
    return User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        roles: (json['roles'] as List<dynamic>)
            .map((r) => Role.fromJson(r))
            .toList(),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'id': id,
      'username': username,
      'roles' : roles.map((r) => r.toJson()).toList(),
    };
  }

}