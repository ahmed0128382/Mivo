import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/view/widgets/CustomeTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class ExchangeScrean extends StatefulWidget {
  const ExchangeScrean({Key? key}) : super(key: key);

  @override
  State<ExchangeScrean> createState() => _ExchangeScreanState();
}

class _ExchangeScreanState extends State<ExchangeScrean> {
  TextEditingController jewelry=TextEditingController();
  TextEditingController coins=TextEditingController();
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Scaffold(appBar: AppBar(centerTitle: true,automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black), title: Text(getLang(context: context, key: "Exchange_gems"),style:  styleb.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20), )),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container( width: SizeConfig.screenWidth,height: 200,child: Center(
              child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${user.userinfo?.Input} : ',style: style1.copyWith(fontSize: 30, height: 1.2),),
                    Container(height: 45,width: 45,child: Image.asset(Images.jwile )),

                  ],
                ),
              ),
            ),decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.ExchangeBackground),fit: BoxFit.fill)),),
           const SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Row(
               children: [
                 Image.asset(Images.jwile,width: 30,height: 30),
                 SizedBox(width : 20,),
                 Expanded(child: TextFormField(controller: jewelry,onChanged: (s){
                   if(s!=''){
                     setState(() {
                       coins.text=((int.parse(s.trim())/100)*30).round().toString();
                     });
                   }else{
                     setState(() {
                       coins.text='0';
                     });
                   }

                 },
                   cursorColor: Colors.black,keyboardType:TextInputType.number,
                   decoration: InputDecoration( hintText: '0',    isDense: true,
                     suffixIconColor: Colors.black,
                     focusedBorder:  OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10.0),
                       borderSide: BorderSide(color: MainColor, width: 1.0),
                     ),
                     enabledBorder:   OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10.0),
                       borderSide: BorderSide(color:   MainColor, width: 1.0),
                     ),



                   ),
                 ),),
               ],
             ),
           ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Image.asset(Images.coins,width: 30,height: 30),
                  SizedBox(width : 20,),
                  Expanded(child: TextFormField(enabled: false,controller:coins ,
                    cursorColor: Colors.black,keyboardType:TextInputType.number,
                    decoration: InputDecoration( hintText: '0',   isDense: true,
                      suffixIconColor: Colors.black,
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MainColor, width: 1.0),
                      ),
                      enabledBorder:   OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color:   MainColor, width: 1.0),
                      ),disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color:   MainColor, width: 1.0),
                        )



                    ),
                  ),),
                ],
              ),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(onTap: (){

                if(jewelry.text !=''){
                  if( int.parse(jewelry.text) <= (user.userinfo?.Input as int) ){
                 Dialogs().showdialog(context: context, tittle: 'asd', content:   'هل انت متأكد كم تبديل هذه الجواهر الي ماسات ؟', buttontext:  getLang(context: context, key: "Yes"), onTap: (){
                   FocusScope.of(context).unfocus();
                   Navigator.pop(context);
                   user.Exchangecoins(context: context,jwile:jewelry.text );
                 });
                  }else{
                    Dialogs().showtoast(getLang(context: context,key: "Not_Enoughbeans"));

                  }
                }


              },child: Container(child: Center(child: Text(getLang(context: context, key: "Exchange"),style: style1, )),height: 50, width: SizeConfig.screenWidth,decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)))),
            )
          ],
        ),
      ),
    );
  }
}
