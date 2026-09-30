import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/CircleProgress.dart';

class ShareRoomScrean extends StatelessWidget {
  const ShareRoomScrean({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black),title: Text(getLang(context: context, key: "ShareRoom_Friends"),style: style1.copyWith(color: MainColor,fontSize: 14),)),
      body: SingleChildScrollView(
        child: Column(children: List.generate(Follow.Friends.length, (index) =>Container(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [

              CircleAvatar(backgroundColor: Colors.transparent,radius: 20,backgroundImage: CachedNetworkImageProvider( Follow. Friends[index].image??'')),
              const     SizedBox(width: 10,),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserSideInfoWidgets(TextColor: Colors.black,UserDate:Follow.Friends[index] ),
                  InkWell(onTap: (){

                       Follow.sentShareRoom(context: context,userid: Follow.Friends[index].id);

                    },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(5)),child: Center( child:  Text( getLang(context: context,key: "Send"),style: style6.copyWith(color: whitecolor))),height: 25 ,width: 60,))
                  ],
                ),
              ),

            ],
          ),
        ) )),),
      ),
    );
  }
}
