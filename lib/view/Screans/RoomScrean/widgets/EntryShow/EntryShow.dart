import 'package:flutter/material.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
class EntryShow extends StatelessWidget {
  const EntryShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);

    return     Center(
      child: svga.isLoading
          ? const SizedBox()
          : SVGAImage(svga.animationController??SVGAAnimationController(vsync: thiss),clearsAfterStop:true),
    );
  }
}
