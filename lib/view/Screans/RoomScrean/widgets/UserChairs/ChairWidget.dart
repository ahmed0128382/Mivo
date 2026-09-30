import 'dart:convert';

import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/RoomScrean/CollectKarismaUser.dart';

import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SendGift.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/helperclass.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
 class Chairwidget extends StatelessWidget {
  final int index;
    Chairwidget({ required this.index});

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);

    return  PopupMenuButton( color: Colors.black , padding: EdgeInsets.all(0.0),iconSize: 100 ,

      itemBuilder: (BuildContext bc) {
      return   [
        _buildPopupMenuItem(title:getLang(context: context,key: "Profile"),iconData: Icons.person,val: 0),
        _buildPopupMenuItem(title: getLang(context: context, key: "Send_Gifts"),iconData: Icons.wallet_giftcard,val:1),
        if(Room.checkadmin(context: context)||((Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false)&&!(Room.Currentroom?.supervisorsId?.contains(Room.Currentroom?.chairs?[index].user?.id.toString())??false)))  _buildPopupMenuItem(title:  Room.Currentroom?.chairs?[index].mute==0?getLang( context: context, key: "mute"):getLang( context: context, key: "unmute"),iconData: Room.Currentroom?.chairs?[index].mute==0?Icons.mic_none:Icons.mic_off_outlined,val: 2),
        if(Room.checkadmin(context: context))  _buildPopupMenuItem(title: Room.Currentroom?.supervisorsId?.contains(Room.Currentroom?.chairs?[index].user?.id.toString())??false?getLang(key: "Remove_Admin",context: context):getLang(key: "Add_Admin",context: context),iconData: Icons.star,val: 5),
        if(Room.checkadmin(context: context)||Room.Currentroom?.chairs?[index].userId==user.userinfo?.id.toString())   _buildPopupMenuItem(title:getLang(key: "Leave_Chair",context: context),iconData: Icons.chair_outlined,val: 3),
        if((Room.checkadmin(context: context)||((Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false)&&!(Room.Currentroom?.supervisorsId?.contains(Room.Currentroom?.chairs?[index].user?.id.toString())??false)))) _buildPopupMenuItem(title: getLang(key: "Room_kick",context: context),iconData: Icons.output_outlined,val: 4),
      ];},shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        )),onSelected: (value){

      if(value==0){
        Room.Chairids=Room.Currentroom?.chairs?[index].chairId;
        Room.ChairIndes=index;
        Room.useridchair=Room.Currentroom?.chairs?[index].user?.id ;
        user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[index].user?.id );
        user.getuserroominfo(user: Room.Currentroom?.chairs?[index].user);
        GlopalbottomSheet(context: context,Screan: const RoomUserProfile());
      }else if(value==1){
        gits. GiftList.clear();
        gits. giftprice=0;
        Room.ChairsRoom.clear();
        Room.UserIds.clear();
        Room.AddUserIds(id: Room.Currentroom?.chairs?[index].user?.id);

        Room.ChairsRoom.clear();

        Room.Currentroom?.chairs?.forEach((element) {
          if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
            Room.ChairsRoom.add(element);
          }
        });
        gits.Cost=0;
        showModalBottomSheet(barrierColor:Colors.transparent,  backgroundColor: Colors.black,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
          context: context,
          builder: (context) {
            return const NestedTabBar();
          },
        );
      }else if(value==2){
        if(Room.Currentroom?.chairs?[index].mute==0){
          Room.updatemute(context: context,state: 1,user_id: Room.Currentroom?.chairs?[index].user?.id);
        }else{
          Room.updatemute(context: context,state: 0,user_id: Room.Currentroom?.chairs?[index].user?.id);
        }
        Agora.mutebyuid(uid: Room.Currentroom?.chairs?[index].user?.id,context: context);
      } else if(value==3){
        Room.ChairIndes=index;
        Room.Chairids=Room.Currentroom?.chairs?[index].chairId;
        Room.useridchair=Room.Currentroom?.chairs?[index].user?.id ;
        Room.LeaveuserChair(context: context);
      } else if(value==4){
        Room.Evictionuser(Userid: Room.Currentroom?.chairs?[index].user?.id,context: context);
      }else if(value==5){
        if(Room.Currentroom?.supervisorsId?.contains(Room.Currentroom?.chairs?[index].user?.id.toString())??false){
          Room.RemovesupervisorsRoom(context: context,userid: Room.Currentroom?.chairs?[index].user?.id).toString();
        }else{
          Room.AddsupervisorsRoom(context: context,userid:  Room.Currentroom?.chairs?[index].user?.id.toString());
        }
      }
      },
      icon:   Stack(alignment: Alignment.center ,
        children: [
         if(Agora.speakerids.any((element) =>element['uid']==int.parse(Room.Currentroom?.chairs?[index].userId??'0') )&&Room.Currentroom?.chairs?[index].mute==0  )
            Positioned(top: 0,
            child: AvatarGlow(
              glowColor: Colors.tealAccent,
              glowRadiusFactor: 1.2,glowCount: 2,
              duration: Duration(milliseconds: 1000),
              repeat: true,
              animate: true,
              child:SizedBox(),
            ),
           ),
          Column(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserFrame(image: Room.Currentroom?.chairs?[index].userId.toString()==user.userinfo?.id.toString()?user.userinfo?.image:   Room.Currentroom?.chairs?[index].user?.image,Frame: Room.Currentroom?.chairs?[index].userId.toString()==user.userinfo?.id.toString()?user.userinfo?.frameimage:   Room.Currentroom?.chairs?[index].user?.frameimage ),
              SizedBox(width: 50,child: Center(child: Text(jsonDecode(jsonEncode(Room.Currentroom?.chairs?[index].user?.name??'')),style: Namestyle.copyWith(overflow: TextOverflow.ellipsis,fontSize: 9,height: 1,color: whitecolor)))),
              InkWell(onTap: () {
                GlopalbottomSheet(context: context,Screan: const UserCollectKarismas());
                Room.GetCollectKarisma(context: context,userid:Room.Currentroom?.chairs?[index].userId,chairid:Room.Currentroom?.chairs?[index].id  );
              },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(Helper().k_m_b_generator(Room.Currentroom?.chairs?[index].Karisma) ,style: style2.copyWith(fontSize:10,height: 1,color: whitecolor)),
                      const   SizedBox(width: 3,),
                      FaIcon(FontAwesomeIcons.heartCircleCheck,size:8,color: Colors.red),
                    ],
                  ),
                ),
              )
            ],
          ),

        ],

      ),
    );
  }
}
PopupMenuItem _buildPopupMenuItem({String ?title, IconData ?iconData,int ?val}) {
  return PopupMenuItem(value: val,height: 30,padding: EdgeInsets.all(0),
    child:  Row(
      children: [
        SizedBox(width: 5,),
        Icon(iconData, color: Colors.white,size:  14),
        SizedBox(width: 5,),
        Text(title??'',style: style5.copyWith(color: Colors.white,height: 1,fontSize: 13)),
      ],
    ),
  );
}
