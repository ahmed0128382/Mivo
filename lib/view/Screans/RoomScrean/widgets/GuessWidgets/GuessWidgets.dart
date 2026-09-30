import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuessWidgets extends StatelessWidget {

List Coins=[10,100,500,1000,2000,5000,10000,20000];
  @override
  Widget build(BuildContext context) {
    LoginViewmodel        user = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

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
              Text('حدد هديه الفائز',style: style1,),
              SizedBox(height: 15,),
              SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row(children:List.generate(Coins.length, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(onTap: () {
                    if(Coins[index]<=user.userinfo?.coins){
                      user.SelectGuesscoins(val:Coins[index] );
                    }else{
                      Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

                    }
                  },
                    child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(color: Coins[index]==user.Guesscoins?MainColor:whitecolor2)) ,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height:   10,),
                          Image.asset(Images.coins,height: 20),
                          SizedBox(height:   5,),
                          Text(Coins[index].toString(),style: style1,),
                          SizedBox(height:   5,),
                        ],
                      ),
                    ),),
                  ),
                )),),
              ),
              SizedBox(height: 15,),
              InkWell(onTap: () {
                if(user.SelectGuessList==null){
                  Dialogs().showtoast('اختر النخمين اولا');
                }else if(user.Guesscoins==null){
                  Dialogs().showtoast('اختر الهديه اولا');
                }else{
                  Navigator.pop(context);
              user.NewGuess(context: context,Roomid:Rooms.Currentroom?.id );
                }
              },child: Container(child: Center(child: Text(getLang(context: context,key: 'Start'),style: style2,)),decoration: BoxDecoration( color: Colors.white,borderRadius:  BorderRadius.circular(10)),height: 50,width: SizeConfig.screenWidth)),
              SizedBox(height: 15,),
            ]),
      ),
    );
  }
}
