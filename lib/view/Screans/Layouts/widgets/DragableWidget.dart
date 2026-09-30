import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spring/spring.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import '../../../../viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import '../../../../viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import '../../../../viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class DragableWidget extends StatefulWidget {
  const DragableWidget({Key? key}) : super(key: key);

  @override
  State<DragableWidget> createState() => _DragableWidgetState();
}

class _DragableWidgetState extends State<DragableWidget> {
  final dragController = DragController();
  final SpringController springController =
  SpringController(initialAnim: Motion.loop);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: false);
    RoomPlayViewModel  RoomPlay =Provider.of<RoomPlayViewModel>(context, listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: false);
    GiftsViewModel  Gift=  Provider.of<GiftsViewModel>(context,listen: true);
    return  InkWell(
      onTap: ()
      {
        Gift.hidpanner();
        Gift.hidpanner2();
        svga.animationController?.clear();
        Provider.of<RoomViewmodel>(context,listen: false).initscrollcontroller();
        Provider.of<GiftsViewModel>(context, listen: false).DeleteGlopal();
        Provider.of<RoomViewmodel>(context,listen: false).Getmaxchat();
        Navigator.pushNamed(  context,AppConstants.Room_Screan);
      },
      child: Row(mainAxisSize: MainAxisSize.min,children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(onTap: (){
if( Room.LeaveLoading==false){
  RoomPlay.changeIsRoomstate(false);
  svga.dispose();
  RoomPlay.changeHasRoomstate(false);
  JoinChairs=false;
  Agora.EndAgora();
  Room.Leaveroom(context: context);
}


          },child: CircleAvatar(radius: 16,backgroundColor: Colors.black38,child: Icon(Icons.close,color: whitecolor,))),
        ),
        Spring.rotate(
          springController: springController,

          animDuration: Duration(seconds: 6),
          child:  Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(Room.Currentroom?.image??Images.unphoto),fit: BoxFit.cover),
                shape:  BoxCircle,

                border: Border.all(color: MainColor,width: 1.5)
            ),
          ),
        ),


      ],)
    );
  }
}
