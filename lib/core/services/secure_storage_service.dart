


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

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key:'userId', value: userId);
  }

  static Future<String?> getUserId() async{
    return await _storage.read(key: 'userId');
  }

  static Future<void> saveUsername(String username) async {
    await _storage.write(key:'userName', value: username);
  }

  static Future<String?> getUsername() async{
    return await _storage.read(key: 'username');
  }

  static Future<void> saveUserEmail(String userEmail) async {
    await _storage.write(key:'userEmail', value: userEmail);
  }

  static Future<String?> getUserEmail() async{
    return await _storage.read(key: 'userEmail');
  }

  static Future<void> clearAll() async{
    await _storage.deleteAll(); //Logout
  }



}