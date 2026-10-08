import 'package:ahlachat/repositores/Room_repositores/Room_repository.dart';
import 'mixins/room_api_error_mixin.dart';
import 'mixins/room_api_state_mixin.dart';
import 'mixins/room_api_admin_mixin.dart';
import 'mixins/room_api_lists_mixin.dart';
import 'mixins/room_api_join_mixin.dart';
import 'mixins/room_api_create_mixin.dart';
import 'mixins/room_api_leave_mixin.dart';
import 'mixins/room_api_chair_mixin.dart';
import 'mixins/room_api_chat_mixin.dart';
import 'mixins/room_api_gifts_mixin.dart';
import 'mixins/room_api_games_mixin.dart';

int Index = 2;
int IndexTrade = 2;
int IndexRecommended = 2;
int IndexRecommended2 = 2;

/// Drop-in replacement for the original Roomapi.
/// Public API and behavior are unchanged.
class Roomapi extends RoomRepository
    with
        RoomApiErrorMixin,
        RoomApiStateMixin,
        RoomApiAdminMixin,
        RoomApiListsMixin,
        RoomApiJoinMixin,
        RoomApiCreateMixin,
        RoomApiLeaveMixin,
        RoomApiChairMixin,
        RoomApiChatMixin,
        RoomApiGiftsMixin,
        RoomApiGamesMixin {}