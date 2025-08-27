
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../core/services/credential_storage_helper.dart';
import '../../dto/upload_item.dart';
import '../model/offer.dart';

class OfferService {

  final logger = Logger();
  final _baseUrl = Uri.parse("http://172.20.10.5:8082");
  final authHelper = CredentialStorageHelper();



  Future<Offer?> save({
    required String type,
    required String name,
    required String desc,
    required String category,
    required double quantity,
    required String unit,
    required double unitPrice,
    required String origin,
    required DateTime availabilityDate,
    required DateTime expirationDate,
    required List<UploadItem> uploads,
    required String userId,
    void Function(String fileName, int sent, int total)? onProgress,
  }) async {
    try {
      final basicAuth = await authHelper.readBasicAuthHeader();
      if (basicAuth == null) {
        logger.e('Error retrieving basic auth credentials');
        return null;
      }

      final url = Uri.parse("$_baseUrl/api/offer");
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = basicAuth;

      // Champs texte
      request.fields.addAll({
        'type': type,
        'name': name,
        'desc': desc,
        'category': category,
        'quantity': quantity.toString(),
        'unit': unit,
        'unitPrice': unitPrice.toString(),
        'origin': origin,
        'availabilityDate': DateFormat('dd-MM-yyyy').format(availabilityDate),
        'expirationDate': DateFormat('dd-MM-yyyy').format(expirationDate),
        'userId': userId,
      });

      // Ajout des fichiers
      for (var u in uploads) {
        if (kIsWeb) {
          final bytes = await u.file!.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes('images', bytes, filename: u.fileName),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('images', u.path),
          );
        }
      }

      // Envoyer la requête
      final streamedResponse = await request.send();

      // Progression
      if (onProgress != null) {
        int totalBytes = streamedResponse.contentLength ?? 0;
        int sentBytes = 0;

        streamedResponse.stream.listen((chunk) {
          sentBytes += chunk.length;
          for (var u in uploads) {
            u.isUploading = true;
            u.progress = totalBytes > 0 ? sentBytes / totalBytes : 0;
          }
          onProgress("", sentBytes, totalBytes);
        });
      }

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Offer.fromJson(data);
      } else {
        logger.e('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.e('Exception during offer save: $e');
      return null;
    }
  }






}

