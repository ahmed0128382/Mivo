import 'package:flutter/foundation.dart';

import 'mixins/login_state.dart';
import 'mixins/lucky_guess_part.dart';
import 'mixins/ui_state_part.dart';
import 'mixins/host_gifts_part.dart';
import 'mixins/chat_part.dart';
import 'mixins/profile_images_part.dart';
import 'mixins/posts_part.dart';
import 'mixins/room_effects_part.dart';
import 'mixins/family_part.dart';
import 'mixins/coins_part.dart';
import 'mixins/notifications_search_part.dart';
import 'mixins/messages_part.dart';
import 'mixins/vip_part.dart';
import 'mixins/spinners_flags_part.dart';
import 'mixins/auth_part.dart';
import 'mixins/profile_data_part.dart';
import 'mixins/report_part.dart';
import 'mixins/appearance_part.dart';
import 'mixins/user_room_part.dart';
import 'mixins/profile_update_part.dart';
import 'mixins/constants_part.dart';
import 'mixins/image_pickers_part.dart';
import 'mixins/misc_part.dart';

/// Refactored from a single large file into focused mixins.
/// Public API and behavior are unchanged — still one [LoginViewmodel] type.
class LoginViewmodel extends ChangeNotifier
    with
        LoginState,
        LuckyGuessMixin,
        UiStateMixin,
        HostGiftsMixin,
        ChatMixin,
        ProfileImagesMixin,
        PostsMixin,
        RoomEffectsMixin,
        FamilyMixin,
        CoinsMixin,
        NotificationsSearchMixin,
        MessagesMixin,
        VipMixin,
        SpinnersFlagsMixin,
        AuthMixin,
        ProfileDataMixin,
        ReportMixin,
        AppearanceMixin,
        UserRoomMixin,
        ProfileUpdateMixin,
        ConstantsMixin,
        ImagePickersMixin,
        MiscMixin {}
