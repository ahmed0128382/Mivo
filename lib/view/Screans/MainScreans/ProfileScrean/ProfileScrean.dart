import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/view/Screans/AgencyLeaderBoardScrean/AgencyLeaderBoardScrean.dart';

import 'package:ahlachat/view/Screans/Family/FamilyProfileScrean.dart';
import 'package:ahlachat/view/Screans/HostreportScrean/HostreportScrean.dart';
import 'package:ahlachat/view/Screans/LanguageScrean/LanguageScrean.dart';
import 'package:ahlachat/view/Screans/LevelScrean/LevelScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/ProfileScrean/ContactUs.dart';
import 'package:ahlachat/view/Screans/MainScreans/ProfileScrean/MyagencyProfile.dart';

import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';

import 'package:ahlachat/view/widgets/ProfileSideInfo.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Levels_ViewModel/Level_ViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';

import 'package:ahlachat/viewmodels/Vip_ViewModel/Vip_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/app_constants.dart';

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/ProfileScrean/Widgets/UsershipRow.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



import 'package:provider/provider.dart';

import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class ProfileScrean extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    VipViewmodel Vips=  Provider.of<VipViewmodel>(context,listen: true);
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);
    LevelViewModel  Level=Provider.of<LevelViewModel>(context,listen:  true);
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  false);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: false);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return Scaffold(backgroundColor: Colors.transparent,
     appBar: AppBar(backgroundColor: Colors.transparent,titleSpacing: 0,automaticallyImplyLeading: false,
    leading: IconButton(icon:  Image.asset('assets/image/ic_me_noble.png',height: 25,width: 25), onPressed: (){
     Agency.GetAgencyLeaderBoard();
     navigateTo(context: context, screen: AgencyLeaderBoardScrean());
    },),
    actions: [
      IconButton(
        icon: Image.asset(Images.Setting,height: 25),
        onPressed: (){
         // NotificationService().instantNofitication(tittle:'message.notification?.title',body: 'message.notification?.title');
        // LocalNotificationService().showNotification(body: ';asd',id: 1, title: 'asdasdasd',  );
        Navigator.pushNamed(context, AppConstants.Edit_Profile);

        },
      )
    ],

    ),
     body: Padding( 
       padding: const EdgeInsets.symmetric(horizontal: 10),
       child: CustomScrollView(  physics: BouncingScrollPhysics(),
         slivers: [
           SliverToBoxAdapter(
             child: InkWell(onTap:() {
               user.GetShoweduserProfile(user.userinfo);
               navigateTo(context: context, screen: ShowUserProfile());
             } ,
               child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CircleAvatar(radius: 38,backgroundColor: whitecolor,backgroundImage: CachedNetworkImageProvider(user.userinfo?.image??Images.profilephoto)),
                   SizedBox(width: 10,),
                   ProfileSideInfoWidgets(UserDate: user.userinfo),
                   Spacer(),
                   Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 35,)



                 ],

               ),
             ),
           ),
           SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
           const SliverToBoxAdapter(
             child:FollwoingRowWidget()
           ),
           const SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),

           SliverToBoxAdapter(
               child:Row(
                 children: [
                   Expanded(child: InkWell(
                     onTap: (){
                       Navigator.pushNamed(context,AppConstants.Recharge_Screan);
                     },
                     child: Container(height:70 ,child:Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         const SizedBox( width: 5,),
                         Image.asset(Images.RechargecoinsIcon,height: 45),
                         const SizedBox( width: 7,),
                         Column(crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Flexible(child: Text(getLang(context: context,key:"Recharge"),style: TextStyle(height: 1,fontSize: 16,color:  Color(0xFFff8848),fontWeight: FontWeight.w600),)),

                             Text(getLang(context: context,key:"Balance")+" : ${user.userinfo?.coins??''}",style: TextStyle(fontSize: 10),)
                           ],
                         ),
                         Icon(Icons.navigate_next,color:Color(0xFFff8848),size: 30,)
                       ],
                     ),decoration: BoxDecoration(color: Color(0xFFfff4e6),borderRadius: BorderRadius.circular(10)),),
                   )) ,
                       const SizedBox( width: 10,),
                       Expanded(child: InkWell(onTap: () {
                         Vips.GetVips(context: context);
                         Navigator.pushNamed(context,AppConstants.Vip_Screan);
                       },
                         child: Container(height:70 ,child:Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [

                             Image.asset(Images.VipIcon,height: 45),

                             Flexible(child: Text(getLang(key: "Vip_Center",context: context),style: TextStyle(height: 1,fontSize: 16,color:  Color(0xFF9d3ce1),fontWeight: FontWeight.w600),)),
                             Icon(Icons.navigate_next,color:Color(0xFF9d3ce1),size: 30,)
                           ],
                         ),decoration: BoxDecoration(color: Color(0xFFf5ecff),borderRadius: BorderRadius.circular(10)),),
                       )) ,
                 ],
               )
           ),
           const SliverPadding(padding: EdgeInsets.symmetric(vertical: 3)),
             SliverToBoxAdapter(
               child:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   InkWell(onTap: () {
                     user.UserGifts(context: context);
                     Navigator.pushNamed(context, AppConstants.User_Gifts);
                   },
                     child: Column(mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset(Images.profileGifts,height: 80),
                         Text(getLang(key:   "gifts",context: context),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,height: 1),)
                       ],
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       Shop.GetBag( context: context);
                     },
                     child: Column(mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset(Images.profilebag,height: 80),
                         Text(getLang(key: "Bag",context: context),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,height: 1),)

                       ],
                     ),
                   ),
                   InkWell( onTap: () {
                     Shop.GetShop(context: context);

                   },
                     child: Column(mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset(Images.profilestore,height: 80),
                         Text(getLang(key: "Shop",context: context),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,height: 1),)
                       ],
                     ),
                   ),
                   InkWell(onTap: () {
                      navigateTo(context: context, screen: LevelScrean());
                   },
                     child: Column(mainAxisSize: MainAxisSize.min,
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Image.asset(Images.profilelevel,height: 80),
                         Text(getLang(key: "Level",context: context),style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,height: 1),)
                       ],
                     ),
                   ),
                 ],
               )
           ),
           const SliverPadding(padding: EdgeInsets.symmetric(vertical: 8)),
           SliverToBoxAdapter(
             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 if(user.userinfo?.agency!=null)       InkWell(
                   onTap: (){

                   Agency.GetAgencyinfo(context: context,info:user.userinfo?.agency);
                   navigateTo(context: context, screen: MyAgencyScrean());

                   },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                          CachedNetworkImage(imageUrl:  user.userinfo?.agency?.image??'',height: 30,width: 30) ,
                           SizedBox(width: 10,),
                           Text(getLang(key: "Agency",context: context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 ),
          if(user.userinfo?.MyFamil!=null)       InkWell(
            onTap: (){
              Family.GetFamily(Val: user.userinfo?.MyFamil);
              navigateTo(context: context,screen: FamilyProfileScrean());
            },
            child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,children: [
                           Image.asset(Family.Levels.where((element) => element['Coins']<=user.userinfo?.MyFamil?.karisma).last['image'],height: 30) ,

                         SizedBox(width: 10,),

                         Text(getLang(key: "Family",context: context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                       ],),
                       Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
          ),
                 if(user.userinfo?.AgencyId!=null)  InkWell(
                   onTap: (){

                     user.GetTargetTime(context: context);

                   },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                           Image.asset(Images.Modif,height: 30) ,

                           SizedBox(width: 10,),

                           Text(getLang(key: "modif",context: context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 ),
                 if(user.userinfo?.MyFamil==null)     SizedBox(height: 8,),
                 if(user.userinfo?.agency==null)
                   InkWell(onTap: () {
                     Navigator.pushNamed(context,AppConstants.Exchange_Screan);

                   },
                     child: Row(
                       children: [
                         Row(crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,children: [
                             Image.asset(Images.jwile,height:30),
                             SizedBox(width: 10,),
                             Text(getLang(context: context,key: "Exchange"),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                           ],),
                         const Spacer(),
                         Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                       ],
                     ),
                   ),
                 SizedBox(height:8,),
                   InkWell(onTap: () {
                   Level.GetModels(context );

                 },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                           Image.asset(Images.profilemodel,height:30),
                           SizedBox(width: 10,),
                             Text(getLang(context: context,key: "Models"),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       const Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 ),
                 SizedBox(height:8,),
                 InkWell(onTap: () {
          navigateTo(context: context, screen: LanguageScrean());
                 },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                           Image.asset(Images.profilelanguage,height:28),
                           SizedBox(width: 10,),
                             Text(getLang(key: "Language",context: context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       const Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 ),
                 SizedBox(height: 8,),
                 InkWell(onTap: () {
                   navigateTo(context: context, screen: ContactUs());
                  },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                           Image.asset(Images.profileReport,height:28),
                           SizedBox(width: 10,),

                           Text(getLang(context: context,key: "Report"),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 ),
                 SizedBox(height: 8,),
                 InkWell(onTap: () {
                   Dialogs().showdialog(context: context, tittle: 'tittle', content: getLang(context: context, key: "Sure_Logout"), buttontext: getLang(context: context, key: "Yes"), onTap: (){
                     Navigator.pop(context);
                    Agora.EndAgora();
                     if(Room.Currentroom!=null){

                       Provider.of<RoomPlayViewModel>(context, listen: false).changeHasRoomstate(false);
                       Provider.of<RoomPlayViewModel>(context, listen: false).changeIsRoomstate(false);
                       JoinChairs=false;
                       Provider.of<SocketViewmodel>(context,listen: false).DisConnect(id: Room.Currentroom?.id.toString());
                       Provider.of<AgoraViewmodel>(context,listen: false).disableAudioroomvoice();
                       Provider.of<AgoraViewmodel>(context,listen: false).stopAudioMexing(context);
                       Room.Currentroom=null;
                     }

                     user.Signout(context: context);
                   });
                 },
                   child: Row(
                     children: [
                       Row(crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,children: [
                    
                           FaIcon(FontAwesomeIcons.signOut,color: MainColor,size: 20),
                           SizedBox(width: 10,),

                           Text(getLang(key: "LogOut",context: context),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,height: 2),)
                         ],),
                       Spacer(),
                       Icon(Icons.navigate_next,color: Colors.grey.withOpacity(0.5),size: 30,)
                     ],
                   ),
                 )

               ],
             ),
           )
         ],
       ),
     )
    );
  }
}

