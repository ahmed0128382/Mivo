
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/AgencyLeaderBoardScrean/AgencyLeaderBoardScrean.dart';
import 'package:ahlachat/view/Screans/Family/FamilyRankScrean.dart';
import 'package:ahlachat/view/Screans/WeeklyStar/WeeklyStarScrean.dart';
import 'package:ahlachat/view/widgets/ImageView.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../util/styles.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class ImageSlide extends StatelessWidget {
  const ImageSlide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    AagencyViewModel  Agency=Provider.of<AagencyViewModel>(context,listen:  false);
    RoomViewmodel    Rooms=  Provider.of<RoomViewmodel>(context,listen: false);
    return  ImageSlideshow(
      width: double.infinity,
      height: 120,
      initialPage: 0,
      indicatorColor: Colors.transparent,

      indicatorBackgroundColor:whitecolor,
      children:List.generate(user.Banners.length, (index) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          onTap: () {
            print(user.Banners[index].id);
            if(user.Banners[index].roomId=='1'){
              Rooms.GetWeeklyStar(context: context);
              navigateTo(context: context, screen: WeeklystarScrean());

            }else if(user.Banners[index].roomId=='2'){
              Agency.GetAgencyLeaderBoard();
              navigateTo(context: context, screen: AgencyLeaderBoardScrean());

            }else if(user.Banners[index].roomId=='3'){
              Navigator.pushNamed( context, AppConstants.LeaderboardScrean);
              Provider.of<RoomViewmodel>(context,listen: false).GetRoomLeaderboard(context: context);
            }else if(user.Banners[index].roomId=='4'){
              Rooms.GetFamilyLeaderboard(context: context);
              navigateTo(context: context,screen: LeaderboardFamilyScrean());
            }else if(user.Banners[index].roomId=='5'){

              showModalBottomSheet( barrierColor: Colors.black.withAlpha(1),
                  backgroundColor: Colors.transparent, isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Container(height: 600,child: WebViewRollet(name: getLang( context: context, key: "Terms_Service"), link: 'http://game.worldchat.online/?token=${user.userinfo?.rememperToken}',));
                  });
            }else if(user.Banners[index].roomId=='6'){

              navigateTo(context: context,screen: Container(width: SizeConfig.screenWidth,height: SizeConfig.screenHeight,
              child: SingleChildScrollView(
                child: Column(children: [
                  Image.asset('assets/image/target002.png'),
                  Image.asset('assets/image/target003.png')
                ]),
              ),));
            }else if(user.Banners[index].roomId=='7'){

              navigateTo(context: context,screen: Container(color: Colors.black,width: SizeConfig.screenWidth,height: SizeConfig.screenHeight,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 30),
                    child: Column(children:List.generate(user.Banners[index].SubBanner?.length??0, (indexs) => Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                      child: Row(
                        children: [
                          InkWell(onTap: () async{

                            if(user.Banners[index].SubBanner![indexs].phone!=null){
                              var whatsappUrl ="whatsapp://send?phone=${user.Banners[index].SubBanner![indexs].phone}";
                              await canLaunch(whatsappUrl);
                              launch(whatsappUrl);
                            }


                          },child: const FaIcon( FontAwesomeIcons.whatsapp,size: 30,color: whitecolor)),
SizedBox(width: 20,),
                          Expanded(child: Container(height: 150,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),image: DecorationImage(image: CachedNetworkImageProvider(user.Banners[index].SubBanner![indexs].image??''),fit: BoxFit.fill)))),
                        ],
                      ),
                    ))),
                  ),
                ),));
            }else if(user.Banners[index].roomId=='8'){
               navigateTo(context: context, screen: ImageView(url:user.Banners[index].Secondimage));
            }

          },
          child: ClipRRect(    borderRadius: BorderRadius.circular((10.0)),
              child:  CachedNetworkImage(
          imageUrl:user.Banners[index].image??'',fit: BoxFit.fill)),
        ),
      )),
      onPageChanged: (value) {},
      autoPlayInterval: 3000,
      isLoop: true,
    );
  }
}

class ImageSlide2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    return  Container(width: 70,
      decoration: BoxDecoration(gradient: gradiant1,borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),topRight: Radius.circular(20),)),
      child: ImageSlideshow(
        width: double.infinity,
        height: 50,
        initialPage: 0,
        indicatorColor: Colors.transparent,
        indicatorBackgroundColor:whitecolor,
        children:List.generate(user.Banners.length, (index) => Image.asset('assets/image/coin6.png',width: 100,height:100)),
        onPageChanged: (value) {},
        autoPlayInterval: 5000,
        isLoop: true,
      ),
    );
  }
}
