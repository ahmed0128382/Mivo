import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';

import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/Socket_ViewModel/Socketviewmodel.dart';
class RoomFollowScrean extends StatelessWidget {
  ScrollController? _controller= ScrollController();

  @override

  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    roomcontext=context;
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Rooms.showloading2){
        Rooms.GetMoreRecommended(context);
      }
    }
    _controller?.addListener(_scrollListener);

    return RefreshIndicator(color:MainColor, onRefresh: ()async{
      Provider.of<RoomViewmodel>(context,listen: false).GetFollowingUserRoom(context);
      Provider.of<RoomViewmodel>(context,listen: false).GetRecommendedRoom(context);

    },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(cacheExtent: 20.0,controller: _controller,

          slivers: <Widget>[

         if(Rooms.FollowingUserRooms.isEmpty)   SliverToBoxAdapter(
              child:Column(children: [
                SizedBox(height: 20,),
                Image.asset(Images.Empty,height: 180),
                  Text(getLang(context: context,key: "no_broadcaster")),
                const SizedBox(height: 20,),
              ]),
            ),
            if(Rooms.FollowingUserRooms.isNotEmpty)
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:1.1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5),
                delegate: SliverChildBuilderDelegate( (context, index) {
                  List<RoomModel> RoomsList = Rooms.FollowingUserRooms ;
                  return  InkWell(onTap: ()
                  {
                    Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );

                  },child:  RoomsContainer(Roominfo: RoomsList[index],));
                },
                  childCount: Rooms.FollowingUserRooms.length,
                ),
              ),
            SliverToBoxAdapter(
              child:   Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 10),
                child: Text(getLang(context: context,key: "Recommended"),style: style2.copyWith(fontSize: 13)),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio:1.1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5),
              delegate: SliverChildBuilderDelegate( (context, index) {
                List<RoomModel> RoomsList = Rooms.RecomendedRoom ;
                return  InkWell(onTap: ()
                {
                  Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );
                },child:  RoomsContainer(Roominfo: RoomsList[index],));
              },
                childCount: Rooms.RecomendedRoom.length,
              ),
            ),



          ],
        ),
      ),
    );
  }

}
