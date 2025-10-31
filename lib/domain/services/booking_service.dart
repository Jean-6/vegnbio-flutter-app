


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/services/secure_storage_service.dart';
import 'package:vegnbio/dto/booking.dart';
import 'package:vegnbio/dto/booking_filter.dart';

import '../../core/services/credential_storage_helper.dart';
import '../../dto/event_booking.dart';
import '../../dto/response_wrapper.dart';

class BookingService {

  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();



  Future<List<RoomBooking>> fetchRoomBookings(String canteenId) async {
    try {
      final url = Uri.parse("$_baseUrl/api/booking/room?canteenId=$canteenId");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(res.body)['data'];
        return jsonList.map((json) => RoomBooking.fromJson(json)).toList();
      } else {
        logger.e('Erreur fetchRoomBookings: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      logger.e('Erreur fetchRoomBookings: $e');
      return [];
    }
  }
  


  Future<List<Booking>?> fetchWithFilters({required BookingFilter bookingFilter}) async {

    final basicAuth = await authHelper.readBasicAuthHeader();
    if(basicAuth == null){
      logger.e('>> Error when retrieving basic auth credentials');
      return null;
    }

    final queryParameters = {
      if (bookingFilter.type != null) 'type': bookingFilter.type,
      if (bookingFilter.startDate != null)
        'startDate': DateFormat('yyyy-MM-dd').format(bookingFilter.startDate!),
      if (bookingFilter.endDate != null)
        'endDate': DateFormat('yyyy-MM-dd').format(bookingFilter.endDate!),
      if (bookingFilter.userId != null) 'userId': bookingFilter.userId,
    };


    final url = Uri.parse(
        "$_baseUrl/api/booking/user")
    .replace(queryParameters: queryParameters);

    final res = await http.get(url);
    logger.d('>> Raw response: ${res.body}');
    if(res.statusCode == 200){
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final rw = ResponseWrapper.fromJson(
        jsonMap,
            (data) => (data as List)
            .map((e)=> Booking.fromJson(e))
            .toList(),
      );
      logger.d('>> Parsed booking (full field): ${rw.data}');

      logger.d('>> Response data: ${json.decode(res.body)['data']}');
      for (var element in json.decode(res.body)['data']) {
        logger.d('Item raw: $element');
      }
      return rw.data;
    }else{
      logger.e('>> Error when fetching bookings: ${res.statusCode}');
      throw Exception ('Error when fetching bookings');
    }
  }


  Future<EventBooking?> reserveEvent({
    required String eventId,
    required String userId,
  }) async{
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

      final url = Uri.parse("$_baseUrl/api/booking/event");
      final res = await http.post(
          url,
          headers: {
            'Content-Type' : 'application/json',
            'Authorization' : basicAuth,
          },
          body: json.encode({
            'eventId' : eventId,
            'userId': userId
          })
      );
      if(res.statusCode == 200 || res.statusCode == 201){
        final data = jsonDecode(res.body);
        return EventBooking.fromJson(data);
      }else{
        logger.e('Error : ${res.statusCode} - ${res.body}');
        return null;
      }
    }catch(e){
      logger.e(' >> Exception catch when event reservation: $e');
      return null;
    }


}


  Future<RoomBooking?> reserveRoom({
    required String canteenId,
    required String name,
    required String startTime,
    required String endTime,
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

      final url = Uri.parse("$_baseUrl/api/booking/room");
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
            'endTime':endTime,
            'date': date.toIso8601String().split("T")[0],
            'people': people,
            'userId': userId
          })
      );
      if(res.statusCode == 200 || res.statusCode == 201){
        final data = jsonDecode(res.body);
        return RoomBooking.fromJson(data);
      }else{
        logger.e('Error : ${res.statusCode} - ${res.body}');
        return null;
      }
    }catch(e){
      logger.e(' >> Exception catch when room reservation: $e');
      return null;
    }
  }



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