import 'package:flutter/material.dart';
import 'package:insta_chat/utils/font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color,
    double? height, FontStyle? fontStyle) {
  return TextStyle(
      fontFamily: FontConstant.fontFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
      fontStyle: fontStyle);
}

TextStyle _getPacificoTextStyle(double fontSize, FontWeight fontWeight,
    Color color, double? height, FontStyle? fontStyle) {
  return TextStyle(
      fontFamily: FontConstant.pacificoFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
      fontStyle: fontStyle);
}

// Regular Style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getTextStyle(
      fontSize, FontWeightManager.regular, color, height, fontStyle);
}

// Medium Style
TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  required Color color,
  double? height,
  FontStyle? fontStyle,
}) {
  return _getTextStyle(
      fontSize, FontWeightManager.medium, color, height, fontStyle);
}

// Light Style
TextStyle getLightStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getTextStyle(
      fontSize, FontWeightManager.light, color, height, fontStyle);
}

// Semi-Bold Style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getTextStyle(
      fontSize, FontWeightManager.semiBold, color, height, fontStyle);
}

// Bold Style
TextStyle getBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getTextStyle(
      fontSize, FontWeightManager.bold, color, height, fontStyle);
}

// Regular Style
TextStyle getRegularPacificoStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getPacificoTextStyle(
      fontSize, FontWeightManager.regular, color, height, fontStyle);
}

// Medium Style
TextStyle getMediumPacificoStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getPacificoTextStyle(
      fontSize, FontWeightManager.medium, color, height, fontStyle);
}

// Light Style
TextStyle getLightPacificoStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getPacificoTextStyle(
      fontSize, FontWeightManager.light, color, height, fontStyle);
}

// Bold Style
TextStyle getBoldPacificoStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    double? height,
    FontStyle? fontStyle}) {
  return _getPacificoTextStyle(
      fontSize, FontWeightManager.bold, color, height, fontStyle);
}
