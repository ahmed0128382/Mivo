
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class SelectAgeWidget extends StatefulWidget {
  const SelectAgeWidget({Key? key}) : super(key: key);

  @override
  State<SelectAgeWidget> createState() => _SelectAgeWidgetState();
}

class _SelectAgeWidgetState extends State<SelectAgeWidget> {

  late DateTime _chosenDateTime=DateTime.now();

  // Show the modal that contains the CupertinoDatePicker

  void _showDatePickers(ctx) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    FocusScope.of(context).unfocus();
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height:SizeConfig.screenHeight!* 0.48366,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                height:SizeConfig.screenHeight!* 0.392,
                child: CupertinoDatePicker(             mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (val) {
                      setState(() {
                        _chosenDateTime = val;
                      });
                      print(_chosenDateTime);

                    }),

              ),
              CupertinoButton(
                child: Text(getLang( context: context, key: "OK"),style: style1.copyWith(color: MainColor),),
                onPressed: () {

                  user.selectage(day:_chosenDateTime.day ,month:_chosenDateTime.month ,year:_chosenDateTime.year );
                  Navigator.of(ctx).pop();
                  FocusScope.of(context).unfocus();},
              )
            ],
          ),
        ));}
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return  InkWell( onTap: () =>  _showDatePickers(context),
      child: Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 10),child: Text(getLang( context: context, key: "Your_Age",),style: style1.copyWith(color: MainColor))),
              Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(15)), width: SizeConfig.screenHeight!* 0.03968253968,child:Center(child:  Text('${user.Selectedday}',style: style1.copyWith(color: MainColor,fontSize: 20),))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child:   Text('-',style: style1.copyWith(color: MainColor,fontSize: 20)),
              ),
              Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(15)), width:  SizeConfig.screenHeight!* 0.03968253968,child:Center(child:  Text('${user.Selectedmonth}',style: style1.copyWith(color: MainColor,fontSize: 20),))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child:   Text('-',style: style1.copyWith(color: MainColor,fontSize: 20)),
              ),
              Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(15)),  child:Center(child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text('${user.Selectedyear}',style: style1.copyWith(color: MainColor,fontSize: 20),),
              ))),

              //InkWell(onTap: () =>  _showDatePickers(context),child: Text('${_chosenDateTime.month}-${_chosenDateTime.day}-${_chosenDateTime.year}',style: style1.copyWith(color: MainColor,fontSize: 20),)),

            ],
          ),
        ),
      ),
    );
  }
}
