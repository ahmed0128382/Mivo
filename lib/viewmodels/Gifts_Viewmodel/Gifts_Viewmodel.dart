
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/GiveGifts.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';
import 'package:spring/spring.dart';

import '../../util/Dialogs.dart';

class GiftsViewModel extends ChangeNotifier{
  TabController?  nestedTabController;
  bool GlobalGiftstate = false;
  bool GlobalLuckystate = false;
  int ? GiftKind;


  DeleteGlopal(){
    GlobalGiftstate = false;

    GlobalLuckystate = false;
    notifyListeners();
  }



  usermodel? Sender;
  usermodel? Reciver;

  usermodel? SenderLucky;


  Gift? GlopelGift;
  String? GlopelGiftQuantity;
  String? GlopelGiftRoomid;
  String? GlopelGiftRoomname;


  int? GlopelLuckyRoomid;
  String? GlopelLuckyRoomname;


  int?GlopelGiftState;
  int?GlopelLuckyState;
  List WaitingGifts=[];
  List WaitingLucky=[];
  GitGlopalGiftData({int ?state,usermodel? sender ,usermodel? reciver ,Gift? gift,String ? Quantati,String? Room_id,String?Roomname}){

    if(gift!=null) {
      WaitingGifts.add({"sender": sender, 'reciver': reciver, 'gift': gift,"Quantati":Quantati,"Room_id":Room_id,'state':state,'Roomname':Roomname});


    }


    if(WaitingGifts.isNotEmpty&&GlobalGiftstate!=true){

      Sender=WaitingGifts[0]['sender'];
      Reciver=WaitingGifts[0]['reciver'];
      GlopelGift=WaitingGifts[0]['gift'];
      GlopelGiftQuantity=WaitingGifts[0]['Quantati'];
      GlopelGiftRoomid=WaitingGifts[0]['Room_id'];
      GlopelGiftState=WaitingGifts[0]['state'];
      GlopelGiftRoomname=WaitingGifts[0]['Roomname'];


      ShowGlobalGift();

    }


  }
  ShowGlobalGift(){
    GlobalGiftstate=true;
    notifyListeners();
  }
  HiddeGlobalGift(){

    GlobalGiftstate=false;

    print(WaitingGifts);

    if(WaitingGifts.isNotEmpty){


      WaitingGifts.removeAt(0);
      print(WaitingGifts);

      if(WaitingGifts.isNotEmpty) {
        Future.delayed(Duration(seconds: 3),() {

          GitGlopalGiftData(Quantati:WaitingGifts.first['Quantati'] ,
            sender: WaitingGifts.first["sender"],
            reciver: WaitingGifts.first["reciver"],
            Room_id:    WaitingGifts.first["Room_id"],
            state:    WaitingGifts.first["state"],
            Roomname:  WaitingGifts.first['Roomname'],
          );
        },);

      }
    }
    notifyListeners();

  }
  GitGlopalLuckyData({int ?state,usermodel? sender ,RoomModel? Room,int? Room_id,String?Roomname}){

    if(Room!=null) {
      WaitingLucky.add({"sender": sender,"Room_id":Room.id,'state':state,'Roomname':Roomname});

    }



    if(WaitingLucky.isNotEmpty&&GlobalLuckystate!=true){

      SenderLucky=WaitingLucky[0]['sender'];
      GlopelLuckyRoomid=WaitingLucky[0]['Room_id'];
      GlopelLuckyState=WaitingLucky[0]['state'];
      GlopelLuckyRoomname=WaitingLucky[0]['Roomname'];

      ShowGlobalLucky();

    }


  }
  ShowGlobalLucky(){
    GlobalLuckystate=true;
    notifyListeners();
  }
  HiddeGlobalLucky(){


    GlobalLuckystate=false;

    if(WaitingLucky.isNotEmpty){
      WaitingLucky.removeAt(0);
      if(WaitingLucky.isNotEmpty) {
        Future.delayed(Duration(seconds: 3),() {
          GitGlopalLuckyData(
            sender: WaitingLucky.first["sender"],
            state: WaitingLucky.first["state"],
            Room_id: WaitingLucky.first["Room_id"],
            Roomname: WaitingLucky.first['Roomname'],
          );
        },);

      }
    }
    notifyListeners();

  }









  int index =0;
  List GiftList=[];
  int Cost=0;
  int giftprice=0;
  String SentValue='1';
  bool selected = false;
  bool selected2 = false;
  List gifelist=[];
  String? gifimage;
  String?giftname;
  String? quantitys;
  String? giftimages;
  String?giftsender;
  String?Imagesender;
  SpringController ?springController;
  bool shows=false;
addtogiftlist({value,giftprices,costs}){
  GiftList.add(value);
  giftprice=value['price'];

  Cost=costs;

  notifyListeners();
}

  hideshowadmin(){
    shows=false;
    gifelist.clear();
    notifyListeners();
  }
  startmotion({required List  ListUser ,image,quantity,required name,username }){

    springController?.play();
    shows=true;
    notifyListeners();
  }
  falseshowadmin(){
    shows=false;

    notifyListeners();
  }

  sidepanner2({givegifts? Give, usermodel? user}){
    gifimage=Give?.image;
    giftname=Give?.name;
    quantitys=Give?.quantity;
    gifelist=Give?.ListUser??[];
    giftsender=user?.name;
    Imagesender=user?.image;
    selected2 = true;
    notifyListeners();
  }
  hidpanner2(){

    selected2 = false;

    notifyListeners();
  }
  changeSentValue(value){
    SentValue=value;
    notifyListeners();
  }
  resetSentValue(value){
    SentValue=value;
    notifyListeners();
  }
  sidepanner(){
   selected = true;
   notifyListeners();
  }
  hidpanner(){
    selected = false;
    notifyListeners();
  }
  initcontroller({context, thisx}){
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    nestedTabController = new TabController(length: user.Giftcatigoris.length, vsync: thisx);
    nestedTabController?.addListener(() {

      index=nestedTabController?.index??0;
      notifyListeners();
    }
    );
  }




}