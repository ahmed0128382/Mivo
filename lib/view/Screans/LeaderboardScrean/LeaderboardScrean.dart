import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/LeaderboardScrean/Room/RoomListLeaderBoard.dart';
import 'package:ahlachat/view/Screans/LeaderboardScrean/Users/UserListLeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../util/images.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class LeaderboardScrean extends StatefulWidget {
  const LeaderboardScrean({Key? key}) : super(key: key);

  @override
  State<LeaderboardScrean> createState() => _LeaderboardScreanState();
}

class _LeaderboardScreanState extends State<LeaderboardScrean> with TickerProviderStateMixin  {
  late TabController _tabController;
  late TabController _tabController2;
  late TabController _tabController3;
  late TabController _tabController4;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)..addListener(() {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Provider.of<RoomViewmodel>(context,listen: false).SelectedLeader(_tabController.index);

      });

      if(_tabController.index==1&&!Provider.of<RoomViewmodel>(context,listen: false).GetGiverLeadestatr){
        Provider.of<RoomViewmodel>(context,listen: false).GetGiverLeaderboard(context: context);
      }
      else if(_tabController.index==0&&!Provider.of<RoomViewmodel>(context,listen: false).GetReciverLeadestatr){
        Provider.of<RoomViewmodel>(context,listen: false).GetReciverLeaderboard(context: context);

      }
    });
    _tabController.animateTo(2);

    _tabController2 = TabController(length:3, vsync: this);
    _tabController3 = TabController(length:3, vsync: this);
    _tabController4 = TabController(length:3, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
     RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.LeadBoard),fit: BoxFit.cover)),
      child: DefaultTabController(length: 3,
        child: Scaffold(
          backgroundColor: Room.LeaderShipColor,
          appBar: AppBar( backgroundColor: Colors.transparent, centerTitle: true,elevation: 0,title: Text(getLang(key: "PlatForm",context: context),style: style6.copyWith(fontSize: 19,color:Colors.white),)),
          body: Column(
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15 ),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child:  TabBar(controller: _tabController,
                    indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius:  BorderRadius.circular(25.0)
                    ) ,
                    labelColor: MainColor,labelStyle: style1.copyWith(color: MainColor,height: 1.5,fontWeight: FontWeight.normal,fontSize: 12),
                    unselectedLabelColor: whitecolor,
                    tabs:    [
                      Tab(text: getLang(key: "Reciver",context: context)   ),

                      Tab(text:  getLang(key: "Giver",context: context)),
                      Tab(text:  getLang(key: "Room",context: context)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
                Expanded(
                  child: Container(color: Colors.transparent,
                    child: TabBarView(controller: _tabController,children: [
                      DefaultTabController(length:3,child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15 ),
                            child: TabBar(  indicator: MaterialIndicator(
                              height: 3,
                              topLeftRadius: 0,
                              topRightRadius: 0,
                              bottomLeftRadius: 5,horizontalPadding: 25,
                              bottomRightRadius: 5,color:  Colors.white,
                              tabPosition: TabPosition.bottom,
                            ),
                                isScrollable: true,controller: _tabController2,
                                labelStyle: style3.copyWith(fontSize: 14),indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,
                                onTap: (val) {},

                                tabs:   [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Daily"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text:getLang(context: context,key: "Weekly"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text:getLang(context: context,key: "Monthly"),
                                    ),
                                  ),


                                ]
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Expanded(
                            child: TabBarView(controller: _tabController2,
                              children: [

                                UserListLeader(LeaderList:Room.Leaderboardsupported?.dailysupporter,),
                                UserListLeader(LeaderList:Room.Leaderboardsupported?.weeklysupporter,),
                                UserListLeader(LeaderList:Room.Leaderboardsupported?.monthlysupporter,)
                              ],
                            ),
                          )
                        ],
                      ),),
                      DefaultTabController(length:3,child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15 ),
                            child: TabBar(  indicator: MaterialIndicator(
                              height: 3,
                              topLeftRadius: 0,
                              topRightRadius: 0,
                              bottomLeftRadius: 5,horizontalPadding: 25,
                              bottomRightRadius: 5,color:  Colors.white,
                              tabPosition: TabPosition.bottom,
                            ),
                                isScrollable: true,controller: _tabController3,
                                labelStyle: style3.copyWith(fontSize: 14),indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,
                                onTap: (val) {},

                                tabs:   [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Daily"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Weekly"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Monthly"),
                                    ),
                                  ),


                                ]
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Expanded(
                            child: TabBarView(controller: _tabController3,
                              children: [

                                UserListLeader(LeaderList:Room.LeaderboardSupporter?.dailysupporter,),
                                UserListLeader(LeaderList:Room.LeaderboardSupporter?.weeklysupporter,),
                                UserListLeader(LeaderList:Room.LeaderboardSupporter?.monthlysupporter,)
                              ],
                            ),
                          )
                        ],
                      ),),
                      DefaultTabController(length:3,child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:15 ),
                            child: TabBar(  indicator: MaterialIndicator(
                              height: 3,
                              topLeftRadius: 0,
                              topRightRadius: 0,
                              bottomLeftRadius: 5,horizontalPadding: 25,
                              bottomRightRadius: 5,color:  Colors.white,
                              tabPosition: TabPosition.bottom,
                            ),
                                isScrollable: true,controller: _tabController4,
                                labelStyle: style3.copyWith(fontSize: 14),indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,
                                onTap: (val) {},

                                tabs:   [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Daily"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text:getLang(context: context,key: "Weekly"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Tab(
                                      text: getLang(context: context,key: "Monthly"),
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Expanded(
                            child: TabBarView(controller: _tabController4,
                              children: [
                                RoomListLeader(LeaderList:Room.LeaderboardRoom?.dailysupporter,),
                                RoomListLeader(LeaderList:Room.LeaderboardRoom?.weeklysupporter,),
                                RoomListLeader(LeaderList:Room.LeaderboardRoom?.monthlysupporter,)
                              ],
                            ),
                          )
                        ],
                      ),),
              ]),
                  ),
                )


            ],
          ),
        ),
      ),
    );
  }
}
