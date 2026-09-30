import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/Widgets/Termsanscondition.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/helperclass.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';

class PhoneAuthScrean extends StatefulWidget {
  const PhoneAuthScrean({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScrean> createState() => _PhoneAuthScreanState();
}

class _PhoneAuthScreanState extends State<PhoneAuthScrean> {

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold( appBar: AppBar(elevation:0.0,automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black)),
        body: Padding(
          padding: WPadding30,
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height:  SizeConfig.TenSize!*5,),

                Column(mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( getLang(context: context, key: "Hey"),style: style2.copyWith(fontSize:  SizeConfig.TenSize!*4.5)),
                    SizedBox(height:  SizeConfig.TenSize!*3,),

                    Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF1878f3).withOpacity(0.1)),
                      child: Padding(
                        padding:   EdgeInsets.symmetric(vertical:  SizeConfig.TenSize!*1.2,horizontal:  SizeConfig.TenSize!),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {

                               Navigator.pushNamed(context, AppConstants.PickCode_Screan);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    user.Flag,
                                    package: countryCodePackageName,
                                    width: 30,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(user.Code, style: style2.copyWith(height: 1,fontSize: 20,color: Colors.black45)),
                                ],
                              ),
                            ),
                            WSized15,
                            Expanded(
                                child: TextFormField(
                              controller: user.LoginPhonenumber,
                              keyboardType: TextInputType.phone,onChanged: (c){
                                setState(() {

                                });
                                },
                              cursorColor: Colors.black54,
                              decoration: InputDecoration.collapsed(
                                  hintText:getLang(context: context, key: "Phone_Number")),
                            ))
                          ],
                        ),
                      ),
                    ),

                    HSized40,

                       InkWell(
                            onTap: () {

                              if (user.LoginPhonenumber.text.length == 0) {
                              } else {
                                if(user.value==false){
                                  Dialogs().showtoast(getLang(context:context,key: "MustAccept" ));
                                }else{
                                  user.userlogin(context: context);


                                }
  
                              }
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: user.LoginPhonenumber.text.length != 0?Color(0xFF1878f3).withOpacity(0.8):Colors.black12,
                                    borderRadius: BorderRadius.circular(25)),
                                width: SizeConfig.screenWidth!,
                                height:  SizeConfig.TenSize!*4.5,
                                child: Center(
                                    child: Text(getLang(context: context,key: "Login_SignUp"),

                                  style: style1,
                                )),
                              ),
                            ),
                          ),

                    HSized10,
                    const Termesandcondition(),
                    HSized20,
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
