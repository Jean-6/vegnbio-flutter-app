


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../core/services/credential_storage_helper.dart';
import '../../dto/menu.dart';

class MenuService {
  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();


  Future<List<MenuItem>?> fetchWithFilters({required ItemMenuFilter menuFilters}) async {
    final basicAuth = await authHelper.readBasicAuthHeader();
    if (basicAuth == null) {
      logger.e('>> Error when retrieving basic auth credentials');
      throw Exception ("Authentication required");
    }

    final url = Uri.parse("$_baseUrl/api/menu/")
        .replace(queryParameters: menuFilters.toQueryParams());

    final res = await http.get(url, headers : {"Authorization": basicAuth});
    logger.d('>> Raw response: ${res.body}');
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final List<dynamic> jsonList = jsonMap['data']; 
      return jsonList.map((json) => MenuItem.fromJson(json)).toList();
      /*final rw = ResponseWrapper.fromJson(
        jsonMap,
            (data) => (data as List).map((e) => Menu.fromJson(e)).toList(),
      );
      logger.d('>> Parsed menu (full field): ${rw.data}');
      return rw.data ?? [];*/
    } else {
      logger.e('>> Error when fetching menus: ${res.statusCode}');
      throw Exception('Error when fetching menus');
    }
  }


  Future<List<MenuItem>?> fetchMenus({
    String? restaurantId,
    String? name,
    /*String? dishType,*/
    String? dietType,
  }) async {

    final queryParameters = {
      if (restaurantId != null) 'restaurantId': restaurantId,
      if (name != null) 'name': name,
      /*if (dishType != null) 'dishType': dishType,*/
      if (dietType != null) 'dietType': dietType
    };


    final basicAuth = await authHelper.readBasicAuthHeader();
    if(basicAuth == null){
      logger.e('error when retrieving basic auth credentials');
      return null;
    }

    final url = Uri.parse(
      "$_baseUrl/api/menu/",
    ).replace(queryParameters: queryParameters);

    final res = await http.get(url);
    if (res.statusCode == 200) {
      logger.d('>> Server response : ${res.body}');
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      logger.e(' >> Error when fetching menus: ${res.statusCode}');
      throw Exception("Error when loading menu");
    }


  }
}