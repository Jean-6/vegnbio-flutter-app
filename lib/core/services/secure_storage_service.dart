


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  static final _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async{
    await _storage.write(key: 'jwt', value: token);
  }

  static Future<String?> getToken() async{
    return await _storage.read(key: 'jwt');
  }

  static Future<void> saveRoles(List<String> roles) async {
    await _storage.write(key: 'roles', value: roles.join(','));
  }

  static Future<List<String>?> getUserRoles() async {
    final rolesStr = await _storage.read(key: 'roles');
    if (rolesStr == null || rolesStr.isEmpty) return null;
    return rolesStr.split(',');
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