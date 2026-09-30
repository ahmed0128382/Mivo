import 'package:ahlachat/models/AgencyModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AgencySideInfo extends StatelessWidget {

  Agencymodel? AgencyDate;
  Color TextColor;
  int showdescr;
  AgencySideInfo({required this.AgencyDate,this.TextColor=Colors.white,this.showdescr=1});

  @override
  Widget build(BuildContext context) {
    return   Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(  AgencyDate?.name??'',style: style5.copyWith(fontWeight: FontWeight.bold,height: 1,fontSize: 17,color: TextColor)),
        if(showdescr==0) SizedBox(height: 5,),
      if(showdescr==0)  Row(
          children: [
            if( AgencyDate?.agencyKind==1||AgencyDate?.agencyKind==2)  Icon(Icons.monetization_on_outlined,size: 20,color: TextColor) ,
            if( AgencyDate?.agencyKind==1)  SizedBox(width: 10,),
            if( AgencyDate?.agencyKind==0||AgencyDate?.agencyKind==2)      Icon(Icons.group,size: 20,color:TextColor) ,
          ],
        ),
        SizedBox(height: 5,),
        InkWell(onTap: () {
          Clipboard.setData(ClipboardData(text:AgencyDate?.appid??'' ));
          Dialogs().showtoast(getLang(context: context, key: "Copied"));
        },child: Text( 'ID : ${AgencyDate?.appid} ',style: style5.copyWith(fontWeight: FontWeight.normal,fontSize: 13,height: 1,color: TextColor))),


      ],
    );
  }
}
