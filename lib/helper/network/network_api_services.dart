

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:poojify_landing_site/helper/app_exception.dart';
import 'package:poojify_landing_site/helper/network/base_api_services.dart';
import 'package:poojify_landing_site/helper/network/normalized_response.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NetworkApiServices extends BaseApiServices {
  Future<String?> _getToken() async {
    final sp = await SharedPreferences.getInstance();

    final role = sp.getInt('role');
    if (role == 2) {
      final staffToken = sp.getString('staff_token');
      if (staffToken != null && staffToken.isNotEmpty) {
        return staffToken;
      }
    }
    return sp.getString('token');
  }

  Future<Map<String, String>> _jsonHeaders() async {
    final token = await _getToken();
    return {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, String>> _formDataHeaders() async {
    final token = await _getToken();
    return {
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  @override
  Future getGetApiResponse(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: await _jsonHeaders())
          .timeout(const Duration(seconds: 10));
      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  @override
  Future getPostApiResponse(String url, data) async {
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: await _jsonHeaders(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  @override
  Future getPutApiResponse(String url, data) async {
    try {
      final response = await http
          .put(Uri.parse(url),
          headers: await _jsonHeaders(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  @override
  Future getPatchApiResponse(String url, data) async {
    try {
      final response = await http
          .patch(Uri.parse(url),
          headers: await _jsonHeaders(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }

  @override
  Future getDeleteApiResponse(String url, [dynamic data]) async {
    try {
      final response = await http
          .delete(Uri.parse(url),
          headers: await _jsonHeaders(),
          body: data != null ? jsonEncode(data) : null)
          .timeout(const Duration(seconds: 10));
      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
  }


  @override
  Future<dynamic> getFormDataApiResponse(
      String url,
      Map<String, dynamic> fields, {
        File? file,
        String? fileFieldName,
        String method = "POST",
      }) async {
    try {
      final request = http.MultipartRequest(method, Uri.parse(url));
      request.headers.addAll(await _formDataHeaders());

      for (final entry in fields.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value == null) continue;

        if (value is List) {
          // ── List of files (e.g. gallery images) ──────────────────────────
          for (int i = 0; i < value.length; i++) {
            final item = value[i];
            if (item is File) {
              final multipart = await _fileToMultipart(key, item);
              if (multipart != null) request.files.add(multipart);
            } else if (item is String || item is int || item is bool) {
              request.fields['$key[$i]'] = item.toString();
            }
          }
        } else if (value is File) {
          // ── Single file ───────────────────────────────────────────────────
          final multipart = await _fileToMultipart(key, value);
          if (multipart != null) request.files.add(multipart);
        } else {
          // ── Scalar field ──────────────────────────────────────────────────
          final str = value.toString();
          if (str.isNotEmpty) request.fields[key] = str;
        }
      }

      // Legacy single-file support (for other endpoints that use the old API)
      if (file != null && fileFieldName != null && await file.exists()) {
        final multipart = await _fileToMultipart(fileFieldName, file);
        if (multipart != null) request.files.add(multipart);
      }

      final streamed =
      await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);

      return returnRequest(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      if (kDebugMode) print("FORM DATA ERROR → $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helper: convert a single File to http.MultipartFile
  // ─────────────────────────────────────────────────────────────────────────

  Future<http.MultipartFile?> _fileToMultipart(String fieldName, File file) async {
    if (!await file.exists()) return null;

    String? mimeType = lookupMimeType(file.path);

    if (mimeType == null || !mimeType.startsWith('image/')) {
      final ext = file.path.split('.').last.toLowerCase();
      mimeType = const {
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'gif': 'image/gif',
        'webp': 'image/webp',
        'bmp': 'image/bmp',
      }[ext];
      if (mimeType == null) {
        throw Exception('Invalid file format. Only image files are allowed.');
      }
    }

    final parts = mimeType.split('/');
    return http.MultipartFile.fromPath(
      fieldName,
      file.path,
      contentType: http.MediaType(parts[0], parts[1]),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Response handler
  // ─────────────────────────────────────────────────────────────────────────

  dynamic returnRequest(http.Response response) {
    if (kDebugMode) {
      debugPrint("STATUS → ${response.statusCode}");
      debugPrint("BODY → ${response.body}");
    }

    final decoded =
    response.body.isNotEmpty ? jsonDecode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return NormalizedResponse(
          data: decoded,
          message: decoded?['message'] ?? "Success",
        );

      case 400:
        throw BadRequestException(decoded?['message'] ?? "Bad Request");

      case 401:
      case 403:
        throw UnauthorisedException(decoded?['message'] ?? "Unauthorized");

      case 404:
        return NormalizedResponse(
          data: decoded,
          message: decoded?['message'] ?? "Not Found",
        );

      case 422:
        throw InvalidInputException(decoded?['message'] ?? "Invalid Input");

      case 500:
        throw FetchDataException(decoded?['message'] ?? "Server Error");

      default:
        if (response.statusCode >= 500) {
          throw FetchDataException(decoded?['message'] ?? "Server Error");
        }
        throw FetchDataException(
            decoded?['message'] ?? "Unexpected Error: ${response.statusCode}");
    }
  }
}