import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyMemberListeader.dart';

import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class MemberFamilyRank extends StatelessWidget {
  const MemberFamilyRank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    print(Room.LeaderboardRoom?.dailysupporter?.length);
    return Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/eh.png'),fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(centerTitle: false,automaticallyImplyLeading: true,backgroundColor: Colors.transparent,title: Text(getLang(context: context,key: "Members_Rank"),style: style1,)),
        body:    DefaultTabController(length: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:15 ),
                child: TabBar(    indicator: MaterialIndicator(
                  height: 3,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 5,horizontalPadding: 25,
                  bottomRightRadius: 5,color:  Colors.amberAccent,
                  tabPosition: TabPosition.bottom,
                ),
                    isScrollable: true,
                    labelStyle: style3.copyWith(fontSize: 14),indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                    unselectedLabelColor: Colors.white54,
                    labelColor:    Colors.amberAccent,
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
              Expanded(
                child: TabBarView(
                  children:  [
                    FamilyMemberListLeader( LeaderList: Family.MemberFamilyLeaderBoard?.dailysupporter),
                    FamilyMemberListLeader( LeaderList: Family.MemberFamilyLeaderBoard?.weeklysupporter),
                    FamilyMemberListLeader( LeaderList: Family.MemberFamilyLeaderBoard?.monthlysupporter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
