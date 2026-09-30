import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LanguageScrean extends StatelessWidget {
  const LanguageScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    languageViewmodel language=Provider.of<languageViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white,title:   Text(getLang(context: context,key: "Language"),style: style2,),automaticallyImplyLeading: true ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: InkWell(onTap: () {
              language.Arbic();

            },child: ListTile(title: Text('عربي',style: styleb.copyWith(fontWeight: FontWeight.bold),),trailing: Icon(Icons.language_outlined,color: Lang=='En'? Colors.black12:MainColor))),
          ),
          SliverToBoxAdapter(
            child:                  InkWell(onTap: (){
              language.English();

            },child: ListTile(title: Text('انجليزي',style: styleb.copyWith(fontWeight: FontWeight.bold)),trailing: Icon(Icons.language_outlined,color: Lang=='En'? MainColor:Colors.black12))),
          ),
        ],
      ),
    );
  }
}
