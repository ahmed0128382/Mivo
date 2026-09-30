import 'package:ahlachat/util/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../util/Localization.dart';
import '../../../../../util/SizeConfig.dart';
import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class GoogleSignin extends StatelessWidget {
  const GoogleSignin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false) ;

    return     InkWell(onTap:(){

      if(user.value==false){
        Dialogs().showtoast(getLang(context:context,key: "MustAccept" ));
      }else{
        user.SignInwithGoogle(context);


      }




    } ,
      child: Container(width: SizeConfig.screenWidth!/1.4,
        height: 55,
        decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(25) ,border: Border.all(color: Colors.black)),
        child: Padding(
          padding: HWPadding10,
          child: Row(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WSized5,
              Text(getLang( context: context, key: "Google_Sign_in"),textAlign: TextAlign.end,textDirection: TextDirection.rtl,style: style8.copyWith(height: 1,fontWeight: FontWeight.bold) ),
              Image.asset(Images.Google,width: SizeConfig.TenSize!*2.7,height: SizeConfig.TenSize!*2.7,),
            ],
          ),
        ),
      ),
    );
  }
}
