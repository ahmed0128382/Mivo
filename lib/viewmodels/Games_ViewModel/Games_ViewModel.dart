import 'package:ahlachat/Repositores/Games_repositores/Games_api.dart';
import 'package:ahlachat/models/GameModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GamesViewModel extends ChangeNotifier {
  bool showloading = false;
  bool showloading2 = false;

  void showSpinner() {
    showloading = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }

  void hideSpinner() {
    showloading = false;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }

  void hideSpinner2() {
    showloading2 = false;
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }

  List<GamesModel> GamesList = [];
  GetGames({context}) async {
    showSpinner();
    await Gamesapi().AllGames(context).then((value) {
      GamesList = value;

      hideSpinner();
    });
    notifyListeners();
  }

  GetMoreGames(context) async {
    showSpinner2();
    await Gamesapi().GetMoreGames(context).then((value) {
      value.forEach((element) {
        GamesList.add(element);
      });
      hideSpinner2();
    });
    notifyListeners();
  }

  IncreamentGames({id, index}) async {
    await Gamesapi().Increament(id: id).then((value) {
      //   GamesList[index].NumberPersons=GamesList[index].NumberPersons??0 +1;
      //notifyListeners();
    });
  }
}
