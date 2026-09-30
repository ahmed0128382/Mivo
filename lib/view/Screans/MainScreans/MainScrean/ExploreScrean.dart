import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/AllCountriesScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/CountriesRoom.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/Socket_ViewModel/Socketviewmodel.dart';
class ExploreRoomScrean extends StatelessWidget {
  ScrollController? _controller= ScrollController();

  @override

  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    roomcontext=context;
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Rooms.showloading2){
        Rooms.GetMoreExploreRoom(                                                                                                                                       context);
      }
    }
    _controller?.addListener(_scrollListener);

    return RefreshIndicator(color:MainColor, onRefresh: ()async{
      Provider.of<RoomViewmodel>(context,listen: false).GetExploreRoom(context);
      Provider.of<RoomViewmodel>(context,listen: false).GetCountries(context);

    },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(cacheExtent: 20.0,controller: _controller,

          slivers: <Widget>[

            SliverToBoxAdapter(
              child:   Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(getLang(context: context,key: "Countries"),style: style2.copyWith(fontSize: 15,height: 1)),
Spacer(),
                    InkWell(onTap: () {

                      navigateTo(context: context,screen: AllCountriesScrean());

                    },
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children:   [
                          Text(getLang(context: context,key: "More"),style:   style2.copyWith(fontSize: 14,color: Colors.black26,height: 1)),
                          Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                delegate: SliverChildBuilderDelegate( (context, index) {

                  return  InkWell(onTap: () {
                    Rooms.GetSelectedCountry(Rooms.Countries[index]);
                  //  Navigator.pushNamed( context, AppConstants.CountriesRoomScrean);

                    navigateTo(context: context,screen:  CountriesRoomScrean());

                  },
                    child: Container( decoration: BoxDecoration(color: Color(0xFF1878f3).withOpacity(0.05),borderRadius: BorderRadius.circular(5) )
                      ,child:Row(
children: [
    SizedBox(width: 10,),
  Image.asset(
    Rooms.Countries[index].flag??"", package: countryCodePackageName, width: 17,
 ),
  SizedBox(width: 5,),
  Flexible(child: Text(  Rooms.Countries[index].name??"",maxLines: 1,style: style2.copyWith(height: 1,fontSize: 12,color: Colors.black87.withOpacity(0.6)),))
],
                      ) ,),
                  );
                },
                  childCount: Rooms.Countries.length>6?6: Rooms.Countries.length,
                ),
              ),
            SliverToBoxAdapter(
              child:   Padding(
                padding: const EdgeInsets.only(bottom: 10,top: 10),
                child: Text(getLang(context: context,key: "Latest"),style: style2.copyWith(fontSize: 13)),
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio:1.1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5),
              delegate: SliverChildBuilderDelegate( (context, index) {
                List<RoomModel> RoomsList = Rooms.ExploreRooms ;
                return  InkWell(onTap: ()
                {
                  Rooms.EnterRoom(context: context,id:RoomsList[index].id,adminId:  RoomsList[index].adminId  );


                },child:  RoomsContainer(Roominfo: RoomsList[index],));
              },
                childCount: Rooms.ExploreRooms.length,
              ),
            ),



          ],
        ),
      ),
    );
  }

}
