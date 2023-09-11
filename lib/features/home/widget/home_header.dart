import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../contants/constants.dart';
import '../../../controller/profile_controler.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.38,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(color: AppColor.brandColor),
        child: Column(children: [
          Container(
            width: 300.w,
            height: 165.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColor.mainSecondryColor,
                  AppColor.mainSecondryColor,
                  AppColor.brandColor,
                  AppColor.brandColor,
                  AppColor.brandColor,
                  AppColor.mainSecondryColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invite a Dispatcher",
                    style: AppTextStyle.body(
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GetBuilder<ProfileController>(
                              builder: (controller) {
                            return SizedBox(
                              height: 380.h,
                              width: 300.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10.h),
                                  Text(
                                    "Scan QR Code",
                                    style: AppTextStyle.body(),
                                  ),
                                  SizedBox(height: 10.h),
                                  controller.getAgentDetails?.profileImage !=
                                          null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundColor: AppColor.brandColor,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${controller.getAgentDetails?.profileImage}",
                                                placeholder: (context, url) =>
                                                    const Icon(Icons.android),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Icon(Icons.android),
                                              )),
                                        )
                                      : const CircleAvatar(
                                          radius: 40,
                                          backgroundColor: AppColor.brandColor,
                                          child: Icon(
                                            Icons.person,
                                            color: AppColor.whiteColor,
                                            size: 60,
                                          )),
                                  Text(
                                      "${controller.getAgentDetails?.name ?? 0}",
                                      style: AppTextStyle.capton(fontSize: 16)),
                                  SizedBox(height: 10.h),
                                  SizedBox(
                                    child: QrImageView(
                                        data:
                                            "${controller.getAgentDetails?.id ?? 0}",
                                        size: 200,
                                        errorCorrectionLevel:
                                            QrErrorCorrectLevel.M),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    height: 45.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.brandColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: AppTextStyle.body(
                                            color: AppColor.whiteColor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.qr_code_2,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Invite a dispatcher today and earn 2% from every successful deliveries they have made',
                textAlign: TextAlign.center,
                style: AppTextStyle.capton(
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 120.w,
                    child: Stack(
                      children: [
                        Image.asset(
                          AppImages.fa001bg,
                        ),
                        Positioned(
                          left: 18,
                          top: 25,
                          child: Center(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: controller.getAgentDetails?.id ??
                                            'MdaLw',
                                      ),
                                    );
                                    Get.snackbar(
                                      "Copied",
                                      "Copied to clipboard",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColor.brandColor,
                                      colorText: AppColor.whiteColor,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy_rounded,
                                    color: AppColor.brandColor,
                                  ),
                                ),
                                SelectableText(
                                  "${controller.getAgentDetails?.id}",
                                  style: AppTextStyle.body(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.black),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          "Register as a Fasta Dispatcher using my referral code ${controller.getAgentDetails?.id}. You can download the app from the Play Store at https://play.google.com/store/apps/details?id=com.fastasmata.fasta or from the App Store.",
                          subject:
                              'Am Fasta Agent Register with my referial code');
                    },
                    child: Container(
                      height: 45.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor.whiteColor,
                      ),
                      child: Center(
                        child: Text(
                          "Invite \nFriends",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          ),
          SizedBox(
            height: 15.h,
          ),
          GetBuilder<ProfileController>(builder: (controller) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Paymentbutton(
                    isAmount: true,
                    title: "Amount Made",
                    subtitle: ' ${controller.getagentdata?.totalIncome ?? 0}'),
                SizedBox(
                  width: 30.w,
                ),
                Paymentbutton(
                    title: "Payment Plan",
                    subtitle:
                        controller.getAgentDetails?.paymentOption ?? "Not set"),
              ],
            );
          })
        ]),
      );
    });
  }
}

class Paymentbutton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isAmount;
  const Paymentbutton(
      {super.key,
      this.isAmount = false,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      width: 110.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.body(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColor.brandColor),
          ),
          isAmount
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "\u20A6",
                      style: TextStyle(
                          color: AppColor.mainSecondryColor, fontSize: 16),
                    ),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.capton(
                          fontWeight: FontWeight.w400,
                          color: AppColor.mainSecondryColor),
                    ),
                  ],
                )
              : Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.capton(
                      fontWeight: FontWeight.w400,
                      color: AppColor.mainSecondryColor),
                )
        ],
      ),
    );
  }
}
