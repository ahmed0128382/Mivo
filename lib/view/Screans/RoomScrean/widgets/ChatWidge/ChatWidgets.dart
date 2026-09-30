
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/RolletUserScrean/RolletUserScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GuessWidgets/GuessWidgets.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InBoxsRoom.dart';

import 'package:ahlachat/view/Screans/RoomScrean/widgets/emoji/emojisscrean.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

import 'package:provider/provider.dart';

import '../GiftBox/GiftBox.dart';
class ChatWidgets extends StatelessWidget {
  const ChatWidgets({Key? key}) : super(key: key);
  @override 
  Widget build(BuildContext context) {
    RoomViewmodel Room=   Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AgoraViewmodel Agora= Provider.of<AgoraViewmodel>(context,listen: true);
    var wait=5;
    return  Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(width: SizeConfig.screenWidth!,color: Colors.transparent,child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: InkWell(onTap: () {
              showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor: Colors.black,shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                context: context,
                builder: (context) {
                  return Container(decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30)) ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround ,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(onTap: (){
                            Navigator.pop(context);
                            if(!Agora.disableAudio){
                              Agora.closeroomvoice();
                            }else{
                              Agora.enableroomvoice();
                            }
                          },child: Image.asset(Agora.disableAudio?'assets/image/ic_hk_tool_mute_off.png':'assets/image/ic_music_no_mute_voice.png',height: 40,)),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:3),
                            child: GestureDetector(onTap:(){
                              Navigator.pop(context);
                              Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
                              showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: false, barrierColor:Colors.black.withAlpha(1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                context: context,
                                builder: (context) {
                                  return  MessageScrean();
                                },
                              );

                              user.changeNewmessage(false);
                            },
                              child: Image.asset('assets/image/icons8-messages-200.png',height:50 ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            }, child: CircleAvatar(radius: 18,backgroundColor: Colors.transparent,child: Image.asset(Agora.disableAudio?'assets/image/ic_hk_tool_mute_off.png':'assets/image/ic_music_no_mute_voice.png',height: 27,))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(onTap:(){
              Room.ChairsRoom.clear();
              Room.ChairMaps.clear();
              Room.ClearMentionid();
              Room.Currentroom?.chairs?.forEach((element) {
                if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
                  Room.ChairMaps.add({
                    'id': element.user?.id.toString(),
                    'display': element.user?.name,
                    'full_name': element.user?.image,
                       },);

                }
              });
              Room.showSpinner7();
            },
              child: Container(height: 37,decoration: BoxDecoration( borderRadius: BorderRadius.circular(25),  color: whitecolor4),child: Row(
                children: [
                  const SizedBox(width: 10,),
                  Text(getLang(context: context,key: "Say_hi"),style: style6.copyWith(fontSize: 13,height: 1,color: whitecolor2)),


                  const SizedBox(width: 30,),

                  if(JoinChairs)   InkWell(onTap: (){
                    showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                      context: context,
                      builder: (context) {
                        return const EmojiTabBar();
                      },
                    );

                  },child: Image.asset(Images.imoje,width: 22,height: 22,color: Colors.white)),
                  const SizedBox(width: 10,),
                  if(JoinChairs)   InkWell(onTap: (){
                    showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                      context: context,
                      builder: (context) {
                        return Container(
                          child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 25,),
                              Text('القسم الترفيهي',style: style1,) ,
                              SizedBox(height: 25,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(onTap: (){
                                    Navigator.pop(context);
                                    showModalBottomSheet( barrierColor: Colors.black.withAlpha(1),
                                        backgroundColor: Colors.transparent, isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return Container(height: 600,child: WebViewRollet(name: getLang( context: context, key: "Terms_Service"), link: 'http://game.worldchat.online/?token=${user.userinfo?.rememperToken}',));
                                        });
                                  },child: Image.asset(Images.fruits,height: 60, width: 60,fit: BoxFit.fill)),
                                  InkWell(onTap: (){
                                    Navigator.pop(context);
                                    Room.Playdice(context: context );
                                  },child: Image.asset(Images.dice,height: 60, width: 60,fit: BoxFit.fill)),
                                  InkWell(onTap: (){
                                    Navigator.pop(context);
                                    Room.ChairsRoom.clear();
                                    Room.Rolletchoice.clear();
                                    Room.Currentroom?.chairs?.forEach((element) {
                                      if(element.userId!=null&&element.user!=null){
                                        Room.ChairsRoom.add(element);

                                      }
                                    });
                                    print(Room.ChairsRoom);
                                    showModalBottomSheet(barrierColor:Colors.transparent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context, void Function(void Function()) setState) {
                                            return Container(decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), ),image: DecorationImage(image: ExactAssetImage(Images.VipBackground),fit: BoxFit.cover)), width: SizeConfig.screenWidth,child: Column(
                                              children: [
                                                SizedBox(height: 20,),
                                                Expanded(
                                                  child: ListView.builder(itemCount: Room.ChairsRoom.length,itemBuilder: (context, index) => Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, ).copyWith(top: 10),
                                                    child: InkWell(onTap:(){
                                                      if( Room.Rolletchoice.contains(Room.ChairsRoom[index].user?.name)){
                                                        setState(() {
                                                          Room.RemoveRolletchoice(Room.ChairsRoom[index].user?.name??'');
                                                        });
                                                      }else{
                                                        setState(() {
                                                          Room.AddRolletchoice(Room.ChairsRoom[index].user?.name??'');
                                                        });
                                                      }
                                                    } ,
                                                      child: Container(width:SizeConfig.screenWidth,height: 50,decoration: BoxDecoration(border: Border.all(color: Colors.white)),child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 20) ,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(Room.ChairsRoom[index].user?.name??'',style: style1.copyWith(fontSize: 13),),
                                                            Room.Rolletchoice.contains(Room.ChairsRoom[index].user?.name)?    Icon(Icons.check_box,color: Colors.white):Icon(Icons.check_box_outline_blank_outlined,color: Colors.white),

                                                          ],
                                                        ),
                                                      ), ),
                                                    ),
                                                  ),),
                                                ),
                                                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                                                    child: InkWell(onTap: (){
                                                      if(  Room.Rolletchoice.length>=2){
                                                        Navigator.pop(context);
                                                        showModalBottomSheet(barrierColor:Colors.transparent,context: context, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )), builder: (BuildContext context) {

                                                          return const RolletFullscrean();
                                                        });
                                                      }else{
                                                        Dialogs().showtoast('عدد الاشخاص يجب ان يكون 2 او اكثر');
                                                      }
                                                    },child: Container(child: Center(child: Text(getLang(context: context,key: 'Start'),style: style2,)),decoration: BoxDecoration( color: Colors.white,borderRadius:  BorderRadius.circular(10)),height: 50,width: SizeConfig.screenWidth))),
                                                SizedBox(height: 20,),
                                              ],
                                            ),);
                                          },

                                        );
                                        //return const RolletFullscrean();
                                      },
                                    );
                                  },child: Image.asset(Images.Rolletuser,height: 60, width: 60,fit: BoxFit.fill)),
                                ],
                              ),
                              SizedBox(height: 25,),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(onTap: (){
                                    Navigator.pop(context);
                                    user.SelectGuess(val: null);
                                    user.SelectGuesscoins(val: null);
                                    showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                        context: context,
                                        builder: (context) {
                                          return GuessWidgets();
                                        });
                                  },child: Image.asset(Images.guessing,height: 60, width: 60,fit: BoxFit.fill)),
                                 ],
                              ),
                              SizedBox(height: 25,),
                            ],
                          ),
                        );
                      },
                    );

                  },child: Image.asset(Images.entertainment,width: 23,height: 23,color: Colors.white)),

                  const SizedBox(width: 5,),

                  const SizedBox(width: 8,),
                ],
              )),
            ),
          ),
          const   Spacer(),

        if(JoinChairs||Room.checkadmin(context: context) )  Padding(
            padding: const EdgeInsets.symmetric(horizontal:3),
            child: InkWell(onTap: () {


                  if(Agora.muted==true&&Room.checkmute()){
                  Room.Changemicestateadmin(userId:UserId ,state: 0 );
                  Agora.UnMute();
                  Room.updatemute(context: context,state: 0,user_id: UserId);
                  }else{

                    Room.Changemicestateadmin(userId:UserId,state: 1 );
                    Room.updatemute(context: context,state: 1,user_id: UserId);
                    Agora.Mute();

                  }


            }, child: CircleAvatar(radius: 18,backgroundColor: Colors.transparent,child: Image.asset(Agora.muted?'assets/image/ic_multi_live_mute_on.png':'assets/image/ic_multi_live_mute_nor.png',height: 30, ))),
          ),


         const GiftBox(),
         SizedBox(width: 10,)
        ],
      ),),
    );
  }
}
