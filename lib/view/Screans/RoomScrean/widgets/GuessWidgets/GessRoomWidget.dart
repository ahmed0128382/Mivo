import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GeussRoomWidget extends StatelessWidget {
  const GeussRoomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return   Align(alignment: Alignment.center,
      child:   Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(width: SizeConfig.screenWidth,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.black,image: DecorationImage(image: ExactAssetImage('assets/image/icon_room_mora_game_bg.png'),fit: BoxFit.cover)),height: 150,
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height:  8,),
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [

                          CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(Room.guesses.first['guess'].Reciver.image??''),radius: 13),
                          SizedBox(width: 5,),
                          Text(Room.guesses.first['guess'].Reciver.name,style: style1.copyWith(fontSize: 13),),
                        ],
                      ),
                      Row(
                        children: [Text(Room.guesses.first['guess'].Sender.name,style: style1.copyWith(fontSize: 13),),
                          SizedBox(width: 5,),
                          CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(Room.guesses.first['guess'].Sender.image??''),radius: 13),

                        ],
                      ),
                    ],
                  ),
                  SizedBox(height:  10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Room.guesses.first['guess'].acceptGueess==1?Images.guessing11:Room.guesses.first['guess'].acceptGueess==2?Images.guessing22:Images.guessing33,height: 60),
                        Image.asset(Room.guesses.first['guess'].senderGueess==1?Images.guessing1:Room.guesses.first['guess'].senderGueess==2?Images.guessing2:Images.guessing3,height: 60),
                      ],
                    ),
                  ),
                  SizedBox(height:  10,),
                  Room.guesses.first['guess'].status==3?
                  Text( '${Room.guesses.first['guess'].Sender?.name}  تعادل مع  ${Room.guesses.first['guess'].Reciver?.name}',textDirection: TextDirection.ltr,style: TextStyle(color: Colors.orange,fontSize: 16 ),):Text('${Room.guesses.first['guess'].Sender?.id==Room.guesses.first['guess'].winner?Room.guesses.first['guess'].Sender?.name:Room.guesses.first['guess'].Reciver?.name} الفائز هو  ',textDirection: TextDirection.ltr,style: TextStyle(color: Colors.orange,fontSize: 16),),
                ],
              ),
            )
        ),
      ),
    );
  }
}
