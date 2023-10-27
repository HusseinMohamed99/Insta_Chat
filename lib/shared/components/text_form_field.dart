import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insta_chat/utils/color_manager.dart';
import 'package:insta_chat/utils/font_manager.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.validate,
    required this.label,
    this.hint,
    this.onTap,
    this.onChanged,
    this.isPassword = false,
    this.isClickable = true,
    this.suffix,
    this.prefix,
    this.suffixPressed,
    this.decoration,
    this.onFieldSubmitted,
    this.focusNode,
    this.color,
    this.onEditingComplete,
    this.prefixPressed,
    this.maxLines,
    this.minLines,
    this.obscuringCharacter,
    this.textColor,
  });

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validate;
  final String label;
  final String? hint;
  final dynamic onTap;
  final dynamic onChanged;
  final bool isPassword;
  final bool isClickable;
  final IconData? suffix;
  final IconData? prefix;
  final Function? suffixPressed;
  final Function? prefixPressed;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final Function(String)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Color? color;
  final Color? textColor;
  final int? maxLines;
  final int? minLines;
  final String? obscuringCharacter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: obscuringCharacter ?? '*',
      onEditingComplete: onEditingComplete,
      style: Theme.of(context).textTheme.titleLarge,
      focusNode: FocusNode(),
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      controller: controller,
      validator: validate,
      enabled: isClickable,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
          color: ColorManager.greyColor,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                  color: ColorManager.greyColor,
                ),
              )
            : null,
        labelText: label,
        labelStyle: GoogleFonts.roboto(
          color: color ?? ColorManager.greyColor,
          fontSize: 18,
          fontWeight: FontWeightManager.regular,
        ),
        hintText: hint,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.prefixIcon,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.hintText,
    required this.textInputType,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    this.suffixIconOnTap,
    this.obscureText = false,
    this.suffixIcon,
  });

  final IconData prefixIcon;
  final bool obscureText;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final String hintText;
  final TextInputType textInputType;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Function()? suffixIconOnTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: ColorManager.blackColor),
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: '*',
      cursorColor: Colors.black,
      cursorHeight: 20,
      keyboardType: textInputType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon:
            GestureDetector(onTap: suffixIconOnTap, child: Icon(suffixIcon)),
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: const Color(0xffdbe4eb),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
