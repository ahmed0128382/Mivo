import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
class MyVipScrean extends StatelessWidget {
  TextEditingController NewId=TextEditingController();


  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);

    return Container(decoration: const BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/VipBackground.png'),fit: BoxFit.fill)),
    child: Scaffold(backgroundColor:  Colors.transparent,
        appBar: AppBar(elevation:0,centerTitle: true,iconTheme: IconThemeData(color: Color(0xFFeae2be)),backgroundColor: Colors.transparent,title: Text(getLang(context: context,key: "My_Vip"),style: style5.copyWith(color:Color(0xFFeae2be)),),actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:Color(0xFFeae2be),
          ),
          onPressed: () {
            showDialog(context: context,builder: (context) {
              return AlertDialog(backgroundColor:  Color(0xFF2b2f3b),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
                child:Text( getLang(context: context,key: "SureRemove_Vip"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
              ),actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                    InkWell(onTap:(){
                      Navigator.pop(context);
                     // user.RemoveVip(context: context,MyVip: user.userinfo?.MyVip);
                      //Navigator.pushNamed(context, '${AppConstants.Recharge_Screan}');
                    },child: Container(child: Center(child:  Text(getLang(context: context, key: "Yes"),style: style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be)))),

                    InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style:  style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(color: Color(0xFFeae2be),borderRadius: BorderRadius.circular(20), ))),

                    // FlatButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),color: ThirdColor,onPressed:()=>Navigator.pop(context), child: Text( getLang( context: context, key: "Close"),style: style1,)),
                  ],),
                )
              ],);
            },);
          },
          child: Text(getLang(context: context,key: "Remove_Vip")),
        )
      ]),
      body: Container(height: SizeConfig.screenHeight!,color: Color(0xFF1a1e28),
        child: Stack(
          children: [
            Container(width: SizeConfig.screenWidth!,height: SizeConfig.screenHeight! ,
              decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/VipBackground.png'),fit: BoxFit.cover)),
              child: Column(
                children: [
                  SizedBox(height: 25,),
                  CachedNetworkImage(imageUrl:  user.userinfo?.MyVip?.Vip?.gif??'',height: 222,width: 222),
                ],
              ),
            ),
            Positioned(bottom: 0,
              child: Container(width: SizeConfig.screenWidth!,height: SizeConfig.screenHeight!/2,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(20) ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Image.asset(Images.abg,width: 130),
                    Text(getLang(context: context, key: "Privileges"),style: style3.copyWith(color: Color(0xFFeae2be),fontWeight: FontWeight.normal,fontSize: 20),),
                    SizedBox(height: 10,),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        children:[
                          Column(
                            children: [
                              Image.asset(user.userinfo?.MyVip?.Vip?.vipicon!=null?viptabs[0].image??'':viptabs[0].grayimage??'',height: 50,width: 50),
                              SizedBox(height: 10),
                              Text(viptabs[0].name??'',style: style3.copyWith(color: user.userinfo?.MyVip?.Vip?.vipicon!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              if(user.userinfo?.MyVip?.Vip?.frame!=null){
                                //  Dialogs().ShowFrame(context: context,svga: user.userinfo?.MyVip?.Vip?.urlframe);
                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      actions: [
                                        if( user.userinfo?.frameimage==user.userinfo?.MyVip?.Vip?.urlframe)
                                          InkWell(onTap:(){
                                            Navigator.pop(context);
                                            Shops.RemoveFrame(context: context );
                                          },child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(child: Center(child:  Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                          ))),
                                        if( user.userinfo?.frameimage!=user.userinfo?.MyVip?.Vip?.urlframe)
                                          InkWell(onTap:(){
                                            Navigator.pop(context);
                                            Shops.UserpdateFrame(context: context,Frame:  user.userinfo?.MyVip?.Vip?.frame );
                                          },child: Center(child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(child: Center(child:  Text(getLang(context: context, key: "set"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                          ))),
                                      ],
                                      backgroundColor: Color(0xFF2b2f3b),
                                      content: Container(height: 300,width: 250,child: Column(mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20) ),child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.clear,color: whitecolor),
                                          ))),
                                          Align(alignment: Alignment.center,child: CircleAvatar(foregroundColor: Colors.black87,radius: 80,backgroundColor: Colors.transparent, child:
                                          Stack(children: [
                                            Align(alignment: Alignment.center,child: CircleAvatar(backgroundColor: Colors.transparent,radius:55  ,backgroundImage:CachedNetworkImageProvider(user.userinfo?.image??'') )),
                                            SVGASimpleImage(resUrl:user.userinfo?.MyVip?.Vip?.urlframe),
                                          ], )))
                                        ],
                                      )),
                                    )
                                );
                              }

                            },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.frame!=null?viptabs[1].image??'':viptabs[1].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[1].name??'',style: style3.copyWith(color:  user.userinfo?.MyVip?.Vip?.frame!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                              ],
                            ),
                          ),
                          InkWell(onTap: (){
                            if(user.userinfo?.MyVip?.Vip?.entry!=null){
                              showDialog(barrierDismissible: false,
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    actions: [
                                      if( user.userinfo?.entry==user.userinfo?.MyVip?.Vip?.urlentry)    InkWell(onTap:(){
                                        Navigator.pop(context);
                                        // user.ByeVip(context: context,vip: Vips.Vips[index]);
                                      },child: Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(child: Center(child:  Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                      ))),
                                      if( user.userinfo?.entry!=user.userinfo?.MyVip?.Vip?.urlentry)
                                        InkWell(onTap:(){
                                          Navigator.pop(context);
                                          Shops.UserpdateEntry(context: context,Entry:user.userinfo?.MyVip?.Vip?.entry );
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "set"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),

                                    ],
                                    backgroundColor: Color(0xFF2b2f3b),
                                    content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.clear,color: whitecolor),
                                        ))),
                                        Container(height: 350,
                                            child:   SVGASimpleImage(resUrl:user.userinfo?.MyVip?.Vip?.urlentry)
                                        ),
                                      ],
                                    )),
                                  )
                              );
                            }
                          },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.entry!=null?viptabs[2].image??'':viptabs[2].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[2].name??'',style: style3.copyWith(color:  user.userinfo?.MyVip?.Vip?.entry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Image.asset(user.userinfo?.MyVip?.Vip?.level!=null?viptabs[3].image??'':viptabs[3].grayimage??'',height: 50,width: 50),
                              SizedBox(height: 10),
                              Text("${viptabs[3].name}${user.userinfo?.MyVip?.Vip?.level??''}",style: style3.copyWith(color:user.userinfo?.MyVip?.Vip?.level!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              if(user.userinfo?.MyVip?.Vip?.specialID==1&&user.userinfo?.MyVip?.newId==null){
                                showDialog(barrierDismissible: false,
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      actions: [

                                        InkWell(onTap:(){
                                          if(NewId.text.length<6){
                                            Dialogs().showtoast(getLang(context: context,key: "ID_long"));
                                          }else{
                                            Navigator.pop(context);
                                         //   v.UpdateNewId(context: context,Id: NewId.text, );

                                          }
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "set"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),
                                      ],
                                      backgroundColor: Color(0xFF2b2f3b),
                                      content: SingleChildScrollView(
                                        child: Column(mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            InkWell(onTap: ()=>Navigator.pop(context),child: Icon(Icons.clear,color: Color(0xFFeae2be))),
                                            SizedBox(height: 10,),
                                            Text('${getLang(context: context,key: "Your_Current")}  ${user.userinfo?.Newid??user.userinfo?.myappid}',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),

                                            TextFormField(autofocus:true,keyboardType: TextInputType.number,controller:NewId,maxLength: 6,style: TextStyle(color: Color(0xFFeae2be)),cursorColor:Color(0xFFeae2be) ,decoration: InputDecoration(  enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color:yellowcolor1),
                                            ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: whitecolor),
                                                ), hintText: getLang(context: context,key: "Enter_New_ID"),hintStyle:style3.copyWith(color: yellowcolor1  ,fontWeight: FontWeight.bold,fontSize: 16) )),
                                            Text(getLang(context: context,key: "change_ID"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),



                                          ],
                                        ),
                                      ),
                                    )
                                );
                              }else{
                                Dialogs().showtoast(getLang(context: context,key: "Alreadychangeid"));
                              }

                            },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.specialID==1?viptabs[4].image??'':viptabs[4].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[4].name??'',style: style3.copyWith(color:user.userinfo?.MyVip?.Vip?.specialID==1?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                              ],
                            ),
                          ),
                          InkWell(onTap: (){
                            if(user.userinfo?.MyVip?.Vip?.profileEntry!=null){
                              showDialog(barrierDismissible: false,
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    actions: [
                                      if( user.userinfo?.bubbles==user.userinfo?.MyVip?.Vip?.profileEntry)    InkWell(onTap:(){
                                        Navigator.pop(context);
                                        user.Removebubbles();
                                      },child: Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(child: Center(child:  Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                      ))),
                                      if( user.userinfo?.bubbles!=user.userinfo?.MyVip?.Vip?.profileEntry)
                                        InkWell(onTap:(){
                                          Navigator.pop(context);
                                          user.updatebubbles(context: context,bubbles: user.userinfo?.MyVip?.Vip?.bubbles);
                                          //Shops.RemoveFrame(context: context,Entry:user.userinfo?.MyVip?.Vip?.entry );
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "set"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),

                                    ],
                                    backgroundColor: Color(0xFF2b2f3b),
                                    content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.clear,color: whitecolor),
                                        ))),
                                        Container(height: 350,
                                            child: SVGASimpleImage(resUrl:user.userinfo?.MyVip?.Vip?.profileEntry)
                                        ),
                                      ],
                                    )),
                                  )
                              );
                            }

                          },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.profileEntry!=null?viptabs[5].image??'':viptabs[5].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[5].name??'',style: style3.copyWith(color:  user.userinfo?.MyVip?.Vip?.profileEntry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                              ],
                            ),
                          ),
                          InkWell(onTap: (){
                            showDialog(barrierDismissible: false,
                                context: context,
                                builder: (_) => AlertDialog(
                                    actions: [
                                      if( user.userinfo?.ColoredMessage==user.userinfo?.MyVip?.Vip?.coloredMessage)
                                        InkWell(onTap:(){
                                          Navigator.pop(context);
                                          user.Removebubbles();
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),
                                      if( user.userinfo?.ColoredMessage!=user.userinfo?.MyVip?.Vip?.coloredMessage)
                                        InkWell(onTap:(){
                                          if(user.selectedcolor.isEmpty){
                                            Dialogs().showtoast(getLang(key: "Select_Color",context: context));
                                          }else{
                                            Navigator.pop(context);
                                            user.updateColoredMessage(context: context);
                                          }

                                          //Shops.RemoveFrame(context: context,Entry:user.userinfo?.MyVip?.Vip?.entry );
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "set"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),
                                    ],
                                    backgroundColor: Color(0xFF2b2f3b),
                                    content:StatefulBuilder(builder: (context, setState){
                                      return Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.clear,color: whitecolor),
                                          ))),

                                          Container(height: 150,width: 250,child:Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(onTap: (){
                                               user.addtoselectedcolor(color:int.parse(user.userinfo?.MyVip?.Vip?.coloredMessage));
                                                setState((){  });
                                              },child: CircleAvatar(radius: 45,backgroundColor:user.selectedcolor.contains( int.parse(user.userinfo?.MyVip?.Vip?.coloredMessage))||user.userinfo?.ColoredMessage.toString()==user.userinfo?.MyVip?.Vip?.coloredMessage.toString()?Colors.greenAccent :Color(0xFFeae2be).withOpacity(0.5), child: CircleAvatar(radius: 40,backgroundColor: Color(int.parse(user.userinfo?.MyVip?.Vip?.coloredMessage))))),
                                              InkWell(onTap: (){
                                                user.addtoselectedcolor(color: Color(0xFFFFFFFF).value);
                                                print(    Color(0xFFFFFFFF).value);
                                                setState((){ });
                                              },child: CircleAvatar( radius: 45,backgroundColor:user.selectedcolor.contains(Color(0xFFFFFFFF).value)||user.userinfo?.ColoredMessage.toString()==user.userinfo?.MyVip?.Vip?.coloredMessage.toString()?Colors.greenAccent :Color(0xFFeae2be).withOpacity(0.5), child: CircleAvatar( radius: 40,backgroundColor: Colors.white))),
                                            ],
                                          )),

                                        ],
                                      );
                                    }

                                    )
                                )
                            );
                          },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.coloredMessage!=null?viptabs[6].image??'':viptabs[6].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[6].name??'',style: style3.copyWith(color:  user.userinfo?.MyVip?.Vip?.coloredMessage!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                              ],
                            ),
                          ),
                          InkWell(onTap: (){
                            showDialog(barrierDismissible: true,
                                context: context,
                                builder: (_) => AlertDialog(
                                    actions: [
                                      if( user.userinfo?.Hidden==1)
                                        InkWell(onTap:(){
                                          Navigator.pop(context);
                                          user.SetHidden(context: context,hidden: 0);
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context, key: "Remove"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),
                                      if( user.userinfo?.Hidden==0)
                                        InkWell(onTap:(){
                                          Navigator.pop(context);
                                          user.SetHidden(context: context,hidden: 1);
                                        },child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(child: Center(child:  Text(getLang(context: context,key: "Hide_Now"),style: style6.copyWith(fontSize: 20),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be))),
                                        ))),
                                    ],
                                    backgroundColor: Color(0xFF2b2f3b),
                                    content:user.userinfo?.Hidden==0?
                                    Column(mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:MainAxisAlignment.center ,                                      children: [
                                        InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.clear,color: whitecolor),
                                        ))),
                                        Text(getLang(context: context,key: "Not_Hidden"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 20),),
                                        Center(child: Image.asset(Images.abg,width: 130)),
                                        Text(getLang(context: context,key: "Hiddn_till"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                      ],
                                    ): Column(mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:MainAxisAlignment.center ,children: [
                                        InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.clear,color: whitecolor),
                                        ))),
                                        Text(getLang(key: "account_hidden",context: context),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 20),),
                                        Center(child: Image.asset(Images.abg,width: 130)),
                                        Text(getLang(context: context,key: "Gust_Vip"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                      ],
                                    )
                                )
                            );
                          },
                            child: Column(
                              children: [
                                Image.asset(user.userinfo?.MyVip?.Vip?.hidden==1?viptabs[7].image??'':viptabs[7].grayimage??'',height: 50,width: 50),
                                SizedBox(height: 10),
                                Text(viptabs[7].name??'',style: style3.copyWith(color: user.userinfo?.MyVip?.Vip?.hidden==1?Color(0xFFeae2be):Color(0xFF4f4d4d) ,fontWeight: FontWeight.normal,fontSize: 11),),
                              ],
                            ),
                          ),

                        ],
                        physics: ScrollPhysics(),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(bottom: 20, child: Container(width: SizeConfig.screenWidth!, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,).copyWith(bottom: 10),
              child: Center(child: Text('${(DateTime.parse(user.userinfo?.MyVip?.createdAt??'').difference(DateTime.now()).inDays==0?1:DateTime.parse(user.userinfo?.MyVip?.createdAt??'').difference(DateTime.now()).inDays).toString()} ${getLang(context: context,key: "Days_Reminder")}',style:style5.copyWith(color: whitecolor,fontSize: 20),)),
            )),),



          ],
        ),
      ),

    ));
  }
}
List<VipTap> viptabs=[
  VipTap(name: 'Vip Icon',image: 'assets/image/abx.png',grayimage: 'assets/image/abx1.png', ),
  VipTap(name: 'Unique Frames',image: 'assets/image/abu.png',grayimage: 'assets/image/abu1.png',),
  VipTap(name: 'Unique Entry',image: 'assets/image/abp.png',grayimage: 'assets/image/abp1.png',),
  VipTap(name: 'Level +',image: 'assets/image/abr.png',grayimage: 'assets/image/abr1.png',),
  VipTap(name: 'special ID',image: 'assets/image/id.png',grayimage: 'assets/image/id1.png',),
  VipTap(name: 'Profile Bubbles',image: 'assets/image/ab8.png',grayimage: 'assets/image/ab81.png',),
  VipTap(name: 'Colorful Message',image: 'assets/image/abq.png',grayimage: 'assets/image/abq1.png',),
  VipTap(name: 'Hidden',image: 'assets/image/ab2.png',grayimage: 'assets/image/ab21.png',),
];
class VipTap {
  String? image;
  String? grayimage;
  String? name;
  VipTap(
      {this.image,
        this.name,
        this.grayimage
      });
}
