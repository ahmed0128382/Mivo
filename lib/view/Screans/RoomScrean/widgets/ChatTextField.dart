import 'package:flutter/material.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';

class ChatTextField extends StatelessWidget {
  final String? hint;
  final bool? obscureText;
  final TextEditingController? Controller;
  final TextInputType? type;
  final bool? enable;
  final bool? autofocus;
  final ValueSetter? onSaved;
  final ValueSetter? onChanged;
  final int? maxLines;
  final int? maxLength;
  final double? radius;
  final double? hight;
  final Color? bordercolor;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final Widget? prefxIcon;
  final Widget? suffixicon;
  final VoidCallback? ontap;

  const ChatTextField({
    super.key,
    this.suffixicon,
    this.hint,
    this.obscureText,
    this.Controller,
    this.enable,
    this.onSaved,
    this.onChanged,
    this.maxLines,
    this.maxLength,
    this.radius,
    this.hight,
    this.bordercolor,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.prefxIcon,
    this.type,
    this.ontap,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    final double cornerRadius = radius ?? 12;

    return TextFormField(
      controller: Controller,
      enabled: enable ?? true,
      autofocus: autofocus ?? false,
      obscureText: obscureText ?? false,
      keyboardType: type,
      maxLines: obscureText == true ? 1 : maxLines ?? 1,
      maxLength: maxLength,
      onSaved: onSaved,
      onChanged: onChanged,
      onTap: ontap,
      cursorColor: textColor ?? Colors.black,
      style: TextStyle(
        color: textColor ?? Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style4.copyWith(
          color: hintColor,
        ),
        prefixIcon: prefxIcon,
        suffixIcon: suffixicon,
        suffixIconColor: Colors.black,
        filled: fillColor != null,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: hight != null ? hight! / 3 : 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
          borderSide: BorderSide(
            color: bordercolor ?? Colors.transparent,
          ),
        ),
        counterText: maxLength != null ? null : '',
      ),
    );
  }
}