import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:vegnbio/dto/event.dart';

import '../../core/services/credential_storage_helper.dart';

class EventService {
  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();

  Future<List<Event>?> fetchEvents({
    String? restaurantId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {

    final queryParameters = {
      if (restaurantId != null) 'restaurantId': restaurantId,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };

    final basicAuth = await authHelper.readBasicAuthHeader();
    if(basicAuth == null){
      logger.e('error when retrieving basic auth credentials');
      return null;
    }

    final url = Uri.parse(
      "$_baseUrl/api/event/",
    ).replace(queryParameters: queryParameters);

    final res = await http.get(url);
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(res.body);

      final List<dynamic> jsonList = jsonMap['data'];

      return jsonList.map((json) => Event.fromJson(json)).toList();
      //final wrapper = ResponseWrapper.fromJson(
      //  jsonMap,
      //  (data) => (data as List).map((e) => Event.fromJson(e)).toList(),
      //);
      logger.d(" >> Events fetching successful");
      //return wrapper.data;
    } else {
      logger.e(' >> Error when fetching events: ${res.statusCode}');
      throw Exception("Error when loading events");
    }
  }
}
