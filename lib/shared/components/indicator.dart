import 'package:flutter/material.dart';
import 'package:insta_chat/utils/color_manager.dart';

class AdaptiveIndicator extends StatelessWidget {
  const AdaptiveIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: ColorManager.grey,
      valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primary),
      strokeWidth: 6,
    );
  }
}
