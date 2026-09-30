
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class SearchRoom extends StatelessWidget {
  const SearchRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(  leading: IconButton(
        icon: Icon(Icons.navigate_before, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ), title:   Text(getLang(context: context,key: "Search_room"),style: style4.copyWith(height: 1,color: Colors.black87,fontWeight: FontWeight.normal)),centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:   ListView.builder(physics: BouncingScrollPhysics(),itemCount: Rooms.SearchRooms.length,itemBuilder: (context, index) => Padding(

          padding: const EdgeInsets.only(top: 10),

          child:InkWell(
            onTap: () {
              Rooms.EnterRoom(context: context,id:Rooms.SearchRooms[index].id,adminId:  Rooms.SearchRooms[index].adminId  );


            },
            child: Container(color: Colors.white54,child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 80,width: 80, decoration: BoxDecoration(borderRadius:BorderRadius.circular(10) ,image: DecorationImage(image: CachedNetworkImageProvider(Rooms.SearchRooms[index].image??''),fit: BoxFit.cover ))),
                SizedBox(width: 6,),
           Expanded(
             child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: 5,),
                 Text( Rooms.SearchRooms[index].name??'',style: Namestyle.copyWith(fontSize: 12,height: 1,color: Colors.black,overflow: TextOverflow.ellipsis),),
SizedBox(height: 10,),
                 Text( Rooms.SearchRooms[index].RoomAds??'',style: Namestyle.copyWith(fontSize: 12,height: 1,color: Colors.black,overflow: TextOverflow.ellipsis),),

                 Row(

  children: [

    Text('ID-${Rooms.SearchRooms[index].RoomID}',style: styleb45.copyWith(fontSize: 13)),

Spacer(),

    Row(
      children: [
          FaIcon( FontAwesomeIcons.fire,size: 12,color: MainColor2),
        const SizedBox(width: 5,),
        Text(Helper().k_m_b_generator(Rooms.SearchRooms[index].Karisma),style: style2.copyWith(height: 1,fontSize: 10),)
      ],
    ),

  ],

)
               ],
             ),
           ),


                ],



            )),
          ),

        ),),
      ),
    );
  }
}
