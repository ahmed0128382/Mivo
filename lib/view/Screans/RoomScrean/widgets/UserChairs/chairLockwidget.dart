import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InviteToChairScrean/InviteToChairScrean.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class ChairLockwidget extends StatelessWidget {

  final int index;
  const ChairLockwidget({ required this.index});
  @override
  Widget build(BuildContext context) {
    LoginViewmodel        user = Provider.of<LoginViewmodel>(context, listen: true);

    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return  Column(mainAxisSize: MainAxisSize.min,
      children: [
        if(Room.checkadmin(context: context))

         PopupMenuButton( color: Colors.black , padding: EdgeInsets.all(0.0), shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            )),onSelected: (value) {
          if(value==0){
if(Room.Currentroom?.chairs?[index].Lock==0){
  Room.LockChairUpdate(state: 1, info: Room.Currentroom?.chairs?[index]);
}else{
  Room.LockChairUpdate(state: 0, info: Room.Currentroom?.chairs?[index]);
}
          }else if(value==1){
            Room.InvitedChair.clear();
            Room.Currentroom?.chairs?.forEach((element) {
              if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
                Room.InvitedChair.add(element.user?.id.toString()??'');
              }
            });
            InviteChairId=Room.Currentroom?.chairs?[index].chairId??'';
            GlopalbottomSheet(context: context,Screan: InviteToChair());
            Room.GetUserJoin(context: context);
          }  },
        itemBuilder: (BuildContext bc) {
          return   [
          if(Room.checkadmin(context: context))  _buildPopupMenuItem(title: Room.Currentroom?.chairs?[index].Lock!=0?getLang(context: context,key: "UnLock"):getLang(context: context,key: "Lock"),iconData: Icons.lock_outline,val: 0),
          if(Room.checkadmin(context: context) &&Room.Currentroom?.chairs?[index].Lock==0)  _buildPopupMenuItem(title:getLang(context: context,key: "Invite_user"),iconData: Icons.add,val: 1),

          ];},icon: Image.asset(Room.Currentroom?.chairs?[index].Lock!=0? Images.LockChairs:Images.Chairs ,height: 80,width: 80 ) )else PopupMenuButton( color: Colors.black , padding: EdgeInsets.all(0.0), shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.all(
             Radius.circular(10.0),
           )),onSelected: (value) {
         if(value==0){
           if(Room.Currentroom?.chairs?[index].Lock==0){
             Room.LockChairUpdate(state: 1, info: Room.Currentroom?.chairs?[index]);
           }else{
             Room.LockChairUpdate(state: 0, info: Room.Currentroom?.chairs?[index]);
           }
         }else if(value==1){
           if(Room.JoinChairLoding){
             Dialogs().showtoast(getLang(context: context,key: "wait"));
           }else{
             if(Room.Currentroom?.chairs?[index].Lock==1){
               Dialogs().showtoast(getLang(context: context,key: "Chair_lock"));
             }

             else{

               if( !JoinChairs&&Room.Currentroom?.chairs?[index].userId==null){

                 Room.JoinChair(index: index,context: context,chairid:Room.Currentroom?.chairs?[index].chairId );
               }
               else{

                 if(Room.Currentroom?.chairs?[index].userId==null&&JoinChairs){
                   if(Room.showloading47){
                     Dialogs().showtoast(getLang(context: context,key: "wait"));

                   }else{
                     Room.ChangeChair(context: context,Index: index ,Newchairid: Room.Currentroom?.chairs?[index].chairId );
                   }
                 }
               }
             }
           }
         }else if(value==2){
           Room.InvitedChair.clear();
           Room.Currentroom?.chairs?.forEach((element) {
             if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
               Room.InvitedChair.add(element.user?.id.toString()??'');
             }
           });
           InviteChairId=Room.Currentroom?.chairs?[index].chairId??'';
           GlopalbottomSheet(context: context,Screan: InviteToChair());
           Room.GetUserJoin(context: context);
         }  },
           itemBuilder: (BuildContext bc) {
             return   [
             if(Room.Currentroom?.chairs?[index].Lock==0)    _buildPopupMenuItem(title:getLang(context: context,key: "set_chair"),iconData: Icons.chair_outlined,val: 1),
               if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))  _buildPopupMenuItem(title: Room.Currentroom?.chairs?[index].Lock!=0?getLang(context: context,key: "UnLock"):getLang(context: context,key: "Lock"),iconData: Icons.lock_outline,val: 0),
               if((Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false) &&Room.Currentroom?.chairs?[index].Lock==0)  _buildPopupMenuItem(title:getLang(context: context,key: "Invite_user"),iconData: Icons.add,val: 2),

             ];},icon: Image.asset(Room.Currentroom?.chairs?[index].Lock!=0? Images.LockChairs:Images.Chairs ,height: 50,width: 50 ) ),
      ],
    );
  }
}
class Circle extends StatelessWidget {
  final String?ChairId;
  const Circle({  required this.ChairId}) ;

  @override
  Widget build(BuildContext context) {
    return   CircleAvatar(backgroundColor: Colors.transparent,radius: 9,child: Text(ChairId.toString() ,style: style1.copyWith(fontSize: 10)));

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