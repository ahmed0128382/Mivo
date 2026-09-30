import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/ChatScrean/ChatScrean.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';
class MessageScrean extends StatefulWidget {

var kind;
  MessageScrean({this.kind});
  @override
  State<MessageScrean> createState() => _MessageScreanState();
}

class _MessageScreanState extends State<MessageScrean> {

  @override
  Widget build(BuildContext context) {
    InboxroomViewModel    Inboxrooms= Provider.of<InboxroomViewModel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return RefreshIndicator(
        onRefresh: () async{
          Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
        },
        child: CustomScrollView( physics: BouncingScrollPhysics(),
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
            SliverToBoxAdapter(child:Column(
              children:List.generate(Inboxrooms.Inboxrooms.length, (index){
                List<InboxRoomModel> sortedchat=Inboxrooms.Inboxrooms..sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!),) ;
                List<InboxRoomModel> Chat=sortedchat.reversed.toList();
                return  InkWell(onLongPress: (){
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        content: Column(mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text('World Team',style: style2.copyWith(fontSize: 20),),
                           SizedBox(height: 10,),
                           InkWell(onTap: (){
                             Navigator.pop(context);
                             Inboxrooms.DeleteInboxroom(context: context,inboxid:Chat[index].id );
                           },child: Text(getLang(context: context,key: "Delete_Conv"),style: style5.copyWith(fontSize: 15),)),
                          SizedBox(height: 10,),
                            InkWell(onTap: (){
                              Navigator.pop(context);

                              Inboxrooms.DeleteAndBlockUserInboxroom(context: context,inboxid:Chat[index].id );
                            },child: Text(getLang(context: context,key: "Block_User"),style: style5.copyWith(fontSize: 15),)),

                          ],
                        ),
                      )
                  );
                },

                  onTap:() {

                    Inboxrooms. ReadInboxRoom(id:Chat[index].id ,context: context);
                    Provider.of<InboxroomViewModel>(context,listen: false).textEditingController.clear();
                    Chat[index].numberUnread=0;
                    user.RemoveMessage();
                    navigateTo(context: context, screen: ChatScrean(InboxContent: Chat[index]));
                  },
                  child: Container(width: SizeConfig.screenWidth,color: Colors.transparent,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Row(
                          children: [

                            CircleAvatar(backgroundColor: Colors.transparent,radius: 30,backgroundImage: CachedNetworkImageProvider(user.checkuserkind(context: context,id:Chat[index].user?.id)?Chat[index].sender?.image??'':Chat[index].user?.image??'')),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text( user.checkuserkind(context: context,id:Chat[index].user?.id)?Helper().utf8convert(Chat[index].sender?.name??''):Helper().utf8convert(Chat[index].user?.name??'') ,style:Namestyle.copyWith(fontWeight: FontWeight.bold),),
                                      Text(Helper().getTimeago(time: Chat[index].updatedAt),style: style6.copyWith(fontSize: 10, color: Colors.black45,)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (Chat[index].message?.isNotEmpty??false)Container(width: 200,child: Text(Chat[index].message?.last.status==1?getLang(context: context,key: "IMage"):Chat[index].message?.last.status==2?'Gift🎁':Chat[index].message?.last.message??'',style: TextStyle().copyWith(
                                          color: Colors.black45,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                      const Spacer(),
                                      Chat[index].numberUnread==0?const SizedBox():
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal:10 ).copyWith(top:10),
                                        child: badges.Badge(badgeStyle: badges.BadgeStyle(badgeColor: MainColor),
                                          child: Icon(Icons.notifications_active_outlined,size: 19),
                                        ),
                                      )


                                    ],
                                  ),
                                ],
                              ),
                            ),


                          ]),
                    ),
                  ),
                );
              } ),
            )),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        )
    );




  }
}
