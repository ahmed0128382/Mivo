import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Family/FamilyRankScrean.dart';
import 'package:ahlachat/view/Screans/WeeklyStar/WeeklyStarScrean.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../util/images.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class NewRoomsScrean extends StatelessWidget {
  ScrollController? _controller= ScrollController();
  int showed_ads = 0;
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    roomcontext=context;
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Rooms.showloading2){
        Rooms.GetMoreNewRoom(context);
      }
    }
    _controller?.addListener(_scrollListener);
    return WillPopScope(onWillPop:()async{
      FocusScope.of(context).unfocus();
      return true;
    },
      child:  RefreshIndicator(color:MainColor, onRefresh: ()async{
        Rooms.GetNewRoom(context: context);
      },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(cacheExtent: 10.0,physics: const BouncingScrollPhysics(),
            controller: _controller,
            slivers: <Widget>[

              SliverToBoxAdapter(
                child:Container(color: Colors.white,
                  child: Row(
                    children: [

                      Expanded(child: InkWell(
                        onTap: (){
                          Rooms.GetWeeklyStar(context: context);
                           navigateTo(context: context, screen: WeeklystarScrean());
                        },
                        child: Container( height: 60,child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Center(child: Text(getLang(context: context, key: "Weekly_Star"),style: style6.copyWith(color: Colors.white,fontSize: 13))),
                        ),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: const DecorationImage(image:const ExactAssetImage(Images.Rank),fit: BoxFit.fill)),),
                      )) ,
                    const SizedBox(width: 10,),
                      Expanded(child: Container( child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Center(child: Text(getLang(context: context, key: "Games" ),style: style6.copyWith(color: Colors.white,fontSize: 13))),
                      ),height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: const DecorationImage(image:const ExactAssetImage(Images.Games),fit: BoxFit.fill)),)),
                      const SizedBox(width: 10,),
                      Expanded(child: InkWell( onTap: () {
                        Rooms.GetFamilyLeaderboard(context: context);
                        navigateTo(context: context,screen: LeaderboardFamilyScrean());
                      },
                        child: Container(child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Center(child: Text(getLang(context: context, key: "Family") ,style: style6.copyWith(color: Colors.white,fontSize: 13))),
                        ),height: 60,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: const DecorationImage(image:ExactAssetImage(Images.Family),fit: BoxFit.fill)),),
                      )),

                    ],
                  ),
                ),
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),


            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:1.2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing:5),
              delegate: SliverChildBuilderDelegate( (context, index) {
                List<RoomModel> RoomsList = Rooms.NewRooms ;

                  return  InkWell(onTap: ()
                   {
                     Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );
                  },child: RoomsContainer(Roominfo:RoomsList[index] ,));
                },
                childCount: Rooms.NewRooms.length,
              ),
            ),

          ],
          ),
        ),
      ),
    );
  }
}
