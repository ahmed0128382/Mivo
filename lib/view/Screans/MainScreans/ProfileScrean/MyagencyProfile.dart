import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/AgencyScrean/JoinAgencyRequests.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/AgecnySideInfo.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MyAgencyScrean extends StatefulWidget {
  @override
  State<MyAgencyScrean> createState() => _MyAgencyScreanState();
}
class _MyAgencyScreanState extends State<MyAgencyScrean> {


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
  String getTimeString(int value) {

    final int hour = (value / 60).floor();
    final int minutes =  value - (hour * 60);
    return '${hour.toString().padLeft(2, "0")} ساعه ${minutes.toString().padLeft(2, "0")} دقيقه';
  }
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    return Scaffold(   appBar: AppBar(actions: [
      if(user.userinfo?.id==Agency.Agencyinfo?.userId) Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(onTap: () {
          Agency.EditAagencyName.text=Agency.Agencyinfo?.name??"";

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                content: Column(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سوف يكلفك تغيير اسم الوكاله 5000 من الالماس الخاص بك',style: style2.copyWith(fontSize: 20),),
                    SizedBox(height: 10,),
                    TextFormField(controller: Agency.EditAagencyName,),
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(onTap: (){
                          if(Agency.EditAagencyName.text==Agency.Agencyinfo?.name){
                            Dialogs().showtoast('لم تقم بتعديل اسم الوكاله بعد');
                          }else{
                            Navigator.pop(context);
                            Agency.EditAagencyNames();

                            // Navigator.pop(context);
                          }



                        },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          child: Text('تعديل',style: style1.copyWith(fontSize: 15),),
                        ))),
                        InkWell(onTap: (){

                          Navigator.pop(context);
                        },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          child: Text('اغلاق',style: style1.copyWith(fontSize: 15),),
                        ))),
                      ],
                    ),

                  ],
                ),
              )
          );

        },child: Icon(Icons.settings)),
      ),

     if(user.userinfo?.id==Agency.Agencyinfo?.userId) Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(onTap: () {
        Agency.GetJoinRequested(id: Agency.Agencyinfo?.id);
        navigateTo(context: context, screen: JoinAgencyRequests());

      },child: Icon(Icons.person_add_alt)),
    ),

    ]  ,iconTheme: IconThemeData(color: Colors.black),centerTitle: true,elevation: 0,title: Text(Agency.Agencyinfo?.name??"",style: style6.copyWith(fontSize: 19),)),

        body:RefreshIndicator(color: MainColor, onRefresh: ()async{
          Agency.GetJoinAgency(context: context);
        },
          child: Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MainColor,
                  whitecolor,
                ],
              )
          ),  width: SizeConfig.screenWidth,child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            child: CustomScrollView(
              slivers:   [
                SliverToBoxAdapter(child: const SizedBox(height: 5,),),
                SliverToBoxAdapter(child: Row(
                  children: [

                    Container(height: 70,width: 70,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(
                        Agency.Agencyinfo?.image?? Images.relation ),fit: BoxFit.cover), ),
                    ),
                    const   SizedBox(width: 10,),
                    Expanded(
                      child: Row(
                        children: [

                          AgencySideInfo(AgencyDate:Agency.Agencyinfo ,showdescr: 0),
                          Spacer(),
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
                         if(user.userinfo?.agency==null&&(user.userinfo?.joinsrequested?.contains(Agency.Agencyinfo?.id)??false ) )
                            InkWell(onTap: (){
                              Dialogs().showtoast(getLang(context: context, key:"Request_Agency"));
                            },
                              child: Container(decoration: BoxDecoration(border: Border.all(color: whitecolor),color: MainColor,borderRadius: BorderRadius.circular(20)), child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Text(getLang(context: context, key: "Requested"),style: style1,),
                              ),),
                            ),
                        ],
                      ),
                    ),



                  ],
                ),),
                SliverToBoxAdapter(child: const SizedBox(height: 30,),),

                SliverToBoxAdapter(child:  Row(
                  children: [
                    Text("اعضاء الوكاله",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,height: 1,color: Colors.white),),
                    Spacer(),

                  ],
                ),),
                SliverToBoxAdapter(child: const SizedBox(height: 30,),),
                SliverToBoxAdapter(child: Column(
                  children:List.generate( Agency.useragincys.length, (index) =>Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if(user.userinfo?.id!=Agency.useragincys[index].id){
                          user.GetShoweduserProfile(Agency.useragincys[index]);
                          navigateTo(context: context,screen: ShowUserProfile());
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(Agency.useragincys[index].image??''),),
                          SizedBox(width: 5,),
                          UserSideInfoWidgets(UserDate: Agency.useragincys[index],TextColor: Colors.black,)
                        ],
                      ),
                    ),
                  )),
                )),

               ],
            ),
          )),
        )
    );
  }
}
