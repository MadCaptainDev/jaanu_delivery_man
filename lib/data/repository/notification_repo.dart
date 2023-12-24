import 'package:jaanu_delivery_man/data/api/api_client.dart';
import 'package:jaanu_delivery_man/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  NotificationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getNotificationList() async {
    return await apiClient
        .getData('${AppConstants.NOTIFICATION_URI}${getUserToken()}');
  }

  Future<Response> getIncentiveList() async {
    return await apiClient
        .getData('${AppConstants.INCENTIVE}${getUserToken()}');
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  void saveSeenNotificationCount(int count) {
    sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, count);
  }

  int getSeenNotificationCount() {
    return sharedPreferences.getInt(AppConstants.NOTIFICATION_COUNT) ?? 0;
  }
}
