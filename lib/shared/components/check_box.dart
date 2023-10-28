import 'package:flutter/material.dart';
import 'package:insta_chat/shared/cubit/cubit/sign_up_cubit.dart';
import 'package:insta_chat/utils/color_manager.dart';

Widget checkBox(BuildContext context, {Color? color}) {
  var cubit = SignUpCubit.get(context);
  return Checkbox.adaptive(
    side: BorderSide(
      color: color ?? ColorManager.white,
    ),
    activeColor: ColorManager.primaryColor,
    value: cubit.isCheck,
    onChanged: (e) {
      cubit.boxCheck(e!);
    },
  );
}
