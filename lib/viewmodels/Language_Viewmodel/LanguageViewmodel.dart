

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


String ? Lang='En';
checklanguage()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Lang= prefs.getString('Lang');
  print("language====================================$Lang");
  print('Lang is $Lang');

}
class languageViewmodel extends ChangeNotifier {


  void Arbic() async{

    Lang = 'Ar';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Lang','Ar');
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }
  void English() async{

    Lang = 'En';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Lang','En');
    notifyListeners(); // (Method for ChangeNotifiers) Or equivalent call to rebuild the view
  }



}