import 'package:jaanu_delivery_man/controller/notification_controller.dart';
import 'package:jaanu_delivery_man/controller/splash_controller.dart';
import 'package:jaanu_delivery_man/helper/date_converter.dart';
import 'package:jaanu_delivery_man/util/dimensions.dart';
import 'package:jaanu_delivery_man/util/styles.dart';
import 'package:jaanu_delivery_man/view/base/custom_app_bar.dart';
import 'package:jaanu_delivery_man/view/base/custom_image.dart';
import 'package:jaanu_delivery_man/view/screens/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncentiveScreen extends StatefulWidget {
  const IncentiveScreen({super.key});

  @override
  State<IncentiveScreen> createState() => _IncentiveScreenState();
}

class _IncentiveScreenState extends State<IncentiveScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getIncentiveList();

    return Scaffold(
      appBar: CustomAppBar(title: "Incentive"),
      body:
          GetBuilder<NotificationController>(builder: (notificationController) {
        if (notificationController.incentiveList != null) {
          notificationController.saveSeenNotificationCount(
              notificationController.incentiveList.length);
        }
        List<DateTime> dateTimeList = [];
        return notificationController.incentiveList != null
            ? notificationController.incentiveList.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await notificationController.getIncentiveList();
                    },
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            child: Center(
                                child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                          width: 1170,
                          child: ListView.builder(
                            itemCount:
                                notificationController.incentiveList.length,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              /* DateTime _originalDateTime =
                                DateConverter.dateTimeStringToDate(
                                    notificationController
                                        .incentiveList[index]
                                        .created_at!);
                                DateTime _convertedDate = DateTime(
                                    _originalDateTime.year,
                                    _originalDateTime.month,
                                    _originalDateTime.day);
                                bool _addTitle = false;
                                if (!_dateTimeList
                                    .contains(_convertedDate)) {
                                  _addTitle = true;
                                  _dateTimeList.add(_convertedDate);
                                }*/
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Start Order : ${notificationController.incentiveList[index].start_km.toString()}",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),
                                        Text(
                                          "End Order : ${notificationController.incentiveList[index].end_km.toString()}",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                       /* Text(
                                          "Single Amount : ${notificationController.incentiveList[index].single_amount.toString()}",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),*/
                                        Text(
                                          "Total Amount : ${notificationController.incentiveList[index].total_amount.toString()}",
                                          style: robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Divider(
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                  ]);
                            },
                          )),
                    )))),
                  )
                : Center(child: Text('no_notification_found'.tr))
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
