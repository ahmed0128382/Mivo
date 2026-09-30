import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HostreportScrean extends StatelessWidget {
  const HostreportScrean({Key? key}) : super(key: key);
  String getRemainingTime(min) {

    var duration = min;
    int days = duration ~/ 1440;
    int hours;
    duration = duration - (1440 * days);
    hours = duration ~/ 60;
    duration = duration - (60 * hours);

    String dateString;

    dateString = '$hours ساعه $duration دقيقه ';

    return dateString;
  }
  String getRemainingday(min) {

    var duration = min;
    int days = duration ~/ 1440;




    return days.toString() + "  يوم  " ;
  }
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text(getLang(key: "modif",context: context),style: style2),automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black45),),
body: Container(color: secondcolor,
  child:   CustomScrollView(

    slivers: [
      SliverPadding(padding: EdgeInsets.only(top: 10)),
      SliverToBoxAdapter(child: Container(color: Colors.white,child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

          Text('ايام البث النشط',style: style2),

          Text(getRemainingday(user.TargetMin),style: style2),

        ],),
      )),),
      SliverPadding(padding: EdgeInsets.only(top: 10)),
      SliverToBoxAdapter(child: Container(color: Colors.white,child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

          Text('فتره البث',style: style2),

          Text(getRemainingTime(user.TargetMin),style: style2),

        ],),
      )),),
      SliverPadding(padding: EdgeInsets.only(top: 10)),
      SliverToBoxAdapter(child: Container(color: Colors.white,child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

          Text('دخل الماس الهدايا لهذا الشهر',style: style2),

          Text('${user.userinfo?.AgencyKarisma} ماسه',style: style2),

        ],),
      )),)
    ],

  ),
),
    );
  }
}
