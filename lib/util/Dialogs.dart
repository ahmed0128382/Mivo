import 'dart:io';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

 import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'package:ahlachat/main.dart';
class Dialogs{
  void showtoast(message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: whitecolor,
        textColor:MainColor,
        fontSize: 15.0
    );
  }
ShowMessage({name, message}){
  MotionToast(
    icon:  Icons.message,
    primaryColor:  Colors.white,
    secondaryColor:  MainColor,
    title:  Text(name),  iconSize: 25,toastDuration: Duration(seconds:2),animationDuration:Duration(seconds: 1) ,
    description:  Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(message,style: style2),
    ),
    toastAlignment: Alignment.topCenter,
    animationType:  AnimationType.slideInFromTop,
    height: 60,width: 300,
  ).show(NavigationService.navigatorKey.currentContext!);
}

  void ShowErrorToast(Code,context){
    switch(Code) {
      case 'E001': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_pass_name"));
        print('The selected name is invalid.');
      }
      break;
      case 'E0011': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_inname"));
        print('The selected name is invalid.');
      }
      break;
      case 'E002': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_password"));
      }
      break;
      case '3500': {
        Dialogs(). showtoast(getLang( context: context, key: "Login_valid"));

      }
      break;
      case 'E010': {
        Dialogs(). showtoast(getLang( context: context, key: "number_valid"));

      }

      break;
      case '23000': {
        Dialogs(). showtoast(getLang( context: context, key: "name_used"));
      }
      break;

      case '111': {
        Dialogs(). showtoast(getLang( context: context, key: "alredysent"));
      }
      break;
      default: {
        print(Code);
      }

      break;
    }


  }
  void ShowErrorRegesterToast(Code,context){
    switch(Code) {
      case 'E0011': {
        Dialogs().showtoast(getLang( context: context, key: "name_used"));
        print('The selected name is invalid.');
      }
      break;
      case 'E002': {
        Dialogs().showtoast(getLang( context: context, key: "incorrect_password"));
      }
      break;
      case '3500': {
        Dialogs(). showtoast(getLang( context: context, key: "Login_valid"));

      }
      break;
      case 'E010': {
        Dialogs(). showtoast(getLang( context: context, key: "phone_taken"));
      }
      break;
      case 'E048':{
        Dialogs().showtoast('You AllReady in  room');

      }
      break;
      case 'E112':{
        Dialogs().showtoast("Room Not found");
      }
      break;
      case 'E111':{
        Dialogs().showtoast("You Already Has Room");
      }
      break;
      case 'admin_id':{
        Dialogs().showtoast("You Already Has Room");
      }
      break;
      case 'E115':{
        Dialogs().showtoast("You Are Kicked From Room");
      }
      break;
      default: {
        print(Code);
      }
      break;
    }


  }
  void ShowcheckToast(Code,context){
    switch(Code) {
      case 'E001': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_pass_name"));
        print('The selected name is invalid.');
      }
      break;
      case 'E0011': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_inname"));
        print('The selected name is invalid.');
      }
      break;
      case 'E002': {
        Dialogs().showtoast(getLang( context: context, key: "correnct_password"));
      }
      break;
      case '3500': {
        Dialogs(). showtoast(getLang( context: context, key: "Login_valid"));

      }
      break;
      case 'E010': {
        Dialogs(). showtoast(getLang( context: context, key: "number_valid"));

      }

      break;
      case '23000': {
        Dialogs(). showtoast(getLang( context: context, key: "name_used"));
      }
      break;

      case '111': {
        Dialogs(). showtoast(getLang( context: context, key: "alredysent"));
      }
      break;
      default: {
        print(Code);

      }

      break;
    }


  }

  Adminshowdialog({required context,required String tittle,required String content,required String buttontext,required String  buttontext2,required  Function?onchange ,required  Function?oninvite }){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child: Text(content,style: style2.copyWith(fontSize: 12),),
        ),actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            InkWell(onTap: onchange as void Function(),child: Container(child: Center(child:  Text(buttontext,style: style1,)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor))),
            InkWell(onTap: oninvite as void Function(),child: Container(child: Center(child:  Text(buttontext2,style:  style1.copyWith(fontSize: 13),)),width: 80,height: 37,decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(20), ))),
           ],)
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(tittle),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text(buttontext)),
        ],)
      ],);
    },);
  }
  showdialog({required context,required String tittle,required String content,required String buttontext,required  Function?onTap }){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child: Text(content,style: style2.copyWith(fontSize: 12),),
        ),actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            InkWell(onTap: onTap as void Function(),child: Container(child: Center(child:  Text(buttontext,style: style1,)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor))),
         //   FlatButton( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed: onTap as void Function(), child: Text(buttontext,style: style1,)),

            InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style:  style1.copyWith(fontSize: 13),)),width: 80,height: 37,decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(20), ))),

           // FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed:()=>Navigator.pop(context), child: Text( getLang( context: context, key: "Close"),style: style1,)),
          ],)
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(tittle),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text(buttontext)),
        ],)
      ],);
    },);
  }
  showdialog2({required context,required String tittle,required String content,required String buttontext,required  Function?onTap }){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child: Text(content,style: style2.copyWith(fontSize: 12),),
        ),actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            InkWell(onTap: onTap as void Function(),child: Container(child: Center(child:  Text(buttontext,style: style1,)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20) ,color: MainColor))),
            //   FlatButton( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed: onTap as void Function(), child: Text(buttontext,style: style1,)),

            InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style:  style1.copyWith(fontSize: 13),)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor))),

            // FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed:()=>Navigator.pop(context), child: Text( getLang( context: context, key: "Close"),style: style1,)),
          ],)
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(tittle),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text(buttontext)),
        ],)
      ],);
    },);
  }
   showdialog4({required context,required String content,  }){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child: Text(content,style: style6.copyWith(fontSize: 12,),),
        ),actions: [
          InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style: style1.copyWith(fontSize: 13),)),width: 80,height: 33,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor)))
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(''),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text('')),
        ],)
      ],);
    },);
  }
  showdialog5({required context,required String content}){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child: Text(content,style: style6.copyWith(fontSize: 12,),),
        ),actions: [
          InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "OK"),style: style1.copyWith(fontSize: 13),)),width: 80,height: 33,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor)))
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(''),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text('')),
        ],)
      ],);
    },);
  }

  showPassworddialog({required context,required Controller,required String tittle,required String content,required String buttontext,required  Function?onTap }){
    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(title: Text(tittle,style: style6.copyWith(fontSize: 16)),backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
          child:TextFormField(autofocus:true,controller: Controller,),

        ),actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            InkWell(onTap: onTap as void Function(),child: Container(child: Center(child:  Text(buttontext,style: style1,)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.greenAccent))),
            //FlatButton( shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed: onTap as void Function(), child: Text(buttontext,style: style1,)),
            InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style: style1,)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.greenAccent,))),
            //FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed:()=>Navigator.pop(context), child: Text( getLang( context: context, key: "Close"),style: style1,)),
          ],)
        ],);
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text(tittle),content:Text(content),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text(buttontext)),
        ],)
      ],);
    },);
  }
// Show the modal that contains the CupertinoDatePicker
  // Show the modal that contains the CupertinoDatePicker
  void ShowFrame({context,svga}){

    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
           content: Container(height: 300,width: 250,child: Column(mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20) ),child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Icon(Icons.cancel_outlined,color: whitecolor),
               ))),
      Align(alignment: Alignment.center,child: CircleAvatar(backgroundColor: Colors.transparent,foregroundColor: Colors.black87,radius: 80, child:
      Stack(children: [
        Align(alignment: Alignment.center,child: CircleAvatar(backgroundColor: Colors.transparent,radius:55  ,backgroundImage:CachedNetworkImageProvider(user.userinfo?.image??'') )),
        SVGASimpleImage(resUrl:svga),

      ], )))
             ],
           )),
        )
    );
  }

  void ShowEntery({context,svga}){
    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.cancel_outlined,color: whitecolor),
              ))),
Container(height: 350,
 child:   SVGASimpleImage(resUrl:svga)
),
            ],
          )),
        )
    );
  }




  void ShowvipEntery({context,svga}){

    showDialog(barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          actions: [
            InkWell(onTap:(){
              Navigator.pop(context);
             // user.ByeVip(context: context,vip: Vips.Vips[index]);
            },child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(child: Center(child:  Text(getLang(context: context, key: "Yes"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
            ))),

           ],
          backgroundColor: Color(0xFF2b2f3b),
          content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.cancel_outlined,color: whitecolor),
              ))),
              Container(height: 350,
                  child:   SVGASimpleImage(resUrl:svga)
              ),
            ],
          )),
        )
    );
  }
  Future showdLanguageialog({required context, required String buttontext,required  Function?onTap }){

    languageViewmodel language=Provider.of<languageViewmodel>(context,listen: false);

    if(!Platform.isIOS){
      return showDialog(context: context,builder: (context) {
        return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content:Container(
              child: Column(mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(onTap: () {
                  language.Arbic();
                  Navigator.pop(context);
                  },child: ListTile(title: Text('عربي',style: styleb,),trailing: Icon(Icons.language_outlined,color: Lang=='En'? Colors.black12:MainColor))),
                  InkWell(onTap: (){
                   language.English();
                   Navigator.pop(context);
                  },child: ListTile(title: Text('انجليزي',style: styleb),trailing: Icon(Icons.language_outlined,color: Lang=='En'? MainColor:Colors.black12))),
                ],
              )
          ),

        );
      },);
    }
    return showCupertinoDialog(context: context,builder: (contexts) {
      return CupertinoAlertDialog(title: Text('tittle'),content:Text('content'),actions: [
        Row(children: [
          CupertinoDialogAction(onPressed: (){

            Navigator.pop(contexts,true);

          }, child: Text(buttontext)),
        ],)
      ],);
    },);
  }

}
