import 'package:flutter/material.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/font_manager.dart';
import 'package:insta_chat/utils/style_manager.dart';
import 'package:insta_chat/utils/value_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    //Colors
    primaryColor: ColorManager.primaryColor,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey,
    splashColor: ColorManager.lightPrimary,
    scaffoldBackgroundColor: ColorManager.primaryColor,

    //Cards Theme
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),

    //AppBar Theme
    appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.primaryColor,
        centerTitle: true,
        elevation: AppSize.s0,
        shadowColor: ColorManager.lightGrey,
        titleTextStyle: getRegularStyle(
          color: ColorManager.black,
          fontSize: FontSize.s16,
        )),

    //Button Theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorManager.grey,
        buttonColor: ColorManager.primaryColor,
        splashColor: ColorManager.lightPrimary),

    //Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(
              color: ColorManager.white,
              fontSize: FontSize.s17,
            ),
            backgroundColor: ColorManager.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12)))),

    //Text Theme
    textTheme: TextTheme(
      displayLarge: getRegularPacificoStyle(
          color: ColorManager.white, fontSize: FontSize.s30),
      headlineMedium:
          getRegularStyle(color: ColorManager.white, fontSize: FontSize.s16),
      titleMedium:
          getMediumStyle(color: ColorManager.black, fontSize: FontSize.s16),
      bodySmall: getRegularStyle(
        color: ColorManager.grey,
      ),
      headlineLarge:
          getMediumStyle(color: ColorManager.black, fontSize: FontSize.s30),
      bodyLarge:
          getRegularStyle(color: ColorManager.black, fontSize: FontSize.s14),
      labelSmall:
          getRegularStyle(color: ColorManager.black, fontSize: FontSize.s12),
    ),

    dialogTheme: DialogTheme(
        backgroundColor: ColorManager.white,
        titleTextStyle:
            getBoldStyle(color: ColorManager.black, fontSize: FontSize.s18),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s16)),
        contentTextStyle: getRegularStyle(color: ColorManager.black),
        alignment: Alignment.center),

    //Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p20),
      hintStyle: getRegularStyle(
        color: ColorManager.grey,
        fontSize: FontSize.s16,
      ),
      labelStyle: getMediumStyle(
        color: ColorManager.grey,
        fontSize: FontSize.s14,
      ),
      errorStyle: getRegularStyle(color: ColorManager.error, height: 1),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.grey,
          width: AppSize.s0_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppSize.s8,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.lightPrimary,
          width: AppSize.s0_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppSize.s8,
          ),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.error,
          width: AppSize.s0_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppSize.s8,
          ),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorManager.primaryColor,
          width: AppSize.s0_5,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppSize.s8,
          ),
        ),
      ),
    ),
  );
}
