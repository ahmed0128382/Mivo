import 'package:flutter/material.dart';

import 'room_state_mixin.dart';

/// All loading flags and spinner helpers.
mixin RoomLoadingMixin on RoomStateMixin {
  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  bool showloading5 = false;
  bool showloading6 = false;
  bool showloading7 = false;
  bool showloading8 = false;
  bool showloading13 = false;
  bool showloading14 = false;
  bool showloading17 = false;
  bool showloading18 = false;
  bool showloading19 = false;
  bool showloading21 = false;
  bool showloading24 = false;
  bool showloading25 = false;
  bool showloading26 = false;
  bool showloading27 = false;
  bool showloading28 = false;
  bool showloading29 = false;
  bool showloading30 = false;
  bool showloading31 = false;
  bool showloading32 = false;
  bool showloading33 = false;
  bool showloading34 = false;
  bool showloading35 = false;
  bool showloading36 = false;
  bool showloading37 = false;
  bool showloading38 = false;
  bool showloading39 = false;
  bool showloading40 = false;
  bool showloading41 = false;
  bool showloading42 = false;
  bool showloading44 = false;
  bool showloading45 = false;
  bool showloading46 = false;
  bool showloading47 = false;

  void changeloading13() {
    showloading13 = !showloading13;
    notifyListeners();
  }

  void showwaitingtimer2() {
    waitingtimer2 = true;
    notifyListeners();
  }

  void hidewaitingtimer2() {
    waitingtimer2 = false;
    notifyListeners();
  }

  void showwaitingtimer() {
    waitingtimer = true;
  }

  void hidewaitingtimer() {
    waitingtimer = false;
    notifyListeners();
  }

  void showLoding() {
    JoinChairLoding = true;
  }

  void hideLoding() {
    JoinChairLoding = false;
  }

  void closealltap() {
    showloading14 = false;
    showloading17 = false;
    showloading18 = false;
    showloading19 = false;
    showloading8 = false;
    showloading21 = false;
    showloading39 = false;
    showloading40 = false;
    notifyListeners();
  }

  // ── Spinners ────────────────────────────────────────────────

  void showSpinner() {
    showloading = true;
    notifyListeners();
  }

  void hideSpinner() {
    showloading = false;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners();
  }

  void hideSpinner2() {
    showloading2 = false;
    notifyListeners();
  }

  void showSpinner3() {
    showloading3 = true;
    notifyListeners();
  }

  void hideSpinner3() {
    showloading3 = false;
    notifyListeners();
  }

  void showSpinner5() {
    showloading5 = true;
    notifyListeners();
  }

  void changeloading5() {
    showloading5 = !showloading5;
    notifyListeners();
  }

  void showSpinner6() {
    showloading6 = true;
    notifyListeners();
  }

  void changeloading6() {
    showloading6 = !showloading6;
    notifyListeners();
  }

  void hideSpinner6() {
    showloading6 = false;
    notifyListeners();
  }

  void showSpinner7() {
    showloading7 = true;
    notifyListeners();
  }

  void hideSpinner7() {
    showloading7 = false;
    notifyListeners();
  }

  void changeloading8() {
    showloading8 = !showloading8;
    notifyListeners();
  }

  void showSpinner14() {
    showloading14 = true;
    notifyListeners();
  }

  void hideSpinner14() {
    showloading14 = false;
    notifyListeners();
  }

  void showSpinner17() {
    showloading17 = true;
    notifyListeners();
  }

  void hideSpinner17() {
    showloading17 = false;
    notifyListeners();
  }

  void showSpinner18() {
    PasswordRoom.text = Currentroom?.password ?? '';
    showloading18 = true;
    notifyListeners();
  }

  void hideSpinner18() {
    showloading18 = false;
    notifyListeners();
  }

  void showSpinner19() {
    showloading19 = true;
    notifyListeners();
  }

  void hideSpinner19() {
    showloading19 = false;
    notifyListeners();
  }

  void showSpinner21() {
    showloading21 = true;
    notifyListeners();
  }

  void hideSpinner21() {
    showloading21 = false;
    notifyListeners();
  }

  void showSpinner24() {
    showloading24 = true;
    notifyListeners();
  }

  void hideSpinner24() {
    showloading24 = false;
    ShowItem = null;
    notifyListeners();
  }

  void showSpinner25() {
    showloading25 = true;
    notifyListeners();
  }

  void hideSpinner25() {
    showloading25 = false;
    notifyListeners();
  }

  void showSpinner26() {
    showloading26 = true;
    notifyListeners();
  }

  void hiddenSpinner26() {
    showloading26 = false;
    notifyListeners();
  }

  void showSpinner27() {
    showloading27 = true;
    notifyListeners();
  }

  void hiddenSpinner27() {
    showloading27 = false;
    notifyListeners();
  }

  void showSpinner28() {
    showloading28 = true;
    notifyListeners();
  }

  void hideSpinner28() {
    showloading28 = false;
    notifyListeners();
  }

  void showSpinner29() {
    showloading29 = true;
    notifyListeners();
  }

  void hideSpinner29() {
    showloading29 = false;
    notifyListeners();
  }

  void showSpinner30() {
    showloading30 = true;
    notifyListeners();
  }

  void hideSpinner30() {
    showloading30 = false;
    notifyListeners();
  }

  void showSpinner31() {
    showloading31 = true;
    notifyListeners();
  }

  void hideSpinner31() {
    showloading31 = false;
    notifyListeners();
  }

  void showSpinner32() {
    showloading32 = true;
    notifyListeners();
  }

  void hideSpinner32() {
    showloading32 = false;
    notifyListeners();
  }

  void showSpinner33() {
    showloading33 = true;
    notifyListeners();
  }

  void hideSpinner33() {
    showloading33 = false;
    notifyListeners();
  }

  void showSpinner34() {
    showloading34 = true;
    notifyListeners();
  }

  void hideSpinner34() {
    showloading34 = false;
    notifyListeners();
  }

  void showSpinner35() {
    showloading35 = true;
    notifyListeners();
  }

  void hideSpinner35() {
    showloading35 = false;
    notifyListeners();
  }

  void hideSpinner36() {
    showloading36 = false;
    notifyListeners();
  }

  void showSpinner37() {
    showloading37 = true;
    notifyListeners();
  }

  void hideSpinner37() {
    showloading37 = false;
    notifyListeners();
  }

  void showSpinner38() {
    showloading38 = true;
    notifyListeners();
  }

  void hideSpinner38() {
    showloading38 = false;
    notifyListeners();
  }

  void changeloading39() {
    showloading39 = !showloading39;
    notifyListeners();
  }

  void hideloading39() {
    showloading39 = false;
    notifyListeners();
  }

  void changeloading40() {
    showloading40 = !showloading40;
    notifyListeners();
  }

  void hideloading40() {
    showloading40 = false;
    notifyListeners();
  }

  void showSpinner41() {
    showloading41 = true;
    notifyListeners();
  }

  void hideSpinner41() {
    showloading41 = false;
    notifyListeners();
  }

  void showSpinner42() {
    showloading42 = true;
    notifyListeners();
  }

  void hideSpinner42() {
    showloading42 = false;
    notifyListeners();
  }

  void showSpinner44() {
    showloading44 = true;
    notifyListeners();
  }

  void hideSpinner44() {
    showloading44 = false;
    notifyListeners();
  }

  void showSpinner45() {
    showloading45 = true;
    notifyListeners();
  }

  void hideSpinner45() {
    showloading45 = false;
    notifyListeners();
  }

  void showSpinner46() {
    showloading46 = true;
    notifyListeners();
  }

  void hideSpinner46() {
    showloading46 = false;
    notifyListeners();
  }

  void showSpinner47() {
    showloading47 = true;
    notifyListeners();
  }

  void hideSpinner47() {
    showloading47 = false;
    notifyListeners();
  }
}
