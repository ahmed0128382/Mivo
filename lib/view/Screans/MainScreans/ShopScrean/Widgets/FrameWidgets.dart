import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/SendtofriendsScrean.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Relations_ViewModel/RelationsViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../../../../util/SizeConfig.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../ByeItem.dart';
class Framewidgets  extends StatelessWidget {
  Items ?items;

  Framewidgets({this.items});

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    RelationsViewModel Relation=  Provider.of<RelationsViewModel>(context,listen: true);

    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(decoration: BoxDecoration(color:whitecolor,borderRadius: BorderRadius.circular( 8 )),
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    if(items?.kind!=4)  InkWell(onTap: (){

      if(items?.kind==0){
      Dialogs().ShowEntery( context: context,svga: items?.svggift);
      }else if(items?.kind==1){
      Dialogs().ShowFrame(context: context,svga: items?.svggift);
      }else if(items?.kind==2){
        Dialogs().ShowEntery(context: context,svga: items?.svggift);
      }else if(items?.kind==3){
        Dialogs().ShowEntery(context: context,svga: items?.svggift);
      }

      },child:       FaIcon(FontAwesomeIcons.playCircle,size: 20,color:MainColor)),
        if(items?.kind==4)SizedBox(height: 16,),
        SizedBox(height: 5,),
      Center(
        child: CachedNetworkImage (
        imageUrl:items?.imagegift??'',height: 70,width: 70,fit: BoxFit.fill),
      ),            SizedBox(height: 2,),
      Center(child: Text(items?.name??'',style:style6.copyWith(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(0.8),fontSize: 12) )),

        SizedBox(height: 2,),
      Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Image.asset(Images.coins,height: 15,width: 15),
      const SizedBox(width: 5,),
      Text(((items?.price??0)*7).toString() ,style:style6.copyWith(fontSize: 13,height: 1,fontWeight: FontWeight.bold, ) ),
    if(items?.kind!=4)  Text(' / 7 ${getLang(key: "Days",context: context)}',style:style6.copyWith(fontWeight: FontWeight.normal,height: 1,color: Colors.black.withOpacity(0.8),fontSize: 12) ),

      ],
      ),
Spacer(),
      InkWell(onTap: (){


        if(items?.kind!=4){
          Room.GetShowItem(items );
          Shops.Getid(id: items?.id,CategoryId: items?.shopcategoryId );
          Shops.selectPackage(value: 2,Priceitem:(items?.price??0)*7,Dayitem: 7, );
          GlopalbottomSheet2(context: context,Screan:  ByeItem() );
        }else{
print((items?.price ??0));
          if((items?.price ??0)<= (user.userinfo?.coins??0)){
            Follow.GetFriends(context: context);
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>   SendrelationshipToFriendsScrean()),
            ).then((value){
              if(value==null){

              }else{

                GlopalbottomSheet2(context: context,Screan:Container(
                  decoration: BoxDecoration(   color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15) )),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15,),
                        CachedNetworkImage(imageUrl: items?.imagegift ??'',height: 100,width: 100, ),
                        SizedBox(height: 15,),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Row(
                              children: [
                                Image.asset(Images.coins,height: 25,width: 25),
                                SizedBox(width: 10,),
                                Text(((items?.price??0)*7).toString() ,style:style6.copyWith(fontSize: 18,height: 1,fontWeight: FontWeight.bold, ) ),
                              ],
                             ),
                     Text(items?.name??'',style: style2,)

                          ],
                        ),
                        SizedBox(height: 5,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('تحديد مده الشراء : ',style: TextStyle(color: Colors.black26),),
                          Container(child: Center(child: Text('دائم')), decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: SecondColor),width: SizeConfig.screenWidth,height: 50,)
                        ],),
                        SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration( color: whitecolor2,borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(Images.coins,height: 20,width: 20),
                                    SizedBox(width: 10,),
                                    Text(user.userinfo?.coins.toString()??'0',style:style6.copyWith(fontSize: 13,height: 1,fontWeight: FontWeight.bold, ) ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(onTap: () {
                              Navigator.pop(context);
                              Relation.SendRelation(Relationid: items?.id, UserId: value.id, context: context);

                            },
                              child: Container(width: 150,height: 40,
child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(getLang(context: context, key: "Dedication"),style: style1),
        ),
    CircleAvatar(backgroundImage: CachedNetworkImageProvider(value.image),)
  ],
),
                                decoration: BoxDecoration( color: MainColor,borderRadius: BorderRadius.circular(25)),

                              ),
                            )

                          ],
                        ),
                        SizedBox(height: 25,),
                      ],
                    ),
                  ),
                ) );
                print(value.id);
                print(value.name);
              }
              });


          }else{


            Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

          }

        }





      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: MainColor ),width: double.infinity,height: 32,child: Center(child:Text( items?.kind==4?getLang(context: context, key: "Dedication"):getLang(context: context, key: "Bye") ,style: style4.copyWith(fontSize: 15,color: whitecolor),) )),
      ),
      )


      ],

      ))),
    );

  }
}
