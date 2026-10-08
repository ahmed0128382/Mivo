import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
import 'room_combo_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';

/// Gifts, emoji, dice, roulette, images.
mixin RoomGiftMixin on RoomStateMixin, RoomLoadingMixin, RoomComboMixin {
  checkcompo() {
    final user = Provider.of<LoginViewmodel>(roomcontext, listen: false);
    if (Combocost != null &&
        ComboListuser != null &&
        waitingtimer2 &&
        ComboQuantity != null &&
        ComboGiftid != null &&
        ComboListuser.isNotEmpty &&
        Combocost <= user.userinfo?.coins) {
      return true;
    }
    return false;
  }

  SentGift({context, giftid, Listuser, quantity, Cost}) async {
    // TODO: Paste full SentGift from original
    throw UnimplementedError('Paste SentGift from original file');
  }

  SentLuckyGift({context, giftid, Listuser, quantity, Cost}) async {
    // TODO: Paste full SentLuckyGift from original
    throw UnimplementedError('Paste SentLuckyGift from original file');
  }

  SentCompoLuckyGift({context}) async {
    // TODO: Paste full SentCompoLuckyGift from original
    throw UnimplementedError('Paste SentCompoLuckyGift from original file');
  }

  SentEmoji({context, emoji}) async {
    await Roomapi().SendEmoje(
      Emoje: emoji,
      context: context,
      Room_id: Currentroom?.id,
    );
    notifyListeners();
  }

  SentImageRoom({context}) async {
    ImageLoading = true;
    notifyListeners();
    await Roomapi()
        .SentImageRoom(
      image: ChatRoomImage,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then((value) {
      ImageLoading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  Playdice({context}) async {
    await Roomapi().Playdice(context: context, Room_id: Currentroom?.id);
    notifyListeners();
  }

  Playrollet({context, name}) async {
    await Roomapi().Playrollet(
      Name: name,
      context: context,
      Room_id: Currentroom?.id,
    );
    notifyListeners();
  }

  GetRoomGifts() async {
    showSpinner37();
    await Roomapi().GetRoomGifts(Roomid: Currentroom?.id).then((value) {
      RoomGifts = value;
      hideSpinner37();
    });
    notifyListeners();
  }
}
