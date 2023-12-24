import 'package:jaanu_delivery_man/data/api/api_checker.dart';
import 'package:jaanu_delivery_man/data/model/response/notification_model.dart';
import 'package:jaanu_delivery_man/data/repository/notification_repo.dart';
import 'package:jaanu_delivery_man/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/incentive_model.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;

  NotificationController({required this.notificationRepo});

  List<NotificationModel>? _notificationList = [];
  List<IncentiveModel>? _incentiveList = [];

  List<NotificationModel>? get notificationList => _notificationList!;

  List<IncentiveModel> get incentiveList => _incentiveList!;

  Future<void> getNotificationList() async {
    Response response = await notificationRepo.getNotificationList();
    if (response.statusCode == 200) {
      _notificationList = [];
      response.body.forEach((notification) {
        NotificationModel _notification =
            NotificationModel.fromJson(notification);
        _notification.title = notification['data']['title'];
        _notification.description = notification['data']['description'];
        _notification.image = notification['data']['image'];
        _notificationList!.add(_notification);
      });
      _notificationList!.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updatedAt!)
            .compareTo(DateConverter.isoStringToLocalDate(b.updatedAt!));
      });
      Iterable iterable = _notificationList!.reversed;
      _notificationList = iterable.cast<NotificationModel>().toList();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getIncentiveList() async {
    Response response = await notificationRepo.getIncentiveList();
    if (response.statusCode == 200) {
      _incentiveList = [];
      response.body.forEach((notification) {
        IncentiveModel _incentive = IncentiveModel.fromJson(notification);
        _incentive.single_amount = notification['single_amount'].toDouble();
        _incentive.total_amount = notification['total_amount'].toDouble();
        _incentive.start_km = notification['start_km'].toDouble();
        _incentive.end_km = notification['end_km'].toDouble();
        _incentiveList!.add(_incentive);
      });
      _incentiveList!.sort((a, b) {
        return DateConverter.isoStringToLocalDate(a.updated_at!)
            .compareTo(DateConverter.isoStringToLocalDate(b.updated_at!));
      });
      Iterable iterable = _incentiveList!.reversed;
      _incentiveList = iterable.cast<IncentiveModel>().toList();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }
}
