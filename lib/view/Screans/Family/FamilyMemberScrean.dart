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
class FamilyMemberScrean extends StatelessWidget {
  const FamilyMemberScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context,key: "Family_Members"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: Family.FamilyMembers.length,itemBuilder: (context, index) => Padding(

          padding: const EdgeInsets.only(top: 10),

          child:Container(color: Colors.white54,child: Row(
            children: [
              InkWell(onTap: () {
                if(user.userinfo?.id!=Family.FamilyMembers[index].id){
                  user.GetShoweduserProfile(Family.FamilyMembers[index]);
                  navigateTo(context: context,screen: ShowUserProfile());
                }

              },
                child: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(backgroundColor: Colors.transparent,radius: 28,backgroundImage: CachedNetworkImageProvider( Family.FamilyMembers[index].image??'')),
                    SizedBox(width: 10,),
                    UserSideInfoWidgets(UserDate: Family.FamilyMembers[index] ),
                  ],
                ),
              ),

              Spacer(),
         if(Family.CurrentFamily?.userId==user.userinfo?.id&&user.userinfo?.id!=Family.FamilyMembers[index].id)       SizedBox(height: 20,
                child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                    onSelected: (value) {
if(value=='0'){
  Family.RemoveFamilyMember(userid: Family.FamilyMembers[index].id);
}

                    },
                    itemBuilder: (BuildContext bc) {
                      return   [
                          PopupMenuItem(
                          child: Text(getLang(context: context,key: "Leave_Family"),style: style6,),
                          value: '0',
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
