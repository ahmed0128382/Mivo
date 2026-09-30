import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/ImageSlide.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';

class TrendScrean extends StatelessWidget {
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
        Rooms.GetMoreRoom(context);
      }
    }
    _controller?.addListener(_scrollListener);
    return RefreshIndicator(color:MainColor, onRefresh: ()async{
      Provider.of<RoomViewmodel>(context,listen: false).GetRoom(context: context);
      Provider.of<RoomViewmodel>(context,listen: false).GetFixedRoom(context: context);
    },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(cacheExtent: 20.0,
              controller: _controller,
              slivers: <Widget>[

                    SliverToBoxAdapter(
                  child:  user.Banners.isEmpty?SizedBox():ImageSlide(),
                ),
             if(Rooms.FixedRooms.length!=0)
               SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio:1.1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  delegate: SliverChildBuilderDelegate( (context, index) {
                    List<RoomModel> RoomsList = Rooms.FixedRooms ;
                    return  InkWell(onTap: ()
                    {
                      Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );
                    },child:  RoomsContainer(Roominfo: RoomsList[index],));
                  },
                    childCount: Rooms.FixedRooms.length,
                  ),
                ),
          SliverPadding(padding: EdgeInsets.only(top: 5)),
          SliverGrid(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               childAspectRatio:1.1,
               mainAxisSpacing: 5,
               crossAxisSpacing: 5),
           delegate: SliverChildBuilderDelegate( (context, index) {
             List<RoomModel> RoomsList = Rooms.Rooms ;
             return  InkWell(onTap: ()
             {
               Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );

             },child:  RoomsContainer(Roominfo: RoomsList[index],));
           },
             childCount: Rooms.Rooms.length,
           ),
         ),



              ],
            ),
      ),
    );
  }

}
