import 'package:ahlachat/view/Screans/GamesScrean/Widgets/GameScrean.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../util/Localization.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Games_ViewModel/Games_ViewModel.dart';
import '../../widgets/CircleProgress.dart';
import 'Widgets/GameContainer.dart';
class GamesScrean extends StatefulWidget {

  @override
  State<GamesScrean> createState() => _GamesScreanState();
}

class _GamesScreanState extends State<GamesScrean> {

  ScrollController? _controller;
  void _scrollListener(){
    if (_controller?.offset == _controller?.position.maxScrollExtent) {
      Provider.of<GamesViewModel>(context,listen: false).GetMoreGames(context);

    } else  {
       }
  }

  void initState(){
    _controller = ScrollController();
    _controller?.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    GamesViewModel Games=  Provider.of<GamesViewModel>(context,listen: true);
     return Scaffold(
       appBar: AppBar(title: Text(getLang(context: context, key: "Games") ,style: style6.copyWith(fontSize: 23),),centerTitle: true),
       body:  RefreshIndicator(color: Colors.greenAccent, onRefresh: ()async{
        Provider.of<GamesViewModel>(context,listen: false).GetGames(context: context);
        },
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverPadding(padding: EdgeInsets.only(top: 5)),
            Games.GamesList.length==0?     SliverToBoxAdapter(
              child: Container(height: 300,width: 200,color: Colors.white,
              child: Center(child: Image.asset(Images.Empty1,height: 200,width: 200)),
              )
            ):   SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:1.1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 8),
              delegate: SliverChildBuilderDelegate( (context, index) {

                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(onTap: ()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => GameScrean(index: index,),));

                  },child:  GameContainer(index: index,)),
                );
              },
                childCount: Games.GamesList.length,
              ),
            ),

            SliverToBoxAdapter(
              child: !Games.showloading2?const SizedBox():Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CustomeCircleProgress()),
              ),
            )

          ],
        ),
    ),
     );
  }

}
