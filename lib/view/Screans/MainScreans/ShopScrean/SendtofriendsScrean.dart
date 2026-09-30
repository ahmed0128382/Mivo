
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';

import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class SendToFriendsScrean extends StatelessWidget {
  const SendToFriendsScrean({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: true);
    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);

    return Scaffold( appBar: AppBar( backgroundColor: Colors.transparent,iconTheme: IconThemeData(color: Colors.black), centerTitle: false,elevation: 0,title: Text(getLang(context: context,key: "Friends"),style: style6.copyWith(fontSize: 19,color:Colors.black87),)),


      body: SingleChildScrollView(
        child: Column(children: List.generate(Follow.Friends.length, (index) =>InkWell( onTap:(){

          Shop.SendByeShop(context: context,userid: Follow.Friends[index].id);
          Navigator.pop(context);


        },
          child: Container(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                CircleAvatar(backgroundColor: Colors.transparent,radius: 30,backgroundImage: CachedNetworkImageProvider(Follow.Friends[index].image??'')),

                SizedBox(width: 6,),
                UserSideInfoWidgets(UserDate:  Follow.Friends[index]),



              ],
            ),
          ) ),
        )),),
      ),
    );
  }
}
class SendrelationshipToFriendsScrean extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: true);
    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);

    return Scaffold( appBar: AppBar( backgroundColor: Colors.transparent,iconTheme: IconThemeData(color: Colors.black), centerTitle: false,elevation: 0,title: Text(getLang(context: context,key: "Friends"),style: style6.copyWith(fontSize: 19,color:Colors.black87),)),


      body: SingleChildScrollView(
        child: Column(children: List.generate(Follow.Friends.length, (index) =>InkWell( onTap:(){


          Navigator.pop(context,Follow.Friends[index]);


        },
          child: Container(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                CircleAvatar(backgroundColor: Colors.transparent,radius: 30,backgroundImage: CachedNetworkImageProvider(Follow.Friends[index].image??'')),

                SizedBox(width: 6,),
                UserSideInfoWidgets(UserDate:  Follow.Friends[index]),



              ],
            ),
          ) ),
        )),),
      ),
    );
  }
}