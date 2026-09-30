
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';

class CustomeButton extends StatelessWidget {
String ?tittle;

CustomeButton({this.tittle, this.color, this.hight,this.ontap});
VoidCallback ? ontap;
  Color ? color;
double? hight;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: ontap,
      child: Container(decoration: BoxDecoration(   color:color??whitecolor ,borderRadius: BorderRadius.circular(25)),
child: Center(child: Text(tittle??'',style: style2,)),
        height:hight??60 ,
      ),
    );
  }
}
