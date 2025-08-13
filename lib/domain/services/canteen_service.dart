import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vegnbio/dto/canteen.dart';
import 'package:vegnbio/dto/canteenOption.dart';
import 'package:vegnbio/dto/response_wrapper.dart';

import '../../core/services/credential_storage_helper.dart';

class CanteenService {
  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();

  Future<List<Canteen>?> fetchCanteens({
    String? restaurantName,
    String? dishName,
    DateTime? startDate,
    DateTime? endDate,
    bool? hasWifi,
    bool? hasPrinter}) async {
    final basicAuth = await authHelper.readBasicAuthHeader();
    if(basicAuth == null){
      logger.e('>> Error when retrieving basic auth credentials');
      return null;
    }

    final url = Uri.parse("$_baseUrl/api/canteen/");

    final res = await http.get(url);
    logger.d('>> Raw response: ${res.body}');
    if(res.statusCode == 200){
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final rw = ResponseWrapper.fromJson(
          jsonMap,
          (data) => (data as List)
              .map((e)=> Canteen.fromJson(e))
              .toList(),
      );
      logger.d('>> Parsed canteens (full field): ${rw.data}');
      return rw.data;
    }else{
      logger.e('>> Error when fetching canteens: ${res.statusCode}');
      throw Exception ('Error when fetching canteens');
    }
  }



  Future<List<CanteenOption>?> fetchCanteenOption() async {
    final basicAuth = await authHelper.readBasicAuthHeader();
    if(basicAuth == null){
      logger.e('>> Error when retrieving basic auth credentials');
      return null;
    }

    final url = Uri.parse("$_baseUrl/api/canteen/");

    final res = await http.get(url);
    logger.d('>> Raw response: ${res.body}');
    if(res.statusCode == 200){
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final rw = ResponseWrapper.fromJson(
        jsonMap,
            (data) => (data as List)
            .map((e)=> CanteenOption.fromJson(e))
            .toList(),
      );
      logger.d('>> Parsed canteens: ${rw.data}');
      return rw.data;
    }else{
      logger.e('>> Error when fetching canteens: ${res.statusCode}');
      throw Exception ('Error when fetching canteens');
    }
  }
}
