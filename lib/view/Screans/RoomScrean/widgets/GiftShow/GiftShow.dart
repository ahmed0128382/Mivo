import 'package:flutter/material.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
class GiftShow extends StatelessWidget {
  const GiftShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);

    return  Center(
      child:svga.isLoading2
          ? SizedBox():SVGAImage(svga.animationController2??SVGAAnimationController(vsync: thiss),clearsAfterStop:false),
    );
  }
}
