import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';
class ContactUs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return  Scaffold(body:   Container(color: whitecolor,height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,child:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.navigate_next,color: whitecolor),
                    Text(
                      'تواصل معنا',
                      style: style6.copyWith(fontSize: 15) ,
                    ),
                    InkWell(onTap: (){

                      user.clearreport();
                    Navigator.pop(context);
                    },child: Icon(Icons.navigate_next)),
                  ],
                ),
              ),
              Text('Types of feedback',style: styleb45.copyWith(fontSize: 15),),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                InkWell(onTap: (){
                  user.SetChoose(value: "Help");
                },
                  child: Row(children: [
                    Radio(
                        value: "Help",
                        groupValue:user.Choose,
                        activeColor: MainColor,
                        onChanged: (value){
                           
                          user.SetChoose(value: "Help");
                        }
                    ),
                    Text('Help',style: styleb.copyWith(fontSize: 13),),

                  ],),
                ),
                InkWell(onTap: (){
                  user.SetChoose(value: "Bug");
                },
                  child: Row(children: [
                    Radio(
                        value: "Bug",
                        groupValue:user.Choose,
                        activeColor: MainColor,
                        onChanged: (value){
                           
                          user.SetChoose(value: value.toString());
                        }
                    ),
                    Text('Bug',style: styleb.copyWith(fontSize: 13),),

                  ],),
                ),
                InkWell(onTap: (){
                  user.SetChoose(value: "Suggestion");
                },
                  child: Row(children: [
                    Radio(
                        value: "Suggestion",
                        groupValue:user.Choose,     activeColor: MainColor,
                        onChanged: (value){
                           
                          user.SetChoose(value: value.toString());
                        }
                    ),
                    Text('Suggestion',style: styleb.copyWith(fontSize: 13),),

                  ],),
                ),
              ],),

              Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color:  whitecolor6),
                height: 150,
                width: SizeConfig.screenWidth!,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Expanded(child: TextFormField(controller: user.Content,maxLines: null,decoration: InputDecoration.collapsed(hintText: 'Please leave your feedback it will be helpful.',hintStyle: styleb45.copyWith(fontSize: 13,color: whitecolor7)), )),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(onTap: (){
                            user.getReportImage(context);
                          },child: Container(width: 60,height: 60,color: Color(0xFFC0C1C4).withOpacity(0.6)  ,child: user.Reportimage==null? Center(child: Icon(Icons.add,size: 60,color: whitecolor,)):Image.file( user.Reportimage,fit: BoxFit.fill),)),
                        )
                      ]),
                ),
              ),
              const SizedBox(height: 20,),
              Text('How to contact you',style: styleb45.copyWith(fontSize: 15),),
              const SizedBox(height: 5,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                InkWell(onTap: (){
                  user.SetChoose2(value: "WhatsApp");
                },
                  child: Row(children: [
                    Radio(
                        value: "WhatsApp",
                        groupValue:user.Choose2,
                        activeColor: MainColor,
                        onChanged: (value){
                           
                          user.SetChoose2(value: "WhatsApp");
                        }
                    ),
                    Text('WhatsApp',style: style6.copyWith(fontSize: 13),),

                  ],),
                ),
                InkWell(onTap: (){
                  user.SetChoose2(value: "Email");
                },
                  child: Row(children: [
                    Radio(
                        value: "Email",
                        groupValue:user.Choose2,
                        activeColor: MainColor,
                        onChanged: (value){
                          user.SetChoose2(value: "Email");
                        }
                    ),
                    Text('Email',style: style6.copyWith(fontSize: 13),),

                  ],),
                ),
                InkWell(onTap: (){
                  user.SetChoose2(value: "Phone");
                },
                  child: Row(children: [
                    Radio(
                        value: "Phone",
                        groupValue:user.Choose2,     activeColor: MainColor,
                        onChanged: (value){
                          user.SetChoose2(value: "Phone");
                        }
                    ),
                    Text('Phone',style: style6.copyWith(fontSize: 13),),

                  ],),
                ),
              ],),
              const SizedBox(height: 20,),
              Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color:  whitecolor6),child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                child: TextFormField(maxLines: null,controller:user.Contact,decoration: InputDecoration.collapsed(hintText: 'Leave your contacts here.',hintStyle: styleb45.copyWith(fontSize: 13,color: whitecolor7)), ),
              )),
              const SizedBox(height: 20,),
              user. showloading7?Center(child: CircularProgressIndicator(color: MainColor),)  : InkWell(onTap: (){

                if(user.Content.text==''){
                  Dialogs().showdialog4(context: context,  content:   'رجاء ادخل نص التقرير اولا' ,);
                }else if(user.Contact.text==''){
                  Dialogs().showdialog4(context: context,  content:   'رجاء ادخل طريقه التواصل' ,);

                }else{

                user.SendReport(context: context  );
                }
              },child: Container(height: 40,width: SizeConfig.screenWidth!,child: Center(child: Text('Send',style: style2.copyWith(color: whitecolor),)),decoration: BoxDecoration(color: MainColor,borderRadius:BorderRadius.circular(8) ),))
            ],
          ),
        ),
      ),


      ),
    );
  }
}
