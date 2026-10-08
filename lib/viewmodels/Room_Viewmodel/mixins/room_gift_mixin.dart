
import 'package:ahlachat/main.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_combo_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomGiftMixin on RoomStateMixin, RoomLoadingMixin, RoomComboMixin, RoomUiMixin {
  SentGift({
    context,
    giftid,
    Listuser,
    quantity,
    Cost,
  }) async {
    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .SendGift(
      Cost: Cost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: giftid,
      Listuser: Listuser,
      quantity: quantity,
    )
        .then(
      (value) {
        if (value == true) {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Cost as int,
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  SentLuckyGift({
    context,
    giftid,
    Listuser,
    quantity,
    Cost,
  }) async {
    Combocost = Cost;
    ComboListuser = Listuser;
    ComboQuantity = quantity;
    ComboGiftid = giftid;

    print(giftid);
    print(Listuser);
    print(quantity);
    print(Cost);

    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    print(
      '=====================MyCOINS========>${user.userinfo?.coins}==================>',
    );
    print(
      '====================COST=========>$Cost==================>',
    );
    print(
      '====================Quantay=========>$quantity==================>',
    );

    await Roomapi()
        .SentLuckyGift(
      Cost: Cost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: giftid,
      Listuser: Listuser,
      quantity: quantity,
    )
        .then(
      (value) {
        if (value != '') {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Cost as int,
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).ShowLuckyCombo();

          showwaitingtimer2();
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  SentCompoLuckyGift({
    context,
  }) async {
    print(Combocost);
    print(ComboListuser);
    print(ComboQuantity);
    print(ComboGiftid);

    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .SentCompoGift(
      Cost: Combocost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: ComboGiftid,
      Listuser: ComboListuser,
      quantity: ComboQuantity,
    )
        .then(
      (value) {
        if (value != '') {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Combocost as int,
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  SentEmoji({
    context,
    emoji,
  }) async {
    await Roomapi()
        .SendEmoje(
      Emoje: emoji,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  SentImageRoom({
    context,
  }) async {
    ImageLoading = true;
    notifyListeners();

    await Roomapi()
        .SentImageRoom(
      image: ChatRoomImage,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {
        ImageLoading = false;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  Playdice({
    context,
  }) async {
    await Roomapi()
        .Playdice(
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  Playrollet({
    context,
    name,
  }) async {
    await Roomapi()
        .Playrollet(
      Name: name,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  GetRoomGifts() async {
    showSpinner37();

    await Roomapi()
        .GetRoomGifts(
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        RoomGifts = value;
        hideSpinner37();
      },
    );

    notifyListeners();
  }

}
