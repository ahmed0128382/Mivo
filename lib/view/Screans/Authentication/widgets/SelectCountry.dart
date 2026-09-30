import 'package:ahlachat/view/Screans/Authentication/widgets/CountryCode.dart';
import 'package:flutter/material.dart';


import '../../../../util/Localization.dart';
import '../../../../util/styles.dart';
class CountryChoose extends StatelessWidget {
  const CountryChoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.circular(10)),width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('${getLang(context:context,  key: "Country")}  :  ',style: style1.copyWith(color: MainColor)),
            const Spacer(),
            SelectCountry()
          ],
        ),
      ),
    );
  }
}
