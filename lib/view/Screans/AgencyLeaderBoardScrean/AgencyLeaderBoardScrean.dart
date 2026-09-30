import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/AgencyScrean/SearchForAgency.dart';
import 'package:ahlachat/view/Screans/Family/SearchFamily.dart';
import 'package:ahlachat/view/Screans/MainScreans/ProfileScrean/MyagencyProfile.dart';
import 'package:ahlachat/view/widgets/AgecnySideInfo.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AgencyLeaderBoardScrean extends StatefulWidget {

  @override
  State<AgencyLeaderBoardScrean> createState() => _AgencyLeaderBoardScreanState();
}

class _AgencyLeaderBoardScreanState extends State<AgencyLeaderBoardScrean> with TickerProviderStateMixin{
  late TabController _tabController;
@override
  void initState() {
  _tabController = TabController(length:2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);
    return Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/Agencyrank.png'),fit: BoxFit.cover)),
      child: Scaffold(backgroundColor: Colors.transparent,  appBar: AppBar(centerTitle: false,automaticallyImplyLeading: true,leading:  IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ) ,actions: [  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
          icon: Image.asset(Images.SearchIcon, color: Colors.white,height: 23),
          onPressed: () => navigateTo(context: context, screen: SearchAgencyScrean()),
        ),
      )],backgroundColor: Colors.transparent,title: Text(getLang(context: context, key:"Agency"),style: style1,)),
        body: Container(color: Colors.transparent,
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: DefaultTabController( length: 2,
            child: Column(
              children: [
                SizedBox(height: 20,),
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
                      labelColor: MainColor,labelStyle: style1.copyWith(color: MainColor,height: 1.0,fontWeight: FontWeight.bold,fontSize: 12),
                      unselectedLabelColor: whitecolor,
                      tabs:    [
                        Tab(text: getLang(key: "Reciver",context: context)   ),
                        Tab(text:  getLang(key: "Giver",context: context)),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:  Radius.circular(20),)),
                  child:  TabBarView(controller: _tabController,children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(children:List.generate(Agency.LeaderBoardAgency?.supported?.length??0, (index) =>
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                          onTap: () {
                              Agency.GetAgencyinfo(context: context,info:Agency.LeaderBoardAgency?.supported![index].Agency);
                              navigateTo(context: context, screen: MyAgencyScrean());
                          },
                          child: Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  if(index==0)Image.asset(Images.AgencyRank1,height: 28),
                                  if(index==1)Image.asset(Images.AgencyRank2,height: 28),
                                  if(index==2)Image.asset(Images.AgencyRank3,height: 28),
                                  if(index>=3)  Text((index+1).toString(),style: style2),
                                  if(index>=3)SizedBox(width: 10,),
                                  CircleAvatar(backgroundColor: Colors.transparent,radius: 22,backgroundImage: CachedNetworkImageProvider(Agency.LeaderBoardAgency?.supported![index].Agency?.image??'')),
                                SizedBox(width: 5,),
                                  AgencySideInfo(AgencyDate:Agency.LeaderBoardAgency?.supported![index].Agency,TextColor: Colors.black,),
                           Spacer(),
                              Center(child: Text('${Helper().k_m_b_generator(int.parse(Agency.LeaderBoardAgency?.supported![index].coins??'0')).toString()} 🔥',style: style1.copyWith(color: MainColor,height: 1,fontSize: 15),)),
                                ],
                              ),
                          ),
                        ),
                            ))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(children:List.generate(Agency.LeaderBoardAgency?.supporter?.length??0, (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell( 
                            onTap: () {
                              Agency.GetAgencyinfo(context: context,info:Agency.LeaderBoardAgency?.supporter![index].Agency);
                              navigateTo(context: context, screen: MyAgencyScrean());
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 5,),
                                  if(index==0)Image.asset(Images.AgencyRank1,height: 28),
                                  if(index==1)Image.asset(Images.AgencyRank2,height: 28),
                                  if(index==2)Image.asset(Images.AgencyRank3,height: 28),
                                  if(index>=3)  Text((index+1).toString(),style: style2),
                                  if(index>=3)SizedBox(width: 10,),
                                  SizedBox(width: 5,),
                                  CircleAvatar(backgroundColor: Colors.transparent,radius: 22,backgroundImage: CachedNetworkImageProvider(Agency.LeaderBoardAgency?.supporter![index].Agency?.image??'')),
                                  SizedBox(width: 5,),
                                  AgencySideInfo(AgencyDate:Agency.LeaderBoardAgency?.supporter![index].Agency,TextColor: Colors.black,),
                                  Spacer(),
                                  Center(child: Text('${Helper().k_m_b_generator(int.parse(Agency.LeaderBoardAgency?.supporter![index].coins??'0')).toString()} 🔥',style: style1.copyWith(color: MainColor,height: 1,fontSize: 15),)),
                                ],
                              ),
                            ),
                          ),
                        ))),
                      ),
                    ),
                  ],),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
