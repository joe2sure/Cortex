import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/generated/assets.dart';

class VoiceSearchComponent extends StatefulWidget {
  const VoiceSearchComponent({super.key});

  @override
  VoiceSearchComponentState createState() => VoiceSearchComponentState();
}

class VoiceSearchComponentState extends State<VoiceSearchComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      margin: const EdgeInsets.only(bottom: 45),
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(Assets.lottieVolume, fit: BoxFit.cover, height: 60, width: 120),
        ],
      ),
    );
  }
}
