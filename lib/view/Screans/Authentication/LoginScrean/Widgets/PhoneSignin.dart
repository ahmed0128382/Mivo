import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../util/Localization.dart';
import '../../../../../util/SizeConfig.dart';
import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';


class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    return InkWell(
      onTap: (){
      //  user.signInWithFacebook();
      },
      child: Container(width: SizeConfig.screenWidth!/1.4,
        height: 55,
        decoration:  BoxDecoration(color: Color(0xFF1878f3),borderRadius: BorderRadius.circular(25) ),
        child: Padding(
          padding: HWPadding10,
          child: Row(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WSized5,
              Text(getLang( context: context, key: "Phone_Sign_in"),textAlign: TextAlign.end,textDirection: TextDirection.rtl,style: style8.copyWith(height: 1,color: Colors.white,fontWeight: FontWeight.bold)),
              Image.asset(Images.FaceBook,width: 27,height: 27 ),

            ],
          ),
        ),
      ),
    );
  }
}
