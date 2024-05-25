import 'package:flutter/material.dart';

class TFF extends StatelessWidget {
  String? hintText;
  TextStyle? hintStyle;
  String? labelText;
  TextStyle? labelStyle;
  Widget? prefixIcon;
  Color? prefixIconColor;
  Widget? suffixIcon;
  bool obscureText;
  var border;
  var enabledBorder;
  TextInputType? keyboardType;
  TextEditingController controller;
  void Function(String)? onChanged;
  void Function()? onPressed;
  void Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  TextStyle? style;
  EdgeInsetsGeometry? contentPadding;
  Color? fillColor;
  bool? filled;

  TFF({super.key,
    required this.obscureText,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.keyboardType,
    this.onPressed,
    this.onChanged,
    this.onFieldSubmitted,
    this.border,
    this.enabledBorder,
    this.validator,
    this.style,
    this.contentPadding,
    this.fillColor,
    this.filled,
   });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onPressed,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      validator: validator?? (value)
      {
        if(value!.isEmpty)
        {
          return 'This Field is required';
        }
        return null;
      },
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: style?? const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
      ),
      decoration: InputDecoration(
        fillColor: fillColor??Colors.white,
        filled: filled??false,
        contentPadding: contentPadding,
        border: border,
        enabledBorder: enabledBorder,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700),
      ),
    );
  }
}
