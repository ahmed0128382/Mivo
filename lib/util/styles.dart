import 'dart:ui';

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



  TextStyle style1 =  GoogleFonts.notoSans(
  fontWeight: FontWeight.bold,
  fontSize:16,
  color: whitecolor,

);

TextStyle Namestyle =  GoogleFonts.notoSans(
  fontWeight: FontWeight.normal,
  fontSize:14,

);
TextStyle Namestyle2 =  GoogleFonts.notoSans(
  fontWeight: FontWeight.normal,
  fontSize:14,
color: Colors.white
);
  TextStyle styleb = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:16,
  color: Colors.black,
);
  TextStyle styleb45 = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:16,
  color: Colors.black45,
);
  TextStyle style2 = GoogleFonts.notoSans(

  fontWeight: FontWeight.bold,
  fontSize:16,
  color: blackcolor,
);
  TextStyle style7 = GoogleFonts.notoSans(

  fontWeight: FontWeight.bold,
  fontSize:16,
  color: whitecolor,
);
  TextStyle style3 = GoogleFonts.notoSans(

  fontSize:2,
  fontWeight: FontWeight.bold,
);
  TextStyle style4 = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:16,
  color: Colors.black45,
);
  TextStyle style5 = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:16,
  color: blackcolor,
);

  TextStyle style6 = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:11,
  color: blackcolor,
);

  TextStyle style8 = GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,
  fontSize:13,
  color: blackcolor,
);
  TextStyle style11= GoogleFonts.notoSans(

  fontWeight: FontWeight.normal,height: 1,
  fontSize:17,
  color:  Colors.white,
);
  TextStyle style9 = TextStyle(
  fontFamily: 'OmarR',
  fontWeight: FontWeight.bold,
  fontSize:25,
  color: blackcolor,
);
  TextStyle style10= TextStyle(
  fontFamily: 'OmarR',
  fontWeight: FontWeight.normal,
  fontSize:17,
  color:  Colors.black54,
);

  TextStyle CountryPickerText= TextStyle(fontSize:16, color: Colors.blueGrey);
  TextStyle CountryPickerText2= TextStyle(fontSize:  16,  color: MainColor);
const Color whitecolor = Colors.white;
const Color blackcolor = Colors.black;
const Color whitecolor2=CupertinoColors.lightBackgroundGray;
const Color whitecolor3=Color.fromRGBO(229, 229, 234, 0.5);
const Color whitecolor4=Colors.white24;
const Color whitecolor5=Color.fromRGBO(192, 193, 196, 0.1);
const Color whitecolor6=Color.fromRGBO(192, 193, 196, 0.2);
const Color whitecolor7=Color.fromRGBO(192, 193, 196, 0.9);

const Color whitecolor8=Color.fromRGBO(255, 255, 255, 0.5);
const Color yellowcolor1=Color.fromRGBO(234, 226, 190, 0.5);
const BoxShape BoxCircle = BoxShape.circle;
const Color OrangeColor=CupertinoColors.activeOrange;

const Color MainColor = const Color(0xFF1878f3);
  Color MainColor2 = const Color(0xFF9a1aaa);
const Color SecondColor = const Color(0xFFfee890);
const  Color ThirdColor=const Color(0xFFa80f03);
const  Color secondcolor=const Color(0xFFF5F6F8);

const  Color black1=const Color.fromRGBO(0, 0, 0, 0.7);
const gradiant1=LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent,Colors.transparent, Colors.deepPurpleAccent]);
const gradiant7=LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFcc5dda), Colors.deepPurpleAccent]);
var gradiant10=LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.red.withOpacity(0.8), Colors.red,   Colors.transparent]);

 var gradiant4=LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.purple.withOpacity(0.9), Colors.blue.withOpacity(0.9)]);
const gradiant6=LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [ Colors.lightGreen, MainColor]);
var gradiant5=LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.red.withOpacity(0.8), Color(0xFF925AF2).withOpacity(0.8)]);


const gradiant2=LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.black12 ,Colors.black12  ]);
const gradiant3=LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.black26 ,Colors.black26]);
//-------------------------------------
const EdgeInsets WPadding50=EdgeInsets.symmetric(horizontal: 50);
const EdgeInsets WPadding15=EdgeInsets.symmetric(horizontal: 15);
const EdgeInsets WPadding10=EdgeInsets.symmetric(horizontal: 10);

const EdgeInsets HWPadding10=EdgeInsets.symmetric(horizontal: 10,vertical:10);
const EdgeInsets WPadding30=EdgeInsets.symmetric(horizontal: 30);
const EdgeInsets WPadding40=EdgeInsets.symmetric(horizontal: 40);



const EdgeInsets BPadding10=EdgeInsets.only(bottom: 10);

//-------------------------------------
 var HSized10=SizedBox(height:10,);
var HSized15=SizedBox(height:5 );
var HSized20=SizedBox(height: 20);
var HSized25=SizedBox(height: 25);
var HSized30=SizedBox(height:30);
var HSized40=SizedBox(height:40);
//-------------------------------------
const WSized5=SizedBox(width: 5,);
const WSized10=SizedBox(width: 10,);
const WSized15=SizedBox(width: 15,);
//-----------------------
const BRadius20= BorderRadius.only(
topLeft: Radius.circular(20.0),
topRight: Radius.circular(20.0),
);
  InputBorder CountryPickerInputBorder=OutlineInputBorder(
  borderSide:   BorderSide(color: MainColor, width:1),
  borderRadius: BorderRadius.circular(15.0),
);