import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../util/styles.dart';
import '../../../../viewmodels/Games_ViewModel/Games_ViewModel.dart';

class GameContainer extends StatelessWidget {
  int index;
  GameContainer({required this.index});
  @override
  Widget build(BuildContext context) {
    GamesViewModel Games=  Provider.of<GamesViewModel>(context,listen: true);

    return  Stack( children: [
      Container(  decoration: BoxDecoration(    borderRadius: BorderRadius.circular(15), image: DecorationImage(fit: BoxFit.fill,image: CachedNetworkImageProvider(Games.GamesList[index].image??''))),),
      Align(alignment:Alignment.bottomCenter,
        child: Container(color:  Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Flexible(child: Text(Games.GamesList[index].name??'',style: style1.copyWith(color: whitecolor,fontSize: 11,overflow: TextOverflow.ellipsis),)),

              Container(decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(7)), child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5 ),
                child: Row(
                  children: [
                    Text(Games.GamesList[index].NumberPersons.toString(),style: style1.copyWith(color: whitecolor,fontSize: 11),),
                    const SizedBox(width: 5,),
                    Icon(Icons.person,color: whitecolor,size: 13),
                  ],
                ),
              ),)
            ],),
          ),
        ),
      )

    ],);


  }
}
