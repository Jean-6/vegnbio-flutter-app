import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class CredentialStorageHelper {
  final logger = Logger();

  final secureStorage = FlutterSecureStorage();

  Future<void> initializeIfNeeded({
    String defaultUsername = 'dev',
    String defaultPassword = 'd5008d27-bc1d-4640-af58-d5591aed8af4',
  }) async {
    final existingUsername = await secureStorage.read(key: 'username');
    final existingPassword = await secureStorage.read(key: 'password');

    if (existingUsername == null || existingPassword == null) {
      logger.w("⚠️ Credentials absents — initialisation avec les valeurs par défaut");
      await writeBasicAuthHeader(
        username: defaultUsername,
        password: defaultPassword,
      );
    } else {
      logger.w("⚠️ Credentials absents — initialisation avec les valeurs par défaut");

    }
  }

  Future<void> writeBasicAuthHeader({
    required String username,
    required String password,
  }) async {
    await secureStorage.write(key: 'username', value: username);
    await secureStorage.write(key: 'password', value: password);
    logger.i("Credentials saved : $username / $password");
  }

  Future<String?> readBasicAuthHeader() async {
    await initializeIfNeeded();
    String? name = await secureStorage.read(key: 'username');
    String? pwd = await secureStorage.read(key: 'password');
    logger.i(">> Name: $name, Password: $pwd");
    if (name != null && pwd != null) {
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$name:$pwd'))}';
      return basicAuth;
    }
    logger.e('Credentials missing');
    return null;
  }

  Future<void> clearCredentials() async {
    await secureStorage.delete(key: 'username');
    await secureStorage.delete(key: 'password');
    logger.i("✅ Credentials supprimés");
  }


}
