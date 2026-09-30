import 'package:ahlachat/models/AchiveModel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/ModelsScrean/ModelsScrean.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Level_repositores/Level_api.dart';

import '../../models/LevelGifts.dart';



class LevelViewModel extends ChangeNotifier{
List<UserLevelGifts> LevelGift=[];
  bool showloading = false;
  void showSpinner() {
     ;
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void HiddenSpinner() {
     ;
    showloading = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
List<AchiveModels>? Models;
   GetModels( context)async {
     ShowGlopalLoading();


    await Levelapi()
        .GetModels( )
        .then((value) {

      Models=value;
      navigateTo(context: context, screen: ModelsScrean());

      DismissGlopalLoading();
    });
    notifyListeners();
  }

}