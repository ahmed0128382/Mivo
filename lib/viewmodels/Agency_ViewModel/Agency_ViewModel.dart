
import 'package:ahlachat/models/AgencyModel.dart';
import 'package:ahlachat/models/JoinRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/AgencyScrean/SearchAgencyResults.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../Repositores/Agency_repositores/Agency_api.dart';
import '../../main.dart';
import '../../models/Usermodel.dart';
import '../../util/Dialogs.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';


class AagencyViewModel extends ChangeNotifier{
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  bool showloading4 = false;
  bool showloading5 = false;
  bool showloading6 = false;
  bool showloading7 = false;
 TextEditingController EditAagencyName=TextEditingController();
  EditAagencyNames()async{
    ShowGlopalLoading();
    LoginViewmodel user= Provider.of<LoginViewmodel>(NavigationService.navigatorKey.currentContext!,listen: false);

    await Agencyapi().EditAgencyNames( Agencyinfo?.id,EditAagencyName.text).then((value) {
      if(value==true){
        Agencyinfo?.name=EditAagencyName.text;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        user.RemoveCoins(cost: 5000);
      }else{

        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }


      DismissGlopalLoading();
    });
    notifyListeners();
  }

  List<JoinRequestModel> JoinRequestes=[];
  GetJoinRequested({id}) async {
 ShowGlopalLoading();
    await Agencyapi().GetJoinRequests(id: id).then((value) {
      JoinRequestes=value;
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  AcceptJoinRequests(int id,context)async{
    ShowGlopalLoading();
    await Agencyapi().AcceptJoinRequests(id:id)
        .then((value) {

      if(value==true){
        useragincys.insert(0,JoinRequestes.where((element) => element.id==id).first.user!);
        JoinRequestes.removeWhere((element) => element.id==id);
        notifyListeners();
        Dialogs().showtoast(getLang(context: context,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context: context,key: "Sorry"));
      }
      DismissGlopalLoading();
    });
  }

  refuseJoinRequests(int id,context)async{
    ShowGlopalLoading();
    await Agencyapi().refuseJoinRequests(id:id)
        .then((value) {

      if(value==true){

        JoinRequestes.removeWhere((element) => element.id==id);
        notifyListeners();
        Dialogs().showtoast(getLang(context: context,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context: context,key: "Sorry"));
      }
      ShowGlopalLoading();
    });
  }
  TextEditingController SearchController=TextEditingController();
  List<Agencymodel> Agences=[];
  List<usermodel> useragincys=[];
  Agencymodel ?Agencyinfo;
  List<Agencymodel> Searchagency=[];
  List<Agencymodel> ImportantAgencys=[];


  SearchGetAgency({context,text}) async {

    ShowGlopalLoading();
    await Agencyapi().SearchAgency(tittle: text).then((value) {
      Searchagency=value;

      navigateTo(context: context,screen: SearchAgencyResults());
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetAgencyinfo({Agencymodel ?info,context}){
    Agencyinfo=info;
    useragincys=[];
    GetJoinAgency(context: context);
    notifyListeners();
  }

  AgencyLeaderBoard ?  LeaderBoardAgency;
  GetAgencyLeaderBoard({context}) async {
    ShowGlopalLoading();
    await Agencyapi().GetAgencyLeaderBoard(context,SearchController.text).then((value) {
      LeaderBoardAgency=value;

      notifyListeners();
      DismissGlopalLoading();
    });
    notifyListeners();
  }


  LeaveAgency({context}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

    showSpinner6();
    await Agencyapi().LeaveAgency(context: context,Agancyid:Agencyinfo?.id  ).then((value) {
     if(value==true){

       user.updateAgency();
       Dialogs().showtoast(getLang(context: context,key: "Done_Succ"));
     }else{
Dialogs().showtoast(getLang(context: context,key: "Sorry"));
     }
      hideSpinner6();
    });
    notifyListeners();
  }

  RequsetJoinAgency({context}) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

    showSpinner7();
    await Agencyapi().RequsetJoinAgency(context: context,Agancyid:Agencyinfo?.id  ).then((value) {
      if(value==true){

        user.userinfo?.joinsrequested?.add(Agencyinfo?.id??0);
        Dialogs().showtoast(getLang(context: context,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context: context,key: "Sorry"));
      }
      hideSpinner7();
    });
    notifyListeners();
  }
  void showSpinner() {
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner() {
    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner5() {
    showloading5 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner5() {

    showloading5 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner6() {

    showloading6 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner6() {

    showloading6 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner7() {
    showloading7 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner7() {
    showloading7 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void showSpinner3() {

    showloading3 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner3() {

    showloading3 = false;
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
  void showSpinner4() {

    showloading4 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner4() {

    showloading4 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }


  GetJoinAgency({context}) async {
    ShowGlopalLoading();
    await Agencyapi().JoinAgency(context:context,id: Agencyinfo?.id).then((value) {
      useragincys=value;
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetImportantAgency({context}) async {
    showSpinner();
    await Agencyapi().AgencyImportant(context).then((value) {
      ImportantAgencys=value;
      hideSpinner();
    });
    notifyListeners();
  }
  GetAgency({context}) async {
    showSpinner();
    await Agencyapi().Agency(context).then((value) {
      Agences=value;
      hideSpinner();
    });
    notifyListeners();
  }
  GetMoreAgency(context) async {
    showSpinner2();
    await Agencyapi().AddmoreAgency(context).then((value) {
       
      value.forEach((element) {
        Agences.add(element);
      });

      HiddenSpinner2();
    });
    notifyListeners();
  }
  GetMoreAgencymembers({context}) async {
    showSpinner4();

    await Agencyapi().AddmoreAgencyMembers(context,Agencyinfo?.id).then((value) {
       
      value.forEach((element) {
        useragincys.add(element);
      });
      HiddenSpinner4();

    });
    notifyListeners();
  }
}