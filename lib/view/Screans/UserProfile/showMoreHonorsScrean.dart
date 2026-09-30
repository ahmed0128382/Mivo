import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import 'package:intl/intl.dart';
class MoreHonorsScrean extends StatelessWidget {
  const MoreHonorsScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Container(decoration: BoxDecoration(
      image: DecorationImage(image: ExactAssetImage('assets/image/eh.png')),
    ),
      child: Scaffold(backgroundColor: Colors.transparent,appBar: AppBar(backgroundColor: Colors.transparent,automaticallyImplyLeading: true,title: Text(getLang(context: context,key: "Models"),)),
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
                Text('${getLang(context: context,key: "Models")} : ${user.userProfileData?.Models?.length??0}',style: style1,)
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
                              CachedNetworkImage(imageUrl: user.userProfileData?.Models![index].AchiveModel?.image??'',height: 70),
                              Text( "${DateFormat('dd-MMM-yyy').format(DateTime.parse(user.userProfileData?.Models![index].createdAt??'' ))}",
                              style: style3.copyWith(fontSize: 12,color: Color(0xFF5f501f)),)
                            ],
                          ) ;
                        },childCount: user.userProfileData?.Models?.length,
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
