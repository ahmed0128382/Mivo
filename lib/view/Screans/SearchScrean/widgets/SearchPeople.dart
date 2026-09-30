
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Searchpeople extends StatelessWidget {
  const Searchpeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context,key: "Search_User"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: user.Searchusers.length,itemBuilder: (context, index) => Padding(

    padding: const EdgeInsets.only(top: 10),

    child:InkWell(
      onTap: () {

        user.GetShoweduserProfile(user.Searchusers[index]);
        navigateTo(context: context,screen: ShowUserProfile());


      },
      child: Container(color: Colors.white54,child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.transparent,radius: 28,backgroundImage: CachedNetworkImageProvider(user.Searchusers[index].image??'')),
          SizedBox(width: 10,),
          UserSideInfoWidgets(UserDate:user.Searchusers[index] ),
          Spacer(),
          InkWell(onTap: () {
            if((user.userinfo?.followIds?.contains(user.Searchusers[index].id.toString())??true)){
              Follow.RemoveFollows3(context: context,userid:user.Searchusers[index].id );
            }else{

              Follow.SentFollow3(context: context,userid:user.Searchusers[index].id );
            }

          },child: Image.asset((user.userinfo?.followIds?.contains(user.Searchusers[index].id.toString() )??true)?Images.followed:Images.follow,width: 40))
        ],



      )),
    ),

  ),),
),
    );
  }
}
