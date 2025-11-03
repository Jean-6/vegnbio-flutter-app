import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../core/services/credential_storage_helper.dart';
import '../../dto/offer_filter.dart';
import '../../dto/response_wrapper.dart';
import '../../dto/upload_item.dart';
import '../model/product.dart';

import 'package:http_parser/http_parser.dart';

class ProductService {
  final logger = Logger();
  final _baseUrl = "http://172.20.10.5:8082";
  final authHelper = CredentialStorageHelper();

  Future<List<Product>> fetchWithFilters({
    required OfferFilter filters
  }) async {
    final basicAuth = await authHelper.readBasicAuthHeader();
    if (basicAuth == null) {
      logger.e('>> Error when retrieving basic auth credentials');
      throw Exception ("Authentication required");
    }

    final url = Uri.parse("$_baseUrl/api/product/")
        .replace(queryParameters: filters.toQueryParams());

    final res = await http.get(url, headers : {"Authorization": basicAuth});
    logger.d('>> Raw response: ${res.body}');
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(res.body);
      final rw = ResponseWrapper.fromJson(
        jsonMap,
        (data) => (data as List).map((e) => Product.fromJson(e)).toList(),
      );
      logger.d('>> Parsed offer (full field): ${rw.data}');
      return rw.data ?? [];
    } else {
      logger.e('>> Error when fetching offers: ${res.statusCode}');
      throw Exception('Error when fetching offers');
    }
  }

  Future<Product?> save({
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

      final url = Uri.parse("$_baseUrl/api/product/");
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = basicAuth;

      request.files.add(
        http.MultipartFile.fromString(
          'data',
          jsonEncode({
            'type': type,
            'name': name,
            'desc': desc,
            'category': category,
            'quantity': quantity.toString(),
            'unit': unit,
            'unitPrice': unitPrice.toString(),
            'origin': origin,
            'availabilityDate': DateFormat(
              'dd-MM-yyyy',
            ).format(availabilityDate),
            'expirationDate': DateFormat('dd-MM-yyyy').format(expirationDate),
            'userId': userId,
          }),
          contentType: MediaType('application', 'json'),
        ),
      );

      // Ajout des fichiers
      for (var u in uploads) {
        if (kIsWeb) {
          final bytes = await u.file!.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes(
              'pictures',
              bytes,
              filename: u.fileName,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('pictures', u.path),
          );
        }
      }

      // Envoi de la requête
      final streamedResponse = await request.send();

      // Gestion de la progression
      if (onProgress != null) {
        final totalBytes = streamedResponse.contentLength ?? 0;
        int sentBytes = 0;

        final stream = streamedResponse.stream.transform<List<int>>(
          StreamTransformer.fromHandlers(
            handleData: (List<int> chunk, EventSink<List<int>> sink) {
              sentBytes += chunk.length;

              // Mettre à jour chaque fichier
              for (var u in uploads) {
                u.isUploading = true;
                u.progress = totalBytes > 0 ? sentBytes / totalBytes : 0;
              }

              onProgress("upload", sentBytes, totalBytes);

              sink.add(chunk); // <-- important : on repasse le chunk
            },
          ),
        );

        // Reconstruire la réponse HTTP avec suivi
        final response = await http.Response.fromStream(
          http.StreamedResponse(
            stream,
            streamedResponse.statusCode,
            contentLength: streamedResponse.contentLength,
            request: streamedResponse.request,
            headers: streamedResponse.headers,
            reasonPhrase: streamedResponse.reasonPhrase,
            isRedirect: streamedResponse.isRedirect,
            persistentConnection: streamedResponse.persistentConnection,
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          return Product.fromJson(data);
        } else {
          logger.e('Error ${response.statusCode}: ${response.body}');
          return null;
        }
      } else {
        // Si pas de suivi demandé
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          return Product.fromJson(data);
        } else {
          logger.e('Error ${response.statusCode}: ${response.body}');
          return null;
        }
      }
    } catch (e) {
      logger.e('Exception during offer save: $e');
      return null;
    }
  }
}
