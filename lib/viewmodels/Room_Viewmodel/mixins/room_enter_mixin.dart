import 'dart:async';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';
import 'room_join_mixin.dart';

mixin RoomEnterMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin, RoomJoinMixin {
 EnterRoom({
  required id,
  required context,
  required adminId,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    Provider.of<SvgViewmodel>(
      context,
      listen: false,
    ).animationController?.clear();

    Provider.of<RoomViewmodel>(
      context,
      listen: false,
    ).initscrollcontroller();

    Provider.of<GiftsViewModel>(
      context,
      listen: false,
    ).DeleteGlopal();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).stopAudioMexing(context);

    HideEnterWidget();

    Navigator.pushNamed(
      context,
      AppConstants.Room_Screan,
    );
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true &&
            adminId.toString() != UserId &&
            Provider.of<LoginViewmodel>(
                  context,
                  listen: false,
                ).userinfo?.Hidden ==
                0) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom4(
                                    Roomid: id,
                                    context: context,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          JoinRoom4(
            Roomid: id,
            context: context,
          );
        }
      },
    );
  }
}

EnterRoom2({
  id,
  context,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    return;
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom4(
                                    context: context,
                                    Roomid: id,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          // IMPORTANT:
          // Do NOT call SvgViewmodel.dispose() here.

          JoinRoom4(
            context: context,
            Roomid: id,
          );
        }
      },
    );
  }
}

EnterRoom3({
  id,
  context,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    return;
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom2(
                                    context: context,
                                    Roomid: id,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          JoinRoom2(
            context: context,
            Roomid: id,
          );
        }
      },
    );
  }
}

  Future<bool> TrackRoomPassword(id) async {
    ShowGlopalLoading();

    return await Roomapi()
        .CheckPassworRooms(
      id: id.toString(),
    );
  }

  Future<bool> EnterTrackRoomPassword({
    id,
    pass,
  }) async {
    ShowGlopalLoading();

    return await Roomapi()
        .EnterCheckPassworRooms(
      id: id.toString(),
      pass: pass,
    );
  }

}
