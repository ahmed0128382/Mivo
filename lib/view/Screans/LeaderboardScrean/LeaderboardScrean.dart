
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

class _LeaderboardScreanState extends State<LeaderboardScrean>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabController2;
  late TabController _tabController3;
  late TabController _tabController4;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          Provider.of<RoomViewmodel>(
            context,
            listen: false,
          ).SelectedLeader(_tabController.index);
        });

        if (_tabController.index == 1 &&
            !Provider.of<RoomViewmodel>(
              context,
              listen: false,
            ).GetGiverLeadestatr) {
          Provider.of<RoomViewmodel>(
            context,
            listen: false,
          ).GetGiverLeaderboard(context: context);
        } else if (_tabController.index == 0 &&
            !Provider.of<RoomViewmodel>(
              context,
              listen: false,
            ).GetReciverLeadestatr) {
          Provider.of<RoomViewmodel>(
            context,
            listen: false,
          ).GetReciverLeaderboard(context: context);
        }
      });

    _tabController.animateTo(2);

    _tabController2 = TabController(
      length: 3,
      vsync: this,
    );

    _tabController3 = TabController(
      length: 3,
      vsync: this,
    );

    _tabController4 = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController2.dispose();
    _tabController3.dispose();
    _tabController4.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room = Provider.of<RoomViewmodel>(
      context,
      listen: true,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(Images.LeadBoard),
          fit: BoxFit.cover,
        ),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: room.LeaderShipColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0,
            title: Text(
              getLang(
                key: "PlatForm",
                context: context,
              ),
              style: style6.copyWith(
                fontSize: 19,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelColor: MainColor,
                    labelStyle: style1.copyWith(
                      color: MainColor,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    unselectedLabelColor: whitecolor,
                    tabs: [
                      Tab(
                        text: getLang(
                          key: "Reciver",
                          context: context,
                        ),
                      ),
                      Tab(
                        text: getLang(
                          key: "Giver",
                          context: context,
                        ),
                      ),
                      Tab(
                        text: getLang(
                          key: "Room",
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // =====================================================
                      // RECEIVER
                      // =====================================================

                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TabBar(
                                controller: _tabController2,
                                isScrollable: true,

                                // FIX:
                                // Keep this smaller than half of every tab.
                                indicator: MaterialIndicator(
                                  height: 3,
                                  topLeftRadius: 0,
                                  topRightRadius: 0,
                                  bottomLeftRadius: 5,
                                  bottomRightRadius: 5,
                                  horizontalPadding: 4,
                                  color: Colors.white,
                                  tabPosition: TabPosition.bottom,
                                ),

                                labelStyle: style3.copyWith(
                                  fontSize: 14,
                                ),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,

                                tabs: [
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Daily",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Weekly",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Monthly",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: TabBarView(
                                controller: _tabController2,
                                children: [
                                  UserListLeader(
                                    LeaderList: room
                                        .Leaderboardsupported
                                        ?.dailysupporter,
                                  ),
                                  UserListLeader(
                                    LeaderList: room
                                        .Leaderboardsupported
                                        ?.weeklysupporter,
                                  ),
                                  UserListLeader(
                                    LeaderList: room
                                        .Leaderboardsupported
                                        ?.monthlysupporter,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =====================================================
                      // GIVER
                      // =====================================================

                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TabBar(
                                controller: _tabController3,
                                isScrollable: true,

                                // FIX:
                                // Small padding prevents the assertion:
                                // "Padding must be less than half of the size
                                // of the tab"
                                indicator: MaterialIndicator(
                                  height: 3,
                                  topLeftRadius: 0,
                                  topRightRadius: 0,
                                  bottomLeftRadius: 5,
                                  bottomRightRadius: 5,
                                  horizontalPadding: 4,
                                  color: Colors.white,
                                  tabPosition: TabPosition.bottom,
                                ),

                                labelStyle: style3.copyWith(
                                  fontSize: 14,
                                ),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,

                                tabs: [
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Daily",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Weekly",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Monthly",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: TabBarView(
                                controller: _tabController3,
                                children: [
                                  UserListLeader(
                                    LeaderList: room
                                        .LeaderboardSupporter
                                        ?.dailysupporter,
                                  ),
                                  UserListLeader(
                                    LeaderList: room
                                        .LeaderboardSupporter
                                        ?.weeklysupporter,
                                  ),
                                  UserListLeader(
                                    LeaderList: room
                                        .LeaderboardSupporter
                                        ?.monthlysupporter,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // =====================================================
                      // ROOM
                      // =====================================================

                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TabBar(
                                controller: _tabController4,
                                isScrollable: true,

                                // FIX:
                                // Small padding prevents the assertion:
                                // "Padding must be less than half of the size
                                // of the tab"
                                indicator: MaterialIndicator(
                                  height: 3,
                                  topLeftRadius: 0,
                                  topRightRadius: 0,
                                  bottomLeftRadius: 5,
                                  bottomRightRadius: 5,
                                  horizontalPadding: 4,
                                  color: Colors.white,
                                  tabPosition: TabPosition.bottom,
                                ),

                                labelStyle: style3.copyWith(
                                  fontSize: 14,
                                ),
                                unselectedLabelColor: Colors.white54,
                                labelColor: Colors.white,

                                tabs: [
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Daily",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Weekly",
                                    ),
                                  ),
                                  Tab(
                                    text: getLang(
                                      context: context,
                                      key: "Monthly",
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: TabBarView(
                                controller: _tabController4,
                                children: [
                                  RoomListLeader(
                                    LeaderList: room
                                        .LeaderboardRoom
                                        ?.dailysupporter,
                                  ),
                                  RoomListLeader(
                                    LeaderList: room
                                        .LeaderboardRoom
                                        ?.weeklysupporter,
                                  ),
                                  RoomListLeader(
                                    LeaderList: room
                                        .LeaderboardRoom
                                        ?.monthlysupporter,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}