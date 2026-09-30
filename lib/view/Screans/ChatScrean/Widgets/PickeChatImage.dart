import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../util/SizeConfig.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
class PickedImageChat extends StatelessWidget {
   var id;
   usermodel ?userinfo;
   PickedImageChat({this.userinfo,this.id});
  @override
  Widget build(BuildContext context) {
    InboxroomViewModel    Inboxrooms= Provider.of<InboxroomViewModel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);

    return  Container(height: 70,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20,),
        InkWell(onTap: () {



           Inboxrooms.SentImageChat(userinfo: userinfo,context: context,id: id );


          Navigator.pop(context);
        },child : Icon(Icons.send,color: Colors.white,)) ,
        const  SizedBox(width: 20,),
        InkWell(onTap: (){
          Navigator.pop(context);
        },child: Icon(Icons.clear ,color: Colors.white,)) ,
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container( width: 65,height: 65,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(image: FileImage(Inboxrooms.ChatuserImage) as ImageProvider,fit: BoxFit.cover))),
        ),

      ],
    ),width: SizeConfig.screenWidth,color:  MainColor.withOpacity(0.7),);
  }
}
