import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SendGift.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class GiftBox extends StatelessWidget {
  const GiftBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);

    return       InkWell(onTap: (){
      Room.ChairsRoom.clear();
      Room.UserIds.clear();
      gits.GiftList.clear();
      Room.clearcompo();
        Room.Currentroom?.chairs?.forEach((element) {
          if(element.userId!=null&&element.user!=null){
            Room.ChairsRoom.add(element);

          }
        });        gits.Cost=0;
      showModalBottomSheet(barrierColor:Colors.transparent,  backgroundColor: Colors.transparent,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
        context: context,
        builder: (context) {
          return const NestedTabBar();
        },
      );
      // Room.showSpinner33();

    },child: Image.asset( Images.PrizeRoom,height: 40, width: 40,));
  }
}
