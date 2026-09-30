import 'package:ahlachat/viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MusicList.dart';

import '../../../../util/app_constants.dart';
import '../../AddMusicScrean/AddMusicScrean.dart';

class MusicPlayerRoom extends StatefulWidget {
  const MusicPlayerRoom({Key? key}) : super(key: key);

  @override
  State<MusicPlayerRoom> createState() => _MusicPlayerRoomState();
}

class _MusicPlayerRoomState extends State<MusicPlayerRoom> {
  @override
  Widget build( context) {
    RoomViewmodel Room   =Provider.of<RoomViewmodel>(context,listen: true);
    AgoraViewmodel Agora =Provider.of<AgoraViewmodel>(context,listen: true);
    MusicViewModel music= Provider.of<MusicViewModel>(context,listen: true);


    print('Agora. setaudiodefult');
    return Container(decoration: const BoxDecoration( color: Colors.black12,borderRadius: const BorderRadius.only(topRight: const Radius.circular(20),topLeft: Radius.circular(20) )) ,width: SizeConfig.screenWidth!,
        child:Room.showloading14? const Padding(
          padding: EdgeInsets.only(top: 100),
          child: const Center(child: CircularProgressIndicator(),),
        ):Column(mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(onTap: (){

                 //   music.addsongs();
                    Navigator.pushNamed(context, AppConstants.AddMusic_Screan);
                  },child: const Icon(Icons.list,color: whitecolor,size: 30,)),
                  if(Agora.PlaySong.isNotEmpty) Container(width: SizeConfig.screenWidth!-80,child: Text(Agora.PlaySong.first,style: style1.copyWith(fontSize: 13,overflow: TextOverflow.ellipsis))),
                ],
              ),
            ),
    //           StreamBuilder <DurationState>(
    //           stream: music.durationStateStream ,
    // builder: (context, snapshot) {
    //             return Row(
    //               children: [
    //                 const SizedBox(width: 20,),
    //                 const FaIcon( FontAwesomeIcons.music,size: 16,color: whitecolor),
    //
    //                 Expanded(
    //                   child: Slider.adaptive(
    //                       activeColor: Colors.white,inactiveColor: MainColor.withOpacity(0.3),
    //                       value: snapshot.data?.position.inSeconds.toDouble()??0.0,
    //                       max:snapshot.data?.total.inSeconds.toDouble()??0.0,
    //                       onChanged: (value) {
    //
    //                        music.seekToSec(int.parse(value.round().toString()));
    //                    Agora.setAudioMixingPosition((int.parse(value.round().toString())*1000));
    //                       }),
    //                 ),
    //               ],
    //             );
    // }),



            StatefulBuilder(
              builder: (context,state){
                return Center(
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      const FaIcon( FontAwesomeIcons.volumeHigh,size: 16,color: whitecolor),
                      Expanded(
                        child: Slider(activeColor: Colors.white,inactiveColor: MainColor.withOpacity(0.3),
                          value:Agora.volumnaudio.toDouble(),
                          max: 100,
                          min: 0,
                          onChanged: (double value) {

                             Agora.setaudiovolum( (value ).round() );
                           setState(() {
                           });

                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),




            const SizedBox(height: 30),
            Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              mainAxisSize:  MainAxisSize.max,
              children: [
             if( Agora.Rebeate)   InkWell(onTap: () {
               Agora.ChangeRepeate(false);
             },child: const FaIcon( FontAwesomeIcons.repeat,size: 26,color: whitecolor)),
                if( !Agora.Rebeate)InkWell(onTap: () {
                  Agora.ChangeRepeate(true);
                },child: const Icon(Icons.repeat_one,size: 30,color: whitecolor)),
const Spacer(),
                 //skip to previous
                Flexible(
                  child: InkWell(
                    onTap: ()async{
                      Agora.last(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5 ),
                      decoration:  BoxDecoration(borderRadius: BorderRadius.circular(20),color: whitecolor),
                      child: const Icon(Icons.skip_next, color:MainColor,),
                    ),
                  ),
                ),

                //play pause
                Flexible(
                  child: InkWell(
                    onTap: (){
                      if(Agora.PlaySong.isEmpty){
                        Dialogs().showtoast(getLang(context: context,key: "Choose_Song_First"));
                      }else{
                        if(Agora.playmusic){
                          Agora.stopAudioMexing(context);

                        }else{
                          Agora.resumAudioMexing(context);
                        }
                      }


                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                      decoration:  BoxDecoration(borderRadius: BorderRadius.circular(20),color: whitecolor),
                      child:Icon(Agora.playmusic?Icons.pause:Icons.play_arrow, size: 30, color: MainColor,),
                    ),
                  ),
                ),

                //skip to next
                Flexible(
                  child: InkWell(
                    onTap: ()async{

                      Agora.next(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration:  BoxDecoration(borderRadius: BorderRadius.circular(20),color: whitecolor,),
                      child: const Icon(Icons.skip_previous, color: MainColor),
                    ),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 15),
          ],
        )



    );
  }
}
