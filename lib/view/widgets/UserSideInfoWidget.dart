
import 'package:ahlachat/view/widgets/LevelWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/Usermodel.dart';
import '../../util/app_constants.dart';
import '../../util/helperclass.dart';
import '../../util/images.dart';
import '../../util/styles.dart';


class UserSideInfoWidgets extends StatelessWidget {

  usermodel? UserDate;
  Color TextColor;
  int showdescr;
  UserSideInfoWidgets({this.UserDate,this.TextColor=Colors.black,this.showdescr=0});
  @override
  Widget build(BuildContext context) {

    return Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start,children: [
          Row(mainAxisSize: MainAxisSize.min,
            children: [
              Text(Helper().CutName(UserDate?.name??'') ,style: Namestyle.copyWith(fontSize: 12,height: 1,color: TextColor,overflow: TextOverflow.ellipsis),),
             SizedBox(width:5,),
              SizedBox(width: 2,),
              if(UserDate?.SuporrtedImage!=null)CachedNetworkImage(imageUrl: UserDate?.SuporrtedImage??'' ,height: 16),
              SizedBox(width: 2,),
              LevelWidget(Karisma:UserDate?.Karisma??0 ),
              SizedBox(width: 2,),
              if(UserDate?.MyVip!=null&&UserDate?.MyVip?.Vip?.vipicon!=null) Row(mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 3,),
                  CachedNetworkImage(imageUrl: UserDate?.MyVip?.Vip?.vipicon??"",height: 13, ),
                ],
              ),

              SizedBox(width: 2,),
              if(UserDate?.Supporter==1)Image.asset(Images.Supporter,height: 16),
              SizedBox(width: 2,),


            ],
          ),
    if(UserDate?.description!=null&&showdescr!=1)  Text(Helper().CutName ( UserDate?.description??'') ,style: Namestyle.copyWith(fontSize: 13,height: 1,color:TextColor,overflow: TextOverflow.ellipsis),),

      Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.min,children: [
            if(UserDate?.MyFamil!=null) if(UserDate?.MyFamil?.model!=null)CachedNetworkImage(imageUrl: UserDate?.MyFamil?.model??'',height: 16),
            if(UserDate?.Admin==1)   Image.asset(Images.Manager,height: 16),
            if(UserDate?.SuperAdmin==1)   Image.asset(Images.SuperManager,height: 16),
            if(UserDate?.Official==1) Image.asset(Images.Official,height: 16),
            if(UserDate?.MoneyAgency==1)  Image.asset(Images.MoneyAgency,height: 16),
            if(UserDate?.AgencyId!=null) Image.asset(Images.Services,height: 16),
            if(UserDate?.CustomersService==1)  Image.asset(Images.CustomerService,height: 16),
            if(UserDate?.MemberAgency==1)  Image.asset(Images.ServicesAgency,height: 16),

          ]),
          Row(mainAxisSize: MainAxisSize.min,
            children: [
              if(UserDate?.Announcer==1) Image.asset(Images.Announcer,height: 16),
              if(UserDate?.DB==1)  Image.asset(Images.DB,height: 16),
            ],
          )
        ],
      ),
    ],);
  }
}
