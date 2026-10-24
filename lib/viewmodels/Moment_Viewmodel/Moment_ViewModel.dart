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
  bool showloadingFollow = false;
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
  Future<void> GetPostes({context}) async {
  ShowGlopalLoading();

  try {
    final value = await Momentapi().GetPosts(context);

    GeneralPosts = value;

    refreshController.refreshCompleted();
    refreshController3.refreshCompleted();

    notifyListeners();
  } catch (e) {
    print('GET POSTS VIEWMODEL ERROR: $e');

    refreshController.refreshFailed();
    refreshController3.refreshFailed();
  } finally {
    DismissGlopalLoading();
  }
}
 
 Future<void> GetFollowPostes({context}) async {
  try {
    final value = await Momentapi().GetFollowPostes(context);

    FollowPosts = value;

    notifyListeners();
  } catch (e) {
    print('GET FOLLOWING POSTS VIEWMODEL ERROR: $e');
  }
}
 
  Future<void> GetMoreFollow(context) async {
  if (showloadingFollow || !HasMoreFollowPosts) {
    return;
  }

  showloadingFollow = true;
  notifyListeners();

  try {
    final newPosts = await Momentapi().AddmoreFollowPosts(context);

    if (newPosts.isNotEmpty) {
      final existingIds = FollowPosts
          .map((post) => post.id)
          .toSet();

      final uniquePosts = newPosts
          .where((post) => !existingIds.contains(post.id))
          .toList();

      if (uniquePosts.isNotEmpty) {
        FollowPosts.addAll(uniquePosts);
      }
    }
  } catch (e) {
    print('LOAD MORE FOLLOWING POSTS VIEWMODEL ERROR: $e');
  } finally {
    showloadingFollow = false;
    notifyListeners();
  }
}
 
 Future<void> GetMorePostes(context) async {
  if (showloading7 || !HasMorePosts) {
    return;
  }

  showloading7 = true;
  notifyListeners();

  try {
    final newPosts = await Momentapi().AddmorePosts(context);

    if (newPosts.isNotEmpty) {
      final existingIds = GeneralPosts
          .map((post) => post.id)
          .toSet();

      final uniquePosts = newPosts
          .where((post) => !existingIds.contains(post.id))
          .toList();

      if (uniquePosts.isNotEmpty) {
        GeneralPosts.addAll(uniquePosts);
      }
    }
  } catch (e) {
    print('LOAD MORE POSTS VIEWMODEL ERROR: $e');
  } finally {
    showloading7 = false;
    notifyListeners();
  }
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

  


Future<void> AddPost({required BuildContext context}) async {
  if (showloading4) return;

  showloading4 = true;
  notifyListeners();

  ShowGlopalLoading();

  try {
    // 1. Create the post through the API.
    final Postes? createdPost = await Momentapi().AddPost(
      image: Postimage,
      context: context,
      tittle: PostName.text,
    );

    if (createdPost == null || createdPost.id == null) {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: "Sorry",
        ),
      );
      return;
    }

    print(
      'ADD POST: Created post ID = ${createdPost.id}. '
      'Fetching posts from API...',
    );

    // 2. Fetch posts from the backend.
    // Do NOT insert createdPost into any list locally.
    await GetPostes(context: context);

    // 3. Clear the form only after successful creation.
    PostName.clear();
    Postimage = null;

    // 4. Complete pull-to-refresh indicators.
    refreshController.refreshCompleted();
    refreshController3.refreshCompleted();

    notifyListeners();

    // 5. Close the Add Post screen.
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  } catch (e, stackTrace) {
    print('ADD POST ERROR: $e');
    print(stackTrace);

    refreshController.refreshFailed();
    refreshController3.refreshFailed();

    Dialogs().showtoast(
      getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: "Sorry",
      ),
    );
  } finally {
    showloading4 = false;
    DismissGlopalLoading();
    notifyListeners();
  }
}
bool get hasMoreGeneralPosts => HasMorePosts;

bool get hasMoreFollowingPosts => HasMoreFollowPosts;

}