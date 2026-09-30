
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyProfileScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/ProfileScrean/MyagencyProfile.dart';

import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/AgecnySideInfo.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SearchAgencyResults extends StatelessWidget {
  const SearchAgencyResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context, key: "Search_Family"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: Agency.Searchagency.length,itemBuilder: (context, index) => Padding(

          padding: const EdgeInsets.only(top: 10),

          child:InkWell(
            onTap: () {


              Agency.GetAgencyinfo(context: context,info:Agency.Searchagency[index]);
              navigateTo(context: context, screen: MyAgencyScrean());


            },
            child: Container(color: Colors.white54,child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.transparent,radius: 23,backgroundImage: CachedNetworkImageProvider(Agency.Searchagency[index].image??'')),
                SizedBox(width: 10,),
                SizedBox(width: 5,),
                AgencySideInfo(AgencyDate:Agency.Searchagency[index],TextColor: Colors.black,),
                Spacer(),

                Spacer(),
              ],



            )),
          ),

        ),),
      ),
    );
  }
}
