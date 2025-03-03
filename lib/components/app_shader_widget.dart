// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:Cortex/utils/colors.dart';

enum AppShaderMode {
  primary,
  secondary,
  gradient,
}

class AppShaderWidget extends StatelessWidget {
  final Widget? child;
  final AppShaderMode mode;
  final Color? color;

  const AppShaderWidget({super.key, this.child, this.color, this.mode = AppShaderMode.primary});

  @override
  Widget build(BuildContext context) {
    Color shaderColor;
    if (color == null) {
      switch (mode) {
        case AppShaderMode.gradient:
          shaderColor = appColorPrimary;
          break;
        case AppShaderMode.secondary:
          shaderColor = appColorSecondary;
          break;
        default:
          shaderColor = appColorPrimary;
      }
    } else {
      shaderColor = color ?? white;
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [shaderColor, shaderColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.0, 1.0],
          tileMode: TileMode.mirror,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: child,
    );
  }
}
