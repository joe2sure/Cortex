import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/components/cached_image_widget.dart';

import '../screens/ai_chat/model/icon_title_model.dart';
import 'app_common.dart';
import 'colors.dart';

class AutoScrollInfiniteCustom extends StatefulWidget {
  final List<IconTitleModel> list;
  final double height;
  final bool animateReverse;

  const AutoScrollInfiniteCustom({
    super.key,
    required this.list,
    this.height = 154,
    this.animateReverse = false,
  });

  @override
  State<AutoScrollInfiniteCustom> createState() => _AutoScrollInfiniteCustomState();
}

class _AutoScrollInfiniteCustomState extends State<AutoScrollInfiniteCustom> {
  ScrollController scrollController = ScrollController();
  bool stop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      double minScrollExtent1 = scrollController.position.minScrollExtent;
      double maxScrollExtent1 = scrollController.position.maxScrollExtent;

      if (scrollController.hasClients) {
        start(maxScrollExtent1, minScrollExtent1);
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          start(maxScrollExtent1, minScrollExtent1);
        });
      }
    });
  }

  void start(double maxScrollExtent1, double minScrollExtent1) {
    if (widget.animateReverse) {
      scrollController.jumpTo(maxScrollExtent1);
    }
    animateToMaxMin(maxScrollExtent1, minScrollExtent1, widget.animateReverse ? minScrollExtent1 : maxScrollExtent1, 25, scrollController);
  }

  animateToMaxMin(double max, double min, double direction, int seconds, ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear).then((value) {
        direction = direction == max ? min : max;
        animateToMaxMin(max, min, direction, seconds, scrollController);
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return Obx(
              () => Container(
                width: Get.width / 3 - 24,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: boxDecorationDefault(color: isDarkMode.value ? lightCanvasColor : context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedImageWidget(url: widget.list[index].icon, fit: BoxFit.cover),
                    16.height,
                    Text(
                      widget.list[index].title,
                      style: primaryTextStyle(color: isDarkMode.value ? whiteTextColor : textPrimaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
