import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/view/widgets/UserInfoWidgets.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Stack(alignment: Alignment.center,
      children: [

        ImageSlideshow(
          width: double.infinity,
          height: 300,
          initialPage: 0,
          indicatorColor: Colors.transparent,

          indicatorBackgroundColor:Colors.transparent,
          children:List.generate(user.userProfileData?.ProfileImages?.length==0?1:user.userProfileData?.ProfileImages?.length??0, (index) => CachedNetworkImage(
              imageUrl:user.userProfileData?.ProfileImages?.length==0?user.userProfileData?.image??'':user.userProfileData?.ProfileImages![index].image??'',fit: BoxFit.fill)),
          onPageChanged: (value) {},
          autoPlayInterval: 4000,
          isLoop: true,
        ),
        Positioned(bottom: 20,
        child: Row(
          children: [


            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  if(user.userProfileData?.Relations?.isNotEmpty??false)
                   user.userProfileData?.Relations?.first.user?.id!=user.userProfileData?.id?
                   FrameUserProfile(image: user.userProfileData?.Relations?.first.user?.image,Frame: user.userProfileData?.Relations?.first.user?.frameimage ):
                    FrameUserProfile(image: user.userProfileData?.Relations?.first.anotheruser?.image,Frame: user.userProfileData?.Relations?.first.anotheruser?.frameimage ),
                  if(user.userProfileData?.Relations?.isNotEmpty??false)  Image.asset('assets/image/cp_tray_3.png',height: 50,width: 50,),
                  FrameUserProfile(image: user.userProfileData?.image,Frame: user.userProfileData?.frameimage ),
                ],
              ),
              UserInfoWidgets( UserDate:user.userProfileData ,)
            ],
    ),
          ],
        ),
      )

      ],
    );
  }
}