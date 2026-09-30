import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class LeaveRoomWidget extends StatelessWidget {

  final ScrollController? _controller= ScrollController();
  @override
  Widget build(BuildContext context) {
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
     RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
     RoomPlayViewModel  RoomPlay =Provider.of<RoomPlayViewModel>(context, listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);
    void _scrollListener() {
      if((_controller?.offset??0) >= (_controller?.position.maxScrollExtent??0)-20 && !Room.showloading2){
        print(_controller?.position);
        Room.GetMoreRoom(context);
      }
    }
    _controller?.addListener(_scrollListener);
    return  Container(color: Colors.black45,height: SizeConfig.screenHeight,width: SizeConfig.screenWidth,
    child:Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                 const SizedBox(height: 50,),
                InkWell(onTap: () {


                  RoomPlay.changeIsRoomstate(false);
                  svga.dispose();
                    Navigator.pop(context);
                  Navigator.pop(context);


                },
                  child:Column(crossAxisAlignment:CrossAxisAlignment.center ,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Image.asset(Images.SaveRoom,width: 80,height: 80,),
                      Text(getLang(context: context,key: "Minimize"), style:style3.copyWith(fontSize: 25,fontWeight: FontWeight.normal,color: Colors.white))
                    ],
                  ),
                ),      const SizedBox(height: 50,),
                InkWell(onTap: () {
                  Navigator.pop(context);
                    svga.dispose();
                    RoomPlay.changeHasRoomstate(false);
                    Provider.of<RoomPlayViewModel>(context, listen: false).changeIsRoomstate(false);
                    JoinChairs=false;
                    Agora.EndAgora();
                    Room.Leaveroom(context:context);

                    Navigator.pop(context);



                },
                  child:  Column(crossAxisAlignment:CrossAxisAlignment.center ,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Image.asset('assets/image/ic_audio_room_exit.png',width: 80,height: 80,),
                      Text(getLang(context: context,key: "Leave"), style:style3.copyWith(fontSize: 25,fontWeight: FontWeight.normal,color: Colors.white))
                    ],
                  ),
                ),
                const SizedBox(height: 50,),


              ],
            ),
          ),
        ),

      ],
    ) ,
    );
  }
}

