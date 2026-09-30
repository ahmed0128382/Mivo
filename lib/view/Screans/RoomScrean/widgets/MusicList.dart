// import 'package:flutter/material.dart';
// import 'package:ahlachat/util/Localization.dart';
// import 'package:ahlachat/util/SizeConfig.dart';
// import 'package:ahlachat/util/images.dart';
// import 'package:ahlachat/util/styles.dart';
// import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
// import 'package:ahlachat/viewmodels/Music_Viewmodel/MusicViewmodel.dart';
// import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
//
// import '../../../../util/app_constants.dart';
// import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
//
// class  Agoralist extends StatelessWidget {
//   const Agoralist({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//   AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);
//    MusicViewModel music= Provider.of<MusicViewModel>(context,listen: true);
//   LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
//
//   return   ListView(
//     children: [
//       Container(height: 50,color: Colors.lightBlue,child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, ),
//               child: InkWell(onTap: (){
//                 Navigator.pop(context);
//                 music.addsongs();
//                 music.SelectedMusic.clear();
//                 Navigator.pushNamed(context, AppConstants.AddMusic_Screan);
//
//               },child: const Icon(Icons.add_box_outlined,size: 30,color:  whitecolor,)),
//             ),
//             Text(getLang(context: context, key: "Music_List"),style: style2.copyWith(color: whitecolor),),
//
//           ],
//         ),
//       ),),
//       Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children:List.generate(music.SongsList.length, (index) => Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(onTap: ()async {
//           Navigator.pop(context);
//           await Agora.StartAudioMexing(filePath: music.SongsList[index].data,duration: music.SongsList[index].duration,tittle: music.SongsList[index].title,indexsong: index);
//
//         },child: Container( child: Row(
//           children: [
//             Icon(Icons.music_note_outlined,color: MainColor),
//             Container(width: SizeConfig.screenWidth!/1.5,child: Text(music.SongsList[index].title,style: style6,overflow: TextOverflow.ellipsis)),
//
//             if(Agora.PlaySong.contains(music.SongsList[index].title)) SVGASimpleImage( assetsName: Images.live,)
//           ],
//         ))),
//       )),)
//     ],
//
// );
//   }
// }
