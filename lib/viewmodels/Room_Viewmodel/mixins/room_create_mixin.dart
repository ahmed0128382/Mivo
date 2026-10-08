import 'dart:async';
import 'dart:io';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomCreateMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  Future<bool> CreateRoom({
  required context,
  required name,
  required Category,
  required city,
  required File backgroundimage,
}) async {
  final LoginViewmodel user = Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  try {
    if (Roomimage == null) {
      print('CREATE ROOM: Roomimage is null');
      return false;
    }

    if (!Roomimage.existsSync()) {
      print(
        'CREATE ROOM: Room image file does not exist: '
        '${Roomimage.path}',
      );
      return false;
    }

    if (!backgroundimage.existsSync()) {
      print(
        'CREATE ROOM: Background image file does not exist: '
        '${backgroundimage.path}',
      );
      return false;
    }

    print(
      'CREATE ROOM IMAGE EXISTS: '
      '${Roomimage.existsSync()}',
    );

    print(
      'CREATE ROOM IMAGE SIZE: '
      '${await Roomimage.length()} bytes',
    );

    print(
      'CREATE ROOM BACKGROUND EXISTS: '
      '${backgroundimage.existsSync()}',
    );

    print(
      'CREATE ROOM BACKGROUND SIZE: '
      '${await backgroundimage.length()} bytes',
    );

    print(
      'CREATE ROOM: '
      'name=$name, '
      'category=$Category, '
      'city=$city',
    );

    print(
      'CREATE ROOM PHOTO: '
      '${Roomimage.path}',
    );

    print(
      'CREATE ROOM BACKGROUND: '
      '${backgroundimage.path}',
    );

    ShowGlopalLoading();
    showSpinner6();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).disableAudioroomvoice();

    final RoomModel value = await Roomapi().CreateRoom(
      RoomAds: RoomAds.text.trim(),
      context: context,
      name: name,
      Category: Category,
      image: Roomimage,
      backgroundimage: backgroundimage,
      city: city,
    );

    print(
      'CREATE ROOM RESULT: '
      'id=${value.id}',
    );

    if (value.id == null) {
      print(
        'CREATE ROOM FAILED: backend returned no room id',
      );
      return false;
    }

    clearadd();

    Currentroom = value;

    user.userinfo?.currentroom = value;

    Rooms.insert(
      0,
      value,
    );

    initscrollcontroller();

    Currentroom?.userNumber =
        (Currentroom?.userNumber ?? 0) + 1;

    JoinChairs = true;

    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).ConnectRoomScocket(
      context,
      value.id,
    );

    Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    ).changeHasRoomstate(true);

    final String agoraChannel =
        value.id?.toString().trim() ?? '';

    final String agoraToken =
        value.Token?.toString().trim() ?? '';

    print('========== CREATE ROOM AGORA ==========');
    print('DB ROOM ID: ${value.id}');
    print('AGORA ROOM ID / CHANNEL: "$agoraChannel"');
    print('AGORA TOKEN PRESENT: ${agoraToken.isNotEmpty}');
    print('AGORA TOKEN LENGTH: ${agoraToken.length}');
    print('========================================');

    if (agoraChannel.isEmpty) {
      print(
        'CREATE ROOM AGORA ERROR: RoomID is empty',
      );
      return false;
    }

    if (agoraToken.isEmpty) {
      print(
        'CREATE ROOM AGORA ERROR: Token is empty',
      );
      return false;
    }

    await Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).initialize(
      role: ClientRole.Broadcaster,
      Token: agoraToken,
      channelName: agoraChannel,
    );

    Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    ).changeIsRoomstate(true);

    Provider.of<GiftsViewModel>(
      context,
      listen: false,
    ).DeleteGlopal();

    final int? userId = int.tryParse(
      user.userinfo?.id.toString() ?? '',
    );

    if (userId != null) {
      Provider.of<AgoraViewmodel>(
        roomcontext,
        listen: false,
      ).unmuteusermic(userId);
    } else {
      print(
        'CREATE ROOM: Unable to parse current user id',
      );
    }

    return true;
  } catch (e, stackTrace) {
    print(
      'CREATE ROOM ERROR: $e',
    );

    print(
      'CREATE ROOM STACK: $stackTrace',
    );

    return false;
  } finally {
    hideSpinner6();
    DismissGlopalLoading();
  }
}

  void clearadd() {
    RoomName.clear();
    RoomAds.clear();

    Roomimage = null;
    RoomBackgroundImage = null;

    choosen.clear();

    notifyListeners();
  }

  Future<void> getImage() async {
  final XFile? pickedFile =
      await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
    maxWidth: 1600,
    maxHeight: 1600,
  );

  if (pickedFile != null) {
    Roomimage = File(
      pickedFile.path,
    );

    print(
      'ROOM IMAGE: ${Roomimage.path}',
    );

    print(
      'ROOM IMAGE SIZE: '
      '${await Roomimage.length()} bytes',
    );
  }

  notifyListeners();
}

  Future getImage2() async {
    final pickedFile =
        await picker2.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      Roomimage2 = File(
        pickedFile.path,
      );
    }

    notifyListeners();
  }

  Future<void> getImage3() async {
  final XFile? pickedFile =
      await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
    maxWidth: 1600,
    maxHeight: 1600,
  );

  if (pickedFile != null) {
    RoomBackgroundImage =
        File(pickedFile.path);

    print(
      'ROOM BACKGROUND IMAGE: '
      '${RoomBackgroundImage!.path}',
    );

    print(
      'ROOM BACKGROUND IMAGE SIZE: '
      '${await RoomBackgroundImage!.length()} bytes',
    );
  }

  notifyListeners();
}

  ClearImage() {
    Roomimage = null;
    notifyListeners();
  }

  ClearImage2() {
    Roomimage2 = null;
    notifyListeners();
  }

  ClearImage3() {
    Roomimage3 = null;
    notifyListeners();
  }

  hidegiffalse() {
    showgif = false;
    notifyListeners();
  }

  updateRoom() async {
    ShowGlopalLoading();

    await Roomapi()
        .UpdateRoom(
      RoomAds: EditRoomDescription.text,
      image: Roomimage2,
      name: EditRoomName.text,
      backimage: backchoosen2.first,
      Category: choosen2.first,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          clearadd2();
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

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

}
