import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Vip_ViewModel/Vip_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class MyVipListScrean extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    VipViewmodel Vips=  Provider.of<VipViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    List<VipTap> viptabs=[
      VipTap(name: getLang( context: context , key: "Vip_Icon"),image: 'assets/image/abx.png',grayimage: 'assets/image/abx1.png', ),
      VipTap(name: getLang( context: context , key: "Unique_Frames"),image: 'assets/image/abu.png',grayimage: 'assets/image/abu1.png',),
      VipTap(name: getLang( context: context , key: "Unique_Entry"),image: 'assets/image/abp.png',grayimage: 'assets/image/abp1.png',),
      VipTap(name:getLang(context: context,key: "Level"),image: 'assets/image/abr.png',grayimage: 'assets/image/abr1.png',),
      VipTap(name:getLang(context: context,key: "special_ID"),image: 'assets/image/id.png',grayimage: 'assets/image/id1.png',),
      VipTap(name: getLang(context: context,key: "Profile_Bubbles"),image: 'assets/image/ab8.png',grayimage: 'assets/image/ab81.png',),
      VipTap(name: getLang(context: context,key: "Colorful_Message"),image: 'assets/image/abq.png',grayimage: 'assets/image/abq1.png',),
      VipTap(name:getLang(context: context,key: "Hidden"),image: 'assets/image/ab2.png',grayimage: 'assets/image/ab21.png',),
    ];
    return Container(decoration: const BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.VipBackground),fit: BoxFit.fill)),

      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: AppBar( elevation:0,centerTitle: false,iconTheme: IconThemeData(color: Color(0xFFeae2be)),backgroundColor:  Colors.transparent, title: Text('Vips',style: style5.copyWith(color: Color(0xFFeae2be)),),),
        body: DefaultTabController(length: Vips.MyVips.length,child:
        Column(
          children: [
            TabBar( isScrollable:true,labelColor: Color(0xFFeae2be),labelStyle:style5.copyWith(fontSize: 14,) ,
                indicator: MaterialIndicator(
                  height: 5,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  horizontalPadding: 10,color: Color(0xFFeae2be),
                  tabPosition: TabPosition.bottom,
                ),
                tabs:List.generate(Vips.MyVips.length, (index) => Tab(
                  text:Vips.MyVips[index].Vip?.name,
                ) )),
            Expanded(
              child: TabBarView(
                  children:List.generate(Vips.MyVips.length, (index) =>  Container(height: SizeConfig.screenHeight!,color:Colors.transparent,
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child:CachedNetworkImage(imageUrl:Vips.MyVips[index].Vip?.gif??'',height: 250,width: 250),),
                          SliverToBoxAdapter(child: Column(
                            children: [
                              Image.asset(Images.abg,width: 130),
                              Text(getLang(context: context, key: "Privileges"),style: style3.copyWith(color: Color(0xFFeae2be),fontWeight: FontWeight.normal,fontSize: 15),),

                            ],
                          ),),
                          SliverFillRemaining(hasScrollBody: true,child: Column(
                            children: [
                              Expanded(
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  children:[
                                    Column(mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(Vips.MyVips[index].Vip?.vipicon!=null?viptabs[0].image??'':viptabs[0].grayimage??'',height: 50,width: 50),
                                        SizedBox(height: 10),
                                        Text(viptabs[0].name??'',style: style3.copyWith(color:Vips.MyVips[index].Vip?.vipicon!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: (){
                                        print(user.userinfo?.frameimage);
                                        print(Vips.MyVips[index].Vip?.frame);
                                        if(Vips.MyVips[index].Vip?.frame!=null){
                                          showDialog(barrierDismissible: true,
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                actions: [
                                                  if( user.userinfo?.frameimage!=Vips.MyVips[index].Vip?.urlframe)
                                                    InkWell(onTap:(){
                                                      Navigator.pop(context);
                                                      user.UserpdateFrame(context: context,Frame:  Vips.MyVips[index].Vip?.frame );

                                                    },child: Center(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(child: Center(child:  Text(getLang(context: context,key: "Use_Now"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be))),
                                                    ))),
                                                ],
                                                backgroundColor: Colors.transparent,
                                                content: Container(height: 300,width: 250,child: Column(mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20) ),child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(Icons.cancel_outlined,color: whitecolor),
                                                    ))),
                                                    Align(alignment: Alignment.center,child: CircleAvatar(backgroundColor: Colors.transparent,foregroundColor: Colors.black87,radius: 80, child:
                                                    Stack(children: [
                                                      Align(alignment: Alignment.center,child: CircleAvatar(backgroundColor: Colors.transparent,radius:55  ,backgroundImage:CachedNetworkImageProvider(user.userinfo?.image??'') )),
                                                      SVGASimpleImage(resUrl:Vips.MyVips[index].Vip?.urlframe),

                                                    ], )))
                                                  ],
                                                )),
                                              )
                                          );
                                        }
                                      },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.frame!=null?viptabs[1].image??'':viptabs[1].grayimage??'',height: 50,width: 50),
                                          SizedBox(height: 10),
                                          Text(viptabs[1].name??'',style: style3.copyWith(color:  Vips.MyVips[index].Vip?.frame!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                        ],
                                      ),
                                    ),
                                    InkWell(onTap: (){
                                      if(Vips.MyVips[index].Vip?.entry!=null){

                                        showDialog(barrierDismissible: true,
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              actions: [
                                                if( user.userinfo?.entry!=Vips.MyVips[index].Vip?.urlentry)
                                                  InkWell(onTap:(){
                                                    Navigator.pop(context);
                                                    user.UserpdateEntry(context: context,Entry:Vips.MyVips[index].Vip?.entry );
                                                  },child: Center(child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(child: Center(child:  Text(getLang(context: context,key: "Use_Now"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be))),
                                                  ))),
                                              ],
                                              backgroundColor: Colors.transparent,
                                              content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.cancel_outlined,color: whitecolor),
                                                  ))),
                                                  Container(height: 350,
                                                      child:   SVGASimpleImage(resUrl:Vips.MyVips[index].Vip?.urlentry)
                                                  ),
                                                ],
                                              )),
                                            )
                                        );
                                      }
                                    },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.entry!=null?viptabs[2].image??'':viptabs[2].grayimage??'',height: 50,width: 50),
                                          SizedBox(height: 10),
                                          Text(viptabs[2].name??'',style: style3.copyWith(color:Vips.MyVips[index].Vip?.entry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                        ],
                                      ),
                                    ),
                                    Column(mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(Vips.MyVips[index].Vip?.level!=null?viptabs[3].image??'':viptabs[3].grayimage??'',height: 50,width: 50),
                                        SizedBox(height: 10),
                                        Text("${viptabs[3].name}",style: style3.copyWith(color:Vips.MyVips[index].Vip?.level!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                      ],
                                    ),
                                    InkWell(onTap: () {
                                      if(Vips.MyVips[index].Vip?.specialID==1){
                                        TextEditingController textEditingController = TextEditingController();

                                        showDialog(barrierDismissible: true,
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                actions: [
                                                  if( Vips.MyVips[index].newId==null)
                                                    Center(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        children: [
                                                          PinCodeTextField(keyboardType: TextInputType.number,
                                                            length: 6,
                                                            obscureText: false,textStyle: TextStyle(color:  Color(0xFFeae2be)),
                                                            animationType: AnimationType.fade,
                                                            pinTheme: PinTheme(borderWidth: 0.0,
                                                              shape: PinCodeFieldShape.box,
                                                              fieldOuterPadding:EdgeInsets.symmetric(horizontal: 3),
                                                              activeColor: Color(0xFFeae2be),borderRadius: BorderRadius.circular(10),
                                                              selectedColor: Color(0xFFeae2be),
                                                              inactiveColor: Color(0xFFeae2be),
                                                              fieldHeight: 40,
                                                              fieldWidth: 40,
                                                              activeFillColor: Color(0xFFeae2be),
                                                            ),
                                                            animationDuration: Duration(milliseconds: 300),
                                                            cursorColor: Color(0xFFeae2be),
                                                            enablePinAutofill: true,
                                                            enableActiveFill: false,mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            enabled:true,
                                                            controller: textEditingController,
                                                            onCompleted: (v) {  },
                                                            onChanged: (value) {

                                                            },
                                                            beforeTextPaste: (text) {
                                                              return true;
                                                            }, appContext: context,
                                                          ),
                                                          InkWell(onTap: (){
                                                            if(textEditingController.text.length<6){
                                                              Dialogs().showtoast(getLang(context: context,key: "ID_long"));
                                                            }else{
                                                              Navigator.pop(context);
                                                              Vips.UpdateNewId(context: context,Id: textEditingController.text,Nyvipid: Vips.MyVips[index].id );

                                                            }
                                                          },child: Container(child: Center(child:  Text(getLang(context: context, key: "Done"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be)))),
                                                        ],
                                                      ),
                                                    )),
                                                ],
                                                backgroundColor: Color(0xFF2b2f3b),
                                                content : Column(mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:MainAxisAlignment.center ,
                                                  children: [
                                                    Text('Special ID',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 15),),
                                                    Center(child: Image.asset(Images.abg,width: 130)),
                                                    Text('You can get a special ID like ( 77777 99999 29633 ) Once',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                                  ],
                                                )
                                            )
                                        );
                                      }
                                    },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.specialID==1?viptabs[4].image??'':viptabs[4].grayimage??'',height: 50,width: 50),
                                          SizedBox(height: 10),
                                          Text(viptabs[4].name??'',style: style3.copyWith(color: Vips.MyVips[index].Vip?.specialID==1?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                        ],
                                      ),
                                    ),
                                    InkWell(onTap: (){

                                      if(Vips.MyVips[index].Vip?.profileEntry!=null){
                                        showDialog(barrierDismissible: false,
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              actions: [
                                                if( user.userinfo?.bubbles!=Vips.MyVips[index].Vip?.profileEntry)
                                                  InkWell(onTap:(){
                                                    Navigator.pop(context);
                                                    user.updatebubbles(context: context,bubbles: Vips.MyVips[index].Vip?.bubbles);
                                                  },child: Center(child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(child: Center(child:  Text(getLang(context: context, key: "Use_Now"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be))),
                                                  ))),
                                              ],
                                              backgroundColor: Colors.transparent,
                                              content: Container(height: 400, child: Column(mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(onTap: ()=>Navigator.pop(context),child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.cancel_outlined,color: whitecolor),
                                                  ))),
                                                  Container(height: 350,
                                                      child:   SVGASimpleImage(resUrl:Vips.MyVips[index].Vip?.profileEntry)
                                                  ),
                                                ],
                                              )),
                                            )
                                        );

                                      }
                                    },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.profileEntry!=null?viptabs[5].image??'':viptabs[5].grayimage??'',height: 50,width: 50),
                                          SizedBox(height: 10),
                                          Text(viptabs[5].name??'',style: style3.copyWith(color: Vips.MyVips[index].Vip?.profileEntry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                        ],
                                      ),
                                    ),
                                    InkWell(onTap: () {
                                      if(Vips.MyVips[index].Vip?.coloredMessage!=null){
                                        showDialog(barrierDismissible: true,
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                backgroundColor: Color(0xFF2b2f3b),
                                                actions: [
                                                  if( user.userinfo?.Hidden==0)
                                                    InkWell(onTap:(){
                                                      Navigator.pop(context);
                                                      user.SetHidden(context: context,hidden: 1);
                                                    },child: Center(child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(child: Center(child:  Text(getLang(context: context,key: "Hide_Now"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be))),
                                                    ))),
                                                ],
                                                content : Column(mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:MainAxisAlignment.center ,
                                                  children: [
                                                    Row(mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        CircleAvatar(radius: 15,backgroundColor: Color(int.parse(Vips.Vips[index].coloredMessage))),
                                                        SizedBox(width: 10,),
                                                        Text(getLang(context: context,key: "Colored_Message"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 15),),
                                                      ],
                                                    ),
                                                    Center(child: Image.asset(Images.abg,width: 130)),
                                                    Text(getLang(context: context,key: "ColordNot"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                                  ],
                                                )
                                            )
                                        );
                                      }
                                    },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.coloredMessage!=null?viptabs[6].image??'':viptabs[6].grayimage??'',height: 50,width: 50),
                                          SizedBox(height: 10),
                                          Text(viptabs[6].name??'',style: style3.copyWith(color: Vips.MyVips[index].Vip?.coloredMessage!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                        ],
                                      ),
                                    ),
                                    InkWell(onTap: () {
                                      if(Vips.MyVips[index].Vip?.hidden==1){
                                        showDialog(barrierDismissible: true,
                                            context: context,
                                            builder: (_) => AlertDialog(actions: [
                                              if( user.userinfo?.Hidden==0)
                                                InkWell(onTap:(){
                                                  Navigator.pop(context);
                                                  user.SetHidden(context: context,hidden: 1);
                                                },child: Center(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(child: Center(child:  Text(getLang(context: context,key: "Hide_Now"),style: style6.copyWith(fontSize: 15,height: 1),)),width: SizeConfig.screenWidth!,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xFFeae2be))),
                                                ))),
                                            ],
                                                backgroundColor: Color(0xFF2b2f3b),
                                                content : Column(mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:MainAxisAlignment.center ,
                                                  children: [
                                                    Text(getLang(context: context,key: "Hidden_Account"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 15),),
                                                    Center(child: Image.asset(Images.abg,width: 130)),
                                                    Text(getLang(context: context,key: "HideNote"),style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                                  ],
                                                )
                                            )
                                        );
                                      }
                                    },
                                      child: Column(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(Vips.MyVips[index].Vip?.hidden==1?viptabs[7].image??'':viptabs[7].grayimage??'',height: 50,width: 50),

                                          SizedBox(height: 10),
                                          Text(viptabs[7].name??'',style: style3.copyWith(color: Vips.MyVips[index].Vip?.hidden==1?Color(0xFFeae2be):Color(0xFF4f4d4d) ,fontWeight: FontWeight.normal,fontSize: 11),),

                                        ],
                                      ),
                                    ),


                                  ],
                                  physics: ScrollPhysics(),
                                ),
                              ),
                              Container(width: SizeConfig.screenWidth!, child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10,).copyWith(bottom: 10),
                                child: Row(
                                  children: [
                                    Text('${(DateTime.parse(Vips.MyVips[index].createdAt??'').difference(DateTime.now()).inDays==0?1:DateTime.parse(Vips.MyVips[index].createdAt??'').difference(DateTime.now()).inDays).toString()} ${getLang(context: context,key: "Days_Reminder")}',style:style5.copyWith(color: whitecolor,fontSize: 16),),
                                    const Spacer(),
                                    InkWell(
                                      onTap: (){
                                        print(user.userinfo?.MyVip?.id);
                                        print(Vips.MyVips[index].id);
                                        if(user.userinfo?.MyVip?.id==Vips.MyVips[index].id){
                                        user.RemoveVip( MyVip:Vips.MyVips[index] );
                                        }else{
                                        user.UseVip(context: context,Myvip: Vips.MyVips[index]);

                                        }

                                      },
                                      child: Container( decoration: BoxDecoration(color: Color(0xFFeae2be) ,borderRadius: BorderRadius.circular(20)),child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                                          child: Text(user.userinfo?.MyVip?.id==Vips.MyVips[index].id?getLang(context: context,key:   "Remove"):getLang(context: context, key: "Use_Now"),style: style5.copyWith(height: 1,color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                                        ),
                                      ),),
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ), ),


                        ],
                      )
                  ),)
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

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