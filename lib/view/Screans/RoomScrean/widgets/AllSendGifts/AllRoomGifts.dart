import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class AllGiftsInRoom extends StatelessWidget {
  const AllGiftsInRoom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return AnimatedPositioned(
        height:   Room.showloading36 ? SizeConfig.screenHeight!/2:0,
        left:0,
        bottom: 0.0,
        duration: const Duration(milliseconds: 300,),
        curve: Curves.fastOutSlowIn,
        child:  Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,
            child:SingleChildScrollView(
              child: Room.showloading37? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator(color: MainColor),),
              ):Column(
                children: [
                  InkWell(onTap: (){

                    Room.hideSpinner36();
                  },child: Container(child: Center(child: Icon(Icons.keyboard_arrow_down,color: whitecolor,)),height: 35,decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),)),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    //print(Room.RoomGifts[index]);
                  },child: Text(getLang(context: context,key: "Send_Gifts"),style: style4.copyWith(color: Colors.black),)),
                  Container(height: SizeConfig.screenHeight!/2,
                    child: GridView.builder(
                        physics: ScrollPhysics(),
                        gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:6,
                            childAspectRatio:0.8,
                            mainAxisSpacing:4,
                            crossAxisSpacing: 4),
                        itemCount:Room.RoomGifts.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: gradiant2 ,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(imageUrl: Room.RoomGifts[index].gift?.image??Images. whitecolor,height: 40,),
                                Text(Room.RoomGifts[index].gift?.name??'',style: style4.copyWith(fontSize: 12,color: Colors.black)),
                                if(Room.RoomGifts[index].quantity!=null)Text("X${Room.RoomGifts[index].quantity}" ,style: style4.copyWith(fontFamily: "numbers",fontSize: 12,color: Colors.black)),

                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )

        ));
  }
}
