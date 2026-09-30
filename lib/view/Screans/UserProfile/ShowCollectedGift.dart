import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
class CollectedGiftScrean extends StatelessWidget {

  List<Gifts> GiftList=[];
  CollectedGiftScrean({required this.GiftList});
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Container(decoration: BoxDecoration(
      image: DecorationImage(image: ExactAssetImage('assets/image/eh.png')),
    ),
      child: Scaffold(backgroundColor: Colors.transparent,appBar: AppBar(backgroundColor: Colors.transparent,automaticallyImplyLeading: true,title: Text('Gifts',)),
        body:   Container(height: SizeConfig.screenHeight,width: SizeConfig.screenWidth,
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10,),
                    CircleAvatar(backgroundColor: Colors.transparent,radius: 40,backgroundImage: CachedNetworkImageProvider(user.userProfileData?.image??''),),
                    SizedBox(height: 10,),
                    Text('${getLang(context: context,key: "gifts")} : ${GiftList.length}',style: style1,)
                  ],
                ),
                SizedBox(height: 30,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color:Color(0xFF222733),borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft:  Radius.circular(25)) ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio:1,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return Column(
                                  children: [
                                    CachedNetworkImage(imageUrl: GiftList[index].gift?.image??'',height: 70,width: 70),
                                    Text((GiftList[index].quantity.toString())+' X',  style: style3.copyWith(fontSize: 12,color: Colors.white70),)
                                  ],
                                ) ;
                              },childCount: GiftList.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ]
          ),
        ),
      ),
    );
  }


}
