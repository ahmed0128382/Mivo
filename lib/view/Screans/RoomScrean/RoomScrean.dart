import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/view/Screans/EnterRoomanimateWidget/EnterRoomanimateWidget.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GlopalGoft/GlopalGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GuessWidgets/GessRoomWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MusicPlayer.dart';
 import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Admin/AdminChair.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/ChatReversedList.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/ChatWidgets.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/EntryShow/EntryShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GiftShow/GiftShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/LeaveChairUser/AdminLeaveChair.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SentGift/SentGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/UserChairs.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWedget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Headwidget.dart';

import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../util/helperclass.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
class RoomScrean extends StatefulWidget {
  const RoomScrean({Key? key}) : super(key: key);

  @override
  State<RoomScrean> createState() => _RoomScreanState();
}

class _RoomScreanState extends State<RoomScrean> with TickerProviderStateMixin , WidgetsBindingObserver  {


  @override
  void initState() {
    thiss=this;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

      RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
      RoomPlayViewModel  RoomPlay =Provider.of<RoomPlayViewModel>(context, listen: true);
    GiftsViewModel  GlopalGift= Provider.of<GiftsViewModel>(context, listen: true);
      LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return  WillPopScope(
      onWillPop: () async{
       if(Room.showloading7){
          Room.hideSpinner7();
        }else if(Room.showloading5){
         Room.changeloading5();
       }else if(Room.showloading39){
         Room.hideloading39();
        }else if(Room.showloading40){
          Room.hideloading40();
        } else if(Room.showloading38){
          Room.hideSpinner38();
        }else if(Room.showloading33){
          Room.hideSpinner33();
        }else if(Room.showloading36){
          Room.hideSpinner36();
        }else if(Room.showloading7){
          Room.hideSpinner7();
        }else if(Room.showloading29){
          Room.hideSpinner29();
        }else if(Room.showloading28){
          Room.hideSpinner28();
        }  else{
          RoomPlay.changeIsRoomstate(false);
          return true;
        }
        Room.hideSpinner7();

        return false;
      },
      child: Scaffold(resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
           Container(width: SizeConfig.screenWidth!,height: SizeConfig.screenHeight!,child:CachedNetworkImage (
            imageUrl:Room.Currentroom?.animateimage??'',height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,fit: BoxFit.cover,)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  const Headwidget(),
                  const AdminChair(),
                  const UserChair(),
                    Expanded(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                      children:  [
                     chatRoom(),

                        if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))    Padding(
                           padding: const EdgeInsets.only(bottom: 20),
                           child: Column(mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                         if(user.Newmessage)   InkWell(onTap: (){
                                 Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
                                 showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: false, barrierColor:Colors.black.withAlpha(1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                   context: context,
                                   builder: (context) {
                                     return  MessageScrean();
                                   },
                                 );
                                 user.changeNewmessage(false);
                               },child: Container(height: 40,width: 40,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image:DecorationImage(image:  ExactAssetImage('assets/image/ezgif.com-crop.gif'))),)),
SizedBox(height: 10,),
                               InkWell(onTap: () { 
                                 showModalBottomSheet(barrierColor:Colors.transparent,  backgroundColor: Colors.black,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                   context: context,
                                   builder: (context) {
                                     return const MusicPlayerRoom();
                                   },
                                 );
                               },child: Image.asset('assets/image/ic_music_empty.png',height: 40)),
                             ],
                           ),
                         ),
                        SizedBox(width: 10,)
                      ],
                    ),
                 ),
                  const  ChatWidgets()
                ],
              ),
            ),
            const EntryShow(),
            const GiftShow(),
         if(Room.selected)   Positioned(top: 100,child: EnterAnimateWidget()),

            GlopalGiftWidget(),
            AnimatedPositioned(
              width: Provider.of<GiftsViewModel>(context, listen: false).GlobalLuckystate?500:0  ,
              height: 100.0  ,
              top:  50.0,
              duration: const Duration(seconds: 2),
              curve: Curves. easeIn,
              onEnd: (){
                if(GlopalGift.GlobalLuckystate){
                  Provider.of<GiftsViewModel>(context, listen: false).HiddeGlobalLucky();
                }
              },
              child:InkWell(onTap: () {
                if(GlopalGift.GlopelLuckyRoomid==Room.Currentroom?.id.toString()){

                }else{
                  Room.EnterRoom2(context: context,id: GlopalGift.GlopelLuckyRoomid);
                }
              },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Align(alignment: Alignment.bottomCenter,child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          CircleAvatar(backgroundColor: Colors.transparent,radius:20,backgroundImage: CachedNetworkImageProvider(  GlopalGift.SenderLucky?.image??Images.userphoto),),
                          SizedBox(width: 5,),
                          Column(mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(GlopalGift.SenderLucky?.name??'',style: Namestyle2.copyWith(fontSize: 12),),
                              Text(" ضرب كيس حظ في ${GlopalGift.GlopelLuckyRoomname}",style: style1.copyWith(fontSize: 12),textDirection: TextDirection.rtl, ),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Image.asset(Images.LuckyPrize,height: 70,)
                        ],
                      ),
                    ),decoration:BoxDecoration( image: DecorationImage(image: ExactAssetImage('assets/image/d6.png'),fit: BoxFit.cover), borderRadius:  BorderRadius.circular(0)), ),
                  )),
                ),
              ),
            ),
            if(Room.guesses.isNotEmpty)GeussRoomWidget(),

            const SendGift(),
            if (!Room.showloading7) const  SizedBox() else
            const   ChatReversedList(),
            if(Room.Combowin.length!=0)      Align(alignment: Alignment.topCenter,child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Stack(alignment: Alignment.center,children: [
                Image.asset('assets/image/ic_lucky_new_bg.png',height: 160),
                Column(mainAxisSize: MainAxisSize.min,children: [
                  Text('فوز',style: TextStyle(color: Colors.yellow,fontSize: 25,height: 0),),
                  SizedBox(height:   10,),
                  Row(mainAxisSize: MainAxisSize.min,children: [
                    Image.asset(Images.coins,height: 18),
                    SizedBox(width: 3,),
                    Text(Room.Combowin.first['amount'].toString(),style: style1.copyWith(fontSize: 22,color: Colors.yellow),),

                  ],),
                  Text(' تهانينك علي فوزك 0.${Room.Combowin.first['persantage'].toString()} اضعاف العائد',style: TextStyle(color: Colors.white,fontSize: 9),),

                ],)
              ],),
            )),
            if(Room.Combouser.length!=0)
              Directionality(textDirection: TextDirection.ltr,
                child: Align(alignment: Alignment.centerLeft,child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:List.generate(Room.Combouser.length, (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(backgroundImage: CachedNetworkImageProvider( Room.Combouser[index]['image']??"",)),
                              Text('ارسل',style: style1),
                              CachedNetworkImage(imageUrl: Room.Combouser[index]['imagegift']??"",width: 60,height: 60),
                              Text('X'+'${ Room.Combouser[index]['count']}',style: style1.copyWith(fontSize: 25,color: Colors.yellow)),

                            ],
                          ),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient: gradiant10),height: 50,width: 200),
                    ),
                    )
                )),
              ),
            if(Room.showcombo)       Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  if(Room.Combocost<user.userinfo?.coins){
                    Room.SentCompoLuckyGift( context: context );

                    Room.Timercontroller.restart();
                    setState(() {

                    });

                  }else{
                    Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

                  }


                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset( 'assets/image/combo2.png',width: 100),
                    Positioned(bottom: 5,
                      child: Countdown(
                        controller:  Room.Timercontroller,
                        seconds: 5,
                        build: (_, double time) => Text(
                          time.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,fontWeight: FontWeight.bold
                          ),
                        ),
                        interval: Duration(milliseconds: 100),
                        onFinished: () {

                          Room.HideLuckyCombo();

                        },
                      ),
                    ),
                  ],),
              ),
            ),

            const   LeaveAdminChair(),

         if(user.Luckypackages.isNotEmpty)   InkWell(onTap: () {
       user.AcceptLuckyPackage(Roomid: Room.Currentroom?.id,context: context,Luckyid:user.Luckypackages.first['id'] );
            },child: SVGASimpleImage(assetsName:'assets/image/1665252390.svga',)),
          ],
        ),
      ),

    );
  }
}
