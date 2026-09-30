import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/app_constants.dart';
import '../../../util/helperclass.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import '../../widgets/CircleProgress.dart';
class AgencyProfileScrean extends StatefulWidget {
  @override
  State<AgencyProfileScrean> createState() => _AgencyProfileScreanState();
}
class _AgencyProfileScreanState extends State<AgencyProfileScrean> {


  ScrollController? _controller2;
  void _scrollListener() {
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  false);
    if((_controller2?.offset??0) >= (_controller2?.position.maxScrollExtent??0)-20 && !Agency.showloading4){

      Agency.GetMoreAgencymembers(context: context);
    }
  }

  void initState() {
    _controller2 = ScrollController();
    _controller2?.addListener(_scrollListener);
    super.initState();
  }

  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    return Scaffold(
        body:RefreshIndicator(color: MainColor, onRefresh: ()async{
          Agency.GetJoinAgency(context: context);
        },
          child: SingleChildScrollView( controller: _controller2,
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container( decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MainColor,
                        whitecolor,
                      ],
                    )
                ),  width: SizeConfig.screenWidth,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.navigate_before_rounded,color: Colors.white,size: 40)),


                          if(user.userinfo?.agency?.id==  Agency.Agencyinfo?.id) Text(" ${getLang(context: context, key:  "Your_Karisma" )} : ${user.userinfo?.AgencyKarisma.toString()}" ,style: style2,),
                          if( Agency.Agencyinfo?.agencyKind==0||Agency.Agencyinfo?.agencyKind==2)     if(user.userinfo?.agency==null&&!(user.userinfo?.joinsrequested?.contains(Agency.Agencyinfo?.id)??false ) )
                            InkWell(onTap: (){
                              Dialogs().showdialog(context: context,tittle: getLang(context: context, key:"Join_Agency"), content: '${getLang(context: context, key: "Want_Join")} ${Agency.Agencyinfo?.name} ${getLang(context: context, key: "Agency")} ?', buttontext: getLang(context: context, key: "Yes"), onTap: ()async{
                                Navigator.pop(context);
                                Agency.RequsetJoinAgency(context: context);
                              }, );
                            },
                              child: Container(decoration: BoxDecoration(border: Border.all(color: whitecolor),color: MainColor,borderRadius: BorderRadius.circular(20)), child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              child: Text(getLang(context: context, key: "Join"),style: style1,),
                          ),),
                            ),
                          if( Agency.Agencyinfo?.agencyKind==0||Agency.Agencyinfo?.agencyKind==2)     if( Agency.Agencyinfo?.agencyKind==1||Agency.Agencyinfo?.agencyKind==2)     if(user.userinfo?.agency==null&&(user.userinfo?.joinsrequested?.contains(Agency.Agencyinfo?.id)??false ) )
                            InkWell(onTap: (){
                            Dialogs().showtoast(getLang(context: context, key:"Request_Agency"));
                            },
                              child: Container(decoration: BoxDecoration(border: Border.all(color: whitecolor),color: MainColor,borderRadius: BorderRadius.circular(20)), child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Text(getLang(context: context, key: "Requested"),style: style1,),
                              ),),
                            ),
                          if(user.userinfo?.agency?.id==  Agency.Agencyinfo?.id) Text(" " ,style: style2.copyWith(color: Colors.transparent),),


                        ],
                      ),
                      const    SizedBox(height: 10,),
                      Row(
                        children: [
                          const    SizedBox(width: 20,),
                          Container(height: 90,width: 100,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(
                              Agency.Agencyinfo?.image?? Images.relation ),fit: BoxFit.cover), ),
                          ),
                          const   SizedBox(width: 20,),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(  Agency.Agencyinfo?.name??'',style: style5.copyWith(fontWeight: FontWeight.normal,fontSize: 17)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:   Row(
                                        children: [
                                          if( Agency.Agencyinfo?.agencyKind==1||Agency.Agencyinfo?.agencyKind==2)  Icon(Icons.monetization_on_outlined,size: 20,color:MainColor) ,
                                          if( Agency.Agencyinfo?.agencyKind==1)  SizedBox(width: 10,),
                                          if( Agency.Agencyinfo?.agencyKind==0||Agency.Agencyinfo?.agencyKind==2)      Icon(Icons.group,size: 20,color: MainColor) ,
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text( 'Id : ${Agency.Agencyinfo?.appid} ',style: style5.copyWith(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black45)),
                                    const   SizedBox(width: 5,),
                                    InkWell(onTap: (){
                                      Clipboard.setData(ClipboardData(text:Agency.Agencyinfo?.appid??'' ));
                                      Dialogs().showtoast(getLang(context: context, key: "Copied"));
                                    },child:Icon(Icons.copy_outlined,color:Colors.black45,size: 16,)),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: MainColor.withOpacity(0.5),borderRadius:   BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Text( Agency.Agencyinfo?.user?.name??'',style: style6.copyWith(fontWeight: FontWeight.normal)),
                                      ),
                                    ),
                                    const   SizedBox(width: 10,),
                                    Row(
                                      children: [
                                        Icon(Icons.group,size: 18,color: Colors.black45) ,
                                        const        SizedBox(width: 5,),
                                        Text( Agency.Agencyinfo?.userNumber.toString()??'',style: style6.copyWith(fontSize: 13, color: Colors.black45,fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),


                        ],
                      ),

                    ],
                  ),
                )),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(getLang(context: context, key: "Members"),style: style5.copyWith(fontSize: 19,fontWeight: FontWeight.normal)),
                ),
SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:Agency.showloading3?Center(child: CustomeCircleProgress()): Agency.useragincys.length==0?Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(child: Text(getLang(context: context, key: "No_Members"),style: style2.copyWith(fontSize: 20),)),
                  ): Column(
                    children: List.generate( Agency.useragincys.length, (index) =>Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(onTap:(){
                        if(user.checkuserkind(context: context,id:  Agency.useragincys[index].id)){

                          Dialogs().showtoast(getLang(context: context, key: "Its_Profile"));
                        }else{
                          user.GetShoweduserProfile(  Agency.useragincys[index]);

                          Navigator.pushNamed(context, '${AppConstants.ShowUser_Profile}');

                        }

                      } ,
                        child: Row(
                          children: [
                            Container(height: 75,width: 75,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),image: DecorationImage(image: CachedNetworkImageProvider(
                                Agency.useragincys[index].image?? Images.relation ),fit: BoxFit.cover), ),
                            ),
                            const  SizedBox(width: 10,),
                            Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Helper().CutName(Agency.useragincys[index].name??'')  ,style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 15)),
                                Row(
                                  children: [
                                    Text( 'Id : ${  Agency.useragincys[index].myappid} ',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.black45)),
                                     const    SizedBox(width: 5,),
                                    InkWell(onTap: (){
                                      Clipboard.setData(ClipboardData(text: Agency.useragincys[index].myappid??'' ));
                                      Dialogs().showtoast(getLang(context: context, key: "Copied"));
                                    },child:Icon(Icons.copy_outlined,color:Colors.black45,size: 12,)),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Container(height: 25,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        child:  Stack(
                                          children: [
                                            Container( child: Image.asset(checkLevelimage(context: context,karisma:Helper().CheckLevel(Karisma: Agency.useragincys[index].Karisma??0) ).image ,height: 30,width: 37,)),
                                            Positioned.fill(child: Padding(
                                              padding: const EdgeInsets.only(left: 0,bottom: 5),
                                              child: Align(alignment:Alignment.topCenter ,child: Text(Helper().CheckLevel(Karisma: Agency.useragincys[index].Karisma??0).toString(),style:style6.copyWith(color:  Colors.white),)),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if( Agency.useragincys[index].MyVip!=null&& Agency.useragincys[index].MyVip?.Vip?.vipicon!=null) Row(
                                      children: [
                                        Text( ' | ',style: style5.copyWith(fontSize: 17,color: Colors.black45),),
                                        const SizedBox(width: 3,),
                                        CachedNetworkImage(imageUrl:  Agency.useragincys[index].MyVip?.Vip?.vipicon??"",height: 16, ),
                                      ],

                                    ),
                                    const   SizedBox(width: 5,),
                                    Row(
                                      children: [
                                        Text( ' | ',style: style5.copyWith(fontSize: 17,color: Colors.black45),),
                                        Text(   Agency.useragincys[index].Flag??'',style: style5.copyWith(fontWeight: FontWeight.bold,fontSize: 15)),
                                      ],
                                    ),

                                  ],
                                ),

                              ],
                            ),


                          ],
                        ),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
