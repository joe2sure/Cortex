import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import 'model/home_detail_res.dart';

class ServiceCard extends StatelessWidget {
  final SystemService serviceItem;
  const ServiceCard({super.key, required this.serviceItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: isDarkMode.value ? appScreenBackgroundDark : appScreenBackground,
        borderRadius: BorderRadius.circular(10),
        decorationImage: DecorationImage(image: CachedNetworkImageProvider(serviceItem.serviceImage), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.transparent, black.withOpacity(0.6)],
                stops: const [0.0, 0.6, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Marquee(
              child: Text(
                serviceItem.name,
                style: boldTextStyle(size: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
