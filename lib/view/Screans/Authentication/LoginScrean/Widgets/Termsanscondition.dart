
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../util/Localization.dart';
import '../../../../../util/styles.dart';
import '../../../../widgets/WebViewScrean.dart';

class Termesandcondition extends StatefulWidget {
  const Termesandcondition({Key? key}) : super(key: key);

  @override
  State<Termesandcondition> createState() => _TermesandconditionState();
}

class _TermesandconditionState extends State<Termesandcondition> {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return  Padding(
      padding: WPadding30,
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text.rich( TextSpan(
              children: [
                TextSpan(
                  text:'agree to',style:style5.copyWith(color: Colors.black45, fontSize:  SizeConfig.TenSize!*1.2),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewScrean(name: getLang( context: context, key: "Terms_Service"), link: 'https://chocolate-elka-52.tiiny.site/',),));
                  },
                  text:  ' Terms Of Service ' ,style:style5.copyWith( fontSize: SizeConfig.TenSize! ,fontWeight: FontWeight.bold,decoration: TextDecoration.underline, color:Color(0xFF1878f3)),
                ),
                TextSpan(
                  text:  ' and ' ,style:style5.copyWith(color: Colors.black45, fontSize: SizeConfig.TenSize!*1.2),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewScrean(name: getLang( context: context, key: "Privacy_Policy"), link: 'http://privacy.worldchat.online/',),));
                  },
                  text:  "Privacy Policy",style:style5.copyWith( fontSize: SizeConfig.TenSize!,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,color:Color(0xFF1878f3) ),
                ),


              ]),maxLines: null,textAlign: TextAlign.center,),
          Transform.scale(
            scale:0.7,
            child:  Checkbox(   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color: Colors.grey),
            ),
              value: user.value,checkColor: Colors.white,
              onChanged: (bool? hh) {
                setState(() {
                  user.value = hh!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
