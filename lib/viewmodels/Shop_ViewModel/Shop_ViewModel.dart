
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/BageScrean/BageScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/ShopScrean.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Shop_repositores/Shop_api.dart';
import 'package:ahlachat/models/MyItemModel.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

class ShopViewmodel extends ChangeNotifier {
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  List<Shop> AllShop=[];
  List<Salesmodel> AllMyItem=[];
  List SelectedPackage=[];
  int ?price;
  int ?day;
  int ?Id;
  int ?categoryid;
  Getid({id,CategoryId}){
    Id=id;
    categoryid=CategoryId;
    notifyListeners();
  }
  selectPackage({value,Priceitem,Dayitem }){
    SelectedPackage.clear();
    SelectedPackage.add(value);
    price=Priceitem;
    day=Dayitem;

    notifyListeners();
  }
  void showSpinner() {
     ;
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner() {
     ;
    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner2() {

    showloading2 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner2() {

    showloading2 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner3() {
     ;
    showloading3 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner3() {
     ;
    showloading3 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }

  GetShop({context}) async {
    ShowGlopalLoading();
    await shopapi().getShop(context: context).then((value) {
      AllShop=value;
      navigateTo(context: context, screen: ShopScrean());
      DismissGlopalLoading();
    });
    notifyListeners();
  }

  GetBag({context}) async {
    ShowGlopalLoading();
    await shopapi().GetMyBag( ).then((value) {
      AllMyItem=value;
      navigateTo(context: context, screen: BagScrean());
      DismissGlopalLoading();
    });
    notifyListeners();
  }

  ByeShop({context}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    ShowGlopalLoading();

    await shopapi().ByeItem(day: day,itemId:Id ,price: price,context: context,categoryid:categoryid ).then((value) {
     if(value==true){



if((user.userinfo?.coins??0)<(price??0)){
  Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

}else{
  user.RemoveCoins(cost: price??0);
  Dialogs().showtoast('تم شراء العنصر بنجاح 🤝');
}

     }else{
       Dialogs().showtoast('You already have this item 🛄');
     }
     DismissGlopalLoading();
    });
    notifyListeners();
  }
  SendByeShop({context,userid}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    ShowGlopalLoading();

    await shopapi().SendByeShop(day: day,itemId:Id ,price: price,context: context,categoryid:categoryid,userid: userid ).then((value) {
      if(value==true){



        if((user.userinfo?.coins??0)<(price??0)){
          Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

        }else{
          user.RemoveCoins(cost: price??0);
          Dialogs().showtoast('تم شراء العنصر بنجاح 🤝');
        }

      }else{
        Dialogs().showtoast('You already have this item 🛄');
      }
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  UserpdateFrame({context, Frame}) async {
    ShowGlopalLoading();
    await shopapi().
         UpdateFrame(Frame:Frame, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  UserpdateEnterbubles({context, Frame}) async {
    ShowGlopalLoading();
    await shopapi().
    UpdateEnterbubles(Frame:Frame, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  UserpdatepROFILEbubles({context, Frame}) async {
    ShowGlopalLoading();
    await shopapi().
    Updateprofilebubles(Frame:Frame, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));

      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));

      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }

  RemoveFrame({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveFrame(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }


  RemoveEntry({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveEntry(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  RemoveEnterbubles({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveEnterbubles(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  RemoveProfilebubles({context}) async {
    ShowGlopalLoading();
    await shopapi().
    RemoveProfilebubles(  context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }
  UserpdateEntry({context, Entry}) async {
    ShowGlopalLoading();
    await shopapi().UpdateEntry(Entry:Entry, context: context)
        .then((value) {
      if(value==true){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
    });

    notifyListeners();
  }

}