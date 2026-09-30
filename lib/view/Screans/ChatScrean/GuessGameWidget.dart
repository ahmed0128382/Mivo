import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GuessGameWidget extends StatelessWidget {
 int   index;
 GuessGameWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text('التخمين',style: style1,),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        user.SelectGuess(val: 1);
                      },
                      child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color:  user.SelectGuessList==1?MainColor: whitecolor2)) ,child: Column(
                        children: [
                          SizedBox(height:   15,),
                          Image.asset(Images.guessing1,height: 60),
                          SizedBox(height:   15,),
                          Text('Rock',style: style1,),
                          SizedBox(height:   15,),
                        ],
                      ),),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child:InkWell(
                      onTap: () {
                        user.SelectGuess(val: 2);
                      },
                      child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: user.SelectGuessList==2?MainColor: whitecolor2)) ,child: Column(
                        children: [
                          SizedBox(height:   15,),
                          Image.asset(Images.guessing2,height: 60),
                          SizedBox(height:   15,),
                          Text('Paper',style: style1,),
                          SizedBox(height:   15,),
                        ],
                      ),),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child:InkWell(
                      onTap: () {
                        user.SelectGuess(val: 3);
                      },
                      child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color:user.SelectGuessList==3?MainColor: whitecolor2)) ,child: Column(
                        children: [
                          SizedBox(height:   15,),
                          Image.asset(Images.guessing3,height: 60),
                          SizedBox(height:   15,),
                          Text('Scissor',style: style1,),
                          SizedBox(height:   15,),
                        ],
                      ),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Text('    ${Room.Currentroom?.chatroom?[index].Coins}   :  القيمه هي    ',style: style1, textDirection: TextDirection.ltr,),


              SizedBox(height: 15,),
              InkWell(onTap: () {
                if(user.SelectGuessList==null){
                  Dialogs().showtoast('اختر النخمين اولا');
                }else if((user.userinfo?.coins??0)<int.parse(Room.Currentroom?.chatroom?[index].Coins??'0')){
                  Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));
                }else{
                  Navigator.pop(context);
                   user.PlayGuess(context: context,Roomid:Room.Currentroom?.id,guessid: Room.Currentroom?.chatroom?[index].Guess?.id,coins:int.parse(Room.Currentroom?.chatroom?[index].Coins??'0') );
                }
              },child: Container(child: Center(child: Text(getLang(context: context,key: 'Start'),style: style2,)),decoration: BoxDecoration( color: Colors.white,borderRadius:  BorderRadius.circular(10)),height: 50,width: SizeConfig.screenWidth)),
              SizedBox(height: 15,),
            ]),
      ),
    );
  }
}
