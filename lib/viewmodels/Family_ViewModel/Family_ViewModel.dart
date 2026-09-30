
import 'package:ahlachat/Repositores/Family_repositores/Familyapi.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/FamilyRequest.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/view/Screans/Family/SearchResults.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyViewModel extends ChangeNotifier{
  bool showloading = false;
  bool showloading2 = false;
  bool showloading5 = false;
  bool showloading3 = false;  bool showloading4 = false;
  TextEditingController FamilyName=TextEditingController();
  TextEditingController FamilyDesc=TextEditingController();
  List Levels=[
    {'Level':'1','name':'Bronze Family','Coins':0,'image':Images.FamilyLevel1,'Color':const Color(0xff0c8a4b).value,'BackImage':Images.Family1},
    {'Level':'1','name':'Bronze Family','Coins':200000,'image':Images.FamilyLevel1,'Color':const Color(0xff0c8a4b).value,'BackImage':Images.Family1},
    {'Level':'2','name':'Silver Family','Coins':600000,'image':Images.FamilyLevel2,'Color':const Color(0xff0158fc).value,'BackImage':Images.Family2},
    {'Level':'3','name':'Gold Family','Coins':1200000,'image':Images.FamilyLevel3,'Color':const Color(0xff15110d).value,'BackImage':Images.Family5},
    {'Level':'4','name':'World Family','Coins':2000000,'image':Images.FamilyLevel4,'Color':const Color(0xff7132ff).value,'BackImage':Images.Family3},
    {'Level':'5','name':'World Family','Coins':3300000,'image':Images.FamilyLevel4,'Color':const Color(0xff7132ff).value,'BackImage':Images.Family5},
  ];
  ListoflEaderboardcategory ? MemberFamilyLeaderBoard;
  List<FamilyModel> SearchFamily=[];

  GetMemberFamilyLeaderboard() async {

      ShowGlopalLoading();


    await Familyapi().GetMembersLeaderboard(CurrentFamily?.id).then((value) {

      MemberFamilyLeaderBoard=value;


      print(MemberFamilyLeaderBoard?.monthlysupporter?.length);
      DismissGlopalLoading();
      notifyListeners();
    });
    notifyListeners();
  }


  SearchGetFamily({context,text}) async {

    ShowGlopalLoading();
    await Familyapi().SearchFamily( text).then((value) {
      SearchFamily=value;
      print(SearchFamily.length);
   navigateTo(context: context,screen: SearchFamilyResults());
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  void showSpinner() {
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner(){
    showloading = false;
    notifyListeners();
  }

  void showSpinner3() {
    showloading3 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner3(){
    showloading3 = false;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner2() {
    showloading2 = false;
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
  void showSpinner4() {
    showloading4 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void hideSpinner4() {
    showloading4 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  List<FamilyModel> AllFamily=[];
  List<RoomModel> FamilyRoom=[];
  List<usermodel> FamilyMembers=[];
  List<FamilyRequest> FamilyRequests=[];
TextEditingController EditFamilyName=TextEditingController();
  FamilyModel? CurrentFamily;
  GetFamily({FamilyModel? Val}){
    CurrentFamily=Val;
GetFamilyProfile();
    notifyListeners();
  }

  EditFamilyNames()async{
    ShowGlopalLoading();
    LoginViewmodel user= Provider.of<LoginViewmodel>(NavigationService.navigatorKey.currentContext!,listen: false);

    await Familyapi().EditFamilyNames( CurrentFamily?.id,EditFamilyName.text).then((value) {
      if(value==true){
        CurrentFamily?.name=EditFamilyName.text;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        user.RemoveCoins(cost: 5000);
      }else{

        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }


      DismissGlopalLoading();
    });
    notifyListeners();
  }
  ExchangeFamily({val})async{
    ShowGlopalLoading();
    LoginViewmodel user= Provider.of<LoginViewmodel>(NavigationService.navigatorKey.currentContext!,listen: false);

    await Familyapi().ExchangeFamily( CurrentFamily?.id).then((value) {
      if(value==true){
        CurrentFamily?.GlopalKarisma=0;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        user.AddCoinspluse(value:  val);
      }else{

        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }


      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetFamilyRequests()async{
    ShowGlopalLoading();
    await Familyapi().GetFamilyRequest( CurrentFamily?.id).then((value) {
      FamilyRequests=value;

      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetFamilyMembers()async{
    ShowGlopalLoading();
    await Familyapi().GetFamilyMembers( CurrentFamily?.id).then((value) {
      FamilyMembers=value;

      DismissGlopalLoading();
    });
    notifyListeners();
  }


  GetFamilyProfile( ) async {
    ShowGlopalLoading();
    await Familyapi().GetFamilyProfile(id: CurrentFamily?.id).then((value) {
      CurrentFamily=value;
      print(CurrentFamily?.name);
      DismissGlopalLoading();
    });
    notifyListeners();
  }
   JoinFamilyRequest({context}) async {
ShowGlopalLoading();

    await Familyapi().SentjoinRequesr(familyid: CurrentFamily?.id,context: context  ).then((value) {
if(value){

  Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
}else{
  Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
}
DismissGlopalLoading();
      notifyListeners();
    });

  }
  AddNewFamily(FamilyModel? val){
    AllFamily.insert(0, val!);
    notifyListeners();
  }
  CreateFamily({context }) async {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
 ShowGlopalLoading();


    await Familyapi().CreateFamily(image: Familymage,describtion: FamilyDesc.text,name: FamilyName.text,  context: context ).then((value) {
      if(value.id!=null){
        user.CreateFamily(value);
        Familymage=null;
        FamilyDesc.clear();
        FamilyName.clear();
        DismissGlopalLoading();

       Navigator.pop(context);
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }

      notifyListeners();
    });
    notifyListeners();
  }
  LeaveMyFamily({context}) async {

    ShowGlopalLoading();
    await Familyapi().LeaveMyFamily(familyid: CurrentFamily?.id,  context: context ).then((value) {
      if(value){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        CurrentFamily?.nubmers=(CurrentFamily?.nubmers??0)-1;
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
      notifyListeners();
    });
    notifyListeners();
  }

  RemoveFamilyMember({context,userid}) async {

    ShowGlopalLoading();

    await Familyapi().RemoveFamilyMember(familyid: CurrentFamily?.id ,userid: userid).then((value) {
      if(value){
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        FamilyMembers.removeWhere((element) => element.id==userid);
        CurrentFamily?.nubmers=(CurrentFamily?.nubmers??0)-1;
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      DismissGlopalLoading();
      notifyListeners();
    });
    notifyListeners();
  }
 AcceptFamilyRequest({ joinid}) async {

    ShowGlopalLoading();

    await Familyapi().AcceptFamilyRequest(joinid: joinid,  ).then((value) {
      if(value){

        FamilyRequests.removeWhere((element) => element.id==joinid);
        CurrentFamily?.nubmers= ( CurrentFamily?.nubmers??0)+1;
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        DismissGlopalLoading();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }

      notifyListeners();
    });
    notifyListeners();
  }



  var Familymage;
  Future ComtImage(context) async {
    await Familyapi().getImageGalary().then((value) {
      Familymage=null;
      Familymage=value;
      print(value.runtimeType);
      notifyListeners();
    });
    notifyListeners();
  }
  CancleJoinRequest({context}) async {
    ShowGlopalLoading();
    await Familyapi().CanclejoinRequesr(Familyid:  CurrentFamily?.id ).then((value) {
      if(value){
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
        user.RemoveFamilyRequest(CurrentFamily?.id);
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        DismissGlopalLoading();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }

      notifyListeners();
    });
    notifyListeners();
  }


  CancleMemberJoinRequest({ joinid,userid}) async {
    ShowGlopalLoading();
    await Familyapi().CancleMemberjoinRequesr(Familyid:  CurrentFamily?.id ,userid:userid ).then((value) {
      if(value){
        FamilyRequests.removeWhere((element) => element.id==joinid);

        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
        DismissGlopalLoading();
      }else{
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }

      notifyListeners();
    });
    notifyListeners();
  }




  }


