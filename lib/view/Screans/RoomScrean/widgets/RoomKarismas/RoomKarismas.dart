import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class  RoomKarismas extends StatelessWidget {
  const RoomKarismas({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(height: 500,decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )) ,width: SizeConfig.screenWidth!,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 10,),
               TabBar(
                  indicatorColor:Color(0xFFFFD700),indicatorSize: TabBarIndicatorSize.label,indicatorWeight: 2 ,
                  labelColor: Color(0xFFFFD700),
                  unselectedLabelColor: Colors.white70,labelStyle: style1,
                  isScrollable: true,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Tab(
                        child: Text( getLang(context: context,key: "Daily"),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Tab(
                        child: Text(getLang(context: context,key: "Weekly")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Tab(
                        child: Text(getLang(context: context,key: "Monthly")),
                      ),
                    )
                  ]
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: TabBarView(children: [
                  SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.RoomLeader?.dailysupporter?.length??0, (index) =>
                        InkWell(onTap: (
                                () {
                              if(user.userinfo?.id!=Room.RoomLeader?.dailysupporter![index].user?.id){
                                Navigator.pop(context);
                                Room.changeloading13();
                                user.GetShoweduserProfile(Room.RoomLeader?.dailysupporter![index].user);
                                 CheckBlocked=false;
                                Navigator.pushNamed(context,'${AppConstants.ShowUser_Profile}');
                              }

                            }
                        ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.RoomLeader?.dailysupporter![index].user?.image??AppConstants.User_Profile) ),
                                const SizedBox(width: 5,),
                                UserSideInfoWidgets(UserDate: Room.RoomLeader?.dailysupporter![index].user,TextColor: Colors.white,showdescr: 0),
                                const Spacer(),
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text( Room.RoomLeader?.dailysupporter![index].karisma.toString() ??'' ,style: style6.copyWith(color: Colors.white,fontSize: 14) ),
                                    Image.asset(Images.coins,width: 20,height: 20),
                                  ],
                                )


                              ],
                            ),
                          ),
                        )),),
                  ),
                  SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.RoomLeader?.weeklysupporter?.length??0, (index) =>
                        InkWell(onTap: (
                                () {
                              if(user.userinfo?.id!=Room.RoomLeader?.weeklysupporter![index].user?.id){
                                Navigator.pop(context);
                                Room.changeloading13();
                                user.GetShoweduserProfile(Room.RoomLeader?.weeklysupporter![index].user);
                                 CheckBlocked=false;
                                Navigator.pushNamed(context,AppConstants.ShowUser_Profile);
                              }

                            }
                        ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.RoomLeader?.weeklysupporter![index].user?.image??AppConstants.User_Profile) ),
                                const SizedBox(width: 5,),
                                UserSideInfoWidgets(UserDate:Room.RoomLeader?.weeklysupporter![index].user,TextColor: Colors.white,showdescr: 0),
                                const Spacer(),
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text( Room.RoomLeader?.weeklysupporter![index].karisma.toString() ??'' ,style: style6.copyWith(color: Colors.white,fontSize: 14) ),
                                    Image.asset(Images.coins,width: 20,height: 20),
                                  ],
                                )


                              ],
                            ),
                          ),
                        )),),
                  ),
                  SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.RoomLeader?.monthlysupporter?.length??0, (index) =>
                        InkWell(onTap: (
                                () {
                              if(user.userinfo?.id!=Room.RoomLeader?.monthlysupporter![index].user?.id){
                                Navigator.pop(context);
                                Room.changeloading13();
                                user.GetShoweduserProfile(Room.RoomLeader?.monthlysupporter![index].user);
                                 CheckBlocked=false;
                                Navigator.pushNamed(context,'${AppConstants.ShowUser_Profile}');
                              }

                            }
                        ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.RoomLeader?.monthlysupporter![index].user?.image??AppConstants.User_Profile) ),
                                const SizedBox(width: 5,),
                                UserSideInfoWidgets(UserDate:Room.RoomLeader?.monthlysupporter![index].user,TextColor: Colors.white,showdescr: 0),
                                const Spacer(),
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text( Room.RoomLeader?.monthlysupporter![index].karisma.toString() ??'' ,style: style6.copyWith(color: Colors.white,fontSize: 14) ),
                                    Image.asset(Images.coins,width: 20,height: 20),
                                  ],
                                )

                              ],
                            ),
                          ),
                        )),),
                  ),

                ],),
              ),

            ],
          ),
        )



    );
  }
}