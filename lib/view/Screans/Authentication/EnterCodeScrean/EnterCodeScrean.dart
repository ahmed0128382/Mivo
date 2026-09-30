
import 'package:flutter/material.dart';


import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';


import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';


class EnterCodeScrean extends StatefulWidget {
 String ?PhoneNumber;

 EnterCodeScrean({required this.PhoneNumber});

  @override
  State<EnterCodeScrean> createState() => _EnterCodeScreanState();
}

class _EnterCodeScreanState extends State<EnterCodeScrean>  with SingleTickerProviderStateMixin   {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Scaffold(

        appBar: AppBar(centerTitle: true,automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black45),),
          body: SingleChildScrollView(
            child: Padding(
              padding:   EdgeInsets.symmetric(horizontal: SizeConfig.TenSize!*2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                    SizedBox(height: SizeConfig.TenSize!*4,),
                  Text(getLang(context: context, key: "Log_phone"),style: style2.copyWith(fontSize: SizeConfig.TenSize!*2,fontWeight: FontWeight.bold)),
                    SizedBox(height: SizeConfig.TenSize!*4,),

                  PinCodeTextField(keyboardType: TextInputType.number,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(borderWidth: 0.0,
                      shape: PinCodeFieldShape.box,
                      fieldOuterPadding:EdgeInsets.symmetric(horizontal: 3),
                      activeColor: Colors.black54,borderRadius: BorderRadius.circular(10),
                      selectedColor:MainColor,
                      inactiveColor: Colors.black54,
                      fieldHeight: SizeConfig.TenSize!*4.5,
                      fieldWidth:SizeConfig.TenSize!*4.5,
                      activeFillColor: Colors.black12,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    cursorColor: Colors.black87,
                    enablePinAutofill: true,
                    enableActiveFill: false,mainAxisAlignment: MainAxisAlignment.spaceAround,
                    enabled: user.sendcodestate==0?false:true,
                    controller: textEditingController,
                    onCompleted: (v) {  },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                       return true;
                    }, appContext: context,
                  ),

                  HSized15,
                  user.sendcodestate==1?
                  Text( getLang(context: context, key: "ReCode_Sent") ,style: style2.copyWith(fontSize: SizeConfig.TenSize!*1.3,color: Colors.black54,fontWeight: FontWeight.normal,))
                  :  InkWell(onTap: (){

                    user.ReSendCodeRlogin(context: context,phonenumber: "+"+user.Code+user.LoginPhonenumber.text);
                    currentText='';
                    textEditingController.clear();
                  },child: Text(  getLang(context: context, key: "ReCode_Sent"),style: style2.copyWith(fontSize: SizeConfig.TenSize!*1.3,color: MainColor,fontWeight: FontWeight.normal,))),
                  HSized40,
                  InkWell(
                    onTap: (){
                      if(user.sendcodestate==0) {

                    }else{
                        if(currentText.length<6){
                          Dialogs().showtoast(getLang(context: context, key: "Correct_Verification"));
                        }else{
                          Provider.of<LoginViewmodel>(context,listen: false).EnterCodelogin(context: context,code:currentText );}
                      }
                    } ,
                    child: Center(child: Container(
                      decoration: BoxDecoration(color:user.sendcodestate!=0?Color(0xFF1878f3).withOpacity(0.8):Colors.black12,borderRadius: BorderRadius.circular(25)),
                      width: SizeConfig.screenWidth!,
                      height: SizeConfig.TenSize!*4.4,
                      child: Center(child: Text(getLang(context: context, key: "Next"),style: style1,)),

                    ),),
                  ),
                ],
              ),
            ),
          )
      );
  }
}

