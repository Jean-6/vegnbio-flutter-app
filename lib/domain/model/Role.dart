import 'ERole.dart';

class Role {

  final String? id;
  final ERole role;

  Role({this.id, required this.role});

  factory Role.fromJson(Map<String,dynamic> json){
    return Role(
      id:json['_id'] ?? json['id'],
      role: ERole.fromString(json['role']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      if(id != null) 'id':id,
      'role': role.name,
    };
  }

}