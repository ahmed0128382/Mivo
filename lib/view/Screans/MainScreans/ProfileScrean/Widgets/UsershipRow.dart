import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/FollowScreans/FanScrean.dart';
import 'package:ahlachat/view/Screans/FollowScreans/FollowingScrean.dart';
import 'package:ahlachat/view/Screans/FollowScreans/FriendsScrean.dart';
import 'package:ahlachat/view/Screans/FollowScreans/VisitorsScrean.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:provider/provider.dart';
class FollwoingRowWidget extends StatelessWidget {
  const  FollwoingRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FollowViewModel follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);


    return  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(onTap: ()
        {follow.GetmyVisitors(context: context);
          navigateTo(context: context, screen: VisitorsScrean());

                },child: followRowWidget(name:getLang(context: context, key: "Visitors")  ,num:user.userinfo?.visitors.toString())),
        InkWell(onTap: ()
        {

          follow.GetFriends(context: context);

          navigateTo(context: context, screen:  FriendsScrean());

          },child: followRowWidget(name: getLang(context: context, key: "Friends") ,num:user.userinfo?.friends.toString())),
    InkWell(onTap: (){
      follow.GetFollowing(context: context);
      navigateTo(context: context, screen:  FollowingScrean());
    },child: followRowWidget(name: getLang(context: context, key: "Following")  ,num:user.userinfo?.following.toString())),
    InkWell(onTap: ()
    {
      follow.Getmyfans(context: context);

      navigateTo(context: context, screen:  FanScrean());
      },child: followRowWidget(name: getLang(context: context, key: "Fans") ,num:user.userinfo?.followers.toString()))
      ],
    );
  }
}
//01061078946
Widget  followRowWidget({String ?num,String? name}){
  return    Column(
    children: [
      Text(num??'',style:TextStyle().copyWith(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
      SizedBox(height: 5,),
      Text(name??"",style: style5.copyWith(color: Colors.black87.withOpacity(0.7),fontSize: 15,height: 1, fontWeight: FontWeight.normal)),
    ],
  );
}