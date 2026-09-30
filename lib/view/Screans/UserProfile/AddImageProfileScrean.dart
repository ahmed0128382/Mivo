import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AddImageProfileScrean extends StatelessWidget {
  const AddImageProfileScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,title:   InkWell(onTap: () {

        print(user.userProfileData?.ProfileImages?.length);
      },child: Text(getLang(context: context,key: "Profile_Photo"),style: style2,)),automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black), ),
body: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   CustomScrollView(
    slivers: [
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio:0.9,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
                if(index==user.userProfileData?.ProfileImages?.length){
                  return InkWell(onTap: (){

                    user.ProfileImagepick(context);
                  },child: Container(height: 70,width: 70,child: Center(child: Icon(Icons.add,size: 30,)),decoration: BoxDecoration(color: Colors.black12,borderRadius:BorderRadius.circular(10)  ),))  ;
                }
                 return InkWell(onTap: () {
                   showDialog(
                       context: context,
                       builder: (_) => AlertDialog(
                         backgroundColor: Colors.white,
                         content: Column(mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text('World Team',style: style2.copyWith(fontSize: 20),),
                             SizedBox(height: 10,),
                             InkWell(onTap: (){
                               Navigator.pop(context);
                              user. deleteProfileImage(user.userProfileData?.ProfileImages![index].id);

                             },child: Text('حذف الصوره',style: style5.copyWith(fontSize: 15),)),

                           ],
                         ),
                       )
                   );
                 },child:  Container(height: 70,width: 70,decoration: BoxDecoration(color: Colors.grey,borderRadius:BorderRadius.circular(10) ,image: DecorationImage(image:CachedNetworkImageProvider( user.userProfileData?.ProfileImages![index].image??''),fit: BoxFit.cover)),))  ;

                 },childCount: (user.userProfileData?.ProfileImages?.length??0)+1,
        ),
      ),
    ],
  ),
),
    );
  }
}
