import 'package:jaanu_delivery_man/controller/auth_controller.dart';
import 'package:jaanu_delivery_man/controller/splash_controller.dart';
import 'package:jaanu_delivery_man/controller/theme_controller.dart';
import 'package:jaanu_delivery_man/helper/route_helper.dart';
import 'package:jaanu_delivery_man/util/app_constants.dart';
import 'package:jaanu_delivery_man/util/dimensions.dart';
import 'package:jaanu_delivery_man/util/images.dart';
import 'package:jaanu_delivery_man/util/styles.dart';
import 'package:jaanu_delivery_man/view/base/confirmation_dialog.dart';
import 'package:jaanu_delivery_man/view/base/custom_image.dart';
import 'package:jaanu_delivery_man/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:jaanu_delivery_man/view/screens/profile/widget/profile_button.dart';
import 'package:jaanu_delivery_man/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null
            ? const Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
                backButton: false,
                circularImage: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Theme.of(context).cardColor),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: ClipOval(
                      child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls!.deliveryManImageUrl}'
                        '/${authController.profileModel != null ? authController.profileModel.image : ''}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
                ),
                mainWidget: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                        child: Container(
                      width: 1170,
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Column(children: [
                        Text(
                          '${authController.profileModel.fName} ${authController.profileModel.lName}',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),
                        const SizedBox(height: 30),

                        Row(children: [
                          ProfileCard(
                              title: 'since_joining'.tr,
                              data:
                                  '${authController.profileModel.memberSinceDays} ${'days'.tr}'),
                          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          ProfileCard(
                              title: 'total_order'.tr,
                              data: authController.profileModel.orderCount
                                  .toString()),
                        ]),
                        const SizedBox(height: 30),

                        // ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                        //   Get.find<ThemeController>().toggleTheme();
                        // }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                          icon: Icons.notifications,
                          title: 'notification'.tr,
                          isButtonActive: authController.notification,
                          onTap: () {
                            authController.setNotificationActive(
                                !authController.notification);
                          },
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        // ProfileButton(icon: Icons.language, title: 'Language'.tr, onTap: () {
                        //   Get.toNamed(RouteHelper.getLanguageRoute());
                        // }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                            icon: Icons.lock,
                            title: 'change_password'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getResetPasswordRoute(
                                  '', '', 'password-change'));
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                            icon: Icons.edit,
                            title: 'edit_profile'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getUpdateProfileRoute());
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.money,
                            title: "Incentive",
                            onTap: () {
                              Get.toNamed(RouteHelper.getIncentiveRoute());
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                            icon: Icons.list,
                            title: 'terms_condition'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getTermsRoute());
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                            icon: Icons.privacy_tip,
                            title: 'privacy_policy'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getPrivacyRoute());
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        // ProfileButton(
                        //   icon: Icons.delete,
                        //   title: 'delete_account'.tr,
                        //   onTap: () {
                        //     Get.dialog(
                        //         ConfirmationDialog(
                        //             icon: Images.warning,
                        //             title: 'are_you_sure_to_delete_account'.tr,
                        //             description:
                        //                 'it_will_remove_your_all_information'
                        //                     .tr,
                        //             isLogOut: true,
                        //             onYesPressed: () =>
                        //                 authController.removeDriver()),
                        //         useSafeArea: false);
                        //   },
                        // ),
                        // const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        ProfileButton(
                            icon: Icons.logout,
                            title: 'logout'.tr,
                            onTap: () {
                              Get.back();
                              Get.dialog(ConfirmationDialog(
                                  icon: Images.support,
                                  description: 'are_you_sure_to_logout'.tr,
                                  isLogOut: true,
                                  onYesPressed: () {
                                    Get.find<AuthController>()
                                        .clearSharedData();
                                    Get.find<AuthController>()
                                        .stopLocationRecord();
                                    Get.offAllNamed(
                                        RouteHelper.getSignInRoute());
                                  }));
                            }),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        /* Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
              ]),*/
                      ]),
                    ))),
              );
      }),
    );
  }
}