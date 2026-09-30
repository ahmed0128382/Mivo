import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/ChatScrean/Widgets/PickeChatImage.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../models/MessageModel.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/helperclass.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import '../../widgets/CustomizeAppBar.dart';
import '../../widgets/ImageView.dart';

class ChatScrean extends StatefulWidget {

  InboxRoomModel ?InboxContent;
int ?states;
  ChatScrean({this.InboxContent,this.states});

  @override
  State<ChatScrean> createState() => _ChatScreanState();
}

class _ChatScreanState extends State<ChatScrean> {
@override


  Widget build(BuildContext context) {
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel        user = Provider.of<LoginViewmodel>(context, listen: true);
    InboxroomViewModel    Inboxrooms= Provider.of<InboxroomViewModel>(context,listen: true);
    if(widget.states==0){
      widget.InboxContent =user.ChatRoom;
    }

    return WillPopScope(onWillPop: ()  async{
      Inboxrooms.ExistChatRoom();
      return true;
    },
      child: Directionality(textDirection: TextDirection.ltr,
        child: Scaffold(
        backgroundColor: Color(0xFFf6f7f9),
         appBar:CustomizeChatAppbar(InBoxid: widget.InboxContent?.id,tittle:user.checkuserkind(context: context,id:widget.InboxContent?.user?.id)?widget.InboxContent?.sender?.name??'':widget.InboxContent?.user?.name??'',image:user.checkuserkind(context: context,id:widget.InboxContent?.user?.id)?widget.InboxContent?.sender?.image??'':widget.InboxContent?.user?.image??'',userchat:user.checkuserkind(context: context,id:widget.InboxContent?.user?.id)?widget.InboxContent?.sender:widget.InboxContent?.user),
        body :Column(  
          children: [ 
            Expanded(
                child: ListView.builder(      physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index)
                  {
                    List<Message> message=widget.InboxContent?.message!.reversed.toList()??[];
                 if(!user.checkuserkind(context: context,id:message[index].senderId)){
                 return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(user.checkuserkind(context: context,id:widget.InboxContent?.user?.id)?widget.InboxContent?.sender?.image??'':widget.InboxContent?.user?.image??'')),
                    SizedBox(width: 5,),
                      message[index].status==1?
                      InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url:AppConstants.Image_URL+(message[index].message??'')),)),child: Container(height: 200,width: 100,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+(message[index].message??'')),fit: BoxFit.cover),color: Colors.white,borderRadius: BorderRadius.circular(10)),)):
                      message[index].status==0?
                      InkWell(onLongPress:(){
                    Clipboard.setData(ClipboardData(text:message[index].message??'' ));
                    Dialogs().showtoast(getLang(context: context, key: "Copied"));
                    },
                      child: Container( constraints: BoxConstraints(minWidth: 10, maxWidth: 200),
                        decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(25)) ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( vertical: 5).copyWith(right: 19,left: 10),
                      child: Text(message[index].message??'', maxLines: null,style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.start),
                    ),
            ),
          ):  InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url:AppConstants.Image_URL+(message[index].message??'')),)),child: Column(
                        children: [
                          Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+(message[index].message??'')),fit: BoxFit.cover),color: Colors.white,borderRadius: BorderRadius.circular(10)),),
                          Text(getLang(context: context, key: "Send_Gifts"),style: TextStyle(color: MainColor,fontWeight: FontWeight.bold),)
                        ],
                      )),
        ],
          ),
                    Text(Helper().getTimeago(time: message[index].createdAt),style: style5.copyWith(fontSize: 10,color: Colors.black45)),

                  ],
                ),
  );
}else{
  return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column( crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
              message[index].status==1?
              InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url:AppConstants.Image_URL+(message[index].message??'')),)),child: Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+(message[index].message??'')),fit: BoxFit.cover),color: Colors.white,borderRadius: BorderRadius.circular(10)),)):
              message[index].status==0?
              InkWell(onLongPress:(){
                Clipboard.setData(ClipboardData(text:message[index].message??'' ));
                Dialogs().showtoast(getLang(context: context, key: "Copied"));
              },
                child: Container(constraints: BoxConstraints(minWidth: 10, maxWidth: 200),decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(25)) ,
                  child: Padding(
                    padding: const EdgeInsets.symmetric( vertical: 5).copyWith(right: 19,left: 10),
                    child: Text(message[index].message??'',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.start),
                  ),
                ),
              ):
              InkWell(onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(url:AppConstants.Image_URL+(message[index].message??'')),)),child: Column(
                children: [
                  Container(height: 100,width: 100,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(AppConstants.Image_URL+(message[index].message??'')),fit: BoxFit.cover),color: Colors.white,borderRadius: BorderRadius.circular(10)),),
                Text(getLang(context: context, key: "Send_Gifts"),style: TextStyle(color: MainColor,fontWeight: FontWeight.bold),)
                ],
              )),

              SizedBox(width: 6,),
              CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(user.userinfo?.image??'')),

        ],
              ),
              Text(Helper().getTimeago(time: message[index].createdAt),style: style5.copyWith(fontSize: 10,color: Colors.black45)),

            ],
          ),
  );
}

},
                  itemCount: widget.InboxContent?.message?.length,
                  reverse: true,
                )),
            Container(
              child: Column(
                children: [
                  Row(
                    children: <Widget>[

                      SizedBox(width: 10,),
                      Flexible(
                        child: Container(decoration: BoxDecoration(color:secondcolor,borderRadius: BorderRadius.circular(20) ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: TextField(
                              style: TextStyle(color: Colors.black, fontSize: 15.0),
                              controller: Inboxrooms.textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText:getLang(context: context, key:  "Say"),
                                hintStyle: TextStyle(color: Colors.black45,),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(color: Colors.white,
                        child:IconButton(
                          icon: const Icon(Icons.send_outlined,color: Colors.black12),
                          onPressed: () {
   if(Inboxrooms.textEditingController.text==''){

     }else{
    if(!user.checkuserkind(context: context,id:widget.InboxContent?.sender?.id)){
      Inboxrooms.SendMessage(userinfo:widget.InboxContent?.sender,context: context,id:widget.InboxContent?.id, message:  Inboxrooms.textEditingController.text );
    }else{
      Inboxrooms.SendMessage(userinfo:widget.InboxContent?.user,context: context,id:widget.InboxContent?.id, message:  Inboxrooms.textEditingController.text );
    }
  }

},
                          color: whitecolor,
                        ),

                      ),
                      Material(
                        child:   IconButton(
                          icon: Image.asset(Images.ChatImage),
                          onPressed: () {
                            Inboxrooms.getChatRoomImage().then((value){
                              if(value==true){
                                showModalBottomSheet(barrierColor:Colors.transparent,backgroundColor:  Colors.white54,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                                  context: context,
                                  builder: (context) {
                                    return    PickedImageChat(id:widget.InboxContent?.id ,userinfo:  !user.checkuserkind(context: context,id:widget.InboxContent?.sender?.id)?widget.InboxContent?.sender:widget.InboxContent?.user ,);

                                  },
                                );

                              }else{

                              }
                            });

                          },
                          color: whitecolor,
                        ),

                      ),

                    ],
                  ),

                ],
              ),
              width: double.infinity,
              height:80,
              decoration: new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(color: whitecolor4, width: 0.5)),
                  color: whitecolor),
            ),
          ],
        )

          ),
      ),
    );
  }
}
