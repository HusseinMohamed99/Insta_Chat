import 'package:flutter/material.dart';
import 'package:insta_chat/utils/color_manager.dart';

class AdaptiveIndicator extends StatelessWidget {
  const AdaptiveIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: ColorManager.grey,
      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
      strokeWidth: 6,
    );
  }
}
