import 'package:flutter/material.dart';
import 'package:poojify_landing_site/helper/response/api_response.dart';
import 'package:poojify_landing_site/model/setting_model.dart';
import 'package:poojify_landing_site/repo/app_setting_repo.dart';

class AppSettingViewModel extends ChangeNotifier {
  final AppSettingRepository _repository = AppSettingRepository();

  ApiResponse<AppSettingModel> appDetails = ApiResponse.loading();


  Future<void> fetchAppDetails() async {
    try {
      appDetails = ApiResponse.loading();
      notifyListeners();
      final response = await _repository.appSettingApi();
      appDetails = ApiResponse.completed(response);
      debugPrint('App details loaded');
    } catch (e) {
      appDetails = ApiResponse.error(e.toString());
      debugPrint('Error loading app details: $e');
    }
    notifyListeners();
  }


  @override
  void dispose() {
    debugPrint('AppSettingViewModel disposed');
    super.dispose();
  }
}