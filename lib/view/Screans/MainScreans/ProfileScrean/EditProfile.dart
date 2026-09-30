import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? Username;

  String? PhoneNumber;
  String? Description;
  var Password;
  String?City;
  String?  Flag;
int ?ginder;
  String ? year;
  String ? day;
  String ? month;
  String? FaceBook;
  @override
  void initState() {
if(mounted){
  LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
  var info=user.userinfo;
  Description=user.userinfo?.description;
  Username=user.userinfo?.name;
  Password=user.userinfo?.password;
  PhoneNumber=user.userinfo?.phoneNumber;
  if(user.userinfo?.ginder=='0'){
    ginder=0;
  }else{
    ginder=1;
  }
  Flag=user.userinfo?.Flag;
  City=user.userinfo?.city;
  year=user.userinfo?.year;
  day=user.userinfo?.day;
  month=user.userinfo?.month;
}

    super.initState();
  }
  bool visable=false;
  ChangeVisability(){
    visable=!visable;
    setState(() {

    });
  }
  void _showDatePickers(ctx) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    FocusScope.of(context).unfocus();

    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height:SizeConfig.screenHeight!* 0.48366,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                height:SizeConfig.screenHeight!* 0.392,
                child: CupertinoDatePicker(mode: CupertinoDatePickerMode.date,
                       initialDateTime:  DateTime(int.parse(year??'2022'),int.parse(month??'2022'),int.parse(day??'2022')),
                    onDateTimeChanged: (val) {
                      setState(() {

                       day=val.day.toString();
                       year=val.year.toString();
                       month=val.month.toString();


                     //   History=((diff.inDays/365).round()+1).toString();
                      });
                      //print(History);

                    }),

              ),
              CupertinoButton(
                child: Text(getLang( context: context, key: "OK"),style: style1.copyWith(color: MainColor),),
                onPressed: () {



              Navigator.of(ctx).pop();
                  FocusScope.of(context).unfocus();},
              )
            ],
          ),
        ));}
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold(
       appBar: AppBar(centerTitle: false,
        elevation: 0,title: Text(getLang(context: context,key: "Edit_Profile"),style: style2.copyWith(fontSize: 17)),
        backgroundColor: whitecolor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),),

body: Container(height: SizeConfig.screenHeight,width: SizeConfig.screenWidth,
  child: Column(mainAxisAlignment: MainAxisAlignment.start,

    crossAxisAlignment: CrossAxisAlignment.center,

    children: [
      InkWell(onTap: () =>user.getEdittImage( context),
          child: Stack(alignment: Alignment.bottomRight,
            children: [
              CircleAvatar( radius: 47,backgroundColor: MainColor,
                child: CircleAvatar(
                    radius: 45,
                    backgroundColor: whitecolor,
                    backgroundImage: user.Edimage == null
                        ?   CachedNetworkImageProvider(
                        user.userinfo?.image??'')
                        : FileImage(user.Edimage) as ImageProvider),
              ),
              CircleAvatar(radius: 15,backgroundColor: MainColor,child: Icon(Icons.camera_alt,color: Colors.white,size: 15),)
            ],
          )),
      const SizedBox(
        height: 30,
      ),

      Row(
        children: [
          Image.asset(Images.EnterName,height: 40,width: 70),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(height: 40,
              decoration: BoxDecoration( color: Color(0xFF1878f3).withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: TextFormField(
                      onChanged: (value) {
                        Username=value;
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                   initialValue: user.userinfo?.name??'',
                      decoration: InputDecoration.collapsed(
                          hintText: getLang(context: context, key: "Enter_Name"),
                          hintStyle: styleb45.copyWith(fontSize: 16)),
                      style: style8.copyWith(height: 1)),
                ),
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      Row(
        children: [
          Image.asset(Images.EnterName,height: 40,width: 70),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(height: 40,
              decoration: BoxDecoration( color: Color(0xFF1878f3).withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: TextFormField(
                      onChanged: (value) {
                        Description=value;
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      initialValue: user.userinfo?.description??'',
                      decoration: InputDecoration.collapsed(
                          hintText:getLang(context: context,key: "Enter_Description"),
                          hintStyle: styleb45.copyWith(fontSize: 16)),
                      style: style8.copyWith(height: 1)),
                ),
              ),
            ),
          )
        ],
      ),

      const SizedBox(
        height: 30,
      ),

      Row(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(Images.EnterSex,height: 40,width: 70),
          const SizedBox(
            width: 5,
          ),
          InkWell(onTap: () {
            ginder = 1;


            setState(() {});
          },
            child: Container( width: 120,decoration: BoxDecoration( color: Color(0xFF1878f3).withOpacity(ginder == 1?1:0.1),borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: Center(
                  child: Text(
                    getLang(context: context, key: "Female") ,
                    style: style4.copyWith(
                        fontSize: 13, color:ginder == 1?Colors.white:Colors.black87),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(onTap: () {
            ginder = 0;
            setState(() {});
          },
            child: Container(width: 120, decoration: BoxDecoration( color: Color(0xFF1878f3).withOpacity(ginder == 0?1:0.1),borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                child: Center(
                  child: Text(
                    getLang(context: context, key: "Male")  ,
                    style: style4.copyWith(
                        fontSize: 13, color: ginder == 0?Colors.white:Colors.black87),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
      const SizedBox(
        height: 30,
      ),
      Row(
        children: [
          Image.asset(Images.EnterName,height: 40,width: 70),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(height: 40,
              decoration: BoxDecoration( color: Color(0xFF1878f3).withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            obscureText: !visable?true:false,
                            onChanged: (value) {
                              Password=value;
                              setState(() {});
                            },
                            keyboardType: TextInputType.text,
                            initialValue: user.userinfo?.password??'',
                            decoration: InputDecoration.collapsed(
                                hintText: getLang(context: context, key:"Password"),
                                hintStyle: styleb45.copyWith(fontSize: 16)),
                            style: style8.copyWith(height: 1)),
                      ),
                      InkWell(onTap: () {
                        ChangeVisability();
                      },child: Icon(visable?Icons.visibility_outlined:Icons.visibility_off_outlined,color: Colors.blue)),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
     Spacer(),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(onTap: (){
          print(user.userinfo?.rememperToken);
          print(Token);
          if(Username?.length==0){
            Dialogs().showtoast(getLang(context: context, key: "required"));
          }else {
            user.updateNormalProfile(context: context,Password: Password,token: Token,name:Username,Description: Description,PhoneNumber: PhoneNumber,City:City,year: year,month: month,day: day,ginder:ginder,FlagCITY:Flag);
          }
        },child: Container(child: Center(child: Text(getLang(context: context, key: "Save"),style: style1, )),height: 50, width: SizeConfig.screenWidth,decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)))),
      ),
      const SizedBox(height: Dimensions.FONT_SIZE_LARGE,),
    ],

  ),
),
    );
  }
}
