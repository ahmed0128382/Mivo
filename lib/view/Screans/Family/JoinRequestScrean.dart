import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class JoinRequestScrean extends StatelessWidget {
  const JoinRequestScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context,key: "Join_Requests"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: Family.FamilyRequests.length,itemBuilder: (context, index) => Padding(

          padding: const EdgeInsets.only(top: 10),

          child:Container(color: Colors.white54,child: Row(
            children: [
              InkWell(onTap: () {
                if(user.userinfo?.id!=Family.FamilyRequests[index].user?.id){
                  user.GetShoweduserProfile(Family.FamilyRequests[index].user);
                  navigateTo(context: context,screen: ShowUserProfile());
                }

              },
                child: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(backgroundColor: Colors.transparent,radius: 28,backgroundImage: CachedNetworkImageProvider( Family.FamilyRequests[index].user?.image??'')),
                    SizedBox(width: 10,),
                    UserSideInfoWidgets(UserDate: Family.FamilyRequests[index].user ),
                  ],
                ),
              ),

              Spacer(),
              if(Family.CurrentFamily?.userId==user.userinfo?.id&&user.userinfo?.id!=Family.FamilyRequests[index].user!.id)       SizedBox(height: 20,
                child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:  Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                    onSelected: (value) {
                      if(value=='0'){
                        Family.AcceptFamilyRequest(joinid:  Family.FamilyRequests[index].id);
                      }else{
                        Family.CancleMemberJoinRequest(joinid: Family.FamilyRequests[index].id,userid:Family.FamilyRequests[index].user?.id );
                      }

                    },
                    itemBuilder: (BuildContext bc) {
                      return   [
                          PopupMenuItem(
                          child: Text(getLang(context: context,key: "Accept"),style: style6,),
                          value: '0',
                        ),
                          PopupMenuItem(
                          child: Text(getLang(context: context,key: "Cancle"),style: style6,),
                          value: '1',
                        ),
                      ];}),
              )
            ],



          )),

        ),),
      ),
    );
  }
}
