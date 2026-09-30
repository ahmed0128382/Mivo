
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_list_pick/country_list_pick.dart' as ss;
import 'package:country_list_pick/country_selection_theme.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PickCode extends StatelessWidget {
  const PickCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold(appBar: AppBar(automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black45)),body:CountryPickerWidget(
      onSelected: (country) {

        user.UpdateFlagCode(
            Code1: country.callingCode,
            Flag1: country.flag,Country1:country.name );
        Navigator.pop(context);
      },
    ));
  }
}


class PickCode2 extends StatelessWidget {
  const PickCode2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold(appBar: AppBar(automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black45)),body:CountryPickerWidget(
      onSelected: (country) {

        user.UpdateFlagCode2(
            Code1: country.callingCode,
            Flag1: country.flag,Name1:  country.name );
        Navigator.pop(context);
      },
    ));
  }
}