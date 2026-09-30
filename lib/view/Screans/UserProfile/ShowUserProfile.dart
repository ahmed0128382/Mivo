
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';

import 'package:ahlachat/view/Screans/UserProfile/AddImageProfileScrean.dart';
import 'package:ahlachat/view/Screans/UserProfile/HonorWall.dart';
import 'package:ahlachat/view/Screans/UserProfile/ProfileView.dart';
import 'package:ahlachat/view/Screans/UserProfile/UserPostsWidgets.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:ahlachat/viewmodels/Relations_ViewModel/RelationsViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class ShowUserProfile extends StatefulWidget {

  @override
  State<ShowUserProfile> createState() => _ShowUserProfileState();
}

class _ShowUserProfileState extends State<ShowUserProfile> {

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);
    RelationsViewModel Relation=  Provider.of<RelationsViewModel>(context,listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return SafeArea(
      child: Scaffold(
        body: Stack(
     children: [

       DefaultTabController(
            length: 2,
            child: NestedScrollView(


              headerSliverBuilder: (context,isScolled){
                return [

                  SliverAppBar(pinned: false,
                    backgroundColor: Colors.transparent,
                    collapsedHeight: 300,
                    expandedHeight: 300,iconTheme: IconThemeData(color: Colors.black),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: CircleAvatar(  radius: 16,backgroundColor: Colors.black12,child: Icon(Icons.navigate_before, color: Colors.white,size: 30)),
                onPressed: () => Navigator.of(context).pop(),
                ) ,
                    actions: [
                 if(user.userProfileData?.id!=user.userinfo?.id)     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CircleAvatar(backgroundColor: Colors.black12,
                          radius: 16,
                          child: SizedBox(height: 20,
                                                child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                ),
                                                    onSelected: (value) {
                                                      if(value=='Report'){
                                                        posts.ReportUser(UserId:  user.userProfileData?.id);
                                                      }else{
                                                        posts.BlockUser(UserId:  user.userProfileData?.id);
                                                      }
// your logic
                                                    },
                                                    itemBuilder: (BuildContext bc) {
                                                      return   [
                                                        PopupMenuItem(
                                                          child: Text(getLang(context: context,key: "Report"),style: style6,),
                                                          value: 'Report',
                                                        ),
                                                        PopupMenuItem(
                                                          child: Text(getLang(context: context,key: "Block_User"),style: style6,),
                                                          value: 'Block',
                                                        ),];}),
                                              ),
                        ),
                      ),
                      if(user.userProfileData?.id==user.userinfo?.id)     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                      navigateTo(context: context, screen: AddImageProfileScrean());
                          },
                          child: CircleAvatar(backgroundColor: Colors.black12,
                              radius: 16,
                              child: Icon(Icons.edit_note_rounded,color: Colors.white,)
                          ),
                        ),
                      ),
                      if(user.userProfileData?.id==user.userinfo?.id)     Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            Relation.GetUserRelation(context: context);
                          },
                          child: CircleAvatar(backgroundColor: Colors.black12,
                              radius: 16,
                              child: Icon(Icons.star,color: Colors.white,)
                          ),
                        ),
                      )
],
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ProfileView(),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: MyDelegate(
                      TabBar(

                          indicatorColor:Colors.black,labelStyle: style2,
                          labelColor: Colors.black, indicator: MaterialIndicator(
                        height: 3,
                        topLeftRadius: 0,
                        topRightRadius: 0,
                        bottomLeftRadius: 5,horizontalPadding: 25,
                        bottomRightRadius: 5,color:Colors.blueGrey,
                        tabPosition: TabPosition.bottom,
                      ),
                          unselectedLabelColor: Colors.black,
                          isScrollable: true,automaticIndicatorColorAdjustment: true,
                          tabs: [
                            Tab(
                              text: getLang( context: context,key: "Honor_wall")  ,
                            ),
                            Tab(
                              text: getLang( context: context,key: "Moments"),
                            ),
                          ]
                      ),
                    )
                   ,floating: false,
                    pinned: true,
                  )
                ];
              },
              body:   TabBarView(
                children:[

               HonorWallWidget()  ,
                  CustomScrollView(physics: BouncingScrollPhysics(),slivers: [
                    SliverToBoxAdapter(child:  UserPostsWidgets(),)
                  ],),
                ]
              ),
            ),
          ),
    if(user.userProfileData?.id!=user.userinfo?.id)   Align(alignment: Alignment.bottomCenter,child: Container( decoration: BoxDecoration(color: Colors.white,gradient: LinearGradient(colors: [
         Colors.white,
         Colors.white,
         Colors.white.withOpacity(0.5),
       ],begin: Alignment.bottomCenter,end: Alignment.topCenter )),height: 100,child: DelayedDisplay(delay: Duration(seconds:1),
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Align(
             alignment: Alignment.bottomCenter,
             child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
               InkWell(onTap: () {
                 if((user.userinfo?.followIds?.contains(user.userProfileData?.id.toString()??'')??true)){
                   Follow.RemoveFollows3(context: context,userid:user.userProfileData?.id );
                 }else{

                   Follow.SentFollow3(context: context,userid:user.userProfileData?.id );
                 }

               },child: Image.asset((user.userinfo?.followIds?.contains(user.userProfileData?.id.toString()??'')??true)?Images.followed:Images.follow,width: 80)),
               InkWell(onTap: () {
                 user.GetInBoxChat(context: context,userid: user.userProfileData?.id??'', user: user.userProfileData );
               },child: Image.asset( Images.chat ,width: 80)),
               if(user.userProfileData?.CurrentRoom!=null)      InkWell(onTap: () {
                 Room.EnterRoom(id:user.userProfileData?.CurrentRoom?.roomId,adminId:user.userProfileData?.CurrentRoom?.userId,context: context );

               },child: Image.asset(Images.enterroom,width: 80)),
               if(user.userProfileData?.MyRoom!=null)    InkWell(onTap: () {
                 Room.EnterRoom(id:user.userProfileData?.MyRoom?.id,adminId:user.userProfileData?.MyRoom?.adminId,context: context );




               },child: Image.asset(Images.tracking,width: 80)),


             ]),
           ),
         ),
       ),)),
     if(user.userProfileData?.bubbles!=null&&user.userProfileData?.bubbles!='')  SVGASimpleImage(resUrl:AppConstants.Image_URL+  user.userProfileData?.bubbles)

     ],
        ),
      ),
    );
  }
}


class MyDelegate extends SliverPersistentHeaderDelegate{
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
