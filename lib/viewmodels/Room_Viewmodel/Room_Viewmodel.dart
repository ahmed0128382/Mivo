import 'package:flutter/material.dart';

import 'mixins/room_admin_mixin.dart';
import 'mixins/room_chair_mixin.dart';
import 'mixins/room_chat_mixin.dart';
import 'mixins/room_combo_mixin.dart';
import 'mixins/room_create_mixin.dart';
import 'mixins/room_enter_mixin.dart';
import 'mixins/room_gift_mixin.dart';
import 'mixins/room_join_mixin.dart';
import 'mixins/room_leave_mixin.dart';
import 'mixins/room_lists_mixin.dart';
import 'mixins/room_loading_mixin.dart';
import 'mixins/room_state_mixin.dart';
import 'mixins/room_ui_mixin.dart';

/// Drop-in replacement for the original RoomViewmodel.
/// Public API and behavior are unchanged.
class RoomViewmodel extends ChangeNotifier
    with
        RoomStateMixin,
        RoomLoadingMixin,
        RoomComboMixin,
        RoomListsMixin,
        RoomUiMixin,
        RoomJoinMixin,
        RoomEnterMixin,
        RoomCreateMixin,
        RoomChairMixin,
        RoomLeaveMixin,
        RoomChatMixin,
        RoomGiftMixin,
        RoomAdminMixin {}