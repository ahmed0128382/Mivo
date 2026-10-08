
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/styles.dart';

import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

class ChatReversedList extends StatelessWidget {
  const ChatReversedList({super.key});

  @override
  Widget build(BuildContext context) {
    RoomViewmodel room=  Provider.of<RoomViewmodel>(context,listen: true);
    
    return Portal(
      child: Container(color: Colors.transparent,
        child: Column(
          children: [
            Expanded(child:   InkWell(onTap:  () {
              room. cleanMessage();
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
                        child: FlutterMentions(defaultText: room.Message.text,onMentionAdd: (p0){

                          room.GetMentionid(id:p0['id'],name: p0['display']);
                        } ,decoration: InputDecoration(
                              suffixIconColor: Colors.black,border: InputBorder.none,
                              hintText:getLang(context: context,key: "Send_Message")),
                             onChanged: (val){
                          if(val.length<2){
                            room.ClearMentionid();
                          }
                          room.Message.text=val.toString();
                         },
                          autofocus: true,
                          appendSpaceOnAdd: true,
                          suggestionPosition: SuggestionPosition.Top,
                          maxLines: 5,
                          minLines: 1,  trailing : [
                          InkWell(onTap: () {

                            if(room.Message.text==''){
                            }else{
                              room.hideSpinner7();
if(room.Mentionid!=null&&(room.MentionName?.length??0)+1<room.Message.text.length){
print(room.Message.text);
  room.sendMentionChat(content: room.Message.text.replaceFirst('@', '') );

}else{
  room.sendMessageChat(content: room.Message.text );

}
                            }
                            room.Message.clear();
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
                                data:  room.ChairMaps,
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
