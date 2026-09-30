

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/view/Screans/ChatScrean/GuessGameWidget.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../widgets/ImageView.dart';
import '../../../widgets/ModelSheet.dart';
 class chatRoom extends StatelessWidget {
   const chatRoom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
   LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
   return Expanded(
     child: ListView.builder(addAutomaticKeepAlives: true,padding: EdgeInsets.only(top: 0),
       physics: BouncingScrollPhysics(),
       controller: Room.controller,
       itemCount:Room.Currentroom?.chatroom?.length,itemBuilder:(context, index) =>
         InkWell(onDoubleTap: (){
         if(user.userinfo?.id!=Room.Currentroom?.chatroom![index].user?.id){
            Room.ChairsRoom.clear();
            Room.ChairMaps.clear();
            Room.ClearMentionid();
            Room.Currentroom?.chairs?.forEach((element) {
      if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
      Room.ChairMaps.add({
        'id': element.user?.id.toString(),
        'display': element.user?.name,
        'full_name': element.user?.image,
      },);

      }
  });

  Room.GetMentionid(id:Room.Currentroom?.chatroom![index].user?.id.toString(),name:Room.Currentroom?.chatroom![index].user?.name );
  Room.showSpinner7();
  Room.Message.text='@ ${Room.Currentroom?.chatroom![index].user?.name}';
}
         },onLongPress:   (){
           if(Room.Currentroom?.chatroom?[index].content?.contains(AppConstants.BASE_URL)??false){

           }else{
             Clipboard.setData(ClipboardData(text:Room.Currentroom?.chatroom?[index].content??'' ));
             Dialogs().showtoast(getLang(context: context, key: "Copied"));
           }

         },onTap: (){
           if(Room.Currentroom?.chatroom?[index].kind!=2){
             if(Room.Currentroom?.chatroom?[index].content?.contains('Leaved Room')??false){

             }else{
               if(user.userinfo?.id.toString()!=Room.Currentroom?.chatroom?[index].user?.id.toString() ){
                 user.userinfoRoom(context: context,id:Room.Currentroom?.chatroom?[index].user?.id );
                 user.getuserroominfo(user:Room.Currentroom?.chatroom?[index].user);
                 GlopalbottomSheet(context: context,Screan: RoomUserunchairProfile());
               }else{


               }
             }
           }
         },
           child: Padding(
             padding: const EdgeInsets.only(top: 3),
             child: Padding(
               padding: const EdgeInsets.all(3.0),
               child: Column(mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,

                 children: [
                   Row(    mainAxisSize: MainAxisSize.min,
                     children: [
                       CircleAvatar(backgroundColor: Colors.transparent,radius: 15,backgroundImage: CachedNetworkImageProvider(Room.Currentroom?.chatroom?[index].user?.image??''),),
                       SizedBox(width: 5,),
                       UserSideInfoWidgets(UserDate: Room.Currentroom?.chatroom?[index].user,showdescr: 1,TextColor: Colors.white,),
                     ],
                   ),

                   Room.Currentroom?.chatroom?[index].kind==2?
                   Container(
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                       child: Row(    mainAxisSize: MainAxisSize.min,
                         children: [
                           Text( '${getLang(context: context,key: "Send")} ${Helper().CutName2(name:Room.Currentroom?.chatroom?[index].Gift?.name??'')}',style: style1.copyWith( fontWeight: FontWeight.bold,fontSize: 10,color: whitecolor, overflow: TextOverflow.ellipsis)),
                           const     SizedBox(width: 0,),
                           CachedNetworkImage (imageUrl: Room.Currentroom?.chatroom?[index].Gift?.image??Images.userphoto,width: 40,height: 40,fit: BoxFit.fill),
                           const     SizedBox(width: 5,),
                           Image.asset(Helper().CheckQuantaty(quantity: Room.Currentroom?.chatroom?[index].Gift?.quantity.toString()),height: 40,width: 40,fit: BoxFit.fill),
                           Container( child: Text('  الي ${Helper().CutName4(name: Room.Currentroom?.chatroom?[index].RecevedUser?.name??'')}' ,style: style1.copyWith( fontWeight: FontWeight.bold,fontSize: 10,color: whitecolor, overflow: TextOverflow.ellipsis)))
                         ],
                       ),
                     ),
                   ):
                   Room.Currentroom?.chatroom?[index].kind==4?Row(mainAxisSize: MainAxisSize.min,
                     children: [
                       Text('${Room.Currentroom?.chatroom?[index].content}',style:Namestyle.copyWith( color: (Room.Currentroom?.chatroom?[index].user?.ColoredMessage!=null&&Room.Currentroom?.chatroom?[index].kind!=1)?Color(int.parse(Room.Currentroom?.chatroom?[index].user?.ColoredMessage)):whitecolor4,fontSize: 15),),
                       SizedBox(width: 25,),
                       Image.asset(Room.Currentroom?.chatroom?[index].roomId=='0'?'assets/image/loselucky.png':'assets/image/winlucky.webp',width: 30,height:  30),
                     ],
                   ):Room.Currentroom?.chatroom?[index].kind==5?
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(child: Lottie.network(
                       Room.Currentroom?.chatroom?[index].content??'',  repeat: false,reverse: false, frameRate: FrameRate.max,animate: true  ),
                         height: 50,width: 50,),
                   ):
                   Room.Currentroom?.chatroom?[index].kind==6?
                   Container(color: Colors.transparent,child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 10),
                         child: Row(mainAxisSize: MainAxisSize.min,children: [
                     Text(Room.Currentroom?.chatroom?[index].content??'',style: style1.copyWith(fontSize: 13) ,),
                     const SizedBox(width: 20,),
                     Image.asset(Images.Rolletuser,height: 50,width: 50),

                   ]),
                       ),):
                   Room.Currentroom?.chatroom?[index].kind==7?
                   Row(mainAxisSize: MainAxisSize.min,
                         children: [
                           Text(' @ ',style: style1.copyWith(height: 1,fontWeight: FontWeight.normal,fontSize: 15,color: Colors.yellowAccent),),
                           Flexible(
                             child: Text.rich(TextSpan(
                             children: [
                               TextSpan(
                                   text: Room.Currentroom?.chatroom?[index].content??'' ,style:Namestyle.copyWith(fontWeight: FontWeight.normal,color: Colors.yellowAccent)
                               ),
                             ]),maxLines: null,),
                           ),
                         ],
                       ):Room.Currentroom?.chatroom?[index].kind==8?InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url: Room.Currentroom?.chatroom?[index].content??''),)),child: Container(height: 70,width: 70 ,decoration: BoxDecoration( color: Colors.transparent,borderRadius: BorderRadius.circular(15),image: DecorationImage(image: CachedNetworkImageProvider(Room.Currentroom?.chatroom?[index].content??''),fit: BoxFit.cover)),)):
                   Room.Currentroom?.chatroom?[index].kind==9?Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Room.Currentroom?.chatroom?[index].Guess?.status==0?   Text('${int.parse(Room.Currentroom?.chatroom?[index].Coins??"0").round().toString()}  لعبه التخمين  , الهديه هي ${Room.Currentroom?.chatroom?[index].user?.name} بداء ',textDirection: TextDirection.ltr,style: TextStyle(color: Colors.orange,fontSize: 13),):
                       Room.Currentroom?.chatroom?[index].Guess?.status==3?
  InkWell(onTap: () {
    Dialogs().showtoast(Room.Currentroom?.chatroom?[index].Guess?.status.toString());
  },child: Text( '${Room.Currentroom?.chatroom?[index].Guess?.Sender?.name} تعادل مع  ',textDirection: TextDirection.ltr,style: TextStyle(color: Colors.orange,fontSize: 16 ),)):InkWell(onTap: () {
    print(Room.Currentroom?.chatroom?[index].Guess?.winner.runtimeType);
  },child: Text('${Room.Currentroom?.chatroom?[index].Guess?.Sender?.id==Room.Currentroom?.chatroom?[index].Guess?.winner?Room.Currentroom?.chatroom![index].Guess?.Sender?.name??'':Room.Currentroom?.chatroom?[index].Guess?.Reciver?.name??""} الفائز هو  ',textDirection: TextDirection.ltr,style: TextStyle(color: Colors.orange,fontSize: 16),)),
          if(Room.Currentroom?.chatroom?[index].Guess?.status==0)    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: InkWell(onTap:() {
                        user.SelectGuess(val: null);
                        user.SelectGuesscoins(val: null);
                        showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.black,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                            context: context,
                            builder: (context) {
                              return GuessGameWidget(index: index,);
                            });

                      },
                        child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(15)),child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          child: Text('تحدي',style: style1,),
                        ),),
                      ),
                    )
                     ],
                   ):

                 Padding(
                   padding: const EdgeInsets.only(top: 5),
                   child: Container(  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:  (Room.Currentroom?.chatroom?[index].user?.ColoredMessage!=null&&Room.Currentroom?.chatroom?[index].kind!=1)?Color(int.parse(Room.Currentroom?.chatroom?[index].user?.ColoredMessage)).withOpacity(0.7):Colors.transparent,),

                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                         child: Text.rich( TextSpan(
                           children: [
                           // if(Room.Currentroom?.chatroom?[index].kind==1)  TextSpan(
                           //     text: '@ ${Helper().CutName3(name: user.userinfo?.name??'')} ',style:style5.copyWith(color: Colors.red,fontSize: 12),
                           //   ),
                             TextSpan(
                               text: '${Room.Currentroom?.chatroom?[index].content}',style:Namestyle.copyWith(color: whitecolor,fontWeight: FontWeight.bold,fontSize: 12),
                             ),
                           ]),maxLines: null,),
                       ),
                     ),
                 ),

                 ],
               ),
             ),
           ),
         ),),
   );
  }
}


class DICE extends StatelessWidget {
  const DICE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return Container(child: Lottie.network(
        Room.Currentroom?.chatroom?[2].content??'',  repeat: false,reverse: false, frameRate: FrameRate.max,animate: true  ),
      height: 50,width: 50,);
  }
}
