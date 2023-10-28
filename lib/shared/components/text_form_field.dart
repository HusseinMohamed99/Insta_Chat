import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_chat/utils/color_manager.dart';

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
    this.inputFormatters,
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
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: ColorManager.black),
      inputFormatters: const <TextInputFormatter>[],
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
