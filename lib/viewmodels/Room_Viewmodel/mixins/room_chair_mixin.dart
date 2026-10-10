import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/foundation.dart';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';

mixin RoomChairMixin on RoomStateMixin, RoomLoadingMixin {
// ============================================================
// Concise chair diagnostics
// Enabled only in debug builds. Never log tokens or headers.
// ============================================================

void _chairLog(String stage, [Object? details]) {
if (!kDebugMode) return;


final message = details == null ? '' : ': $details';
debugPrint('[CHAIR] $stage$message');


}

void _logError(String stage, Object error) {
if (!kDebugMode) return;


// Keep the error useful without printing a full request or stack trace.
final message = error.toString().split('\n').first;
final shortened = message.length > 240
    ? '${message.substring(0, 240)}...'
    : message;

debugPrint('[CHAIR][ERROR] $stage: $shortened');

}

void _logChair(
String stage, {
Chairs? chair,
int? index,
Map<String, dynamic>? extra,
}) {
if (!kDebugMode) return;


final details = <String, dynamic>{
  if (index != null) 'index': index,
  if (chair?.id != null) 'databaseId': chair!.id,
  if (chair?.chairId != null) 'chairNumber': chair!.chairId,
  if (chair?.userId != null) 'userId': chair!.userId,
  if (chair?.mute != null) 'mute': chair!.mute,
  if (chair?.Lock != null) 'locked': chair!.Lock,
  if (chair?.adminleaved != null) 'adminLeft': chair!.adminleaved,
  if (extra != null) ...extra,
};

_chairLog(stage, details);


}

/// Prints a compact summary only when explicitly requested.
/// Does not dump every chair record.
void _logAllChairs(String stage) {
if (!kDebugMode) return;
final chairs = Currentroom?.chairs ?? <Chairs>[];
final databaseIds = <int, int>{};
final chairNumbers = <int, int>{};

for (final chair in chairs) {
  final id = chair.id;
  if (id != null) {
    databaseIds[id] = (databaseIds[id] ?? 0) + 1;
  }

  final number = _parseInt(chair.chairId);
  if (number != null) {
    chairNumbers[number] = (chairNumbers[number] ?? 0) + 1;
  }
}

final duplicateIds = databaseIds.entries
    .where((entry) => entry.value > 1)
    .map((entry) => entry.key)
    .toList();

final duplicateNumbers = chairNumbers.entries
    .where((entry) => entry.value > 1)
    .map((entry) => entry.key)
    .toList();

_chairLog(
  stage,
  {
    'count': chairs.length,
    'duplicateDatabaseIds': duplicateIds,
    'duplicateChairNumbers': duplicateNumbers,
  },
);


}

// ============================================================
// Safe chair lookup
// ============================================================

int? _parseInt(dynamic value) {
if (value == null) return null;
return int.tryParse(value.toString().trim());
}

Chairs? _chairAt(int? index) {
final chairs = Currentroom?.chairs;
if (index == null ||
    chairs == null ||
    index < 0 ||
    index >= chairs.length) {
  return null;
}

return chairs[index];
}

/// Finds a chair by its database record ID.
/// Duplicate database IDs are reported and rejected.
Chairs? _chairByDatabaseId(dynamic value) {
final id = _parseInt(value);
final chairs = Currentroom?.chairs;
if (id == null || chairs == null) return null;

final matches = chairs.where((chair) => chair.id == id).toList();

if (matches.length > 1) {
  _chairLog(
    'Duplicate database ID rejected',
    {'databaseId': id, 'matches': matches.length},
  );
  _logAllChairs('Chair identity diagnostic');
  return null;
}

if (matches.isEmpty) {
  _chairLog('Database chair not found', {'databaseId': id});
  return null;
}

return matches.single;

}

/// Finds a chair by visible number only when that number is unique.
/// Duplicate chair numbers are rejected to avoid updating the wrong row.
Chairs? _chairByNumber(dynamic value) {
final number = _parseInt(value);
final chairs = Currentroom?.chairs;
if (number == null || number < 1 || chairs == null) {
  return null;
}

final matches = chairs
    .where((chair) => _parseInt(chair.chairId) == number)
    .toList();

if (matches.length == 1) {
  return matches.single;
}

if (matches.length > 1) {
  _chairLog(
    'Duplicate chair number rejected',
    {'chairNumber': number, 'matches': matches.length},
  );
  _logAllChairs('Chair identity diagnostic');
  return null;
}

final hasChairNumbers = chairs.any(
  (chair) => _parseInt(chair.chairId) != null,
);

if (!hasChairNumbers && number <= chairs.length) {
  return chairs[number - 1];
}

_chairLog('Chair number not found', {'chairNumber': number});
return null;

}

void _clearChair(Chairs? chair) {
if (chair == null) return;

chair.userId = null;
chair.user = null;


}

void _assignChair(Chairs? chair, usermodel? user) {
if (chair == null || user?.id == null) return;

chair.userId = user!.id.toString();
chair.user = user;

}

void _showChairError() {
final context = NavigationService.navigatorKey.currentContext;

if (context != null) {
  getLang(
    context: context,
    key: 'Another_Set',
  );
}


}

// ============================================================
// Chair state updates
// ============================================================

void changeChairLock({
int? state,
String? chairId,
}) {
final chair = _chairByNumber(chairId);


if (chair == null) {
  _chairLog('Lock update skipped: chair could not be identified');
  return;
}

chair.Lock = state;
_logChair('Lock state updated', chair: chair, extra: {'state': state});
notifyListeners();


}

void NulledKaresmaChair({
String? chairId,
}) {
final chair = _chairByNumber(chairId);


if (chair == null) return;

chair.Karisma = 0;
_logChair('Karisma reset', chair: chair);
notifyListeners();


}

void addKaresmaChair({
String? chairId,
}) {
final chair = _chairByNumber(chairId);


if (chair == null) return;

chair.Karisma = 100;
_logChair('Karisma assigned', chair: chair);
notifyListeners();


}

void updatekaresma({
required int Amount,
context,
}) {
Currentroom?.Karisma = (Currentroom?.Karisma ?? 0) + Amount;


Provider.of<SvgViewmodel>(
  context,
  listen: false,
).getcontroller4(
  Svga: 'assets/image/16207300489766.svga',
);

_chairLog('Room Karisma updated', {'amount': Amount});
notifyListeners();


}

void AddKaresmaChair({
required List userids,
int? Amount,
}) {
final amount = Amount ?? 0;


for (final userId in userids) {
  for (final chair in Currentroom?.chairs ?? <Chairs>[]) {
    if (chair.userId?.toString() == userId.toString()) {
      chair.Karisma = (chair.Karisma ?? 0) + amount;
    }
  }
}

_chairLog('Chair Karisma incremented', {
  'usersCount': userids.length,
  'amount': amount,
});
notifyListeners();


}

void Changemicestateadmin({
dynamic userId,
dynamic state,
context,
}) {
var updated = 0;


for (final chair in Currentroom?.chairs ?? <Chairs>[]) {
  if (chair.userId?.toString() == userId?.toString()) {
    chair.mute = _parseInt(state);
    updated++;
  }
}

_chairLog('Microphone state updated', {
  'userId': userId,
  'state': state,
  'chairsUpdated': updated,
});

notifyListeners();

}

bool checkmute() {
for (final chair in Currentroom?.chairs ?? <Chairs>[]) {
if (chair.userId?.toString() == UserId.toString()) {
return chair.mute == 1;
}
}


return false;

}

void UpdateThronechair({
int? value,
}) {
Currentroom?.SecondKing = value;
_chairLog('Throne chair updated', {'value': value});
notifyListeners();
}

void showLoding() {
JoinChairLoding = true;
notifyListeners();
}

void hideLoding() {
JoinChairLoding = false;
notifyListeners();
}

// ============================================================
// Join chair
// ============================================================

Future<void> JoinChair({
context,
index,
chairid,
}) async {
final int? chairIndex = _parseInt(index);
final chair = _chairAt(chairIndex);
final roomId = Currentroom?.id;


if (chair == null || roomId == null || chairid == null) {
  _chairLog('Join rejected: invalid room, chair index, or chair ID', {
    'index': index,
    'chairId': chairid,
    'roomId': roomId,
  });
  return;
}

final user = Provider.of<LoginViewmodel>(
  context,
  listen: false,
);

final agora = Provider.of<AgoraViewmodel>(
  context,
  listen: false,
);

final String? currentUserId = user.userinfo?.id.toString();

if (currentUserId == null) {
  _chairLog('Join rejected: current user ID is missing');
  return;
}

final String? previousUserId = chair.userId;
final previousUser = chair.user;
final bool previousJoinChairs = JoinChairs;

_logChair(
  'Join requested',
  chair: chair,
  index: chairIndex,
  extra: {'roomId': roomId, 'userId': currentUserId},
);

showLoding();

chair.userId = currentUserId;
chair.user = user.userinfo;
JoinChairs = true;
notifyListeners();

try {
  final success = await Roomapi().joinChair(
    context: context,
    index: chairIndex,
    room_id: roomId,
    chair_id: chairid,
  );

  if (success == true) {
    agora.updateKickedFromChair(value: false);

    Chairid = chairid;
    Chairidex = chairIndex!;

    if (chair.mute == 0) {
      agora.UnMute();
    } else {
      agora.Mute();
    }

    _logChair('Join succeeded', chair: chair, index: chairIndex);
  } else {
    chair.userId = previousUserId;
    chair.user = previousUser;
    JoinChairs = previousJoinChairs;

    _chairLog('Join failed: API returned false', {
      'roomId': roomId,
      'chairId': chairid,
    });
    _showChairError();
  }
} catch (error) {
  chair.userId = previousUserId;
  chair.user = previousUser;
  JoinChairs = previousJoinChairs;

  _logError('Join chair', error);
  _showChairError();
} finally {
  hideLoding();
  notifyListeners();
}


}

// ============================================================
// Change chair
// ============================================================

Future<void> ChangeChair({
context,
Index,
Newchairid,
}) async {
final int? targetIndex = _parseInt(Index);
final int? currentIndex = _parseInt(Chairidex);


final currentChair = _chairAt(currentIndex);
final targetChair = _chairAt(targetIndex);

if (currentChair == null ||
    targetChair == null ||
    Currentroom?.id == null) {
  _chairLog('Change rejected: invalid source or target chair', {
    'currentIndex': currentIndex,
    'targetIndex': targetIndex,
    'roomId': Currentroom?.id,
  });
  return;
}

if (currentIndex == targetIndex) return;

final user = Provider.of<LoginViewmodel>(
  context,
  listen: false,
);

final agora = Provider.of<AgoraViewmodel>(
  context,
  listen: false,
);

final previousCurrentUserId = currentChair.userId;
final previousCurrentUser = currentChair.user;
final previousTargetUserId = targetChair.userId;
final previousTargetUser = targetChair.user;
final previousChairIndex = Chairidex;

_chairLog('Change requested', {
  'fromDatabaseId': currentChair.id,
  'toDatabaseId': targetChair.id,
  'fromIndex': currentIndex,
  'toIndex': targetIndex,
});

showSpinner47();

_clearChair(currentChair);
_assignChair(targetChair, user.userinfo);
notifyListeners();

try {
  final success = await Roomapi().ChangeChair(
    context: context,
    room_id: Currentroom?.id,
    CurrentChairid: currentChair.id,
    NewCharid: targetChair.id,
  );

  if (success == true) {
    Chairidex = targetIndex!;

    if (targetChair.mute == 1) {
      agora.SetasAudience();
    } else {
      agora.SetasBroadcaster();
    }

    _chairLog('Change succeeded', {
      'fromDatabaseId': currentChair.id,
      'toDatabaseId': targetChair.id,
    });
  } else {
    currentChair.userId = previousCurrentUserId;
    currentChair.user = previousCurrentUser;
    targetChair.userId = previousTargetUserId;
    targetChair.user = previousTargetUser;
    Chairidex = previousChairIndex;

    _chairLog('Change failed: API returned false');
    _showChairError();
  }
} catch (error) {
  currentChair.userId = previousCurrentUserId;
  currentChair.user = previousCurrentUser;
  targetChair.userId = previousTargetUserId;
  targetChair.user = previousTargetUser;
  Chairidex = previousChairIndex;

  _logError('Change chair', error);
  _showChairError();
} finally {
  hideSpinner47();
  notifyListeners();
}


}

// ============================================================
// Admin chair transitions
// ============================================================

Future<void> ChangeAdminsChair({
context,
Index,
Newchairid,
}) async {
await _changeAdminChair(
context: context,
targetIndexValue: Index,
returnToAdminChair: false,
);
}

Future<void> ReturnAdminsChair({
context,
Index,
Newchairid,
}) async {
await _changeAdminChair(
context: context,
targetIndexValue: Index,
returnToAdminChair: true,
);
}

Future<void> _changeAdminChair({
required context,
required dynamic targetIndexValue,
required bool returnToAdminChair,
}) async {
final int? targetIndex = _parseInt(targetIndexValue);
final int? currentIndex = _parseInt(Chairidex);

final targetChair = _chairAt(targetIndex);
final currentChair = _chairAt(currentIndex);
final adminChair = _chairAt(8);

if (targetChair == null ||
    currentChair == null ||
    adminChair == null ||
    Currentroom?.id == null) {
  _chairLog('Admin chair transition rejected: required chair missing', {
    'currentIndex': currentIndex,
    'targetIndex': targetIndex,
    'adminChairAvailable': adminChair != null,
    'roomId': Currentroom?.id,
  });
  return;
}

final user = Provider.of<LoginViewmodel>(
  context,
  listen: false,
);

final agora = Provider.of<AgoraViewmodel>(
  context,
  listen: false,
);

final oldCurrentUserId = currentChair.userId;
final oldCurrentUser = currentChair.user;
final oldTargetUserId = targetChair.userId;
final oldTargetUser = targetChair.user;
final oldAdminLeaved = adminChair.adminleaved;
final oldChairIndex = Chairidex;

_chairLog('Admin chair transition requested', {
  'returnToAdminChair': returnToAdminChair,
  'currentDatabaseId': currentChair.id,
  'targetDatabaseId': targetChair.id,
});

showSpinner47();

adminChair.adminleaved = returnToAdminChair ? 0 : 1;

if (currentIndex != 0) {
  _clearChair(currentChair);
}

_assignChair(targetChair, user.userinfo);
notifyListeners();

try {
  final success = returnToAdminChair
      ? await Roomapi().ReturnAdminChair(
          context: context,
          room_id: Currentroom?.id,
          CurrentChairid: currentChair.id,
          NewCharid: targetChair.id,
        )
      : await Roomapi().AdminChangeChair(
          context: context,
          room_id: Currentroom?.id,
          CurrentChairid: currentChair.id,
          NewCharid: targetChair.id,
        );

  if (success == true) {
    Chairidex = targetIndex!;

    if (targetChair.mute == 1) {
      agora.SetasAudience();
    } else {
      agora.SetasBroadcaster();
    }

    _chairLog('Admin chair transition succeeded', {
      'returnToAdminChair': returnToAdminChair,
      'targetDatabaseId': targetChair.id,
    });
  } else {
    currentChair.userId = oldCurrentUserId;
    currentChair.user = oldCurrentUser;
    targetChair.userId = oldTargetUserId;
    targetChair.user = oldTargetUser;
    adminChair.adminleaved = oldAdminLeaved;
    Chairidex = oldChairIndex;

    _chairLog('Admin chair transition failed: API returned false');
    _showChairError();
  }
} catch (error) {
  currentChair.userId = oldCurrentUserId;
  currentChair.user = oldCurrentUser;
  targetChair.userId = oldTargetUserId;
  targetChair.user = oldTargetUser;
  adminChair.adminleaved = oldAdminLeaved;
  Chairidex = oldChairIndex;

  _logError('Admin chair transition', error);
  _showChairError();
} finally {
  hideSpinner47();
  notifyListeners();
}


}

// ============================================================
// Leave chair
// ============================================================

Future<void> LeaveChair({
context,
chairid,
index,
}) async {
final int? chairIndex = _parseInt(index);
final chair = _chairAt(chairIndex);


if (chair == null || Currentroom?.id == null) {
  _chairLog('Leave rejected: chair or room not found', {
    'index': chairIndex,
    'roomId': Currentroom?.id,
  });
  return;
}

final agora = Provider.of<AgoraViewmodel>(
  context,
  listen: false,
);

final oldUserId = chair.userId;
final oldUser = chair.user;

_logChair(
  'Leave requested',
  chair: chair,
  index: chairIndex,
  extra: {'roomId': Currentroom?.id},
);

_clearChair(chair);
notifyListeners();

try {
  final success = await Roomapi().LeaveChair(
    context: context,
    Roomid: Currentroom?.id,
    chairid: chairid,
  );

  if (success == true) {
    agora.SetasAudience();
    _showSuccessToast();
    _chairLog('Leave succeeded', {
      'chairId': chairid,
      'index': chairIndex,
    });
  } else {
    chair.userId = oldUserId;
    chair.user = oldUser;
    _chairLog('Leave failed: API returned false', {'chairId': chairid});
    _showSorryToast();
  }
} catch (error) {
  chair.userId = oldUserId;
  chair.user = oldUser;
  _logError('Leave chair', error);
  _showSorryToast();
} finally {
  hideSpinner3();
  notifyListeners();
}


}

Future<void> LeaveuserChair({
context,
}) async {
final int? chairIndex = _parseInt(ChairIndes);
final chair = _chairAt(chairIndex);


if (chair == null || Currentroom?.id == null) {
  _chairLog('Remove user rejected: chair or room not found', {
    'index': chairIndex,
    'roomId': Currentroom?.id,
  });
  return;
}

final oldUserId = chair.userId;
final oldUser = chair.user;

showloading8 = false;
_clearChair(chair);
notifyListeners();

try {
  final success = await Roomapi().LeaveuserChair(
    context: context,
    user_id: useridchair,
    Roomid: Currentroom?.id,
    chairid: Chairids,
  );

  if (success == true) {
    _chairLog('Remove user from chair succeeded', {
      'userId': useridchair,
      'chairId': Chairids,
    });
    _showSuccessToast();
  } else {
    chair.userId = oldUserId;
    chair.user = oldUser;
    _chairLog('Remove user from chair failed: API returned false');
    _showSorryToast();
  }
} catch (error) {
  chair.userId = oldUserId;
  chair.user = oldUser;
  _logError('Remove user from chair', error);
  _showSorryToast();
} finally {
  hideSpinner3();
  notifyListeners();
}


}

void _showSuccessToast() {
final context = NavigationService.navigatorKey.currentContext;
if (context == null) return;


Dialogs().showtoast(
  getLang(
    context: context,
    key: 'Done_Succ',
  ),
);


}

void _showSorryToast() {
final context = NavigationService.navigatorKey.currentContext;
if (context == null) return;


Dialogs().showtoast(
  getLang(
    context: context,
    key: 'Sorry',
  ),
);


}

// ============================================================
// Socket-driven chair updates
// ============================================================

void AddusertoChair({
Chairs? data,
ctx,
}) {
if (data == null) {
_chairLog('Socket chair update ignored: payload is null');
return;
}


final incomingRoomId = _parseInt(data.roomId);
final currentRoomId = Currentroom?.id;

if (incomingRoomId != null &&
    currentRoomId != null &&
    incomingRoomId != currentRoomId) {
  _chairLog('Socket chair update ignored: room mismatch', {
    'incomingRoomId': incomingRoomId,
    'currentRoomId': currentRoomId,
  });
  return;
}

final Chairs? targetChair;

if (data.id != null) {
  targetChair = _chairByDatabaseId(data.id);
  if (targetChair == null) {
    _chairLog('Socket chair update ignored: database ID is ambiguous or missing', {
      'databaseId': data.id,
    });
    return;
  }
} else {
  targetChair = _chairByNumber(data.chairId);
  if (targetChair == null) {
    _chairLog('Socket chair update ignored: chair number is ambiguous or missing', {
      'chairNumber': data.chairId,
    });
    return;
  }
}

if (data.userId != null) {
  targetChair.userId = data.userId;
}

if (data.roomId != null) {
  targetChair.roomId = data.roomId;
}

if (data.chairId != null) {
  targetChair.chairId = data.chairId;
}

if (data.user != null) {
  targetChair.user = data.user;
}

if (data.mute != null) {
  targetChair.mute = data.mute;
}

if (data.Lock != null) {
  targetChair.Lock = data.Lock;
}

if (data.Karisma != null) {
  targetChair.Karisma = data.Karisma;
}

if (data.adminleaved != null) {
  targetChair.adminleaved = data.adminleaved;
}

if (data.createdAt != null) {
  targetChair.createdAt = data.createdAt;
}

if (data.updatedAt != null) {
  targetChair.updatedAt = data.updatedAt;
}

_logChair(
  'Socket chair update applied',
  chair: targetChair,
  extra: {'roomId': targetChair.roomId},
);

notifyListeners();


}

void LockChair({
int? state,
int? chairId,
}) {
if (state == null || chairId == null) return;


final chair = _chairByNumber(chairId);
if (chair == null) return;

chair.Lock = state;
_logChair('Socket lock update applied', chair: chair, extra: {'state': state});
notifyListeners();


}

// ============================================================
// Local chair transitions from room events
// ============================================================

void changeRoomChair({
usermodel? user,
String? CurrentChair,
String? newChair,
}) {
if (user?.id == null) return;


final room = Currentroom;
if (room == null) return;

if (user?.id.toString() == room.adminId?.toString()) {
  final adminChair = _chairAt(8);
  if (adminChair != null) {
    adminChair.adminleaved = 1;
  }
}

final userId = user?.id.toString();

for (final chair in room.chairs ?? <Chairs>[]) {
  final occupantId = chair.userId ?? chair.user?.id.toString();

  if (occupantId == userId) {
    _clearChair(chair);
    chair.Karisma = 0;
  }
}

final targetChair = _chairByNumber(newChair);

if (targetChair == null) {
  _chairLog('Local chair move stopped: target chair is ambiguous or missing', {
    'userId': userId,
    'targetChair': newChair,
  });
  notifyListeners();
  return;
}

_assignChair(targetChair, user);
_logChair(
  'Local chair move applied',
  chair: targetChair,
  extra: {'userId': userId},
);
notifyListeners();


}

void returntoAdminRoomChair({
usermodel? user,
String? CurrentChair,
String? newChair,
}) {
if (user?.id == null) return;


final room = Currentroom;
if (room == null) return;

if (user?.id.toString() == room.adminId?.toString()) {
  final adminChair = _chairAt(8);
  if (adminChair != null) {
    adminChair.adminleaved = 0;
  }
}

final userId = user?.id.toString();

for (final chair in room.chairs ?? <Chairs>[]) {
  final occupantId = chair.userId ?? chair.user?.id.toString();

  if (occupantId == userId) {
    _clearChair(chair);
    chair.Karisma = 0;
  }
}

final targetChair = _chairByNumber(newChair);

if (targetChair == null) {
  _chairLog('Return to admin chair stopped: target chair is ambiguous or missing', {
    'userId': userId,
    'targetChair': newChair,
  });
  notifyListeners();
  return;
}

_assignChair(targetChair, user);
_logChair(
  'Return to admin chair applied',
  chair: targetChair,
  extra: {'userId': userId},
);
notifyListeners();


}

void RemoveuserfromChair({
String? id,
}) {
if (id == null) return;


final agora = Provider.of<AgoraViewmodel>(
  roomcontext,
  listen: false,
);

final user = Provider.of<LoginViewmodel>(
  roomcontext,
  listen: false,
);

if (id == user.userinfo?.id.toString()) {
  agora.keickedfromasAudience();
}

ChairsRoom.removeWhere(
  (chair) => chair.userId?.toString() == id,
);

var removed = 0;

for (final chair in Currentroom?.chairs ?? <Chairs>[]) {
  if (chair.userId?.toString() == id ||
      chair.user?.id.toString() == id) {
    _clearChair(chair);
    chair.Karisma = 0;
    removed++;
  }
}

_chairLog('User removed from chairs', {
  'userId': id,
  'chairsCleared': removed,
});

notifyListeners();


}

// ============================================================
// API-backed chair locking
// ============================================================

Future<void> LockChairUpdate({
int? state,
Chairs? info,
}) async {
if (info == null || info.id == null || state == null) {
_chairLog('Lock update rejected: missing chair ID or state');
return;
}


_logChair(
  'Lock request',
  chair: info,
  extra: {'requestedState': state},
);

try {
  final success = await Roomapi().LockChair(
    Chair_id: info.id,
    Lock: state,
    Roominfo: Currentroom,
  );

  if (success == true) {
    changeChairLock(
      chairId: info.chairId,
      state: state,
    );
    _chairLog('Lock request succeeded', {
      'databaseId': info.id,
      'state': state,
    });
  } else {
    _chairLog('Lock request failed: API returned false', {
      'databaseId': info.id,
      'state': state,
    });
  }
} catch (error) {
  _logError('Lock chair API', error);
}


}
}
