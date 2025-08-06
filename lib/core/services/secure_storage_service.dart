


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../dto/role.dart';

class SecureStorageService{
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async{
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<String?> getToken() async{
    return await _storage.read(key: 'jwt');
  }

  static Future<void> saveRole(Role role) async{
    await _storage.write(key: 'role', value: role.role.toString());
  }

  static Future<String?> getRole() async{
    return await _storage.read(key: 'role');
  }

  static Future<void> clearAll() async{
    await _storage.deleteAll(); //Logout
  }



}