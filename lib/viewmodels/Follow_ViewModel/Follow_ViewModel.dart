import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Follow_repositores/Follow_api.dart';
import 'package:ahlachat/models/Followmodel.dart';
import 'package:ahlachat/models/Visitors.dart';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/Visitors.dart';

class FollowViewModel extends ChangeNotifier {
bool fanspanner=false;
bool fanspanner2=false;
bool Visitorspanner=false;
RefreshController refreshController = RefreshController(initialRefresh: false);
RefreshController refreshController2 = RefreshController(initialRefresh: false);
RefreshController refreshController4 = RefreshController(initialRefresh: false);
RefreshController refreshController6 = RefreshController(initialRefresh: false);

disposecontrollers(){
  refreshController.dispose();
  refreshController2.dispose();
}

  showfanspanner(){

    fanspanner = true;

    notifyListeners();
  }
  hidfanspanner(){

    fanspanner = false;

    notifyListeners();
  }

showfanspanner2(){

  fanspanner2 = true;

  notifyListeners();
}
hidfanspanner2(){

  fanspanner2 = false;

  notifyListeners();
}
showVisitorsspanner(){

  Visitorspanner = true;

  notifyListeners();
}
hidVisitorsspanner(){

  Visitorspanner = false;

  notifyListeners();
}
  List<visitors>visitor=[];
  List<Follows> Myfans=[];
List<Follows> Following=[];
List<usermodel> Friends=[];
List<Follows> ShareFriends=[];
List<Follows> Myfans2=[];
List<Follows> Following2=[];
List<Follows> Friends2=[];



  Getmyfans({context})async{
    ShowGlopalLoading();
    await Followapi().GetFans( context ).then((value) {

        Myfans=value;
DismissGlopalLoading();
        hidfanspanner();
    });
    notifyListeners();
  }
sentShareRoom({context,userid})async{
    ShowGlopalLoading();
  RoomViewmodel Room=   Provider.of<RoomViewmodel>(context,listen: false);
  SharedRoomIds.add(userid);

  await Followapi().SentShareRoom(userid:userid,roomid: Room.Currentroom?.id).then((value) {
    DismissGlopalLoading();
   if(value==true){
     Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

   }else{
     Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
     SharedRoomIds.remove(userid);
   }

  });
  notifyListeners();
}


GetmyVisitors({context})async{
  ShowGlopalLoading();
  await Followapi().Getvisitors( context ).then((value) {

    visitor=value;

    DismissGlopalLoading();

  });
  notifyListeners();
}

GetFollowing({context})async{
  ShowGlopalLoading();
  await Followapi().GetFollowing( context ).then((value) {

    Following=value;
    DismissGlopalLoading();
    hidfanspanner();
  });
  notifyListeners();
}
GetFriends({context})async{
  ShowGlopalLoading();
  await Followapi().GetFriends( context ).then((value) {

    Friends=value;

    DismissGlopalLoading();
  });
  notifyListeners();
}
GetShareFriends({context})async{
  RoomViewmodel Room=   Provider.of<RoomViewmodel>(context,listen: false);

  await Followapi().GetShareFriends( Roomid:Room.Currentroom?.id.toString() ).then((value) {
    ShareFriends=value;


  });
  notifyListeners();
}







ReturnFollow({context,Senderid})async{
  ShowGlopalLoading();
  await Followapi().ReturnFollow(context:  context,senderid: Senderid ).then((value) {
   
  if(value==true){
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    user.userinfo?.following= (user.userinfo?.following??0)+1;
    user.userinfo?.friends= (user.userinfo?.friends??0)+1;
    user.userinfo?.followIds?.add(Senderid.toString());

    Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
  }else{
    Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
     notifyListeners();
  }
  DismissGlopalLoading();
  notifyListeners();
  });

}

RemoveFollow({context,int ?followid})async{


  ShowGlopalLoading();

  await Followapi().RemoveFollow(context:  context,followid: followid ).then((value) {
     
    if(value==true){
      LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
      user.userinfo?.following= (user.userinfo?.following??0)-1;
      user.userinfo?.friends= (user.userinfo?.friends??0)-1;
      user.userinfo?.followIds?.removeWhere((element) => element==Following.where((element) => element.id==followid).first.userId);
      Following.removeWhere((element) => element.id.toString()==followid.toString()) ;
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      notifyListeners();
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      Following.where((element) => element.id.toString()==followid.toString()).first.status=1;
      notifyListeners();
    }
    DismissGlopalLoading();
    notifyListeners();
  });
  notifyListeners();
}
 SentFollow({context,userid})async{
   LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
   user.userinfo?.followIds?.add(userid.toString());
   user.userinfo?.following= (user.userinfo?.following??0)+1;
  notifyListeners();
  await Followapi().SentFollow(context: context, userid: userid ,Sender:  user.userinfo?.id ).then((value) {
     
    if(value==true){
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      notifyListeners();
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      user.userinfo?.friends= (user.userinfo?.following??0)-1;
      user.userinfo?.followIds?.remove(userid.toString());
      notifyListeners();
    }

    hidfanspanner();
  });
  notifyListeners();
}
SentFollow3({context,userid})async{


  LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
  user.userinfo?.followIds?.add(userid.toString());
  user.userProfileData?.followers= (user.userProfileData?.followers??0)+1;
    user.userinfo?.following= (user.userinfo?.following??0)+1;

  notifyListeners();
  await Followapi().SentFollow(context: context, userid: userid ,Sender:  user.userinfo?.id ).then((value) {

    if(value==true){
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      notifyListeners();
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      user.userProfileData?.followers= (user.userProfileData?.followers??0)-1;
      user.userinfo?.following= (user.userinfo?.following??0)-1;
      user.userinfo?.followIds?.remove(userid.toString());
      notifyListeners();
    }

    hidfanspanner();
  });
  notifyListeners();
}

RemoveFollows3({context,userid})async{
  LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
  user.userinfo?.followIds?.remove(userid.toString());
  user.userProfileData?.followers= (user.userProfileData?.followers??0)-1;
  user.userinfo?.following= (user.userinfo?.following??0)-1;

  notifyListeners();
  await Followapi().RemoveFollowRoom(context: context, userid: userid ,Sender:  user.userinfo?.id ).then((value) {
     
    if(value==true){
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      notifyListeners();
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      user.userProfileData?.followers= (user.userProfileData?.followers??0)+1;
      user.userinfo?.followIds?.add(userid.toString());
      user.userinfo?.following= (user.userinfo?.following??0)+1;
      notifyListeners();
    }

    hidfanspanner();
  });
  notifyListeners();
}
RemoveFollow2({context,followid})async{

  ShowGlopalLoading();
  await Followapi().RemoveUserFollow(context:  context,Userid:followid , ).then((value) {

    if(value==true){
      LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
      user.userinfo?.following= (user.userinfo?.following??0)-1;
      user.userinfo?.friends= (user.userinfo?.friends??0)-1;
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      user.userinfo?.followIds?.remove ( followid.toString());
        Friends.removeWhere((element) => element.id==followid);
    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));


    }
    DismissGlopalLoading();
    notifyListeners();
  });
  notifyListeners();
}
}