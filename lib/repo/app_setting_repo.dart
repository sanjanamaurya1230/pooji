import 'package:flutter/foundation.dart';
import 'package:poojify_landing_site/api_urls.dart';
import 'package:poojify_landing_site/helper/network/base_api_services.dart';
import 'package:poojify_landing_site/helper/network/network_api_services.dart';
import 'package:poojify_landing_site/helper/network/normalized_response.dart';
import 'package:poojify_landing_site/model/setting_model.dart';

class AppSettingRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<AppSettingModel> appSettingApi() async {
    try {
      final NormalizedResponse response = await _apiServices.getGetApiResponse(ApiUrls.appSettingEndPoint);
      return AppSettingModel.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print('Error in appSettingApi: $e');
      }
      rethrow;
    }
  }


}
