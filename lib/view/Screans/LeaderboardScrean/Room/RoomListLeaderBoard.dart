import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/LeaderboardScrean/Room/RoomRankWidget.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RoomListLeader extends StatelessWidget {
 List<LeaderboardRoommodel> ?LeaderList=[];

 RoomListLeader({required this.LeaderList});

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
    return  CustomScrollView(   physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(width: SizeConfig.screenWidth,decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Rooms.LeaderShipBack),fit: BoxFit.cover)),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if((LeaderList?.length??0)>1)    RoomRankWidget(image:Rooms.SelectedRank['rank2'],Leader:LeaderList![1], ),
                if((LeaderList?.length??0)!=0)  RoomRankWidget(image:Rooms.SelectedRank['rank1'],Leader:LeaderList![0], ),
                if((LeaderList?.length??0)>2)      RoomRankWidget(image:Rooms.SelectedRank['rank3'],Leader:LeaderList![2], ),

              ],
            ),
          ),
        ),
        SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
        if((LeaderList?.skip(3).length??0)>0)    SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:Radius.circular(20), )),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children:List.generate((LeaderList?.skip(3).length)??0 , (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(onTap:(){

                      Rooms.EnterRoom(id:LeaderList![index+3].room?.id,adminId:LeaderList![index+3].room?.adminId,context: context );



                                },
                      child: Container( color: Colors.white,child: Row(
                        children: [
                          Container(width: 20,child: Center(child: Text((index+3).toString(),style: TextStyle(color: Colors.black45),))),
                          SizedBox(width: 5,),
                          CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(LeaderList![index+3].room?.image??''),),
                          SizedBox(width: 5,),
                          Text(LeaderList![index+3].room?.name??'',style:style2.copyWith(height: 1,fontSize:12,color: Colors.black) ,),
                          Spacer(),
                          Row(
                            children: [
                              Text( Helper().k_m_b_generator(int.parse(LeaderList![index+3].coins??''))  ,style: style7.copyWith(height: 1,fontSize:12,fontWeight: FontWeight.normal,color:  Colors.black)),
                              SizedBox(width: 5,),
                              Image.asset(Images.coins,width: 13),
                            ],
                          ),
                          SizedBox(width: 5,),
                        ],
                      )),
                    ),
                  )),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
