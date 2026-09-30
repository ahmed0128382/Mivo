
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:flutter/material.dart';

import 'package:purchases_flutter/models/package_wrapper.dart';
import '../../Repositores/Wallet_repositores/Wallet_api.dart';
import '../../models/PayPalPackage.dart';
import '../../util/Dialogs.dart';

class WalletViewmodel extends ChangeNotifier{
  bool showloading = false;
  List  <Package> packages=[];
  List  <PayPalPackage> PayPalPackages=[];
  void showSpinner() {

    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hiddeSpinner() {

    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  Future FeatchOffers() async {

    final Offerings=await PurchasaApi.fetchoffers();
    if(Offerings.isEmpty){

    }else{

      packages=Offerings.map((e) => e.availablePackages).expand((element) => element).toList();
      print(packages.runtimeType);
      print(packages.length);
      print('packages.length packages.length packages.length packages.length packages.length packages.length packages.length' );
    }

    notifyListeners();
  }

  Future purchasePackage({required Package Backage, context}) async {
    showSpinner();
    bool state = await PurchasaApi.purchesPackage(Backage);

    if(state==false){
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));


    }else{
//  Provider.of<LoginViewmodel>(context, listen: false).ByeBackage(context:context,Backage:Backage  );
      Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    }

    hiddeSpinner();
    notifyListeners();
  }

  Future  FeatchPaypalPackages() async {

    PayPalPackages=await PurchasaApi().GeyPayPalPackages();

    notifyListeners();
  }





}