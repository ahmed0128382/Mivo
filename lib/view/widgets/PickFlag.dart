import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickCode extends StatelessWidget {
  const PickCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.black45,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                user.UpdateFlagCode(
                  Code1: '+${country.phoneCode}',
                  Flag1: country.flagEmoji,
                  Country1: country.name,
                );

                Navigator.pop(context);
              },
            );
          },
          child: const Text('Select Country'),
        ),
      ),
    );
  }
}

class PickCode2 extends StatelessWidget {
  const PickCode2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.black45,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                user.UpdateFlagCode2(
                  Code1: '+${country.phoneCode}',
                  Flag1: country.flagEmoji,
                  Name1: country.name,
                );

                Navigator.pop(context);
              },
            );
          },
          child: const Text('Select Country'),
        ),
      ),
    );
  }
}