//
//
// import 'package:ahlachat/util/Dialogs.dart';
// import 'package:ahlachat/util/Localization.dart';
// import 'package:ahlachat/util/SizeConfig.dart';
// import 'package:ahlachat/util/app_constants.dart';
// import 'package:ahlachat/util/helperclass.dart';
// import 'package:ahlachat/util/styles.dart';
// import 'package:ahlachat/view/Screans/AddMusicScrean/SelectMusicList.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
//
// import '../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
// import '../../../viewmodels/Music_Viewmodel/MusicViewmodel.dart';
// import '../../widgets/CircleProgress.dart';
// class AddMusicScrean extends StatelessWidget {
//   const AddMusicScrean({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     MusicViewModel music= Provider.of<MusicViewModel>(context,listen: true);
//     AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: false);
//
//     return Scaffold(backgroundColor: Color(0xFF10152b),
//       appBar: AppBar(elevation:10,actions: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: InkWell(onTap: () {
//             //music.addsongs();
//            // navigateTo(context: context, screen: SelectMusicScrean());
//           },child: Icon(Icons.add_box_outlined,color: Colors.white,size: 25)),
//         )
//       ],title:  Text( getLang( context: context, key: "Playlist"),style: style1.copyWith(height: 1)),automaticallyImplyLeading: true,backgroundColor: Color(0xFF10152b), ),
//       body: Container(height: SizeConfig.screenHeight,width:SizeConfig.screenWidth,child:true?Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(height: 40,width: 40,child: CustomeCircleProgress()),
//           SizedBox(height: 20,),
//           Text(getLang( context: context, key: "Please_wait"),style: style1.copyWith(height: 1,fontSize: 20))
//         ],
//       // )): Column(
//       //   children: [
//       //     SizedBox(height: 20,),
//       //     Container(height: 2,color: Colors.white24,width: SizeConfig.screenWidth),
//       //     Expanded(child: ListView.separated(separatorBuilder: (context, index) => Container(height: 2,color: Colors.white24,width: SizeConfig.screenWidth),itemBuilder: (context, index) => Padding(
//       //       padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
//       //       child: InkWell(onTap: ()async{
//       //         Navigator.pop(context);
//       //         MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);
//       //
//       //        music.play(music.SongsList[index].data);
//       //   await Agora.StartAudioMexing(filePath: music.SongsList[index].data,duration: music.SongsList[index].duration,tittle: music.SongsList[index].title,indexsong: index);
//       //      },child: Container(  color: Colors.transparent,child: Text( music.SongsList[index].title,style: style1.copyWith(color: Agora.PlaySong.contains(music.SongsList[index].title)?Colors.red:Colors.white),))),
//       //     ), itemCount: music.SongsList.length,)),
//       //
//       //
//       //   ],
//       // ),
//      // ),
//     //);
//
// }
