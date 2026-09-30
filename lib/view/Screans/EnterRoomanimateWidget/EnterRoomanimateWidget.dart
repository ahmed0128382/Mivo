
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:animated_overflow/animated_overflow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterAnimateWidget extends StatefulWidget {
  EnterAnimateWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EnterAnimateWidgetState createState() => _EnterAnimateWidgetState();
}

class _EnterAnimateWidgetState extends State<EnterAnimateWidget> {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);

    return  TweenAnimationBuilder(
      child:Container(color: Colors.transparent,

        child: Stack(alignment: Alignment.center,
          children: [
            if(Rooms.EnterUserinfo?.Enterbubles!='')   Container(width: 150,height: 45,
              decoration: BoxDecoration( color:  Colors.transparent ,image:  DecorationImage(image: CachedNetworkImageProvider(Rooms.EnterUserinfo?.Enterbubles??''),fit: BoxFit.fill)),
              child: Center(child: Text(' ${Helper().CutName7(name: Rooms.EnterUserinfo?.name??'')}دخل الغرفه  ',style: style2.copyWith(color: Colors.white,fontSize: 12) ,textDirection: TextDirection.ltr,)),
            ),
            if(Rooms.EnterUserinfo?.Enterbubles=='')  Container(width: 150,height: 30 ,
              decoration: BoxDecoration(color:   Colors.orange, gradient: gradiant5, borderRadius: BorderRadius.circular(10)),
              child: Center(child: Padding(
                padding:   EdgeInsets.only(left: 10 ),
                child: Text(' دخل الغرفه ${Rooms.EnterUserinfo?.name??''} ',style: style2.copyWith(color: Colors.white,fontSize: 12) ,textDirection: TextDirection.ltr,),
              )),
            ),
            Positioned(left: 5, child: CircleAvatar(backgroundImage: CachedNetworkImageProvider(  Rooms.EnterUserinfo?.image??""),radius: 12,)),


          ],
        ),
      ),
      duration: Duration(milliseconds: 3000),
      onEnd: (){
      Rooms.HideEnterWidget();


      },
      curve: Curves.fastOutSlowIn,
      tween: Tween(begin:1.5, end: Rooms.EnterOffser),
      builder: (context, value, child){
        return Transform.translate(
          offset:  Offset(
              ( value  as double) * 60,
              0.0
          ),
          child: child,
        );
      },
    );
  }
}