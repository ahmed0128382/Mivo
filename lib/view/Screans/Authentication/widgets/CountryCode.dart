import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../../../util/app_constants.dart';
import '../../../../util/styles.dart';

class CountryCodePhone extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  CountryCodePicker(
      onChanged: (value){
        phonecode=value.dialCode.toString();
      },
      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      initialSelection: 'EG',
      favorite: ['+20','EG'],
      // optional. Shows only country name and flag
      showCountryOnly: false,textStyle:style1.copyWith(color: MainColor),

      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,searchStyle: style1.copyWith(color: MainColor),
      // optional. aligns the flag and the Text left
      alignLeft: false,
    );
  }
}
class  SelectCountry extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  CountryCodePicker(
      onChanged: (value){
        countryname=value.name.toString();
      },
      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      initialSelection: 'EG',
      favorite: ['+20','EG'],
      // optional. Shows only country name and flag
      showCountryOnly: true,textStyle:style1.copyWith(color: MainColor),

      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: true,searchStyle: style1.copyWith(color: MainColor),
      // optional. aligns the flag and the Text left
      alignLeft: false,
    );
  }
}
