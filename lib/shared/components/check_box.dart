import 'package:flutter/material.dart';
import 'package:insta_chat/cubits/auth/auth_cubit.dart';
import 'package:insta_chat/utils/color_manager.dart';

Widget checkBox(BuildContext context, {Color? color}) {
  AuthCubit cubit = AuthCubit.get(context);
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
