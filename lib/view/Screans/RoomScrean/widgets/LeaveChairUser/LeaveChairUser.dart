import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ShowUserRoom.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/UserInfoWidgets.dart';
class LeaveChairUser extends StatelessWidget {
  const LeaveChairUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);
    return Container(decoration: const BoxDecoration(color: Colors.transparent,image: const DecorationImage(image: ExactAssetImage(Images.shopback),fit: BoxFit.cover)), width: SizeConfig.screenWidth! ,child:
    Column(mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.min,
      children: [


        PhotoFrame2(image: user.userroominfo?.image ,Frame:user.userroominfo?. frameimage ),

        UserInfoWidgets(UserDate: user.userroominfo),


        user.showloading3?const SizedBox(height: 50,):Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(onTap:() {
            showModalBottomSheet(barrierColor:Colors.transparent,shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
              context: context,
              builder: (context) {
                return const ShowGiftRoom();
              },
            );
          },
            child: Container(decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(10)),height: 45,width: SizeConfig.screenWidth!,child: Row(
              children: [
                Image.asset(Images.CAS,height: 30),
                const Spacer(),
                Row(
                  children: [
                    if((user.userroominfo?.giftssent?.length??0)>0)  CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[0].gift?.image??Images.userphoto, height: 30,),
                    const SizedBox(width: 5,),
                    if((user.userroominfo?.giftssent?.length??0)>1)    CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[1].gift?.image??Images.userphoto, height: 30,),
                    const SizedBox(width: 5,),
                    if((user.userroominfo?.giftssent?.length??0)>2)CachedNetworkImage(imageUrl: user.userroominfo?.giftssent?[2].gift?.image??Images.userphoto, height: 30,),
                    const SizedBox(width: 5,),
                    const Icon(Icons.arrow_forward_ios,color:Colors.black38,size: 20,)
                  ],
                )
              ],
            )),
          ),
        ),

        Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InkWell(onTap: () {

                Agora.updateKickedFromChair(value: false);
                JoinChairs=false;
                Room.LeaveChair(chairid:Room.Chairid,context: context,index: Room.Chairidex );
                Navigator.pop(context);
              },
                child: Column(crossAxisAlignment:CrossAxisAlignment.center ,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(radius: 25,backgroundColor: Colors.red,child: const Icon(Icons.chair,size: 30,color: whitecolor),),
                    Text(getLang(context: context,key: "Leave_Chair"),style:style3.copyWith(fontWeight: FontWeight.normal))
                  ],
                ),
              ),
            )
        ),
      ],
    ),


    );
  }
}
