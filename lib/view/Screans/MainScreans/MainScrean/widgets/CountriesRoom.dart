import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CountriesRoomScrean extends StatelessWidget {
  const CountriesRoomScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);

    return Scaffold(
        appBar: AppBar(  leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ), title:   Text(Rooms.SelectedCountry?.name??"",style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),

        body: RefreshIndicator(  color:MainColor, onRefresh: ()async{

       Provider.of<RoomViewmodel>(context,listen: false).GetCountriRoom();

        },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CustomScrollView(cacheExtent: 20.0 ,
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:1.2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing:5),
                    delegate: SliverChildBuilderDelegate( (context, index) {
                      List<RoomModel> RoomsList = Rooms.CountryRoom ;

                      return  InkWell(onTap: ()
                      {


                          Rooms.EnterRoom(id:RoomsList[index].id,adminId: RoomsList[index].adminId,context: context );


                      },child: RoomsContainer(Roominfo:RoomsList[index] ,));
                    },
                      childCount: Rooms.CountryRoom.length,
                    ),
                  ),
                ]
            ),
          ),
        )
    );

  }
}
