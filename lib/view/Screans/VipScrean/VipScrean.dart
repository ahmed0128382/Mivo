import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/VipScrean/MyVipListScrean.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Vip_ViewModel/Vip_ViewModel.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class VipScrean extends StatefulWidget {
  const VipScrean({Key? key}) : super(key: key);

  @override
  State<VipScrean> createState() => _VipScreanState();
}

class _VipScreanState extends State<VipScrean> {

  @override
  Widget build(BuildContext context) {
    List<VipTap> viptabs=[
      VipTap(name: getLang( context: context , key: "Vip_Icon"),image: 'assets/image/abx.png',grayimage: 'assets/image/abx1.png', ),
      VipTap(name: getLang( context: context , key: "Unique_Frames"),image: 'assets/image/abu.png',grayimage: 'assets/image/abu1.png',),
      VipTap(name: getLang( context: context , key: "Unique_Entry"),image: 'assets/image/abp.png',grayimage: 'assets/image/abp1.png',),
      VipTap(name: getLang(context: context,key: "Level"),image: 'assets/image/abr.png',grayimage: 'assets/image/abr1.png',),
      VipTap(name: getLang(context: context,key: "special_ID"),image: 'assets/image/id.png',grayimage: 'assets/image/id1.png',),
      VipTap(name:getLang(context: context,key: "Profile_Bubbles"),image: 'assets/image/ab8.png',grayimage: 'assets/image/ab81.png',),
      VipTap(name: getLang(context: context,key: "Colorful_Message"),image: 'assets/image/abq.png',grayimage: 'assets/image/abq1.png',),
      VipTap(name:getLang(context: context,key: "Hidden"),image: 'assets/image/ab2.png',grayimage: 'assets/image/ab21.png',),
    ];
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    VipViewmodel Vips=  Provider.of<VipViewmodel>(context,listen: true);
    return Container(decoration: const BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.VipBackground),fit: BoxFit.fill)),
      child: Scaffold(backgroundColor:  Colors.transparent,
        appBar: AppBar(actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(onTap: () {
            Vips.GetMyVips();
            navigateTo(context: context, screen: MyVipListScrean());

          },child: Icon(Icons.shopping_bag_outlined)),
        )],elevation:0,centerTitle: false,iconTheme: IconThemeData(color: Color(0xFFeae2be)),backgroundColor:  Colors.transparent, title: Text('Vip Center',style: style5.copyWith(color: Color(0xFFeae2be)),),),
        body: DefaultTabController(length: Vips.Vips.length,child:
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
              tabs:List.generate(Vips.Vips.length, (index) => Tab(
                text:Vips.Vips[index].name,
              ) )),
          Expanded(
            child: TabBarView(
              children:List.generate(Vips.Vips.length, (index) =>  Container(height: SizeConfig.screenHeight!,color:Colors.transparent,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child:CachedNetworkImage(imageUrl:Vips.Vips[index].gif??'',height: 250,width: 250),),
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
                                  Image.asset(Vips.Vips[index].vipicon!=null?viptabs[0].image??'':viptabs[0].grayimage??'',height: 50,width: 50),
                                  SizedBox(height: 10),
                                  Text(viptabs[0].name??'',style: style3.copyWith(color: Vips.Vips[index].vipicon!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                ],
                              ),
                              InkWell(
                                onTap: (){
                                  if(Vips.Vips[index].frame!=null){
                                    Dialogs().ShowFrame(context: context,svga: Vips.Vips[index].urlframe);
                                  }
                                },
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(Vips.Vips[index].frame!=null?viptabs[1].image??'':viptabs[1].grayimage??'',height: 50,width: 50),
                                    SizedBox(height: 10),
                                    Text(viptabs[1].name??'',style: style3.copyWith(color:  Vips.Vips[index].frame!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                  ],
                                ),
                              ),
                              InkWell(onTap: (){
                                if(Vips.Vips[index].entry!=null){
                                  Dialogs().ShowEntery(context:context,svga:Vips.Vips[index].urlentry);

                                }
                              },
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(Vips.Vips[index].entry!=null?viptabs[2].image??'':viptabs[2].grayimage??'',height: 50,width: 50),
                                    SizedBox(height: 10),
                                    Text(viptabs[2].name??'',style: style3.copyWith(color:  Vips.Vips[index].entry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                  ],
                                ),
                              ),
                              Column(mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Vips.Vips[index].level!=null?viptabs[3].image??'':viptabs[3].grayimage??'',height: 50,width: 50),
                                  SizedBox(height: 10),
                                  Text("${viptabs[3].name}",style: style3.copyWith(color: Vips.Vips[index].level!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                ],
                              ),
                              InkWell(onTap: () {
                                if(Vips.Vips[index].specialID==1){
                                  showDialog(barrierDismissible: true,
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          backgroundColor: Color(0xFF2b2f3b),
                                          content : Column(mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:MainAxisAlignment.center ,
                                            children: [
                                              Text('Special ID',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 15),),
                                              Center(child: Image.asset(Images.abg,width: 130)),
                                              Text('You can get a special ID like ( 77777 99999 29633 )',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                            ],
                                          )
                                      )
                                  );
                                }
                              },
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(Vips.Vips[index].specialID==1?viptabs[4].image??'':viptabs[4].grayimage??'',height: 50,width: 50),
                                    SizedBox(height: 10),
                                    Text(viptabs[4].name??'',style: style3.copyWith(color: Vips.Vips[index].specialID==1?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                  ],
                                ),
                              ),
                              InkWell(onTap: (){
                                if(Vips.Vips[index].profileEntry!=null){
                                  Dialogs().ShowEntery(context:context,svga:Vips.Vips[index].profileEntry);
                                }
                              },
                                child: Column(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(Vips.Vips[index].profileEntry!=null?viptabs[5].image??'':viptabs[5].grayimage??'',height: 50,width: 50),
                                    SizedBox(height: 10),
                                    Text(viptabs[5].name??'',style: style3.copyWith(color:  Vips.Vips[index].profileEntry!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),

                                  ],
                                ),
                              ),
                              InkWell(onTap: () {
                                if(Vips.Vips[index].coloredMessage!=null){
                                  showDialog(barrierDismissible: true,
                                      context: context,
                                      builder: (_) => AlertDialog(
                                          backgroundColor: Color(0xFF2b2f3b),
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
                                    Image.asset(Vips.Vips[index].coloredMessage!=null?viptabs[6].image??'':viptabs[6].grayimage??'',height: 50,width: 50),
                                    SizedBox(height: 10),
                                    Text(viptabs[6].name??'',style: style3.copyWith(color:  Vips.Vips[index].coloredMessage!=null?Color(0xFFeae2be):Color(0xFF4f4d4d),fontWeight: FontWeight.normal,fontSize: 11),),
                                  ],
                                ),
                              ),
                              InkWell(onTap: () {
                                if(Vips.Vips[index].hidden==1){
                                  showDialog(barrierDismissible: true,
                                      context: context,
                                      builder: (_) => AlertDialog(
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
                                    Image.asset(Vips.Vips[index].hidden==1?viptabs[7].image??'':viptabs[7].grayimage??'',height: 50,width: 50),

                                    SizedBox(height: 10),
                                    Text(viptabs[7].name??'',style: style3.copyWith(color: Vips.Vips[index].hidden==1?Color(0xFFeae2be):Color(0xFF4f4d4d) ,fontWeight: FontWeight.normal,fontSize: 11),),

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
                              Image.asset(Images.coins,height: 17),
                              Text.rich( TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ' ${Vips.Vips[index].cost} ${getLang(context: context,key: "Coins")} -',style:TextStyle().copyWith(color:  Colors.white,fontSize: 18),
                                    ),
                                    TextSpan(
                                      text: ' ${Vips.Vips[index].day} ${getLang(context: context,key: "days")} ',style:TextStyle().copyWith(color: Colors.white,fontSize: 18),
                                    ),



                                  ]),maxLines: null,textAlign: TextAlign.start,),
                              const Spacer(),
                              InkWell(
                                onTap: (){
                                  if((user.userinfo?.coins??0)<(Vips.Vips[index].cost??0)){
                                    Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));
                                    Navigator.pushNamed(context, AppConstants.Recharge_Screan);
                                  }else{
                                    showDialog(context: context,builder: (context) {
                                      return AlertDialog(backgroundColor:  Color(0xFF2b2f3b),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
                                        child:Text( '${getLang(key: "Want_to_Buy",context: context)} ${Vips.Vips[index].name} ?',style: style3.copyWith(color: Color(0xFFeae2be)  ,fontWeight: FontWeight.bold,fontSize: 16),),
                                      ),actions: [
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                          InkWell(onTap:(){
                                            Navigator.pop(context);
                                            user.ByeVip(context: context,vip: Vips.Vips[index]);
                                          },child: Container(child: Center(child:  Text(getLang(context: context, key: "Yes"),style: style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFFeae2be)))),

                                          InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(getLang( context: context, key: "Close"),style:  style6.copyWith(fontSize: 15),)),width: 80,height: 37,decoration: BoxDecoration(color: Color(0xFFeae2be),borderRadius: BorderRadius.circular(20), ))),

                                        ],)
                                      ],);
                                    },);
                                  }

                                },
                                child: Container( decoration: BoxDecoration(color: Color(0xFFeae2be) ,borderRadius: BorderRadius.circular(20)),child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                    child: Text( getLang(context: context, key: "Bye"),style: style5.copyWith(color: Colors.black,fontSize: 15),),
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


