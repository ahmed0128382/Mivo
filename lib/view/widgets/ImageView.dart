import 'dart:io';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class ImageView extends StatelessWidget {
 String ?url ;
 ImageView({this.url});
  @override
  Widget build(BuildContext context) {
   return Container(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            // Container(width: SizeConfig.screenWidth,height: 60,child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            //   GestureDetector(onTap:   ()=>
            //     Navigator.pop(context) ,child: const Icon(Icons.close,color: Colors.white,size: 25)), GestureDetector(onTap:   ()async{
            //     Dialogs().showtoast('بدأ التحميل'); 
            //
            //     try {
            //       var imageId = await ImageDownloader.downloadImage(url??'');
            //       if (imageId == null) {
            //         Dialogs().showtoast('imageId Not Found');
            //         return;
            //       }
            //
            //       Dialogs().showtoast('Done');
            //
            //     } on PlatformException catch (error) {
            //       print(error);
            //     }
            //
            //   },child: const Icon(Icons.save_alt,color: Colors.white,size: 25,))],)),
            Expanded(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(url??''),
              ),
            ),
          ],
        )
    );
  }
}
class ImageFileView extends StatelessWidget {
  File ?Files ;
  ImageFileView({this.Files});
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return Container(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Container(width: SizeConfig.screenWidth,height: 60,child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              GestureDetector(onTap:   (){
                Navigator.pop(context);

            }
                   ,child: const Icon(Icons.close,color: Colors.white,size: 25)),
              GestureDetector(onTap:   (){
                Navigator.pop(context);
                Room.AddackImage(  );
              },child: const Icon(Icons.check,color: Colors.white,size: 25))
            ])),
    Expanded(
    child: PhotoView(
    imageProvider: FileImage(Files! ),
    ),
    ),
          ],
        )
    );
  }
}

class ImageView2 extends StatelessWidget {
  String ?url ;
  ImageView2({this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Container(width: SizeConfig.screenWidth,height: 60,child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
              GestureDetector(onTap:   ()=>
                  Navigator.pop(context) ,child: const Icon(Icons.close,color: Colors.white,size: 25)),
           ],)),
            Expanded(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(url??''),
              ),
            ),
          ],
        )
    );
  }
}