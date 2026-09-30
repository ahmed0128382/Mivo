
import 'package:ahlachat/Repositores/user_repositores/user_api.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/MyVip.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Vip_repositores/Vip_api.dart';
import 'package:ahlachat/models/VipModel.dart';
import 'package:provider/provider.dart';
class VipViewmodel extends ChangeNotifier{
  bool showloading = false;
  List<VipModel> Vips=[];
  List<MyVipmodel> MyVips=[];
  void showSpinner() {

    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hiddeSpinner() {

    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  UpdateNewId({context, Id,Nyvipid}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

    ShowGlopalLoading();
    await userapi().
    UpdateNewId(newid:Id, context: context,myvip_id:Nyvipid)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

        user.userinfo?.Newid=Id;
        user.userinfo?.MyVip?.newId=Id;
        MyVips.where((element) => element.id==Nyvipid).first.newId=Id;
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "ID_Taken"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  GetMyVips( ) async {
    if(MyVips.isEmpty){
      ShowGlopalLoading();
    }
    await Vipapi().GetMyVips( ).then((value) {
      MyVips=value;
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetVips({context}) async {
 if(Vips.isEmpty){
   ShowGlopalLoading();
 }
    await Vipapi().GetVips( ).then((value) {
      Vips=value;
      DismissGlopalLoading();
    });
    notifyListeners();
  }
}