


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vegnbio/core/services/secure_storage_service.dart';
import 'package:vegnbio/dto/table_booking.dart';

import '../../core/services/credential_storage_helper.dart';

class BookingService {

  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();


  Future<TableBooking?> reserveTable({
    required String canteenId,
    required String name,
    required String startTime,
    required DateTime date,
    required int people,
    required String userId
  }) async {
    try {
      final basicAuth = await authHelper.readBasicAuthHeader();
      if (basicAuth == null) {
        logger.e('error when retrieving basic auth credentials');
        return null;
      }

      final userId = await SecureStorageService.getUserId();
      if(userId == null){
        logger.d("User id not found");
        return null;
      }

      final url = Uri.parse("$_baseUrl/api/booking/table");
      final res = await http.post(
          url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : basicAuth,
          },
          body: json.encode({
            'canteenId' : canteenId,
            'name': name,
            'startTime':startTime,
            'date': date.toIso8601String().split("T")[0],
            'people': people,
            'userId': userId
          })
      );
      logger.d('>> Response body: ${res.body}');

      if(res.statusCode == 200 || res.statusCode == 201){
        final data = jsonDecode(res.body);
        return TableBooking.fromJson(data);
      }else{
        logger.e('Error : ${res.statusCode} - ${res.body}');
        return null;
      }
    }catch(e){
      logger.e(' >> Exception catch when table reservation: $e');
      return null;
    }
  }


}