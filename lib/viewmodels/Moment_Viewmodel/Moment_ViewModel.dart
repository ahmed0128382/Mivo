import 'dart:io';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/models/CommentsModel.dart';

import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';

import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class MomentViewModel extends ChangeNotifier{
  List<Postes> GeneralPosts=[];
  List<Postes> FollowPosts=[];
  List<Postes> MyPosts=[];
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  List LikedPost=[];
  bool showloading4= false;
  bool showloading5= false;
  bool showloading6= false;
  bool showloading7= false;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RefreshController refreshController3 = RefreshController(initialRefresh: false);
  RefreshController refreshController4 = RefreshController(initialRefresh: false);
  RefreshController refreshController5= RefreshController(initialRefresh: false);
  disposecontrollers(){
    refreshController.dispose();
    refreshController3.dispose();
  }
  TextEditingController PostName=TextEditingController();
  var   Postimage ;
  final ImagePicker _picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      Postimage = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
    notifyListeners();
  }

  void showSpinner5(){
    showloading5 = true;
    notifyListeners();
  }
  void hidespinner5(){
    showloading5 = false;
    notifyListeners();
  }
  void showSpinner4(){
    showloading4 = true;
    notifyListeners();
  }

  ReportPost({  Postid})async{
    Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    await Momentapi().ReportPost( Postid: Postid).then((value){


    });

    notifyListeners();
  }
  ReportUser({  UserId})async{
    Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    await Momentapi().ReportUser(  Userid: UserId).then((value){


    });

    notifyListeners();
  }
  BlockUser({  UserId})async{
    ShowGlopalLoading();

    await Momentapi().BlockUser(  Userid: UserId).then((value){
      if(value==true){
        CheckBlocked=true;
        UserBlockedId=UserId.toString();

      }else{
        CheckBlocked=false;
      }
      DismissGlopalLoading();
      notifyListeners();
    });

    notifyListeners();
  }
  UnBlockUser({  UserId})async{
    CheckBlocked=false;
    Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
    await Momentapi().UnBlockUser(  Userid: UserId).then((value){
      if(value==true){
        CheckBlocked=false;
      }else{
        CheckBlocked=true;

      }
      notifyListeners();
    });

    notifyListeners();
  }
  void hidespinner4(){

    Postimage=null;
    PostName.clear();
    showloading4 = false;
    notifyListeners();
  }
  int kindoftap=1;

  kindoftaps({int? val}){
    kindoftap=val!;
    notifyListeners();
  }

  GetLikedPost(List value){
    LikedPost = value;
    notifyListeners();
  }

  void showSpinner() {

    showloading = true;
    notifyListeners();
  }

  void hideSpinner() {

    showloading = false;
    notifyListeners();
  }
  void showSpinner2() {

    showloading2 = true;
    notifyListeners();
  }

  void hideSpinner2() {

    showloading2 = false;
    notifyListeners();
  }
  void showSpinner7() {

    showloading7 = true;
    notifyListeners();
  }

  void hideSpinner7() {

    showloading7 = false;
    notifyListeners();
  }

  void showSpinner3() {
     ;
    showloading3 = true;
    notifyListeners();
  }

  void hideSpinner3() {

    showloading3 = false;
    notifyListeners();
  }
  GetPostes({context}) async {
    ShowGlopalLoading();
    await Momentapi().GetPosts(context).then((value) {
      GeneralPosts=value;
      refreshController.refreshCompleted();
      refreshController3.refreshCompleted();
      DismissGlopalLoading();
    });
    notifyListeners();
  }
  GetFollowPostes({context}) async {

    await Momentapi().GetFollowPostes(context).then((value) {
      FollowPosts=value;


    });
    notifyListeners();
  }
  GetMoreFollow(context) async {
    showSpinner7();

    await Momentapi().AddmoreFollowPosts(context).then((value) {

      value.forEach((element) {
        FollowPosts.add(element);
      });
      hideSpinner7();
    });
    notifyListeners();
  }
  GetMorePostes(context) async {

    showSpinner7();
    await Momentapi().AddmorePosts(context).then((value) {
       
      value.forEach((element) {
        GeneralPosts.add(element);
      });
      hideSpinner7();
    });
    notifyListeners();
  }


  GetMyPostes({context}) async {
    showSpinner();
    await Momentapi().GetMyPosts(context).then((value) {
      MyPosts=value;
      refreshController4.refreshCompleted();
      hideSpinner();
    });
    notifyListeners();
  }

  AddComment({ Comment,Postid,context })async{
 ShowGlopalLoading();
    await Momentapi().AddComment( Comment: Comment,Postid: Postid).then((value){
       

      if(value!=null&&value!=Comments()){
        var General =GeneralPosts.where((element) => element.id==Postid) ;
        if(General.isNotEmpty){
          GeneralPosts.where((element) => element.id==Postid).first.commentsuser?.add(value);
        }

        var Follow =FollowPosts.where((element) => element.id==Postid)  ;
        if(Follow.isNotEmpty){
          Follow.where((element) => element.id==Postid).first.commentsuser?.add(value);
        }
        if(context!=null){
          var Profile = Provider.of<LoginViewmodel>(context,listen: false).userProfileData?.Postuser?.where((element) => element.id==Postid)??[]  ;
          if(Profile.isNotEmpty){
            Provider.of<LoginViewmodel>(context,listen: false).AddComment(Postid,value);
          }
        }
      DismissGlopalLoading();
    }});

    notifyListeners();
  }
  AddComment3({ Comment,Postid,index,context})async{
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    showSpinner2();
    await Momentapi().AddComment( Comment: Comment,Postid: Postid).then((value){
       

      if(value!=null&&value!=Comments()){
        user.userProfileData?.Postuser?[index].commentsuser?.add(value);
        LikedPost.add(Postid);
      }
      hideSpinner2();
    });

    notifyListeners();
  }


  AddComment2({ Comment,Postid,index})async{
    showSpinner2();
    await Momentapi().AddComment( Comment: Comment,Postid: Postid).then((value){
       

      if(value!=null&&value!=Comments()){
         MyPosts.reversed.toList()[index].commentsuser?.add(value);
        LikedPost.add(Postid);
      }
      hideSpinner2();
    });

    notifyListeners();
  }
  LikePost({Postid,context})async{
    LikedPost.add(Postid.toString());
    notifyListeners();
    await Momentapi().LikePost(   Postid: Postid).then((value){


      print(value.id);

      if(value.id!=null){
        var General =GeneralPosts.where((element) => element.id==Postid)  ;
        if(General.isNotEmpty){
          GeneralPosts.where((element) => element.id==Postid).first.like?.add(value);
        }
        var Follow =FollowPosts.where((element) => element.id==Postid)  ;
        if(Follow.isNotEmpty){
          Follow.where((element) => element.id==Postid).first.like?.add(value);

        }
if(context!=null){
  var Profile = Provider.of<LoginViewmodel>(context,listen: false).userProfileData?.Postuser?.where((element) => element.id==Postid)??[]  ;
  if(Profile.isNotEmpty){
    Provider.of<LoginViewmodel>(context,listen: false).likepost(Postid,value);
  }
}


      }else  {

        LikedPost.remove(Postid.toString());
      }

    });

    notifyListeners();
  }
  LikePost2({Postid,index,context})async{
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

    LikedPost.add(Postid.toString());
    notifyListeners();
    await Momentapi().LikePost( Postid: Postid).then((value){


      if(value.id!=null){
        user.userProfileData?.Postuser?[index].like?.add(value);
      }else {

        LikedPost.remove(Postid.toString());
      }

    });

    notifyListeners();
  }
  RemoveLike({Postid,context })async{
    LikedPost.remove(Postid.toString());
    notifyListeners();
    await Momentapi().RemoveLike( Postid: Postid).then((value){

      if(value=true){
        var General =GeneralPosts.where((element) => element.id==Postid)  ;
        if(General.isNotEmpty){
          GeneralPosts.where((element) => element.id==Postid).first.like?.removeWhere((element) => element.userId.toString()==UserId.toString());
        }
        var Follow =FollowPosts.where((element) => element.id==Postid)  ;
        if(Follow.isNotEmpty){
          Follow.where((element) => element.id==Postid).first.like?.removeWhere((element) => element.userId.toString()==UserId.toString());

        }
        if(context!=null){
          var Profile = Provider.of<LoginViewmodel>(context,listen: false).userProfileData?.Postuser?.where((element) => element.id==Postid)??[]  ;
          if(Profile.isNotEmpty){
            Provider.of<LoginViewmodel>(context,listen: false).removeLikepost(Postid,value);
          }
        }
        notifyListeners();

      }else  {

        LikedPost.add(Postid.toString());
      }

    });

    notifyListeners();
  }
  RemoveLike2({Postid,index,context})async{
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    LikedPost.remove(Postid.toString());
    notifyListeners();
    await Momentapi().RemoveLike( Postid: Postid).then((value){

      if(value=true){
        user.userProfileData?.Postuser?[index].like?.removeWhere((element) => element.postId.toString()==Postid.toString());
        notifyListeners();

      }else  {

        LikedPost.add(Postid.toString());
      }

    });

    notifyListeners();
  }

  ReplayComment({ Commentid,index,context,Replay,indexx})async{

    await Momentapi().ReplayComment( Commentid:Commentid ,context: context ,Replay: Replay).then((value){

if(value.id!=null){

   GeneralPosts[index].commentsuser?.where((element) => element.id==Commentid).first.commentReplay=Replay.toString();
   GeneralPosts[index].commentsuser?.where((element) => element.id==Commentid).first.updatedAt=value.updatedAt;
   notifyListeners();
}

    });

    notifyListeners();
  }
  ReplayComment2({ Commentid,index,context,Replay,indexx})async{

    await Momentapi().ReplayComment( Commentid:Commentid ,context: context ,Replay: Replay).then((value){
       
      if(value.id!=null){


         MyPosts.reversed.toList()[index].commentsuser?.reversed.toList()[indexx].commentReplay=value.commentReplay;
   MyPosts.reversed.toList()[index].commentsuser?.reversed.toList()[indexx].updatedAt=value.updatedAt;
   notifyListeners();
      }

    });


  }

  AddPost({ context})async{

    ShowGlopalLoading();
    await Momentapi().AddPost(image: Postimage,context: context,tittle: PostName.text).then((value){

      if(value.id!=null){
        MyPosts.add(value);
        PostName.clear();
        Postimage=null;
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
        DismissGlopalLoading();
      }else  {
        Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Sorry"));
      }
      hideSpinner3();
    });

    notifyListeners();
  }
}