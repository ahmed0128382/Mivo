
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/styles.dart';

import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';

class ChatReversedList extends StatelessWidget {
  const ChatReversedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Portal(
      child: Container(color: Colors.transparent,
        child: Column(
          children: [
            Expanded(child:   InkWell(onTap:  () {
              Room. cleanMessage();
            } , child: Container(color: Colors.transparent,))),


            Container(height: 100,color: Colors.transparent,
              child: ListView(physics: NeverScrollableScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10) ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FlutterMentions(defaultText: Room.Message.text,onMentionAdd: (p0){

                          Room.GetMentionid(id:p0['id'],name: p0['display']);
                        } ,decoration: InputDecoration(
                              suffixIconColor: Colors.black,border: InputBorder.none,
                              hintText:getLang(context: context,key: "Send_Message")),
                             onChanged: (val){
                          if(val.length<2){
                            Room.ClearMentionid();
                          }
                          Room.Message.text=val.toString();
                         },
                          autofocus: true,
                          appendSpaceOnAdd: true,
                          suggestionPosition: SuggestionPosition.Top,
                          maxLines: 5,
                          minLines: 1,  trailing : [
                          InkWell(onTap: () {

                            if(Room.Message.text==''){
                            }else{
                              Room.hideSpinner7();
if(Room.Mentionid!=null&&(Room.MentionName?.length??0)+1<Room.Message.text.length){
print(Room.Message.text);
  Room.SendMentionChat(content: Room.Message.text.replaceFirst('@', '') );

}else{
  Room.SendMessageChat(content: Room.Message.text );

}
                            }
                            Room.Message.clear();
                          }, child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.send_outlined,color: MainColor),
                          )),
                        ],

                          mentions: [
                            Mention(
                                trigger: '@',
                                style: TextStyle(
                                  color: Colors.amber,
                                ),
                                data:  Room.ChairMaps,
                                matchAll: false,markupBuilder: (String trigger, String mention, String value){

                                  return value;
                          },
                                suggestionBuilder: (data) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(child:  Row(children: [ CircleAvatar(backgroundColor: Colors.transparent,radius: 13,backgroundImage:  CachedNetworkImageProvider( data['full_name']) ),Text(data['display'],style: style2.copyWith(fontSize: 12))]) ,),
                                  );
                                }
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
