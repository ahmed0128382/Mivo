import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class ShowGiftRoom extends StatelessWidget {
  const ShowGiftRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return DefaultTabController(length: 2,
      child: Container(height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(Room.Currentroom?.animateimage??''),fit: BoxFit.fill)),child:
      Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const    SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: (){
                       Navigator.pop(context);
                      },child: Icon(Icons.cancel_outlined,color: whitecolor2,)),
                      Text( getLang(context: context,key: "gifts"),style: style6.copyWith(fontSize: 16,color: whitecolor2)),
                      Opacity(opacity: 0,child: Icon(Icons.cancel_outlined,)),

                    ],
                  ),
                ),
                const    SizedBox(height: 10,),
                Container(width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                      gradient: gradiant2,
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child:      TabBar(
                    indicatorColor: whitecolor,
                    tabs:    [
                      Tab(text:  getLang(context: context,key: "Send_Gifts")),
                      Tab(text:  getLang(context: context,key: "Collected_Gifts")),

                  ],
                    labelColor: whitecolor,labelStyle:style5 ,
                    indicator: MaterialIndicator(
                      height: 5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 50,color: MainColor,
                      tabPosition: TabPosition.bottom,
                    ),
                  ),


                ),
                Container(height:  (SizeConfig.screenHeight!/2),
                  child: TabBarView(children: [
                    GridView.builder(
                        gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:4,
                            childAspectRatio:0.9,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                        itemCount:user.userroominfo?.giftssent?.length ,
                        itemBuilder: (BuildContext ctx, index) {
                          return InkWell(onTap: (){

                          },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: gradiant2 ,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(imageUrl:user.userroominfo?.giftssent?[index].gift?.image??Images.userphoto ,height: 40,),
                                  Text(user.userroominfo?.giftssent?[index].gift?.name??'',style: style4.copyWith(fontSize: 12,color: whitecolor)),
                                  Text("X${user.userroominfo?.giftssent?[index].quantity.toString()}" ,style: style4.copyWith(fontFamily: "numbers",fontSize: 12,color: whitecolor)),

                                ],
                              ),
                            ),
                          );
                        }),
                    GridView.builder(
                        gridDelegate:    SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:4,
                            childAspectRatio:0.9,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                        itemCount:user.userroominfo?.giftscollect?.length ,
                        itemBuilder: (BuildContext ctx, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: gradiant2 ,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(imageUrl:  user.userroominfo?.giftscollect?[index].gift?.image??Images.userphoto ,height: 40,),
                                Text(user.userroominfo?.giftscollect?[index].gift?.name??'',style: style4.copyWith(fontSize: 12,color: whitecolor)),
                                Text("X${user.userroominfo?.giftscollect?[index].quantity.toString()}" ,style: style4.copyWith(fontFamily: "numbers",fontSize: 12,color: whitecolor)),

                              ],
                            ),
                          );
                        }),
                  ],),
                )
              ],
            ),
          )
      ),


      ),
    );
  }
}
