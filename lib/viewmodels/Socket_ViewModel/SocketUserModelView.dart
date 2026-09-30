import 'dart:convert';
import 'dart:developer';

import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/main.dart';
import '../../util/Dialogs.dart';
class SocketuserViewmodel extends ChangeNotifier{
  PusherClient? pusher2;
  Channel? channel2;
  Future ConnectuserScocket(roomcontext)async {

    pusher2 =   PusherClient(
      "123456789",
      PusherOptions(
        wssPort:6001,
        wsPort:6001,
        host:'worldchat.online',
        encrypted: false,
      ),
      enableLogging: true,
    );
    pusher2?.connect();
    pusher2?.onConnectionStateChange((state) {
      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");});
    pusher2?.onConnectionError((error) {
      log("error: ${error?.message}");
    });

    channel2 = pusher2?.subscribe('user$UserId');
    channel2?.bind('user', (e) {
      degisenMenu(data: jsonDecode(e?.data??''),state: jsonDecode(e?.data??'')['state'],roomcontext: roomcontext,);

     });
    pusher2?.onConnectionStateChange((state) {

      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher2?.onConnectionError((error) {

      log("error: ${error?.message}");
    });

    notifyListeners();
  }



  Future DisConnect({required id})async{
    pusher2?.unsubscribe('user$id');
    notifyListeners();
  }

  degisenMenu({data,state, roomcontext,index}) async{
    LoginViewmodel user=  Provider.of<LoginViewmodel>(roomcontext,listen: false);
    InboxroomViewModel Inboxroom=  Provider.of<InboxroomViewModel>(roomcontext,listen: false);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(roomcontext,listen: false);
    switch (state) {
      case 0:


       user.UpdateFrame(frames:data['data']['frame'] );
        break;
      case 1:
        user.UpdateEntry(Entry: data['data']['entry'] );
        break;
      case 2:
        user.removeFrame();
        break;
      case 3:
        user.removeEntry();
        break;
      case 4:

        InboxRoomModel Inbox=InboxRoomModel.fromJson(data['data']['InboxRoom']);


          Inboxroom.AddnewInboxRoom(value: Inbox);
        break;
      case 5:
       Message messages=Message.fromJson(data['data']['Messages']);

var Inbox= Inboxroom.Inboxrooms.where((element) => element.id==messages.inboxroomId);
        if(Inboxroom.inroomid==messages.inboxroomId){

if(Inbox.isNotEmpty){
  Inboxroom.Inboxrooms.where((element) => element.id==messages.inboxroomId).first.numberUnread=0 ;
}

          Inboxroom.AlreadyinInboxRoom();
        }else{
          if(Inbox.isNotEmpty){
            Inboxroom.Inboxrooms.where((element) => element.id==messages.inboxroomId).first.numberUnread=Inboxroom.Inboxrooms.where((element) => element.id==messages.inboxroomId).first.numberUnread!+1;

          }
        }
       if(Inbox.isNotEmpty){
         Inboxroom.Inboxrooms.where((element) => element.id==messages.inboxroomId).first.updatedAt=messages.createdAt ;
       }


if(messages.senderId.toString()!=user.userinfo?.id.toString()){
  LocalNotificationService().showNotification(body: messages.message??"",id: 1, title:'رساله جديده',  );

  Inboxroom.AddMessageInbox(value: messages,id:messages.inboxroomId,context: roomcontext );
}

        if(messages.userId.toString()==user.userinfo?.id.toString()){
        //  Dialogs().ShowMessage(name: 'رساله جديده',message:messages.message);
          LocalNotificationService().showNotification(body: messages.message??"",id: 1, title:'رساله جديده',  );
          user.changeNewmessage(true);

         Helper().PlayMusic(path: AppConstants.Chatnotifi);
        }
        break;
      case 6:

        user.AddCoinspluse(value:int.parse(data['data']['coins'].toString()));
        break;
      case 7:
        LocalNotificationService().showNotification(body:'${data['data']['Room']['name']}قام بدعوتك الي غرفه ',id: 3, title:data['data']['user']['name'],  );

        Rooms.InviteToRoom(Roominfo:  data['data']['Room'], user:  data['data']['user'],context:roomcontext );

        break;
      case 8:
        Rooms.InviteToChair(Roominfo:  data['data']['Room'], user:  data['data']['user'],Chair_id:data['data']['chair_id'] ,context:roomcontext );


        break;
      case 9:

        user.Changecoins(value:int.parse(data['data']['coins'].toString()));
        break;
      case 10:

        user.MinusCoinspluse(value:int.parse(data['data']['coins'].toString()));

         break;
      case 11:
        Dialogs().showtoast('    لقد ربحت  ${data['data']['coins'].toString()} ماسه   ');
        user.AddCoinspluse(value:int.parse(data['data']['coins'].toString()));

        break;
      case 12:
        user.removeEnterbubles();
        break;
      case 13:
        user.UpdateEnterbubles(frames:data['data']['frame'] );
        break;
      case 14:

        var user=usermodel.fromJson(data['data']['sender']);
        LocalNotificationService().showNotification(body:'  قام ${user.name} بمتابعتك  ',id: 5, title:'رساله جديده',  );
        showDialog(context: NavigationService.navigatorKey.currentContext!,builder: (context) {
          return AlertDialog(backgroundColor:  Color(0xFF2b2f3b),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
            child:Text('  قام ${user.name} بمتابعتك  ',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),textDirection: TextDirection.rtl  ),
          ),actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                InkWell(onTap:(){
                  Provider.of<FollowViewModel>(context,listen: false).ReturnFollow(context: NavigationService.navigatorKey.currentContext!,Senderid:user.id);

                  Navigator.pop(context);
                },child: Container(child: Center(child:  Text('رد المتابعه',style: style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be)))),

                InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style:  style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(color: Color(0xFFeae2be),borderRadius: BorderRadius.circular(20), ))),

               ],),
            )
          ],);
        },);

        break;
      case 15:
        user.removeProfilebubles();
        break;
      case 16:
        user.UpdateProfilebubles(frames:data['data']['frame'] );
        break;
      case 17:
        LocalNotificationService().showNotification(body:'تم حظر هذا الحساب',id: 2, title:'رساله جديده',  );
        Dialogs().showtoast('تم حظر هذا الحساب');
        SystemNavigator.pop();
        break;
        case 18:
          LocalNotificationService().showNotification(body:data['data']['message'],id: 8, title:'رساله جديده',  );

      break;
      default:

    }
  }


}