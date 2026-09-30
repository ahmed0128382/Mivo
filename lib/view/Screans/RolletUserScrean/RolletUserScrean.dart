import 'dart:math';

import 'package:ahlachat/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roulette/roulette.dart';

import '../../../util/images.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
    required this.group,
  }) : super(key: key);

  final RouletteController controller;
  final RouletteGroup group;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              group: group,
              // Provide controller to update its state
              controller: controller,
              // Configure roulette's appearance
              style: const RouletteStyle(dividerColor: Colors.white,
                dividerThickness: 4,
                textLayoutBias: .8,
                centerStickerColor: Colors.white,
              ),
            ),
          ),
        ),
        Container(width: 30,height: 30,color: Colors.transparent,child: Image.asset(Images.roulettecenter),)
      ],
    );
  }
}

class RolletFullscrean extends StatefulWidget {
  const RolletFullscrean({Key? key}) : super(key: key);

  @override
  State<RolletFullscrean> createState() => _RolletFullscreanState();
}

class _RolletFullscreanState extends State<RolletFullscrean> {
  static final _random = Random();

  late RouletteController _controller;
  late RouletteGroup _group;
  bool _clockwise = true;


  @override
  void initState() {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
    _group = RouletteGroup.uniform(
      Room.Rolletchoice.length,
      colorBuilder: (index) => Colors.red.withAlpha(50),
      textBuilder: Room.Rolletchoice.elementAt,textStyleBuilder: (index) => style1.copyWith(fontSize: 13),
    );
    _controller = RouletteController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);


    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), ),image: DecorationImage(image: ExactAssetImage(Images.VipBackground),fit: BoxFit.fill)),
      child: Scaffold(backgroundColor: Colors.transparent,

        body: Center(
          child: MyRoulette(controller: _controller, group: _group),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: MainColor,
          // Use the controller to run the animation with rollTo method
          onPressed: ()
          {
            int num= _random.nextInt(Room.Rolletchoice.length) ;
            _controller.rollTo(num,clockwise: _clockwise,
              offset: _random.nextDouble(),
            );

           Future.delayed(Duration(seconds: 4),() => Room.Playrollet(context: context,name: Room.Rolletchoice[num]),);

          },
            child:   Image.asset(Images.Rolletuser),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
