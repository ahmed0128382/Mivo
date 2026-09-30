
import 'package:flutter/material.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';

class ChatTextField extends StatelessWidget {
  String ? hint;
  bool ?obscureText;
  TextEditingController ?Controller;
  final TextInputType? type;
  final bool ?enable;
  final bool ?autofocus;
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
  final VoidCallback ? ontap;
  ChatTextField({
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
    this.ontap,this.autofocus});

  @override
  Widget build(BuildContext context) {
    return TextFormField(autofocus:autofocus??false ,enabled:enable??true,controller: Controller,obscureText:obscureText??false,
      cursorColor: Colors.black,keyboardType:type,
      decoration: InputDecoration( suffixIcon: suffixicon,
          suffixIconColor: Colors.black,border: InputBorder.none,
          hintText:hint,hintStyle: style4),
    );
  }
}
