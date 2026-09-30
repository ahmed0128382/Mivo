
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../util/Localization.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class SelectGenderWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return  Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(left: 10),child: Text(getLang( context: context, key: "Gender"),style: style1.copyWith(color: MainColor, fontWeight: FontWeight.normal))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              Checkbox(focusColor: MainColor,checkColor:whitecolor ,activeColor: MainColor,value: !user.gender, onChanged: (value){
                user.selectginder();
              }),
              Text(getLang( context: context, key: "Male"),style:  style1.copyWith(color: MainColor,fontWeight: FontWeight.normal) ),
              Checkbox(focusColor: MainColor,checkColor:whitecolor ,activeColor: MainColor,value: user.gender, onChanged: (value){
                user.selectginder();
              }),
              Text(getLang( context: context, key: "Female"),style:    style1.copyWith(color: MainColor,fontWeight: FontWeight.normal)),

            ],)
          ],
        ),
      ),
    );
  }
}
