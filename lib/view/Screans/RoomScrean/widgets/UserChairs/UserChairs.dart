import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/ChairWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/chairLockwidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class UserChair extends StatelessWidget {
  const UserChair({Key? key}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);


     return  GridView.count( padding: EdgeInsets.only(top: 0),shrinkWrap: true ,cacheExtent: 15.6,physics: NeverScrollableScrollPhysics(),
       crossAxisCount:4,
          childAspectRatio :0.98,
       crossAxisSpacing:0.0,
       mainAxisSpacing:0.0,
       children: List.generate(8, (index) { 
         return  Center(
           child:
           Stack(alignment: Alignment.center,
             children: [
               if(Room.Currentroom?.chairs?[index].userId!=null)
                 Align(alignment: Alignment.center,child: Chairwidget(index:  index)),
                if(Room.Currentroom?.chairs?[index].userId==null)
                Align(alignment: Alignment.center,child: ChairLockwidget(index:index )),
               if(Room.Currentroom?.chairs?[index].userId!=null) Padding(
                  padding: const EdgeInsets.only(left: 15,bottom: 50),
                  child: Align(alignment: Alignment.bottomLeft,child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: Colors.transparent,),child: CircleAvatar(backgroundColor: Colors. white54,radius: 10, child: Icon(Room.Currentroom?.chairs?[index].mute==0?Icons.mic:Icons.mic_off_outlined,color: whitecolor,size: 15,))) ),
                ),
               if(user.imoge.any((element) =>element['uid']==int.parse(Room.Currentroom?.chairs?[index].userId??'0')) )
                 Padding(
                   padding: const EdgeInsets.only(bottom: 30),
                   child: Container(height: 80,width: 80,color: Colors.transparent,child: CachedNetworkImage(imageUrl:  user.imoge.where((element) => element['uid']==int.parse(Room.Currentroom?.chairs?[index].userId??'0')).first['imoge']),),
                 )
             ],
           ),
         );

       }

       ),);
  }
}
