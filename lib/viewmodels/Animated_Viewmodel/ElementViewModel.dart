import 'package:ahlachat/models/GiveGifts.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../models/Usermodel.dart';
import '../../util/app_constants.dart';
import '../Gifts_Viewmodel/Gifts_Viewmodel.dart';

List svgas=[];
class SvgViewmodel extends ChangeNotifier    {
  SVGAAnimationController? animationController;
  bool isLoading = false;

  getcontroller({required String svga,enterImage,entername})async{

    EnterImage=enterImage;
    Entername=entername;

    animationController=await SVGAAnimationController(vsync: thiss)..addListener(() {
      if ( animationController?.isCompleted == true) {
        animationController?.stop();
        isLoading = true;
        notifyListeners();
      }

    });
    loadAnimation(image: svga);
    notifyListeners();

  }

  addsvgtolist({required String svgaimage}){
    svgas.add(svgaimage);
  }

  void dispose() {
    animationController?.dispose();
    animationController = null;
    animationController?.clear();
    animationController2?.dispose();
    animationController2 = null;
    animationController2?.clear();
    notifyListeners();
  }


  Future  loadVideoItem(String image) {
    Future Function(String) decoder;
    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(image);
  }

  void loadAnimation({image}) async {

    print(image);
    // FIXME: may throw error on loading
    final videoItem = await loadVideoItem(image);

    animationController?.clear();

    animationController?.videoItem = videoItem;
    playAnimation();
    notifyListeners();

  }

  void  playAnimation()async {
    print('playAnimation');
    isLoading=false;
    await animationController?.forward();
    notifyListeners();
  }
//-------------------------------------------------

  SVGAAnimationController? animationController2;
  bool isLoading2 = false;
  List<dynamic> Image=[];
  getcontroller2({String? svga,context,givegifts?  Give,usermodel ?userinfo})async{

    if(svga!=null){
      Image.add({'SVGA':svga,'GIVE':Give});
    }
    if(Image.isNotEmpty){
      if(animationController2 == null ||animationController2?.value==0.0){

        animationController2=await SVGAAnimationController(vsync: thiss, )..addListener(() {
          if (animationController2?.isCompleted == true){

            Provider.of<GiftsViewModel>(context,listen: false).startmotion(ListUser:Give?.ListUser??[],image:Give?.image,name: Give?.name,quantity: Give?.quantity);

            animationController2=null;
            animationController2?.dispose();
            Image.removeAt(0);
            if(Image.isNotEmpty){
              getcontroller2(context: context,Give:Image.first['GIVE'],userinfo: userinfo   );
            }
            isLoading2 = true;
            notifyListeners();
          }});
        if(Provider.of<GiftsViewModel>(context,listen: false).selected2==true){

          Provider.of<GiftsViewModel>(context,listen: false).hidpanner2();
          Future.delayed(Duration(seconds: 1),() {

            Provider.of<GiftsViewModel>(context,listen: false).sidepanner2(user: userinfo,Give: Give);
          },);

        }else{
          Provider.of<GiftsViewModel>(context,listen: false).sidepanner2(user: userinfo,Give: Give);

        }

        loadAnimation2(image:Image[0]['SVGA'],context:context,Give: Image[0]['GIVE'] );

        notifyListeners();

      }}

  }
  Future  loadVideoItem2(String image) {
    Future Function(String) decoder;
    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(image);
  }
  void loadAnimation2({image,context,Give}) async {
    print('9');
    print(image);
    // FIXME: may throw error on loading
    final videoItem = await loadVideoItem2(image,);
    if(Give?.Sound!=null){
      //Dialogs().showtoast(message)
      Helper().PlaylinkMusic(path: Give?.Sound);
    }
    animationController2?.clear();
    print('loadAnimation  1010101010101010101');

    animationController2?.videoItem = videoItem;
    playAnimation2(context:context,Give: Give );
    notifyListeners();

  }
  void  playAnimation2({context,givegifts ?Give})async {


    isLoading2=false;
    await animationController2?.forward();

    notifyListeners();
  }


//-------------------------------------------------
  SVGAAnimationController? animationController3;
  getcontroller3({String? Svga})async{

    animationController3=await SVGAAnimationController(vsync: thiss )..addListener(() {
      if (animationController3?.isCompleted == true){
        animationController3?.repeat();
      }});
    loadAnimation3(image:Svga  );
    notifyListeners();

  }
  Future  loadVideoItem3(String image) {
    Future Function(String) decoder;
    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(image);
  }
  void loadAnimation3({image }) async {
    final videoItem = await loadVideoItem3(image);
    animationController3?.clear();
    animationController3?.videoItem = videoItem;
    playAnimation3();
    notifyListeners();
  }
  void  playAnimation3()async {
    await animationController3?.forward();
    notifyListeners();
  }
//-------------------------------------------------
  SVGAAnimationController? animationController4;
  bool loading5=false;
  getcontroller4({String? Svga})async{
    loading5=true;
    animationController4=await SVGAAnimationController(vsync: thiss )..addListener(() {
      if (animationController4?.isCompleted == true){
        loading5=false;
        animationController4?.stop();
     //   animationController4?.dispose();
      }});
    loadAnimation4(image:Svga  );

    notifyListeners();

  }
  Future  loadVideoItem4(String image) {
    Future Function(String) decoder;
    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(image);
  }
  void loadAnimation4({image }) async {
    print('image');
    print(image);
    // FIXME: may throw error on loading
    final videoItem = await loadVideoItem3(image);

    animationController4?.clear();
    print('animationController4  1010101010101010101 animationController4' );

    animationController4?.videoItem = videoItem;
    playAnimation4();
    notifyListeners();

  }
  void  playAnimation4()async {
    print('playAnimation animationController4 animationController4 ');
    await animationController4?.forward();
    notifyListeners();
  }
//-------------------------------------------------

  SVGAAnimationController? animationController5;
  bool isLoading5 = false;
  List<dynamic> Image2=[];
  getcontroller5({String? svgas,userid})async{

    if(svgas!=null){
      Image2.add({'SVGA':svgas,'userid':userid});
      print('svgassvgassvgassvgassvgassvgassvgassvgassvgas');
      print(Image2);
      print('svgassvgassvgassvgassvgassvgassvgassvgassvgas');
    }
    if(Image2.isNotEmpty){
      if(animationController5 == null ||animationController5?.value==0.0){
        animationController5=await SVGAAnimationController(vsync: thiss)..addListener(() {
          if (animationController5?.isCompleted == true){
            animationController5=null;
            animationController5?.dispose();

            Image2.removeAt(0);


            if(Image2.isNotEmpty){
              getcontroller5(userid:userid  );

            }
            isLoading5 = true;
            notifyListeners();
          }});


      }else{

      }

      loadAnimation5(image:Image2[0]['SVGA'],userid:Image2[0]['userid']);

      notifyListeners();

    }}
  Future  loadVideoItem5(String image) {
    Future Function(String) decoder;
    if (image.startsWith(RegExp(r'https?://'))) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(image);
  }
  void loadAnimation5({image,userid}) async {

    final videoItem = await loadVideoItem5(image);
    animationController5?.clear();
    animationController5?.videoItem = videoItem;
    playAnimation5(userid: userid);
    notifyListeners();
  }

  void  playAnimation5({userid})async {
    isLoading5=false;
    ImojeSUserId=userid;
    await animationController5?.forward();
    notifyListeners();
  }

}
