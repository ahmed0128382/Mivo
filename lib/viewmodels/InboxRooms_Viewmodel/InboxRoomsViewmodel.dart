import 'dart:io';

import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Chat_repositores/Chat_api.dart';

import 'package:ahlachat/models/Inboxroom.dart';

import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/app_constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class InboxroomViewModel extends ChangeNotifier{
  List<InboxRoomModel> Inboxrooms=[];
  bool showloading = false;
  bool showloading2 = false;
  TextEditingController textEditingController=TextEditingController();
  int inroomid=0;
  int defaultindex= 0;
  BlockUser({  id,UserId})async{
    ShowGlopalLoading();

    await Momentapi().BlockUser(  Userid: UserId).then((value){
      if(value==true){
        CheckBlocked=true;
        UserBlockedId=UserId.toString();

        Inboxrooms.removeWhere((element) => element.id==id);
      }else{
        CheckBlocked=false;
      }
      DismissGlopalLoading();
      notifyListeners();
    });

    notifyListeners();
  }
  void changdefaultindex({value}) {

    defaultindex = value;
    notifyListeners();
  }
  void showSpinner() {

    showloading = true;
    notifyListeners();
  }


  void hideSpinner(){

    showloading = false;
    notifyListeners();
  }


  void showSpinner2() {

    showloading2 = true;
    notifyListeners();
  }

  var   ChatuserImage ;
  final ImagePicker _picker2 = ImagePicker();
  Future getChatRoomImage() async {
    bool selected=false;
    final pickedFile = await _picker2.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      ChatuserImage = File(pickedFile.path);
      Cropimage(ChatuserImage);

      selected=true;
      notifyListeners();
    } else {
      selected=false;

    }
    notifyListeners();
    return selected;
  }
  Cropimage(value)async{
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: value.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),

      ],
    );
    if(croppedFile!=null){
      ChatuserImage=File(croppedFile.path);

      notifyListeners();
    }
  }
  void hideSpinner2(){

    showloading2 = false;
    notifyListeners();
  }
bool InboxLoading=false;
  GetInboxroom({context}) async {
    if(InboxLoading==false){
      ShowGlopalLoading();
    }

    await Chatapi().GetInboxRooms(context).then((value) {
      Inboxrooms=value;


      InboxLoading=true;
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  bool ImageLoading=false;

  DeleteInboxroom({context,inboxid}) async {
    ShowGlopalLoading();
    await Chatapi().deleteInboxRooms(context:context,inboxid: inboxid.toString()  ).then((value) {
   if(value==true){

     Inboxrooms.removeWhere((element) => element.id==inboxid);
     DismissGlopalLoading();
   }else{

   }
   notifyListeners();
    });

  }
  DeleteAndBlockUserInboxroom({context,inboxid}) async {
    ShowGlopalLoading();
    await Chatapi().deleteandBlockInboxRooms(context:context,inboxid: inboxid.toString()  ).then((value) {
      if(value==true){

        Inboxrooms.removeWhere((element) => element.id==inboxid);
        DismissGlopalLoading();
      }else{

      }
      notifyListeners();
    });

  }
  AddnewInboxRoom({required InboxRoomModel  value}){
    Inboxrooms.add(value);
    notifyListeners();
  }
  AddMessageInbox({required Message  value,id,context}){
    var inbox=Inboxrooms.where((element) => element.id.toString()==id.toString());
    if(inbox.isNotEmpty){
      Inboxrooms.where((element) => element.id.toString()==id.toString()).first.message?.add(value);
    }

    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

if(value.inboxroomId==user.ChatRoom?.id){

  user.addtochatRoom(value);
}
    notifyListeners();
  }
  ExistChatRoom(){
    inroomid=0;
    notifyListeners();
  }
ReadInboxRoom({id,context})async{
  Inboxrooms.where((element) => element.id==id).first!=0;
  inroomid=id;
  print(inroomid);
  await Chatapi().ReadInboxRoom(InboxRoom:inroomid ,context:context ).then((value) {
 if(value==true){
   print('truee');

 }else{
   print('false');
 }


    hideSpinner();
  });
  notifyListeners();
}



  AlreadyinInboxRoom({context})async{

    await Chatapi().ReadInboxRoom(InboxRoom:inroomid ,context:context ).then((value) {
      if(value==true){
        print('truee');

      }else{
        print('false');
      }


      hideSpinner();
    });
    notifyListeners();
  }

  SentImageChat({context,usermodel ?userinfo ,id}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    ImageLoading=true;
    notifyListeners();
    await Chatapi().SentImageChat(image: ChatuserImage, context: context,userid: userinfo?.id  ).then((value) {

      var inbox=Inboxrooms.where((element) => element.id==id);
      if(inbox.isNotEmpty){
        Inboxrooms.where((element) => element.id==id).first.message?.add(value);
        Inboxrooms.where((element) => element.id==id).first.updatedAt=value.createdAt;
      }

      if(user.ChatRoom?.id==0){

        user.UpdateChatRoom(value:InboxRoomModel(numberUnread: 0,id: value.inboxroomId,message: [],lastMessage:value.message,createdAt:value.createdAt,updatedAt: value.updatedAt,senderId: UserId,sender: user.userinfo,userId: userinfo?.id.toString(),user:userinfo  ) );
      }


      if(value.inboxroomId==user.ChatRoom?.id){

        user.addtochatRoom(value);
      }
      ImageLoading=false;
      notifyListeners();
    });
    notifyListeners();
  }
 SendMessage({id,context,message,usermodel ?userinfo })async{

   LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);


   await Chatapi().SendMessage(message:message ,userid:userinfo?.id ,Senderid:UserId ,context:context ).then((value) {

     if(value.id!=null){

  var inbox=Inboxrooms.where((element) => element.id==id);

  if(inbox.isNotEmpty){
    Inboxrooms.where((element) => element.id==id).first.message?.add(value);
    Inboxrooms.where((element) => element.id==id).first.updatedAt=value.createdAt;
  }
  if(user.ChatRoom?.id==0){

    user.UpdateChatRoom(value:InboxRoomModel(numberUnread: 0,id: value.inboxroomId,message: [],lastMessage:value.message,createdAt:value.createdAt,updatedAt: value.updatedAt,senderId: UserId,sender: user.userinfo,userId: userinfo?.id.toString(),user:userinfo  ) );
  }



       if(value.inboxroomId==user.ChatRoom?.id){

         user.addtochatRoom(value);
       }
      textEditingController.clear();
     }else{
       print('falseeeeeeeeeeeeeeeeee');
     }



   });
   notifyListeners();

 }
  SendGiftMessage({id,context,gift,usermodel? userinfo })async{
    ShowGlopalLoading();
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

    await Chatapi().SendGiftMessage(giftid:gift['id'],userid:userinfo?.id ,Senderid:UserId ,context:context ).then((value) {

      if(value.id!=null){
        //print('true');
        user.RemoveCoins(cost: gift['price']);

        var inbox=Inboxrooms.where((element) => element.id==id);
        if(inbox.isNotEmpty){
          Inboxrooms.where((element) => element.id==id).first.message?.add(value);
          Inboxrooms.where((element) => element.id==id).first.updatedAt=value.createdAt;
        }
        if(user.ChatRoom?.id==0){

          user.UpdateChatRoom(value:InboxRoomModel(numberUnread: 0,id: value.inboxroomId,message: [],lastMessage:value.message,createdAt:value.createdAt,updatedAt: value.updatedAt,senderId: UserId,sender: user.userinfo,userId: userinfo?.id.toString(),user:userinfo  ) );
        }


        if(value.inboxroomId==user.ChatRoom?.id){
          user.addtochatRoom(value);
        }
        textEditingController.clear();
      }else{
        print('falseeeeeeeeeeeeeeeeee');
      }

      DismissGlopalLoading();

    });
    notifyListeners();

  }

  SendMessageInRoom({context,message,userid })async{

    showSpinner2();
    await Chatapi().SendMessage(message:message ,userid:userid ,Senderid:UserId ,context:context ).then((value) {

      if(value.id!=null){
        defaultindex=value.inboxroomId!;
      //Inboxrooms.where((element) => element.id==id).first.message?.add(value);
       // Inboxrooms.where((element) => element.id==id).first.updatedAt=value.createdAt;
        textEditingController.clear();
      }else{
        print('falseeeeeeeeeeeeeeeeee');
      }

      hideSpinner2();
    });
    notifyListeners();

  }







}