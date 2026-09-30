import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/Widgets/Termsanscondition.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class IDloginScrean extends StatefulWidget {
  const IDloginScrean({Key? key}) : super(key: key);

  @override
  State<IDloginScrean> createState() => _IDloginScreanState();
}

class _IDloginScreanState extends State<IDloginScrean> {
  bool visable=false;
  ChangeVisability(){
    visable=!visable;
    setState(() {

    });
  }
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
                        padding:   EdgeInsets.symmetric(vertical: SizeConfig.TenSize!*1.2,horizontal: SizeConfig.TenSize!),
                        child: TextFormField(
                          controller: user.LoginID,
                          keyboardType: TextInputType.text,onChanged: (c){
                          setState(() {

                          });
                        },
                          cursorColor: Colors.black54,
                          decoration: InputDecoration.collapsed(
                              hintText:getLang(context: context, key: "Account_id")),
                        ),
                      ),
                    ),

                    HSized20,
                    Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color(0xFF1878f3).withOpacity(0.1)),
                      child: Padding(
                        padding:   EdgeInsets.symmetric(vertical: SizeConfig.TenSize!*1.2,horizontal: SizeConfig.TenSize!),
                        child: Row(
                          children: [

                            Expanded(
                              child: TextFormField(
                                controller: user.LoginPassword,
                                obscureText: !visable?true:false,
                                keyboardType: TextInputType.text,onChanged: (c){
setState(() {

});
                              },
                                cursorColor: Colors.black54,
                                decoration: InputDecoration.collapsed(
                                    hintText:getLang(context: context, key: "Password")),
                              ),
                            ),
                            InkWell(onTap: () {
                              ChangeVisability();
                            },child: Icon(visable?Icons.visibility_outlined:Icons.visibility_off_outlined,color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                    HSized20,
                    InkWell(
                      onTap: () {

                        if (user.LoginPassword.text.length == 0||user.LoginID.text.length == 0) {
                        } else {
                          if(user.value==false){
                            Dialogs().showtoast(getLang(context:context,key: "MustAccept" ));
                          }else{
                            user.LoginId(context: context);


                          }

                        }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: user.LoginID.text.length != 0&& user.LoginPassword.text.length != 0?const Color(0xFF1878f3).withOpacity(0.8):Colors.black12,
                              borderRadius: BorderRadius.circular(25)),
                          width: SizeConfig.screenWidth!,
                          height: SizeConfig.TenSize!*4.5,
                          child: Center(
                              child: Text(getLang(context: context,key: "Login"),

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
