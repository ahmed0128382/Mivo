import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/images.dart';
import '../../../viewmodels/Family_ViewModel/Family_ViewModel.dart';
class CreateFamilyScrean extends StatelessWidget {
  const CreateFamilyScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Container(decoration: const BoxDecoration(image: const DecorationImage(image: ExactAssetImage( Images.VipBackground),fit: BoxFit.cover)),
      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent,title:   Text(getLang(key: "Create_Family",context: context),style: style1,),automaticallyImplyLeading: true ),
        body: SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               const SizedBox(height: 50,),
                  Center(
                    child:InkWell(
                      onTap: () => Family.ComtImage(context),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.circular(20),image: DecorationImage(fit: BoxFit.cover,image: Family.Familymage == null
                            ? const ExactAssetImage(
                            Images.Personalphoto)
                            : FileImage(Family.Familymage) as ImageProvider)),
                 width: 100,height: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                    Center(child: Text(getLang(context: context,key: "picture_family"),style: style11,)),
                  const SizedBox(height: 35,),
                    Text(getLang(context: context,key: "name_family"),style: style11,),
                  const SizedBox(height: 25,),
                  Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(child: TextFormField(controller: Family.FamilyName,decoration:   InputDecoration.collapsed(hintText: getLang(context: context,key: "hint_Name"),))),
                  ),),
                  const SizedBox(height: 25,),
                    Text(getLang(context: context,key: "Desc_family"),style: style11,),
                  const SizedBox(height: 25,),
                  Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(child: TextFormField(controller: Family.FamilyDesc,decoration:   InputDecoration.collapsed(hintText:  getLang(context: context,key: "Enter_Description")))),
                  ),),         const SizedBox(height: 80,),
                InkWell(onTap: () {

                    if(Family.FamilyName.text==''||Family.FamilyDesc.text==''||Family.Familymage==null){
                      Dialogs().showtoast(getLang(context: context,key: "Com_Req"));
                    }else{

Family.CreateFamily(context: context);
                    }

                  },child: Container(child: Center(child:     Text(getLang(context: context,key: "Create"),style: style11.copyWith(fontSize: 25),),),height: 50,width: SizeConfig.screenWidth,decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: MainColor,),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
