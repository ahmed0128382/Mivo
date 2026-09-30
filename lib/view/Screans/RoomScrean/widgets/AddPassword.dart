

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/CustomeTextField.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../widgets/CircleProgress.dart';
class AddRoomPassword extends StatelessWidget {
  const AddRoomPassword({Key? key}) : super(key: key);
   @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return AnimatedPositioned(
        height:   Room.showloading18 ? SizeConfig.screenHeight! /2:0,
        left:0,
        top: 0.0,
        duration: const Duration(milliseconds: 300,),
        curve: Curves.fastOutSlowIn,
        child:  Container(decoration: BoxDecoration(color: whitecolor ,borderRadius: BorderRadius.only(bottomRight:   Radius.circular(20),bottomLeft: Radius.circular(20) )),height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,
            child:SingleChildScrollView(
              child:  Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      InkWell(onTap: () {
                        print('asdas');
                        Room.hideSpinner18();

                      },child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(20)),child: Icon(Icons.close,size:25,color: MainColor)),
                      ),
                      ),
                    const Spacer(),

                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(width: SizeConfig.screenWidth , child: Row(
                    children: [
                      InkWell(onTap: () {
                        Room.hideSpinner18();
                        Room.PasswordRoom.clear();
                        Room.RemoveRoomPassword(context: context);

                      },child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(20)),child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical:2),
                          child: Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 13,color: whitecolor),),
                        )),
                      ),
                      ),

                      SizedBox(width: 10,),
                      Expanded(
                        child: TextFormField(onChanged: (v){

                        },controller:  Room.PasswordRoom , cursorColor: MainColor ,textAlign: TextAlign.center,decoration:InputDecoration(hintText: getLang(context: context,key: "RoomPassword"),  enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MainColor),
                        ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: MainColor),
                          ),

                        ) ,),
                      ),
                      Text( getLang(context: context,key: "RoomPassword"),style: style6.copyWith(fontSize: 13,color: black1),textAlign: TextAlign.center),

                    ],
                  )),
                  SizedBox(height: 40,),
                  Room.showloading19? Center(child: CustomeCircleProgress()): InkWell(onTap: (){
                    if(Room.PasswordRoom.text.length==0)
                    {
                      Room.hideSpinner18();
                      Room. RemoveRoomPassword(context: context);

                    }else{
                      Room.hideSpinner18();
                      Room. SetRoomPassword(context: context);
                    }

                  },child: Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,color: MainColor),child: Center(child: Text(getLang(context: context, key: "Done"),style:  style1,)),height:50,width: SizeConfig.screenWidth!,),
                  )))


                ],
              ),
            )



        ));
  }
}
