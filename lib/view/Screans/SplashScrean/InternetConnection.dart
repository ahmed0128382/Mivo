import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import '../../../util/app_constants.dart';
class InternetConnection extends StatefulWidget {
  @override
  State<InternetConnection> createState() => InternetConnection_State();
}

class InternetConnection_State extends State<InternetConnection> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Container(height: SizeConfig.screenHeight,width: SizeConfig.screenWidth,decoration: const BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/5966878.jpg')))),),
    );
  }
}
