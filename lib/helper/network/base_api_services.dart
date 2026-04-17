import 'dart:io';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);

  Future<dynamic> getPutApiResponse(String url, dynamic data);

  Future<dynamic> getPatchApiResponse(String url, dynamic data);

  Future<dynamic> getDeleteApiResponse(String url, [dynamic data]);

  Future<dynamic> getFormDataApiResponse(
      String url,
      Map<String, dynamic> fields, {
        File? file,
        String? fileFieldName,
        String method, // NEW → POST / PUT / PATCH
      });
}
