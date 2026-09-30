

import 'dart:convert';
import 'dart:developer';

import 'package:ahlachat/models/guessGameModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:pusher_client/pusher_client.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/GiveGifts.dart';

import '../../util/helperclass.dart';
//ezgif.com_gif_maker_4_.json
var roomcontext;
class SocketViewmodel extends ChangeNotifier{
  PusherClient? pusher;
  Channel? channel;
  Future ConnectRoomScocket( context,id)async {

    pusher =   PusherClient(
      "123456789",
      PusherOptions(
        wssPort:6001,
        wsPort:6001,
        host:'worldchat.online',
        encrypted: false,
      ),
      enableLogging: true,
    );
    pusher?.connect();

    pusher?.onConnectionStateChange((state) {

      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher?.onConnectionError((error) {
      log("error: ${error?.message}");
    });

    channel = pusher?.subscribe('Room$id');
    channel?.bind('Room', (e) {

      degisenMenu(data: jsonDecode(e?.data??''),state: jsonDecode(e?.data??'')['state']   );
    });
    pusher?.onConnectionStateChange((state) {

      log("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher?.onConnectionError((error) {

      log("error: ${error?.message}");
    });

    notifyListeners();
  }



  Future DisConnect({required id})async{
    pusher?.unsubscribe('Room$id');
    notifyListeners();
  }
  degisenMenu({data,state, index}) async{

     AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(roomcontext,listen: false);
     LoginViewmodel user=  Provider.of<LoginViewmodel>(roomcontext,listen: false);
      switch (state) {
      case 0:
      var  userinfo = usermodel.fromJson(data['data']);
      if(userinfo.Hidden==0){
        Provider.of<RoomViewmodel>(roomcontext,listen: false).ShowEnterWidget(Info: userinfo);
        if(userinfo.entry!=null&&userinfo.entry!=''){
          Provider.of<SvgViewmodel>(roomcontext,listen: false).getcontroller(enterImage: userinfo.image,entername: userinfo.name,svga: userinfo.entry??'');
          if(userinfo.id.toString()!=user.userinfo?.id.toString()&&userinfo.Hidden!=1){
            if(userinfo.entry==null||userinfo.entry==''){
              EnterImage=userinfo.image;
              Entername=userinfo.name;
            }

            Provider.of<GiftsViewModel>(roomcontext,listen: false).sidepanner();
          }
        }
        Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 3,user:userinfo,content: '${userinfo.name} Enter Room' ));
        Provider.of<RoomViewmodel>(roomcontext,listen: false).AddusertoRoom(JoinRoom:joinRoom(user: userinfo,id: 45,index: 1,roomId: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id,userId: userinfo.id,updatedAt: '',createdAt: '' ),join:userinfo,ctx: roomcontext,index: index );



      }




      if(userinfo.id.toString()==  Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.adminId.toString()){
        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.chairs?[8].user=userinfo;
        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.chairs?[8].userId=userinfo.id.toString();
        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.chairs?[8].Karisma=0;
                 Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.chairs?[8].mute=0;
        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.chairs?[8].adminleaved=0;
      }
      break;
      case 1:
        var  Chair = Chairs.fromJson(data['data']);
        Provider.of<RoomViewmodel>(roomcontext,listen: false).AddusertoChair(ctx:roomcontext, data:Chair );
        break;
      case 2:
        var  userinfo = usermodel.fromJson(data['data']);
        Provider.of<AgoraViewmodel>(roomcontext,listen: false).unmuteusermic(int.parse(userinfo.id.toString()));
        if(userinfo.Hidden==0){
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 3,user:userinfo,content: '${userinfo.name} Leaved Room' ));

        }
        Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveuserfromRoom(id:userinfo.id.toString());
        break;
      case 3:
        Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveuserfromChair(id:data['data'].toString());
        break;
      case 4:
        var  CHATROOM = Chatroom.fromJson(data['data']);
        Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: CHATROOM);
        break;
      case 5:

        var  Give = givegifts.fromJson(data['data']['gift']);

          var user=usermodel.fromJson(data['data']['user']);
        Give.ListUser.forEach((elements) {
         List ?SSS= Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.joinRooms?.where((element) => element.userId.toString()==elements.toString()).toList();
        if(SSS?.length!=0 ){
          usermodel ? userinfo=SSS?.first.user;
          Provider.of<RoomViewmodel>(roomcontext,listen: false).Addmessagetocurrentroom(message: Chatroom(kind:2 ,user: user,id: 0,content:'xxxxxxxxxx',userId:user.id.toString(),updatedAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.updatedAt,roomId:  Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString(),createdAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.createdAt,Gift:Give,RecevedUser: userinfo ));
        }else{
          Provider.of<RoomViewmodel>(roomcontext,listen: false).Addmessagetocurrentroom(message: Chatroom(kind:2 ,user: user,id: 0,content:'xxxxxxxxxx',userId:user.id.toString(),updatedAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.updatedAt,roomId: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString(),createdAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.createdAt,Gift:Give,RecevedUser:Provider.of<LoginViewmodel>(roomcontext,listen: false).userinfo  ));
        }
         });
        Provider.of<RoomViewmodel>(roomcontext,listen: false). updatekaresma( context:roomcontext,Amount: Give.ListUser.length*Give.price!* int.parse(Give.quantity??"0") );
       if(data['data']['kind']==1||data['data']['kind']=='1'){
         Provider.of<RoomViewmodel>(roomcontext,listen: false).AddKaresmaChair(userids: Give.ListUser,Amount: ((int.parse(Give.quantity??'0')*(Give.price??0))/10).round() ) ;
       }else{
         Provider.of<RoomViewmodel>(roomcontext,listen: false).AddKaresmaChair(userids: Give.ListUser,Amount:int.parse(Give.quantity??'0')*(Give.price??0) );

       }
        Provider.of<SvgViewmodel>(roomcontext,listen: false).getcontroller2(svga:Give.svga,Give: Give,context: roomcontext,userinfo:   user);

        break;
      case 6:

        var users=usermodel.fromJson(data['data']);
        Provider.of<AgoraViewmodel>(roomcontext,listen: false).muteusermic(int.parse(users.id.toString()));
        if(users.id.toString()==user.userinfo?.id.toString()){
          Provider.of<SocketViewmodel>(roomcontext,listen: false).DisConnect(id: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString());
          Provider.of<SvgViewmodel>(roomcontext,listen: false).dispose();
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeHasRoomstate(false);
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeIsRoomstate( false);
          JoinChairs=false;
          Agora.EndAgora();
          if(Provider.of<RoomPlayViewModel>(roomcontext, listen: false).IsRoom==true){
            Navigator.pop(roomcontext);
          }
          Future.delayed(Duration(seconds: 1),() {
            Provider.of<RoomViewmodel>(roomcontext,listen: false).ClearCurrentroom();
          },);
        }
      //  Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveChatofuser(userid:users.id );
        Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveuserfromRoom(id:users.id.toString());
        Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 3,user:users,content: '${users.name} Leaved Room' ));

        break;
      case 7:

        var  Rooms = RoomModel.fromJson(data['data']['room']);

        if(Rooms.adminId.toString()!=user.userinfo?.id.toString()){
          Provider.of<SocketViewmodel>(roomcontext,listen: false).DisConnect(id: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString());
          Provider.of<SvgViewmodel>(roomcontext,listen: false).dispose();
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeHasRoomstate(false);
          JoinChairs=false;
          Agora.EndAgora();
          if( Provider.of<RoomPlayViewModel>(roomcontext, listen: false).IsRoom==true){
            Navigator.pop(roomcontext);
          }
          Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveRoomFromlist(RoomId: Rooms.id);
         Dialogs().showtoast('Room Disbanded');
        }
        if(Rooms.adminId.toString()==user.userinfo?.id.toString()&&data['data']['admin']!=null){
          Dialogs().showtoast('Room Disbanded By Admin !');
          Provider.of<SocketViewmodel>(roomcontext,listen: false).DisConnect(id: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString());
          Provider.of<SvgViewmodel>(roomcontext,listen: false).dispose();
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeIsRoomstate( false);
          JoinChairs=false;
          Agora.EndAgora();
          if( Provider.of<RoomPlayViewModel>(roomcontext, listen: false).IsRoom==true){
            Navigator.pop(roomcontext);
          }
          Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveRoomFromlist(RoomId: Rooms.id);
        Provider.of<LoginViewmodel>(roomcontext, listen: false).userinfo?.currentroom=null;
        }
        break;
      case 8:

        if(data['data']['userid']==UserId&&data['data']['state']=='0'){
          Agora.UnMute();

        }else if(data['data']['userid']==UserId&&data['data']['state']=='1'){
          Agora.Mute();
        }
        Provider.of<RoomViewmodel>(roomcontext,listen: false).Changemicestateadmin(userId:data['data']['userid']  ,state: int.parse(data['data']['state']));

        break;
      case 9:

        if(Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.adminId.toString()==UserId.toString()){

        }else{
          Provider.of<RoomViewmodel>(roomcontext,listen: false). LockChair(state:int.parse(data['data']['state']),chairId: int.parse(data['data']['chair']['chair_id'])-1);

        }

        break;
      case 10:

        if(data['data'].toString()==user.userinfo?.id.toString()){
          Provider.of<RoomViewmodel>(roomcontext,listen: false).DisposeController();
          Provider.of<SocketViewmodel>(roomcontext,listen: false).DisConnect(id:  Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString());
          Provider.of<SvgViewmodel>(roomcontext,listen: false).dispose();
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeHasRoomstate(false);
          Provider.of<RoomPlayViewModel>(roomcontext, listen: false).changeIsRoomstate( false);
          JoinChairs=false;
          Agora.EndAgora();
          if( Provider.of<RoomPlayViewModel>(roomcontext, listen: false).IsRoom==true){
            Navigator.pop(roomcontext);
          }
          Provider.of<RoomViewmodel>(roomcontext,listen: false).removecurrentroom();
        }
        Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveuserfromRoom(id:data['data'].toString());
         break;
      case 11:
        var  Rooms = RoomModel.fromJson(data['data']);

      Provider.of<RoomViewmodel>(roomcontext,listen: false).updateCurrentRoom(NewRoom: Rooms);
        break;
      case 12:
         Provider.of<RoomViewmodel>(roomcontext,listen: false).updateCurrentRoomPassword(Id: data['data']['room_id'],Password:data['data']['password']  );
        break;
      case 13:
        Provider.of<RoomViewmodel>(roomcontext,listen: false).deleteroomchat();
        break;
        case 14:
          Provider.of<RoomViewmodel>(roomcontext,listen: false).Addsupervisors(id: data['data']);
          break;
        case 15:
          Provider.of<RoomViewmodel>(roomcontext,listen: false).Removesupervisors(id: data['data']);
          break;
        case 16:

          Provider.of<RoomViewmodel>(roomcontext,listen: false).RemoveuserfromRoom(id:data['data'].toString());
          break;
        case 17:
          Provider.of<LoginViewmodel>(roomcontext,listen: false).adduserimoge(id: int.parse(data['data']['user']),imoges:data['data']['emoji'] );
         break;
        case 18:
          Provider.of<RoomViewmodel>(roomcontext,listen: false).UpdateThronechair(value: int.parse(data['data'] ));
          break;
        case 19:
          usermodel user=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).ChangeRoomChair(user: user, newChair:data['data']['chair_id']);
          break;
        case 20:
          usermodel user=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).returntoAdminRoomChair(user: user, newChair:data['data']['chair_id']);
          break;
        case 21:
          usermodel user=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 5,user:user,content: AppConstants.Image_URL+data['data']['dice'] ));
          break;
        case 22:
          usermodel user=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 6,user:user,content:  data['data']['name'] ));
          break;
        case 23:
          usermodel users=usermodel.fromJson(data['data']['user']);
          usermodel Reciveduser=usermodel.fromJson(data['data']['reciveruser']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 7,user:users,content:  data['data']['content'],RecevedUser: Reciveduser ));
          break;
        case 24:
 
          usermodel users=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 8,user:users,content:  AppConstants.Image_URL+ data['data']['content'], ));
          break;
        case 25:

          var  Give = givegifts.fromJson(data['data']['gift']);
          var user=usermodel.fromJson(data['data']['user']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false). addCombo(count:Give.quantity ,id:user.id,image:user.image??'',image2: Give.image );

          Give.ListUser.forEach((elements) {
            List ?SSS= Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.joinRooms?.where((element) => element.userId.toString()==elements.toString()).toList();
            if(SSS?.length!=0 ){
              usermodel ? userinfo=SSS?.first.user;
              Provider.of<RoomViewmodel>(roomcontext,listen: false).Addmessagetocurrentroom(message: Chatroom(kind:2 ,user: user,id: 0,content:'xxxxxxxxxx',userId:user.id.toString(),updatedAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.updatedAt,roomId:  Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString(),createdAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.createdAt,Gift:Give,RecevedUser: userinfo ));
            }else{
              Provider.of<RoomViewmodel>(roomcontext,listen: false).Addmessagetocurrentroom(message: Chatroom(kind:2 ,user: user,id: 0,content:'xxxxxxxxxx',userId:user.id.toString(),updatedAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.updatedAt,roomId: Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.id.toString(),createdAt:        Provider.of<RoomViewmodel>(roomcontext,listen: false).Currentroom?.createdAt,Gift:Give,RecevedUser:Provider.of<LoginViewmodel>(roomcontext,listen: false).userinfo  ));
            }
          });
          Provider.of<RoomViewmodel>(roomcontext,listen: false). updatekaresma( context:roomcontext,Amount: Give.ListUser.length*Give.price!* int.parse(Give.quantity??"0") );
          if(data['data']['kind']==1||data['data']['kind']=='1'){
            Provider.of<RoomViewmodel>(roomcontext,listen: false).AddKaresmaChair(userids: Give.ListUser,Amount: ((int.parse(Give.quantity??'0')*(Give.price??0))/10).round() ) ;
          }else{
            Provider.of<RoomViewmodel>(roomcontext,listen: false).AddKaresmaChair(userids: Give.ListUser,Amount:int.parse(Give.quantity??'0')*(Give.price??0) );
          }
          break;
        case 26:
          usermodel user=usermodel.fromJson(data['data']['user']);

          guessgamemodel Guessgame=guessgamemodel.fromJson(data['data']['Guessgame']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddChatRoom(message: Chatroom(kind: 9,Guess:Guessgame ,id: data['data']['Guessgameid'],user:user,content:data['data']['Guess'],Coins:data['data']['Coins']));
          break;
        case 27:
          guessgamemodel Guessgame=guessgamemodel.fromJson(data['data']['Guessgame']);
          Provider.of<RoomViewmodel>(roomcontext,listen: false).AddGuessGame(winnerid:data['data']['winner'],guess: Guessgame );
          Provider.of<RoomViewmodel>(roomcontext,listen: false).ChangeGuessGame(Guess:Guessgame,winnerid: data['data']['winner']   );
          break;
        case 28:
          SmartDialog.dismiss();
          Provider.of<LoginViewmodel>(roomcontext,listen: false).LuckYPackage(id: int.parse(data['data']['id'].toString()),Lucky: data['data']['user'] );

           break;
        default:

    }
  }



}