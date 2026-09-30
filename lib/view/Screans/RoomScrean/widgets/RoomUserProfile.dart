import 'dart:convert';

import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatwithuserRoom.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/view/widgets/UserInfoWidgets.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SendGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ShowUserRoom.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
class RoomUserProfile extends StatelessWidget {
  const RoomUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    InboxroomViewModel    Inboxlsit= Provider.of<InboxroomViewModel>(context,listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);

    return Container(decoration: const BoxDecoration(image: DecorationImage(image: const ExactAssetImage(Images.shopback),fit: BoxFit.fill)),width: SizeConfig.screenWidth! ,child:
    Column(mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     mainAxisSize: MainAxisSize.min,
     children: [

       PhotoFrame2(image: user.userroominfo?.image ,Frame:user.userroominfo?. frameimage ),

       UserInfoWidgets(UserDate:user.userroominfo ),
       const SizedBox(height: 5,),
        user.showloading3?const SizedBox():  Padding(
         padding: const EdgeInsets.all(8.0),
         child: Row(
           children: [
             const SizedBox(width: 10,),
             Expanded(flex: 1,child: InkWell(
               onTap: () {
Navigator.pop(context);

               },
               child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.deepPurpleAccent,),height: 60,child: Row(
                 children: [
                   const SizedBox(width: 10,),
                   Image.asset(Images.CAS,height: 40),
                   const SizedBox(width: 5,),
                   Column(mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(getLang(context: context,key: "charisma"),style: style3.copyWith(fontSize: 10,color: Colors.white),overflow: TextOverflow.ellipsis),
                       Row(
                         children: [
                           Text(user.userroominfo?.ginput.toString()??'',style: style1.copyWith(fontSize: 13)),
                           const SizedBox(width: 10),
                         ],
                       ),
                     ],)
                 ],
               ),),
             )),
             const SizedBox(width: 10,),
             Expanded(flex: 1,child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.blueAccent.withOpacity(0.9),),height: 60,child: Row(
               children: [
                 const SizedBox(width: 10,),
                 Image.asset(Images.Cardheart,height: 40),
                 const SizedBox(width: 5,),
                 Column(mainAxisAlignment: MainAxisAlignment.center,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text(getLang(context: context,key: "fortune"),style: style1.copyWith(fontSize: 13),),
                       Row(
                           children: [
                             Text(user.userroominfo?.Karisma.toString()??'0',style: style1.copyWith(fontSize: 10)),
                             const SizedBox(width: 10,),
                           ]
                       )
                     ])],
             ),)),
             const SizedBox(width: 10,),
            ],
         ),
       ),
       const SizedBox(height: 10,),
       Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [

         if(user.userinfo?.id!=user.userroominfo?.id)      InkWell(  onTap: (){
           Navigator.pop(context);
           user.GetShoweduserProfile(user.userroominfo);
            CheckBlocked=false;

           Navigator.pushNamed(context,AppConstants.ShowUser_Profile);
         },child: const FaIcon( FontAwesomeIcons.user,size: 20 ,color: Colors.black54,)),
         if(user.userinfo?.id!=user.userroominfo?.id)     InkWell(  onTap: (){
           user.GetInBoxChat(context: context,userid: user.userroominfo?.id??'', user: user.userroominfo );
         }, child:  const FaIcon( FontAwesomeIcons.commenting,size: 20 ,color: Colors.black54,)),
         InkWell(  onTap: (){
           gits. GiftList.clear();
           gits. giftprice=0;
           Room.ChairsRoom.clear();
           Room.ChairsRoom.clear();
           Room.UserIds.clear();
           Room.AddUserIds(id: user.userroominfo?.id);
           Navigator.pop(context);
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


         },child: const FaIcon( FontAwesomeIcons.gift,size: 20 ,color: Colors.black54,)),
         if(user.userinfo?.id!=user.userroominfo?.id)   InkWell(onTap: (){

           if((user.userinfo?.followIds?.contains(user.userroominfo?.id.toString()??'')??true)){
             Follow.RemoveFollows3(context: context,userid:user.userroominfo?.id );
           }else{
             Follow.SentFollow(context: context,userid:user.userroominfo?.id );

           }
         },child: FaIcon( (user.userinfo?.followIds?.contains(user.userroominfo?.id.toString()??'')??true)?FontAwesomeIcons.remove:FontAwesomeIcons.add,size: 20 ,color: Colors.black54,)),
         if(user.userinfo?.id!=user.userroominfo?.id)     InkWell(  onTap: (){

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

           Room.GetMentionid(id:user.userroominfo?.id.toString(),name:user.userroominfo?.name );
           Navigator.pop(context);
           Room.showSpinner7();
           Room.Message.text='@ ${user.userroominfo?.name }';
           Dialogs().showtoast('Mention');

         },child: const FaIcon( FontAwesomeIcons.at,size: 20 ,color: Colors.black54,)),
       ],),
       const SizedBox(height: 25,),
       if(Room.Currentroom?.adminId!=user.userroominfo?.id)   if(Room.checkadmin(context: context) ||(( (Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString()) ??false))  &&!(Room.Currentroom?.supervisorsId?.contains(user.userroominfo?.id.toString())??false))) Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [

         if(Room.checkadmin(context: context)&&!(Room.Currentroom?.supervisorsId?.contains(user.userroominfo?.id.toString())??false))     InkWell(  onTap: (){
           Dialogs().showdialog(context: context, tittle: 'tittle', content:getLang(key: "Make_Supervisor",context: context), buttontext: getLang(context: context, key: "Yes"), onTap:() {
             Navigator.pop(context);
             Room.AddsupervisorsRoom(context: context,userid:  user.userroominfo?.id.toString());
           });

         },child: const FaIcon( FontAwesomeIcons.microblog,size: 20 ,color: Colors.black54,)),
         InkWell(  onTap: (){

           if(Room.Currentroom?.chairs?.where((element) => element.chairId==Room.Chairids).first.mute==1){
             Room.updatemute(context: context,state: 0,user_id: user.userroominfo?.id);
           }else{
             Room.updatemute(context: context,state: 1,user_id:user.userroominfo?.id);
           }
           Agora.mutebyuid(uid: user.userroominfo?.id,context: context);
         }, child:  FaIcon(Room.Currentroom?.chairs?.where((element) => element.chairId==Room.Chairids).first.mute==0?FontAwesomeIcons.microphoneLines: FontAwesomeIcons.microphoneLinesSlash,size: 30 ,color: Colors.black54,)),

         InkWell(onTap: (){
           Navigator.pop(context);
           Room.Evictionuser(Userid: user.userroominfo?.id,context: context);
         },child: const FaIcon(FontAwesomeIcons.signOutAlt, size: 20 ,color: Colors.black54,)),
         InkWell(  onTap: (){
           Navigator.pop(context);

           Room.LeaveuserChair(context: context);
         },child: const FaIcon( FontAwesomeIcons.chair,size: 20 ,color: Colors.black54,)),
       ],),
       const SizedBox(height: 25,),
     ],
      ),


    );
  }
}


class MyProfileInRoom extends StatelessWidget {
  const MyProfileInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);

    return Container(decoration: BoxDecoration(color: Colors.transparent,image: DecorationImage(image: ExactAssetImage(Images.shopback),fit: BoxFit.cover)), width: SizeConfig.screenWidth! ,child:
    Column(mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [


        PhotoFrame2(image: user.userroominfo?.image ,Frame:user.userroominfo?. frameimage ),

        UserInfoWidgets(UserDate: user.userroominfo),



        user.showloading3?SizedBox(height: 50,):Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(onTap:() {
            showModalBottomSheet(barrierColor:Colors.transparent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
              context: context,
              builder: (context) {
                return const ShowGiftRoom();
              },
            );
          },
            child: Container(decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(10)),height: 45,width: SizeConfig.screenWidth!,child: Row(
              children: [
                Image.asset(Images.CAS,height: 30),
                const Spacer(),
                Row(
                  children: [
                    if((user.userroominfo?.giftssent?.length??0)>0)  CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[0].gift?.image??Images.userphoto, height: 25,),
                    SizedBox(width: 5,),
                    if((user.userroominfo?.giftssent?.length??0)>1)    CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[1].gift?.image??Images.userphoto, height: 25,),
                    SizedBox(width: 5,),
                    if((user.userroominfo?.giftssent?.length??0)>2)CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[2].gift?.image??Images.userphoto, height: 25,),
                    SizedBox(width: 5,),
                    Icon(Icons.arrow_forward_ios,color:Colors.black38,size: 20,)
                  ],
                )
              ],
            )),
          ),
        ),

        SizedBox(height: 35,),

      ],
    ),


    );
  }
}

class RoomUserunchairProfile extends StatelessWidget {
  const RoomUserunchairProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    InboxroomViewModel    Inboxlsit= Provider.of<InboxroomViewModel>(context,listen: true);
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);

    return Container(decoration: BoxDecoration(color: Colors.transparent,image: DecorationImage(image: ExactAssetImage(Images.shopback),fit: BoxFit.cover)), width: SizeConfig.screenWidth! ,child:
    Column(mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PhotoFrame2(image: user.userroominfo?.image ,Frame:user.userroominfo?. frameimage ),
        const   SizedBox(height: 5),
        UserInfoWidgets(UserDate: user.userroominfo),

        SizedBox(height: 25,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
          InkWell(  onTap: (){
            user.GetShoweduserProfile(user.userroominfo);
            CheckBlocked=false;
            Navigator.pushNamed(context,'${AppConstants.ShowUser_Profile}');
          },child: FaIcon( FontAwesomeIcons.user,size: 20 ,color: Colors.black54,)),
          InkWell(  onTap: (){

            Inboxlsit.Inboxrooms.forEach((element) {
              if((element.userId.toString()==user.userinfo?.id.toString()&&element.senderId.toString()==user.userroominfo?.id.toString())||(element.userId.toString()==user.userroominfo?.id.toString()&&element.senderId.toString()==user.userinfo?.id.toString())){
                Inboxlsit.changdefaultindex(value:element.id );
                print('Found Found');
              }else{
                Inboxlsit.changdefaultindex(value:0 );
                print('NotFound');
              }
            });
            Navigator.pop(context);
            Room. showSpinner28();
          }, child:  FaIcon( FontAwesomeIcons.commenting,size: 20 ,color: Colors.black54,)),
          InkWell(  onTap: (){
            gits.GiftList.clear();
            gits. giftprice=0;
            Room.ChairsRoom.clear();
            Room.ChairsRoom.clear();
            Room.UserIds.clear();
            Room.AddUserIds(id: user.userroominfo?.id);
            Navigator.pop(context);
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

          },child: FaIcon( FontAwesomeIcons.gift,size: 20 ,color: Colors.black54,)),
          InkWell(onTap: (){

            if((user.userinfo?.followIds?.contains(user.userroominfo?.id.toString()??'')??true)){
              Follow.RemoveFollows3(context: context,userid:user.userroominfo?.id );
            }else{
              Follow.SentFollow(context: context,userid:user.userroominfo?.id );

            }
          },child: FaIcon( (user.userinfo?.followIds?.contains(user.userroominfo?.id.toString()??'')??true)?FontAwesomeIcons.remove:FontAwesomeIcons.add,size: 30 ,color: Colors.black54,)),
          InkWell(  onTap: (){

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

            Room.GetMentionid(id:user.userroominfo?.id.toString(),name:user.userroominfo?.name );
            Navigator.pop(context);
            Room.showSpinner7();
            Room.Message.text='@ ${user.userroominfo?.name }';
            Dialogs().showtoast('Mention');

          },child: FaIcon( FontAwesomeIcons.at,size: 20 ,color: Colors.black54,)),
          if((Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))&&!(Room.Currentroom?.supervisorsId?.contains(user.userroominfo?.id.toString())??false))
            if(user.userroominfo?.id!=Room.Currentroom?.adminId)InkWell(onTap: (){
            Navigator.pop(context);
            Room.Evictionuser(Userid:user.userroominfo?.id,context: context);
            },child: const FaIcon(FontAwesomeIcons.signOutAlt, size: 20 ,color: Colors.black54)),
        ],),
        const   SizedBox(height: 25),
      ],
    ),


    );
  }
}