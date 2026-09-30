import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/Chatroom.dart';
import '../../../../../util/SizeConfig.dart';
import '../../../../../util/images.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import '../../../../../viewmodels/Socket_ViewModel/Socketviewmodel.dart';
class PickedImageRoom extends StatelessWidget {
  const PickedImageRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return  Container(height: 70,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20,),
        InkWell(onTap: () {
          Room.SentImageRoom(context: context);
          Navigator.pop(context);
        },child : Image.asset(Images.send,width: 40,height: 40)) ,
        const  SizedBox(width: 20,),
        InkWell(onTap: (){
          Navigator.pop(context);
        },child: Image.asset(Images.close,width: 40,height: 40)) ,
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container( width: 65,height: 65,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(image: FileImage(Room.ChatRoomImage) as ImageProvider,fit: BoxFit.cover))),
        ),

      ],
    ),width: SizeConfig.screenWidth,color:   const Color(0xFF221316).withOpacity(0.7),);
  }
}
