//
//
// import 'package:ahlachat/util/Dialogs.dart';
// import 'package:ahlachat/util/Localization.dart';
// import 'package:ahlachat/util/SizeConfig.dart';
// import 'package:ahlachat/util/app_constants.dart';
// import 'package:ahlachat/util/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:provider/provider.dart';
//
// import '../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
// import '../../../viewmodels/Music_Viewmodel/MusicViewmodel.dart';
// import '../../widgets/CircleProgress.dart';
// class SelectMusicScrean extends StatelessWidget {
//   const SelectMusicScrean({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     MusicViewModel music= Provider.of<MusicViewModel>(context,listen: true);
//     AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: false);
//
//     return Scaffold(backgroundColor: Color(0xFF10152b),
//       appBar: AppBar(elevation:10,title:  Text("قائمه الاغاني",style: style1.copyWith(height: 1)),automaticallyImplyLeading: true,backgroundColor: Color(0xFF10152b), ),
//       body: Container(height: SizeConfig.screenHeight,width:SizeConfig.screenWidth,child:music.loading?Center(child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(height: 40,width: 40,child: CustomeCircleProgress()),
//           SizedBox(height: 20,),
//           Text(getLang( context: context, key: "Please_wait"),style: style1.copyWith(height: 1,fontSize: 20))
//         ],
//       )): Column(
//         children: [
//           SizedBox(height: 5,),
//           Container(height: 60,width: SizeConfig.screenWidth, child: TextFormField(style: style1,onChanged: (e){
//             music.Filtercity(e);
//
//           },decoration: InputDecoration(border: InputBorder.none,prefixIcon: const Icon(Icons.search,color: Colors.white60),hintText: getLang( context: context, key: "Music_search"),hintStyle: style1.copyWith(color: Colors.white60)),)),
//           Container(height: 2,color: Colors.white24,width: SizeConfig.screenWidth),
//           Expanded(child: ListView.separated(separatorBuilder: (context, index) => Container(height: 2,color: Colors.white24,width: SizeConfig.screenWidth),itemBuilder: (context, index) => Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
//             child: InkWell(onTap: ()async{
//
//               MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);
//
//               if(music.SongsList.contains(music.searchResult[index])){
//                 music.UnSelectMusic(music.searchResult[index]);
//               }else{
//                 music.SelectMusic(music.searchResult[index]);
//               }
//              },child: Container(  color: Colors.transparent,child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(child: Text( music.searchResult[index].title,style: style1.copyWith(color: Agora.PlaySong.contains(music.searchResult[index].title)?Colors.red:Colors.white),)),
// SizedBox(width: 5,),
//
//              if(music.SongsList.contains(music.searchResult[index]))   CircleAvatar(radius: 5,backgroundColor: Colors.tealAccent),
//               ],
//             ))),
//           ), itemCount: music.searchResult.length,)),
//
//
//         ],
//       ), ),
//     );
//   }
// }
