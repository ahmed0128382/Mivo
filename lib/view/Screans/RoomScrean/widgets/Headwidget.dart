import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/AllBlockedUser.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MusicPlayer.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MuteMice.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Supervisor/Supervisor.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/app_constants.dart';

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/AllusersInRoom.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomKarismas/RoomKarismas.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';

import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'EditRoom.dart';
import 'LeaveRoom/LeaveRoomWidget.dart';
class Headwidget extends StatelessWidget {
  const Headwidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
     FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
     return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 3),
       child: Column( crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Row(
             children: [
               Container(decoration: BoxDecoration(color: whitecolor4,borderRadius: BorderRadius.circular(50), ),
                 child: Row(
                   children: [
                     Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(10),image: DecorationImage(image: CachedNetworkImageProvider (Room.Currentroom?.image??Images.profilephoto),fit: BoxFit.cover )),height: 40,width: 40),
                     SizedBox(width : 5,),
                     Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min,
                       children: [
                         Text(Helper().CutName3(name:  Room.Currentroom?.name??''),style:style3.copyWith(color: whitecolor,fontSize: 11,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis) ),
                         Text('ID : ${Room.Currentroom?.RoomID ?? ''}',style:style3.copyWith(color: whitecolor,fontSize: 11,height: 1,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis) ),
                       ],
                     ),
                     SizedBox(width : 10,),
                   ],
                 ),
               ),
               Spacer(),
               Row(
                 children: [

                   PopupMenuButton(color: Colors.black , padding: EdgeInsets.all(0.0), shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
    Radius.circular(20.0),
    )),icon:Image.asset(Images.editroom,width: 25,height: 25,color: whitecolor2,),
                       onSelected: (value) {
                     if(value==0){
                       Room.AddtoEdit();
                       GlopalbottomSheet(isscrollable: true,context: context,Screan: EditRoom());
                     }else if(value==1){
                       Room.GetRoomSupervisor();
                       GlopalbottomSheet2(context: context,Screan: SupervisorsTabBar());

                     } else if(value==3){
                       showModalBottomSheet(barrierColor:Colors.transparent,  backgroundColor: Colors.black,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                         context: context,
                         builder: (context) {
                           return const MusicPlayerRoom();
                         },
                       );
                     }else if(value==4){
                       Room.GetKickeduser(context:context );
                       GlopalbottomSheet(context: context,Screan: AllBlockeduserInRoom());

                     }else if(value==5){
                       Dialogs().showdialog(context: context, tittle: 'sad', content:getLang(context: context,key: "Delete_chat_room"), buttontext: getLang(context: context, key: "Yes"), onTap: (){
                         Navigator.pop(context);
                         Room.deletechat(context: context );
                       });
                     }else if(value==6){
                       if( Room.Currentroom?.password!=null){
                         Room.RemoveRoomPassword(context: context);

                       }else{
                         TextEditingController   EnterPasswordRoom=TextEditingController();
                         showDialog(barrierDismissible: true,
                             context: context,
                             builder: (_) => AlertDialog(
                               actions: [

                                 Center(child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                     children: [
                                       Text(getLang(context: context, key: "Enter_Password"),style: style1),
                                       SizedBox(height: 25,),
                                       PinCodeTextField(keyboardType: TextInputType.number,
                                         length: 4,
                                         obscureText: false,textStyle: TextStyle(color:  Color(0xFFeae2be)),
                                         animationType: AnimationType.fade,
                                         pinTheme: PinTheme(borderWidth: 0.0,
                                           shape: PinCodeFieldShape.box,
                                           fieldOuterPadding:EdgeInsets.symmetric(horizontal: 3),
                                           activeColor: Color(0xFFeae2be),borderRadius: BorderRadius.circular(10),
                                           selectedColor: Color(0xFFeae2be),
                                           inactiveColor: Color(0xFFeae2be),
                                           fieldHeight: 40,
                                           fieldWidth: 40,
                                           activeFillColor: Color(0xFFeae2be),
                                         ),
                                         animationDuration: Duration(milliseconds: 300),
                                         cursorColor: Color(0xFFeae2be),
                                         enablePinAutofill: true,
                                         enableActiveFill: false,mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         enabled:true,
                                         controller: EnterPasswordRoom,
                                         onCompleted: (v) {  },
                                         onChanged: (value) {

                                         },
                                         beforeTextPaste: (text) {
                                           return true;
                                         }, appContext: context,
                                       ),
                                       InkWell(onTap: (){
                                         if(EnterPasswordRoom.text.length<4){

                                         }else{

                                           Room. SetRoomPassword(context: context,PasswordRoom: EnterPasswordRoom);


                                         }
                                       },child: Container(child: Center(child:  Text( getLang(context: context, key: "Done"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be)))),
                                     ],
                                   ),
                                 )),
                               ],
                               backgroundColor: Color(0xFF2b2f3b),

                             )
                         );
                       }
                     }

                       },
                       itemBuilder: (BuildContext bc) {
                         return   [
                           if(Room.checkadmin(context: context))    _buildPopupMenuItem(title:getLang(context: context, key: "Edit") ,iconData: Icons.edit,val: 0),
                           if(Room.checkadmin(context: context)) _buildPopupMenuItem(title: getLang(context: context, key: "Admins"),iconData: Icons.person,val: 1),
                           if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))  _buildPopupMenuItem(title: getLang(context: context, key: "Play_Music"),iconData: Icons.music_note,val:3),
                           if(Room.checkadmin(context: context))    _buildPopupMenuItem(title:getLang(context: context, key: "Banned_User"),iconData: Icons.person,val:4),
                           if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))   _buildPopupMenuItem(title:getLang(context: context, key: "delete_chat"),iconData: Icons.chat_outlined,val:5),
                           if(Room.checkadmin(context: context))  _buildPopupMenuItem(title: Room.Currentroom?.password!=null?getLang(context: context, key: "Remove_Password"):getLang(context: context, key: "Set_Password"),iconData: Icons.lock_outline,val:6)
                         ];}),


                   InkWell(onTap:(){
                     Follow.GetFriends(context: context);
                     Navigator.pushNamed(context, AppConstants.ShareRoom_Screan);
                   },child: Image.asset(Images.Kickout,width: 28,height: 28,color: whitecolor2,)),
              SizedBox(width: 15,),
                   InkWell(onTap:(){
                     GlopalbottomSheet(isscrollable: true,context: context,Screan: LeaveRoomWidget());

                   },child: Image.asset(Images.LeaveRoom,width: 25,height: 25,color: whitecolor2,)),

                 ],
               )
             ],
           ),

           Row(crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 child: InkWell(onTap: (){
                  print(Room.Currentroom?.supervisorsId);

                  GlopalbottomSheet(context: context,Screan: RoomKarismas());
                  Room.GetRoomKarisma(context: context);
                 },
                   child :Container(decoration: BoxDecoration(color: whitecolor4,borderRadius: BorderRadius.circular(10), ),

                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                       child: Row(mainAxisSize: MainAxisSize.min,
                         children: [
                           Image.asset(Images.LeaderShip,width: 15,height: 15,),
                           const SizedBox(width: 3),
                           Text( Helper().k_m_b_generator(Room.Currentroom?.Karisma??0),style: style1.copyWith(color: whitecolor,fontSize: 10,height: 1),),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
               Spacer(),
               InkWell(onTap: (){
                 GlopalbottomSheet(context: context,Screan: AlluserInRoom());
                 Room.GetUserJoin(context: context);
               },
                 child :Container(decoration: BoxDecoration(color: whitecolor4,borderRadius: BorderRadius.circular(10), ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                     child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(Icons.person,color:Colors.white ,size: 13),
                         Text(Room.Currentroom?.joinRooms?.length.toString()??'',style: style1.copyWith(color: whitecolor,fontSize: 10),),
                       ],
                     ),
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
  return PopupMenuItem(padding: EdgeInsets.all(0),value: val,height: 30,
    child:  Row(mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 5,),
        Icon(iconData,color: Colors.white,size: 13),
        SizedBox(width: 5,),
        Text(title??'',style: style5.copyWith(color: Colors.white,height: 1,fontSize: 13)),
      ],
    ),
  );
}