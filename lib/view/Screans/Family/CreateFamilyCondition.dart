import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/CreateFamilyScrean.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CreateFamilyCondition extends StatelessWidget {
  const CreateFamilyCondition({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
     LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

    return Container(decoration: const BoxDecoration(image: const DecorationImage(image: ExactAssetImage( Images.VipBackground),fit: BoxFit.cover)),
      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent,title:   Text(getLang(key: "Family",context: context),style: style1,),automaticallyImplyLeading: true ),
        body: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50,),
                Image.asset('assets/image/5498791.png'),
                const SizedBox(height: 10,),
                Text(getLang(key: "What_Family",context: context),style: style1,),
                const SizedBox(height: 10,),
                Text(getLang(key: "Family_Desc",context: context),style: style11.copyWith(wordSpacing: 2,height: 1.5),),
                const SizedBox(height: 25,),
                Text(getLang(context: context,key: "Create_Cond"),style: style1,),
                const SizedBox(height: 15,),
                Text('${getLang(key: "Cost",context: context)} 10000 ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15)),
 Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
                  child: InkWell(onTap: () {
                    if((user.userinfo?.coins??0)<10000){
                      Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));
                    }else{
                      navigatereplacementTo(context,CreateFamilyScrean());
                    }

                  },child: Container(height: 45,width: SizeConfig.screenWidth,child: Center(child: Text(getLang(key: "Create_Family",context: context),style: style2.copyWith(height: 1,color: MainColor),)),decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),)),
                ),                const SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
