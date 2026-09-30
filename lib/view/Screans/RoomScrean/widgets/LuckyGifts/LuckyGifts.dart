

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class LuckyTabBar extends StatelessWidget  {
  const LuckyTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return  Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.bg__time),fit: BoxFit.cover),borderRadius:BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30) ) ),width: SizeConfig.screenWidth!,
      child: Column(
        children: [
          SizedBox(height: 10,),
          Container(width: SizeConfig.screenWidth!,decoration: BoxDecoration(   color: Colors.transparent,),height:40 ,child: Row(
              children: [

                SizedBox(width: 10,),
                InkWell(onTap: (){
                  Room.ChairsRoom.forEach((element) {
                    Room.AddUserIds(id: element.user?.id );
                  });
                }, child: Container(decoration: BoxDecoration(color: Colors.white24,borderRadius: BorderRadius.circular(20)),child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1,).copyWith(bottom: 5),
                  child: Text('اختيار الكل',style: style1.copyWith(fontSize: 12)),
                ),)),
                Expanded(
                  child: Container(decoration: BoxDecoration(color: Colors.transparent,),
                    child: ListView.builder(itemCount:Room.ChairsRoom.length ,scrollDirection: Axis.horizontal,itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child:Room.ChairsRoom[index].user?.id==null?SizedBox():InkWell(onTap: (){
                        if(Room.UserIds.contains(Room.ChairsRoom[index].user?.id)){
                          Room.RemoveUserIds(id: Room.ChairsRoom[index].user?.id);
                        }else{
                          Room.AddUserIds(id: Room.ChairsRoom[index].user?.id);


                        }
                      },child: CircleAvatar(backgroundColor:Room.UserIds.contains(Room.ChairsRoom[index].user?.id)? MainColor:Colors.transparent,radius: 18,child: CircleAvatar(backgroundColor: Colors.transparent,radius: 16,  backgroundImage: CachedNetworkImageProvider(  Room.ChairsRoom[index].user?.image??'')))),
                    ),),
                  ),
                ),
                const SizedBox(width: Dimensions.FONT_SIZE_LARGE,),
                InkWell(onTap: (){
                  Navigator.pop(context);
                }, child: Icon(Icons.clear,color: whitecolor2,)),
                const SizedBox(width: Dimensions.FONT_SIZE_LARGE,),
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Container(color: Colors.white54,width: SizeConfig.screenWidth,height: 1),
          ),

          DefaultTabController(length: user.LuckyGiftcatigoris.length,
            child: Expanded(flex: 2,
              child: Column(
                children: [
           SizedBox(height: 10,),
                  Flexible (
                    child: TabBarView(children:
                    List.generate(user.LuckyGiftcatigoris.length, (index) =>
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:4,
                                  childAspectRatio:0.8,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                              itemCount:user.LuckyGiftcatigoris[index]['gifts'].length ,
                              itemBuilder: (BuildContext ctx, indexx) {
                                return InkWell(onTap: (){


                                  gits.GiftList.clear();

                                  gits.addtogiftlist(value: user.LuckyGiftcatigoris[index]['gifts'][indexx],costs:(int.parse(gits.SentValue.toString())*user.LuckyGiftcatigoris[index]['gifts'][indexx]['price']) .toInt()*Room.UserIds.length);

                                },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color:!gits.GiftList.contains(user.LuckyGiftcatigoris[ index]['gifts'][indexx])?Colors.transparent: MainColor.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(imageUrl:   AppConstants.Image_URL+user.LuckyGiftcatigoris[ index]['gifts'][indexx]['image'] ,height: 70,),
                                        Text(user.LuckyGiftcatigoris[index]['gifts'][indexx]['name']??'',style: style4.copyWith(fontSize: 10,color: whitecolor)),
                                        Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text( user.LuckyGiftcatigoris[index]['gifts'][indexx]['price'].toString() ,style: style4.copyWith(fontSize: 10,color: whitecolor)),
                                          SizedBox(width: 3,),
                                            Image.asset(Images.coins,height: 15,width: 15,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                    )
                    ),
                  ),

                  Container(width: SizeConfig.screenWidth!,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25 ),
                      child: Row( children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(onTap: (){
                                if(gits.GiftList.isEmpty){
                                  Dialogs().showtoast(getLang(context: context,key: "NoGiftSelected"));
                                }else if(Room.UserIds.isEmpty){
                                  Dialogs().showtoast(getLang(context: context,key: "NouserSelected"));
                                }else{
                                  if((user.userinfo?.coins??0) < gits.Cost){
                                    Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));
                                  }else{


                                   Room.SentLuckyGift(Cost:gits.Cost ,Listuser: Room.UserIds,context: context,giftid: gits.GiftList.first['id'],quantity:gits.SentValue.toString());

                                    Navigator.pop(context);

                                  }

                                }


                              },child: Container(width: 60,height: 35,                                decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.only(bottomRight:       Radius.circular(20),topRight: Radius.circular(20) )),
                                  child: Center(child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Text(getLang(context: context,key: "Send") ,style: style1.copyWith(color: Color(0xFF221316),fontSize: 12, fontWeight: FontWeight.normal) ),
                                  )))),

                              Container(width: 60,height: 35,
                                decoration: BoxDecoration( color: Colors.white,border: Border.all(color: MainColor,width: 1),borderRadius: BorderRadius.only(topLeft:   Radius.circular(20),bottomLeft: Radius.circular(20) )),

                                child: PopupMenuButton(
                                  offset: Offset(0, 0),
                                  onSelected: (s){

                                    gits.changeSentValue(s.toString());


                                    gits.Cost=gits.giftprice*int.parse(s.toString())*Room.UserIds.length ;


                                  },child: Container( width: 50, color: Colors.transparent,child: Center(child: Text(gits.SentValue.toString(),style: style6,))),
                                  onCanceled: (){
                                    print('d');
                                  },
                                  itemBuilder: (_) => <PopupMenuEntry>[
                                    PopupMenuItem(value:'1',
                                        child:Text( '1',style: style6,)),
                                    PopupMenuItem(value:'5' ,
                                        child:Text('5',style: style6,)),
                                    PopupMenuItem(value:'10',
                                        child:Text('10',style: style6,)),
                                    PopupMenuItem(value:'20',child:Text('20',style: style6,)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text( 'Cost: ${gits.Cost}',style: style6.copyWith(height: 1,color: whitecolor,fontSize: 15)),
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(user.userinfo?.coins.toString()??'0',style: style6.copyWith(height: 1,color: whitecolor,fontSize: 15)),
                                ),
                                Image.asset(Images.coins,width: 15,height: 15),
                              ],
                            ),
                            Row(children: [

                            ],),
                          ],
                        ),

                        const         SizedBox(width: 10,)
                      ]),
                    ),),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
