import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:flutter/material.dart';
class LevelWidget extends StatelessWidget {
  int Karisma;

  LevelWidget({required this.Karisma});
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.loose,alignment: Alignment.center,
      children: [

        Image.asset(UserLevel.where((element) => element['karisma']<=Karisma).last['image'],height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(UserLevel.where((element) => element['karisma']<=Karisma).last['Level'],style: style6.copyWith( height: 1,fontWeight: FontWeight.bold,color:  Colors.white,fontSize: 9) ),
        ),
      ],);
  }
}
