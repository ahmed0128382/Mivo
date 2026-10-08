import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

/// Shared password dialog used by EnterRoom / EnterRoom2 / EnterRoom3.
Future<void> showRoomPasswordDialog({
  required BuildContext context,
  required dynamic id,
  required Future<bool> Function({required dynamic id, required String pass})
      enterTrackRoomPassword,
  required VoidCallback onSuccess,
}) async {
  DismissGlopalLoading();

  final TextEditingController passwordController = TextEditingController();

  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF2b2f3b),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  getLang(context: context, key: "Enter_Password"),
                  style: style1,
                ),
                const SizedBox(height: 25),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 4,
                  obscureText: false,
                  textStyle: const TextStyle(color: Color(0xFFeae2be)),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    borderWidth: 0.0,
                    shape: PinCodeFieldShape.box,
                    fieldOuterPadding:
                        const EdgeInsets.symmetric(horizontal: 3),
                    activeColor: const Color(0xFFeae2be),
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: const Color(0xFFeae2be),
                    inactiveColor: const Color(0xFFeae2be),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor: const Color(0xFFeae2be),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  cursorColor: const Color(0xFFeae2be),
                  enablePinAutofill: true,
                  enableActiveFill: false,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  enabled: true,
                  controller: passwordController,
                  onCompleted: (_) {},
                  onChanged: (_) {},
                  beforeTextPaste: (_) => true,
                  appContext: context,
                ),
                InkWell(
                  onTap: () {
                    if (passwordController.text.length < 4) return;

                    Navigator.pop(context);

                    enterTrackRoomPassword(
                      id: id,
                      pass: passwordController.text,
                    ).then((value) {
                      if (value == true) {
                        Provider.of<GiftsViewModel>(context, listen: false)
                            .hidpanner2();
                        onSuccess();
                      } else {
                        DismissGlopalLoading();
                        Dialogs().showtoast(
                          getLang(context: context, key: "Wrong_Password"),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: SizeConfig.screenWidth!,
                    height: 37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFeae2be),
                    ),
                    child: Center(
                      child: Text(
                        getLang(context: context, key: "Done"),
                        style: style6.copyWith(fontSize: 15, height: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
