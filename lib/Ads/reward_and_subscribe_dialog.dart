import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../screens/home/home_controller.dart';
import '../screens/subscription_plan/sub_scription_plan_screen.dart';

void rewardedAdFailDialog() {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    Get.dialog(
      AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Couldn't load reward ad, Please try after sometime",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  const Text(
                    "OR",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  InkWell(
                    onTap: () {
                      Get.to(() => SubscriptionPlanScreen(homeController: HomeController()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(50)),
                      width: Get.width * 0.8,
                      height: Get.height * 0.08,
                      child: const Text(
                        "Buy Subscription",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ))),
      barrierDismissible: true,
    );
  });
}
