import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vegnbio/core/services/credential_storage_helper.dart';
import 'package:vegnbio/core/services/secure_storage_service.dart';

import '../../dto/login_response.dart';
import '../../dto/response_wrapper.dart';

class AuthService {

  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();

  Future<LoginResponse?> register({
    required String username,
    required String email,
    required String password,
  }) async {

    try{
      final basicAuth = await authHelper.readBasicAuthHeader();
      if(basicAuth == null){
        logger.e('error when retrieving basic auth credentials');
        return null;
      }

      final url = Uri.parse("$_baseUrl/api/auth/signup");

      final res = await http.post(url ,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : basicAuth,
          },
          body: json.encode({
            'username':username,
            'email': email,
            'password': password,
            'source':"mobile",
            'userType':"customer"
          })
      );
      if(res.statusCode == 200){
        final decoded = json.decode(res.body) as Map<String, dynamic>;
        final rw = ResponseWrapper<LoginResponse>.fromJson(
          decoded,
            (json) => LoginResponse.fromJson(json)
        );

        final loginResp = rw.data;
        await SecureStorageService.saveToken(loginResp.token);
        await SecureStorageService.saveUserId(loginResp.id);
        if (loginResp.roles.isNotEmpty) {
          final rolesList = loginResp.roles.map((r) => r.role.toString()).toList();
          await SecureStorageService.saveRoles(rolesList);
        }

        logger.d(" >> registration successful");
        return loginResp;
      }else{
        logger.e(' >> Error when registration: ${res.statusCode}');
        return null;
      }
    }catch(e){
      logger.e(' >> Exception catch when registration: $e');
      return null;
    }
  }



  Future<LoginResponse?> login({
    required String username,
    required String password,
  }) async {
    try{
      final basicAuth = await authHelper.readBasicAuthHeader();
      if(basicAuth == null){
        logger.e('error when retrieving basic auth credentials');
        return null;
      }

      final url = Uri.parse("$_baseUrl/api/auth/sign-in");

      final res = await http.post(url ,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : basicAuth,
          },
          body: json.encode({
            'username':username,
            'password': password,
          })
      );
      if(res.statusCode == 200){
        final decoded = json.decode(res.body) as Map<String, dynamic>;
        final rw = ResponseWrapper<LoginResponse>.fromJson(
            decoded,
                (json) => LoginResponse.fromJson(json)
        );

        final loginResp = rw.data;
        /*
          if (!loginResp.hasValidToken) {
          logger.e('Token invalide');
          return null;
          }
         */
        await SecureStorageService.saveToken(loginResp.token);
        await SecureStorageService.saveUserId(loginResp.id);
        await SecureStorageService.saveUsername(loginResp.username);
        await SecureStorageService.saveUserEmail(loginResp.email);
        if(loginResp.roles.isNotEmpty){
          final rolesList = loginResp.roles.map((r) => r.role.toString()).toList();
          await SecureStorageService.saveRoles(rolesList);
        }
        logger.d(" >> login successful");
        return loginResp;
      }else{
        logger.e(' >> Error when login: ${res.statusCode}');
        return null;
      }
    }catch(e){
      logger.e(' >> Exception catch when login: $e');
      return null;
    }
  }


}
