import 'package:ahlachat/Repositores/Relation_repositores/Relationapi.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/RelationModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Family/SearchResults.dart';
import 'package:ahlachat/view/Screans/RelationsScrean/UserRelationList.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RelationsViewModel extends ChangeNotifier{
List<RelationModel> UserRelations=[];
  SendRelation({required Relationid,required UserId,required context})async{
    ShowGlopalLoading();

    await Relationapi().SendRelations(context: context,user_id:UserId,Relationid:Relationid  ).then((value){
     if(value==1){
       Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

     }else if(value==2){
       Dialogs().showtoast('لقد قمت بالاهداء من قبل');

     }else{
       Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

     }
      DismissGlopalLoading();
      notifyListeners();
    });

    notifyListeners();
  }
RemoveRelation({required id,required context})async{
  ShowGlopalLoading();

  await Relationapi().RemoveRelations(context: context,id:id , ).then((value){
    if(value==true){
      UserRelations.removeWhere((element) => element.id==id);
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

    }
    DismissGlopalLoading();
    notifyListeners();
  });

  notifyListeners();
}
AcceptRelation({required id,required RelationModel Relati,required context,userid})async{
  ShowGlopalLoading();
  LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

  await Relationapi().AcceptRelations(context: context,id:id ,userid: userid ).then((value){
    if(value==true){
      UserRelations.where((element) => element.id==id).first.status=1;
      user.userProfileData?.Relations?.add(Relati);

      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

    }
    DismissGlopalLoading();
    notifyListeners();
  });

  notifyListeners();
}

LeaveRelation({required id,required context})async{
  ShowGlopalLoading();
  LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
  await Relationapi().LeaveRelations(context: context,id:id ).then((value){
    if(value==true){
      UserRelations.where((element) => element.id==id).first.status=2;
      UserRelations.where((element) => element.id==id).first.Leaved=int.parse(UserId.toString());
      user.userProfileData?.Relations?.removeWhere((element) => element.id==id,);
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

    }else{
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

    }
    DismissGlopalLoading();
    notifyListeners();
  });

  notifyListeners();
}

  GetUserRelation({context}) async {

    ShowGlopalLoading();
    await Relationapi().GetUserRelation().then((value) {
      UserRelations=value;
      print(UserRelations.length);
      navigateTo(context: context,screen: UserRelationResults());
      DismissGlopalLoading();
    });
    notifyListeners();
  }


}