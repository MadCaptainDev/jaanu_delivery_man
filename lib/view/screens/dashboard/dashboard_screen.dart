import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:jaanu_delivery_man/controller/auth_controller.dart';
import 'package:jaanu_delivery_man/controller/order_controller.dart';
import 'package:jaanu_delivery_man/helper/notification_helper.dart';
import 'package:jaanu_delivery_man/helper/route_helper.dart';
import 'package:jaanu_delivery_man/util/dimensions.dart';
import 'package:jaanu_delivery_man/view/base/custom_alert_dialog.dart';
import 'package:jaanu_delivery_man/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:jaanu_delivery_man/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:jaanu_delivery_man/view/screens/home/home_screen.dart';
import 'package:jaanu_delivery_man/view/screens/profile/profile_screen.dart';
import 'package:jaanu_delivery_man/view/screens/request/order_request_screen.dart';
import 'package:jaanu_delivery_man/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int? pageIndex;

  const DashboardScreen({required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController? _pageController;
  int? _pageIndex = 0;
  List<Widget>? _screens;
  final _channel = const MethodChannel('com.sixamtech/app_retain');
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AppUpdateInfo? _updateInfo;

  Timer? _timer;
  int? _orderCount;
  Timer? _timer2;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        print(_updateInfo!.availableVersionCode);
        print(_updateInfo!.updateAvailability);
        print(_updateInfo!.flexibleUpdateAllowed);
        print(_updateInfo!.packageName);
        print(_updateInfo!.updatePriority);
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => showSnack(e.toString()));
        }
      });
    }).catchError((e) {
      print("In app update error");
      print(e.toString());
      // showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    // if (_scaffoldKey.currentContext != null) {
    //   ScaffoldMessenger.of(_scaffoldKey.currentContext!)
    //       .showSnackBar(SnackBar(content: Text(text)));
    // }
  }

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex!);

    _screens = [
      HomeScreen(),
      OrderRequestScreen(onTap: () => _setPage(0)),
      OrderScreen(),
      ProfileScreen(),
    ];
    getData();
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().latestOrderList != null) {
      //   _orderCount = Get.find<OrderController>().latestOrderList.length;
      // }
      print("onMessage: ${message.data}");
      String _type = message.notification!.bodyLocKey!;
      String _orderID = message.notification!.titleLocKey!;
      if (_type != 'assign' && _type != 'new_order') {
        NotificationHelper.showNotification(
            message, flutterLocalNotificationsPlugin!, false);
      }
      Get.find<OrderController>().getCurrentOrders();
      Get.find<OrderController>().getLatestOrders();
      // _startAlarm();
      //Get.find<OrderController>().getAllOrders();
      Get.dialog(NewRequestDialog(
          isRequest: true, onTap: () => _navigateRequestPage()));
      if (_type == 'new_order') {
        //_orderCount = _orderCount + 1;
        // Get.dialog(NewRequestDialog(
        //     isRequest: true, onTap: () => _navigateRequestPage()));
      } else if (_type == 'assign' && _orderID != null && _orderID.isNotEmpty) {
        Get.dialog(
            NewRequestDialog(isRequest: false, onTap: () => _setPage(0)));
      } else if (_type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });

    // _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
    //   await Get.find<OrderController>().getLatestOrders();
    //   int _count = Get.find<OrderController>().latestOrderList!.length;
    //   if (_orderCount != null && _orderCount! < _count) {
    //     Get.dialog(NewRequestDialog(
    //         isRequest: true, onTap: () => _navigateRequestPage()));
    //   } else {
    //     _orderCount = Get.find<OrderController>().latestOrderList!.length;
    //   }
    // });
  }

  getData() async {
    await checkForUpdate();
  }

  void _startAlarm() {
    print("Comming........");
    AudioCache audio = AudioCache();
    audio.play('notification.mp3');
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      audio.play('notification.mp3');
    });
    Future.delayed(Duration(seconds: 10)).then((value) {
      if (_timer2 != null) {
        _timer2!.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer2?.cancel();
    _timer?.cancel();
  }

  void _navigateRequestPage() {
    if (Get.find<AuthController>().profileModel != null &&
        Get.find<AuthController>().profileModel.active == 1 &&
        Get.find<OrderController>().currentOrderList != null &&
        Get.find<OrderController>().currentOrderList!.isEmpty) {
      _setPage(1);
    } else {
      if (Get.find<AuthController>().profileModel == null ||
          Get.find<AuthController>().profileModel.active == 0) {
        Get.dialog(CustomAlertDialog(
            description: 'you_are_offline_now'.tr,
            onOkPressed: () => Get.back()));
      } else {
        //Get.dialog(CustomAlertDialog(description: 'you_have_running_order'.tr, onOkPressed: () => Get.back()));
        _setPage(1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (GetPlatform.isAndroid &&
              Get.find<AuthController>().profileModel.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: GetPlatform.isDesktop
            ? const SizedBox()
            : BottomAppBar(
                elevation: 5,
                notchMargin: 5,
                shape: const CircularNotchedRectangle(),
                child: Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    BottomNavItem(
                        iconData: Icons.home,
                        isSelected: _pageIndex == 0,
                        onTap: () => _setPage(0)),
                    BottomNavItem(
                        iconData: Icons.list_alt_rounded,
                        isSelected: _pageIndex == 1,
                        onTap: () {
                          _navigateRequestPage();
                        }),
                    BottomNavItem(
                        iconData: Icons.shopping_bag,
                        isSelected: _pageIndex == 2,
                        onTap: () => _setPage(2)),
                    BottomNavItem(
                        iconData: Icons.person,
                        isSelected: _pageIndex == 3,
                        onTap: () => _setPage(3)),
                  ]),
                ),
              ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens!.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens![index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
