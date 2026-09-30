import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/CreateFamilyCondition.dart';
import 'package:ahlachat/view/Screans/Family/FamilyRankWedgit.dart';
import 'package:ahlachat/view/Screans/Family/SearchFamily.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../util/images.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class LeaderboardFamilyScrean extends StatefulWidget {
  const LeaderboardFamilyScrean({Key? key}) : super(key: key);

  @override
  State<LeaderboardFamilyScrean> createState() => _LeaderboardFamilyScreanState();
}

class _LeaderboardFamilyScreanState extends State<LeaderboardFamilyScrean> {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel Family = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/eh.png'),fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(centerTitle: false,automaticallyImplyLeading: true,leading:  IconButton(
            icon: Icon(Icons.navigate_before, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ) ,actions: [  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
            icon: Image.asset(Images.SearchIcon, color: Colors.white,height: 23),
            onPressed: () => navigateTo(context: context, screen: SearchFamilyScrean()),
          ),
      )],backgroundColor: Colors.transparent,title: Text(getLang(context: context, key: "Family"),style: style1,)),
        body:    Stack(alignment: Alignment.center,
          children: [
            DefaultTabController(length: 3,
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
                        FamilyRankWidget(FamilyList: Room.LeaderboardFamily?.dailysupporter,),
                        FamilyRankWidget(FamilyList: Room.LeaderboardFamily?.weeklysupporter,),
                        FamilyRankWidget(FamilyList: Room.LeaderboardFamily?.monthlysupporter,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
         if(user.userinfo?.MyFamil==null)   Align(alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
                child: InkWell(onTap: () {
                  navigateTo(context: context,screen: CreateFamilyCondition());
                },child: Container(height: 45,width: SizeConfig.screenWidth,child: Center(child: Text(getLang(key: "Create_Family",context: context),style: style2.copyWith(height: 1),)),decoration: BoxDecoration(color:Color(0xFFf3c98d),borderRadius: BorderRadius.circular(10)),)),
              ),
            )
          ],
        )
      ),
    );
  }
}
