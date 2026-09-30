import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LuckyBagswidget extends StatelessWidget {
  const LuckyBagswidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List LuckyPackage=[{'coins':50,'id':1},{'coins':100,'id':2},{'coins':500,'id':3},{'coins':1000,'id':4}];
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("اكياس الحظ",style: style2.copyWith(fontSize: 15),),
        SizedBox(height: 10,),
        Container( width: MediaQuery.of(context).size.width * .7,height: 280,
          child: GridView.builder(cacheExtent: 15,physics: ScrollPhysics(),
              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:2,
                  childAspectRatio:1,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2),itemBuilder:(context, index){
                return InkWell(
                  onTap: () {

                    user.UpdatePackageid(val: LuckyPackage[index]['coins']);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:LuckyPackage[index]['coins']==user.Packageid? Colors.blue.withOpacity(0.3) :Colors.blueGrey.withOpacity(0.1)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15,),
                          Image.asset(Images.LuckyPrize,height: 70),
                          SizedBox(height: 10,),
                          Row(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(LuckyPackage[index]['coins'].toString(),style: style2,),
                              SizedBox(width: 5,),
                              Image.asset(Images.coins,width: 13),
                            ],
                          )

                        ]),
                  ),
                );
              },itemCount:LuckyPackage.length ),
        ),
        InkWell(onTap:(){
if(user.Packageid==null){

}else if((user.Packageid??0)>(user.userinfo?.coins??0)||(user.Packageid??0)<0){
  Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));
}else{

  Navigator.pop(context);
  user.NewLuckyPackage(context: context,Roomid: Rooms.Currentroom?.id);

}
        },child: Container(child: Center(child:  Text('ارسال',style:  style1.copyWith(fontSize: 13),)),width: SizeConfig.screenWidth,height: 35,decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10), ))),

      ],
    );
  }
}
