import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../apis/models/agent_profile.dart';
import '../../../contants/constants.dart';
import '../../../core/helper.dart';

class DriverDetialCard extends StatelessWidget {
  const DriverDetialCard({
    super.key,
    required this.driver,
  });

  final Referral driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 203.h,
      width: 300.w,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.brandColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(),
            SizedBox(
              width: 10.w,
            ),
            Column(
              children: [
                Text(
                  "${driver.name}",
                  style: AppTextStyle.body(color: AppColor.whiteColor),
                ),
                Text(
                  "${driver.phone}",
                  style: AppTextStyle.capton(color: AppColor.whiteColor),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        DetailView(
            title: "Date Joined",
            subtitle: checkDeliveryDate(driver.createdAt)),
        DetailView(
            title: "Successful Deliveries",
            subtitle: "${driver.totalSuccessfulDeliveries}"),
        DetailView(
            isAmount: true,
            title: "Referral Bonus",
            subtitle: "${driver.totalReferralBonus}"),
        DetailView(
            title: "Status",
            subtitle: driver.activeStatus ? "Active" : "Inactive"),
        DetailView(
            title: "Last Delivery",
            subtitle: checkDeliveryDate(driver.lastDelivery)),
      ]),
    );
  }
}

class DetailView extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isAmount;
  const DetailView({
    super.key,
    required this.title,
    required this.subtitle,
    this.isAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Text(
            title,
            style: AppTextStyle.body(color: AppColor.whiteColor, fontSize: 14),
          ),
          const Spacer(),
          isAmount
              ? Row(
                  children: [
                    const Text(
                      "\u20A6",
                      style: TextStyle(
                          color: AppColor.mainSecondryColor, fontSize: 16),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyle.capton(
                          color: AppColor.whiteColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              : Text(
                  subtitle,
                  style: AppTextStyle.capton(
                      color: AppColor.whiteColor, fontWeight: FontWeight.w400),
                ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
    );
  }
}
