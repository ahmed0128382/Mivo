import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    Path path0 = Path();
    path0.moveTo(size.width*0.5034184,size.height*0.1688026);
    path0.quadraticBezierTo(size.width*0.9510459,size.height*0.1778158,size.width*0.9923469,size.height*0.1947368);
    path0.lineTo(size.width*0.9974490,size.height*0.9973684);
    path0.lineTo(size.width*0.0076531,size.height*0.9973684);
    path0.lineTo(size.width*0.0025510,size.height*0.1973684);
    path0.quadraticBezierTo(size.width*0.0936990,size.height*0.1798684,size.width*0.5034184,size.height*0.1688026);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
class CustomClipPath2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size){


    Path path0 = Path();
    path0.moveTo(size.width*0.1388889,size.height*0.6549020);
    path0.quadraticBezierTo(size.width*0.3037778,size.height*0.7203137,size.width*0.1388889,size.height*0.7856209);
    path0.lineTo(size.width*0.6972222,size.height*0.7830065);
    path0.quadraticBezierTo(size.width*0.8529722,size.height*0.7147974,size.width*0.7951111,size.height*0.6553464);
    path0.cubicTo(size.width*0.6310556,size.height*0.6552353,size.width*0.6180556,size.height*0.6529412,size.width*0.1388889,size.height*0.6549020);
    path0.close();

    return path0;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}