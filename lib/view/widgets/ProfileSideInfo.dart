
import 'package:ahlachat/view/widgets/LevelWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/Usermodel.dart';
import '../../util/app_constants.dart';
import '../../util/helperclass.dart';
import '../../util/images.dart';
import '../../util/styles.dart';


class ProfileSideInfoWidgets extends StatelessWidget {

  usermodel? UserDate;
  Color TextColor;
  int showdescr;
  ProfileSideInfoWidgets({this.UserDate,this.TextColor=Colors.black,this.showdescr=0});
  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,children: [
      Row(
        children: [
          Text(Helper().CutName(UserDate?.name??'') ,style: Namestyle.copyWith(fontSize: 18,height: 1,color: TextColor,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),),
          SizedBox(width:5,),
          LevelWidget(Karisma:UserDate?.Karisma??0 ),
          SizedBox(width: 2,),
          if(UserDate?.MyVip!=null&&UserDate?.MyVip?.Vip?.vipicon!=null) Row(
            children: [
              const SizedBox(width: 3,),
              CachedNetworkImage(imageUrl: UserDate?.MyVip?.Vip?.vipicon??"",height: 17, ),
            ],
          ),
          SizedBox(width: 2,),
          if(UserDate?.Supporter==1)Image.asset(Images.Supporter,height: 15),

        ],
      ),

      if(UserDate?.description!=null&&showdescr!=1)  Text(Helper().CutName ( UserDate?.description??'') ,style: Namestyle.copyWith(fontSize: 13,height: 1,color:TextColor,overflow: TextOverflow.ellipsis),),

      Row(mainAxisSize: MainAxisSize.min,children: [
        if(UserDate?.SuperAdmin==1)   Image.asset(Images.Manager,height: 20),
        if(UserDate?.Official==1) Image.asset(Images.Official,height: 20),
        if(UserDate?.MoneyAgency==1)  Image.asset(Images.MoneyAgency,height: 20),
        if(UserDate?.DB==1) Image.asset(Images.DB,height: 20),

      ]),
      Row(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(UserDate?.AgencyId!=null) Image.asset(Images.Services,height: 20),
          if(UserDate?.CustomersService==1)  Image.asset(Images.CustomerService,height: 20),
          if(UserDate?.MemberAgency==1)  Image.asset(Images.ServicesAgency,height: 20),
          if(UserDate?.SuporrtedImage!=null)CachedNetworkImage(imageUrl: UserDate?.SuporrtedImage??'' ,height: 15),
          if(UserDate?.Announcer==1) Image.asset(Images.Announcer,height: 20),
        ],
      ),
      SizedBox(height:  3,),
      Row(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text( 'ID : '+(UserDate?.Newid??UserDate?.myappid)  ,style: Namestyle.copyWith(fontSize: 13,height: 1,color: Colors.black45,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal),),
          SizedBox(width: 2,),
          Image.asset(UserDate?.ginder=='0'?Images.sexman:Images.sexwoman,height: 16),

        ],
      ),

    ],);
  }
}
