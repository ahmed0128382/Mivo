import 'package:flutter/material.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Authentication/widgets/CountryCode.dart';

class CustomeTextField extends StatelessWidget {
 String ? hint;
bool ?obscureText;
TextEditingController ?Controller;
 final TextInputType? type;
 final bool ?enable;
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
 CustomeTextField({
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
 this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: whitecolor),width:SizeConfig.screenWidth,child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [

          Expanded(
            child: TextFormField(enabled:enable??true,controller: Controller,obscureText:obscureText??false,
cursorColor: Colors.black,keyboardType:type,
              decoration: InputDecoration( suffixIcon: suffixicon,
                  suffixIconColor: Colors.black,
                focusedBorder:bordercolor==null?OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),

                ): OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: MainColor, width: 1.0),
                ),
                enabledBorder: bordercolor==null?OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1.0),
                ): OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.black45, width: 1.0),
                ),
                hintText:hint,


              ),
            ),
          ),
          if(type==TextInputType.phone)


            CountryCodePhone()
        ],
      ),
    ),);
  }
}

class CustomTextFormField3 extends StatelessWidget {
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChanged;
  final int? maxLines;
  final int? maxlength;
  final double? radius;
  final double? hight;
  final String? hint;
  final String? initialValue;
  final bool? obscureText;
  final Color? bordercolor;
  final Color? fillColor;
  final Color? hintColor;

  final Color? textColor;
  final Widget? prefxIcon;
  final TextEditingController?Controller;

  const CustomTextFormField3({
    Key? key,
    @required this.inputType,
    this.suffexIcon,  this.prefxIcon,
    this.hint,
    this.onSaved,
    this.onChanged,
    this.Controller,
    this.maxLines,
    this.obscureText,
    this.bordercolor,
    this.radius,
    this.initialValue,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.hight,
    this.maxlength

  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField( textAlign: TextAlign.center, controller: Controller,initialValue: initialValue,
      keyboardType: inputType,
      onChanged: onChanged,
      style: style1.copyWith(color:textColor?? MainColor),

      onSaved: onSaved,  obscureText: obscureText??false,
      maxLines: maxLines,cursorColor: MainColor,maxLength: maxlength,
      decoration: InputDecoration(

          hintStyle: style1.copyWith(color:hintColor??Colors.black45),

          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(radius??30),
            borderSide:  BorderSide(color:Colors.transparent  ),

          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(radius??30),
            borderSide:  BorderSide(color: Colors.transparent ),

          ),
          hintText: hint.toString(),
          filled: true,
          fillColor: fillColor??whitecolor,
          suffixIcon: suffexIcon,prefixIcon: prefxIcon

      ),
    );
  }
}


class CustomTextFormField4 extends StatelessWidget {
  final TextInputType? inputType;
  final Widget? suffexIcon;
  final ValueSetter? onSaved;
  final ValueSetter? onChanged;
  final int? maxLines;
  final double? radius;
  final double? hight;
  final String? hint;
  final String? initialValue;
  final bool? obscureText;
  final Color? bordercolor;
  final Color? fillColor;
  final Color? hintColor;

  final Color? textColor;
  final Widget? prefxIcon;
  final TextEditingController?Controller;

  const CustomTextFormField4({
    Key? key,
    @required this.inputType,
    this.suffexIcon,  this.prefxIcon,
    this.hint,
    this.onSaved,
    this.onChanged,
    this.Controller,
    this.maxLines,
    this.obscureText,
    this.bordercolor,
    this.radius,
    this.initialValue,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.hight,

  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField( controller: Controller,initialValue: initialValue,
      keyboardType: inputType,
      onChanged: onChanged,
      style: style1.copyWith(color:textColor?? MainColor),

      onSaved: onSaved,  obscureText: obscureText??false,
      maxLines: maxLines,cursorColor: MainColor,
      decoration: InputDecoration(

          hintStyle: style1.copyWith(color:hintColor??Colors.black45),

          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(radius??30),
            borderSide:  BorderSide(color:Colors.transparent  ),

          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(radius??30),
            borderSide:  BorderSide(color: Colors.transparent ),

          ),
          hintText: hint.toString(),
          filled: true,
          fillColor: fillColor??whitecolor,
          suffixIcon: suffexIcon,prefixIcon: prefxIcon

      ),
    );
  }
}