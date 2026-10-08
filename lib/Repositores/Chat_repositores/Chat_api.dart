import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/Inboxroom.dart';
import '../../models/MessageModel.dart';

int Index = 2;

class Chatapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<InboxRoomModel> InboxRooms = [];

  Message messages = Message();

  // ============================================================
  // ERROR HANDLING
  // ============================================================

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final dynamic responseData = response?.data;

      String? message;

      if (responseData is Map) {
        message =
            responseData['message']?.toString() ??
            responseData['msg']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errNum']?.toString();
      }

      return ApiException(
        statusCode: response?.statusCode,
        message:
            message ??
            error.message ??
            'Something went wrong',
        data: responseData,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  // ============================================================
  // GET INBOX ROOMS
  // ============================================================

  Future<List<InboxRoomModel>> GetInboxRooms(
    context,
  ) async {
    InboxRooms.clear();

    final String userId =
        UserId?.toString().trim() ?? '';

    if (userId.isEmpty) {
      print('');
      print('========== GET INBOX ROOMS ==========');
      print('SKIPPED: UserId is empty');
      print('=====================================');

      return InboxRooms;
    }

    try {
      print('');
      print('========== GET INBOX ROOMS ==========');
      print('METHOD: GET');
      print(
        'URL: ${_dio.options.baseUrl}/api/GetMyInboxRoom/$userId',
      );
      print('USER ID: $userId');
      print(
        'TOKEN PRESENT: '
        '${Token != null && Token.toString().trim().isNotEmpty}',
      );
      print('=====================================');

      final Response response = await _dio.get(
        '/api/GetMyInboxRoom/$userId',
      );

      print('');
      print('========== GET INBOX ROOMS RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('URL: ${response.requestOptions.uri}');
      print('DATA: ${response.data}');
      print('==============================================');

      if (response.statusCode == 200) {
        final dynamic data = response.data;

        if (data is List) {
          for (final element in data) {
            if (element is Map) {
              InboxRooms.add(
                InboxRoomModel.fromJson(
                  Map<String, dynamic>.from(element),
                ),
              );
            }
          }
        } else {
          print(
            'GET INBOX ROOMS WARNING: '
            'response data is not a List',
          );
        }
      }
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== GET INBOX ROOMS DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('===============================================');
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== GET INBOX ROOMS UNKNOWN ERROR '
        '==========',
      );
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('================================================');
    }

    return InboxRooms;
  }

  // ============================================================
  // SEND IMAGE CHAT
  // ============================================================

  Future<Message> SentImageChat({
    context,
    image,
    userid,
  }) async {
    print('');
    print('========== SEND IMAGE CHAT ==========');
    print('RECIVER USER ID: $userid');
    print('SENDER USER ID: $UserId');
    print('======================================');

    if (image == null) {
      print(
        'SEND IMAGE CHAT SKIPPED: image is null',
      );

      return messages;
    }

    try {
      final formData = FormData.fromMap({
        'message': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'user_id': userid.toString(),
        'sender_id': UserId.toString(),
      });

      print('');
      print('========== SEND IMAGE CHAT REQUEST ==========');
      print('METHOD: POST');
      print(
        'URL: ${_dio.options.baseUrl}/api/sendImage',
      );
      print('RECIVER USER ID: $userid');
      print('SENDER USER ID: $UserId');
      print('IMAGE PATH: ${image.path}');
      print('=============================================');

      final Response response = await _dio.post(
        '/api/sendImage',
        data: formData,
      );

      print('');
      print('========== SEND IMAGE CHAT RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('URL: ${response.requestOptions.uri}');
      print('DATA: ${response.data}');
      print('===============================================');

      if (response.statusCode == 200) {
        final dynamic data = response.data;

        if (data is Map && data['Messages'] is Map) {
          messages = Message.fromJson(
            Map<String, dynamic>.from(
              data['Messages'],
            ),
          );
        } else {
          print(
            'SEND IMAGE CHAT WARNING: '
            'Messages object is missing or invalid',
          );
        }
      }
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== SEND IMAGE CHAT DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('===============================================');
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== SEND IMAGE CHAT UNKNOWN ERROR '
        '==========',
      );
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('================================================');
    }

    return messages;
  }

  // ============================================================
  // DELETE INBOX ROOM
  // ============================================================

  Future<bool> deleteInboxRooms({
    context,
    inboxid,
  }) async {
    final String inboxId =
        inboxid?.toString().trim() ?? '';

    if (inboxId.isEmpty) {
      print(
        'DELETE INBOX ROOM SKIPPED: inboxid is empty',
      );

      return false;
    }

    try {
      print('');
      print('========== DELETE INBOX ROOM ==========');
      print('METHOD: GET');
      print(
        'URL: ${_dio.options.baseUrl}/api/deleteInboxRoom/$inboxId',
      );
      print('INBOX ID: $inboxId');
      print('=======================================');

      final Response response = await _dio.get(
        '/api/deleteInboxRoom/$inboxId',
      );

      print('');
      print('========== DELETE INBOX ROOM RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('===============================================');

      return response.statusCode == 200;
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== DELETE INBOX ROOM ERROR ==========');
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('=============================================');

      return false;
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== DELETE INBOX ROOM UNKNOWN ERROR ==========');
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('=====================================================');

      return false;
    }
  }

  // ============================================================
  // DELETE + BLOCK INBOX ROOM
  // ============================================================

  Future<bool> deleteandBlockInboxRooms({
    context,
    inboxid,
  }) async {
    final String inboxId =
        inboxid?.toString().trim() ?? '';

    final String userId =
        UserId?.toString().trim() ?? '';

    if (inboxId.isEmpty || userId.isEmpty) {
      print('');
      print(
        'DELETE + BLOCK INBOX ROOM SKIPPED',
      );
      print('INBOX ID: $inboxId');
      print('USER ID: $userId');
      print('======================================');

      return false;
    }

    try {
      print('');
      print(
        '========== DELETE + BLOCK INBOX ROOM '
        '==========',
      );
      print('METHOD: GET');
      print(
        'URL: ${_dio.options.baseUrl}'
        '/api/deleteInboxRoomandBlockUser/'
        '$inboxId/$userId',
      );
      print('INBOX ID: $inboxId');
      print('USER ID: $userId');
      print('=============================================');

      final Response response = await _dio.get(
        '/api/deleteInboxRoomandBlockUser/'
        '$inboxId/$userId',
      );

      print('');
      print(
        '========== DELETE + BLOCK RESPONSE '
        '==========',
      );
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('============================================');

      return response.statusCode == 200;
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== DELETE + BLOCK DIO ERROR '
        '==========',
      );
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('=============================================');

      return false;
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== DELETE + BLOCK UNKNOWN ERROR '
        '==========',
      );
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('================================================');

      return false;
    }
  }

  // ============================================================
  // READ INBOX ROOM
  // ============================================================

  Future<bool> ReadInboxRoom({
    context,
    InboxRoom,
  }) async {
    final String inboxRoomId =
        InboxRoom?.toString().trim() ?? '';

    if (inboxRoomId.isEmpty) {
      print(
        'READ INBOX ROOM SKIPPED: inboxroomid is empty',
      );

      return false;
    }

    try {
      final formData = FormData.fromMap({
        'inboxroomid': inboxRoomId,
      });

      print('');
      print('========== READ INBOX ROOM ==========');
      print('METHOD: POST');
      print(
        'URL: ${_dio.options.baseUrl}/api/ReadInboxRoom',
      );
      print('INBOX ROOM ID: $inboxRoomId');
      print('=====================================');

      final Response response = await _dio.post(
        '/api/ReadInboxRoom',
        data: formData,
      );

      print('');
      print('========== READ INBOX ROOM RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('==============================================');

      return response.statusCode == 200;
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== READ INBOX ROOM ERROR ==========');
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('===========================================');

      return false;
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== READ INBOX ROOM UNKNOWN ERROR ==========');
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('===================================================');

      return false;
    }
  }

  // ============================================================
  // SEND TEXT MESSAGE
  // ============================================================

  Future<Message> sendMessage({
    context,
    message,
    Senderid,
    userid,
  }) async {
    print('');
    print('========== SEND MESSAGE ==========');
    print('MESSAGE: ${message.toString()}');
    print('SENDER ID: $Senderid');
    print('RECIVER ID: $userid');
    print('==================================');

    try {
      final formData = FormData.fromMap({
        'message': message.toString(),
        'user_id': userid.toString(),
        'sender_id': Senderid.toString(),
      });

      print('');
      print('========== SEND MESSAGE REQUEST ==========');
      print('METHOD: POST');
      print(
        'URL: ${_dio.options.baseUrl}/api/sendmessage',
      );
      print('SENDER ID: $Senderid');
      print('RECIVER ID: $userid');
      print('==========================================');

      final Response response = await _dio.post(
        '/api/sendmessage',
        data: formData,
      );

      print('');
      print('========== SEND MESSAGE RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('URL: ${response.requestOptions.uri}');
      print('DATA: ${response.data}');
      print('============================================');

      if (response.statusCode == 200) {
        final dynamic data = response.data;

        print('');
  print('========== SEND MESSAGE PARSING ==========');
  print('RESPONSE TYPE: ${data.runtimeType}');
  print('RESPONSE DATA: $data');
  print('Messages TYPE: ${data is Map ? data['Messages'].runtimeType : 'N/A'}');
  print('Messages DATA: ${data is Map ? data['Messages'] : 'N/A'}');
  print('==========================================');

        if (data is Map && data['Messages'] is Map) {
          messages = Message.fromJson(
            Map<String, dynamic>.from(
              data['Messages'],
            ),
          );
          print('========== MESSAGE PARSED ==========');
    print('ID: ${messages.id}');
    print('USER ID: ${messages.userId}');
    print('SENDER ID: ${messages.senderId}');
    print('INBOX ID: ${messages.inboxroomId}');
    print('MESSAGE: ${messages.message}');
    print('STATUS: ${messages.status}');
    print('CREATED: ${messages.createdAt}');
    print('====================================');
        } else {
          print(
            'SEND MESSAGE WARNING: '
            'Messages object is missing or invalid',
          );
        }
      }
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print('========== SEND MESSAGE DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('============================================');

    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== SEND MESSAGE UNKNOWN ERROR '
        '==========',
      );
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('================================================');

    }

    return messages;
  }

  // ============================================================
  // SEND GIFT MESSAGE
  // ============================================================

  Future<Message> SendGiftMessage({
    context,
    giftid,
    Senderid,
    userid,
  }) async {
    print('');
    print('========== SEND GIFT MESSAGE ==========');
    print('GIFT ID: $giftid');
    print('SENDER ID: $Senderid');
    print('RECIVER ID: $userid');
    print('=======================================');

    try {
      final formData = FormData.fromMap({
        'gift_id': giftid.toString(),
        'user_id': userid.toString(),
        'sender_id': Senderid.toString(),
      });

      print('');
      print('========== SEND GIFT MESSAGE REQUEST ==========');
      print('METHOD: POST');
      print(
        'URL: ${_dio.options.baseUrl}/api/sendgiftmessage',
      );
      print('GIFT ID: $giftid');
      print('SENDER ID: $Senderid');
      print('RECIVER ID: $userid');
      print('===============================================');

      final Response response = await _dio.post(
        '/api/sendgiftmessage',
        data: formData,
      );

      print('');
      print(
        '========== SEND GIFT MESSAGE RESPONSE '
        '==========',
      );
      print('STATUS: ${response.statusCode}');
      print('URL: ${response.requestOptions.uri}');
      print('DATA: ${response.data}');
      print('=================================================');

      if (response.statusCode == 200) {
        final dynamic data = response.data;

        if (data is Map && data['Messages'] is Map) {
          messages = Message.fromJson(
            Map<String, dynamic>.from(
              data['Messages'],
            ),
          );
        } else {
          print(
            'SEND GIFT MESSAGE WARNING: '
            'Messages object is missing or invalid',
          );
        }
      }
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== SEND GIFT MESSAGE DIO ERROR '
        '==========',
      );
      print('TYPE: ${e.type}');
      print('STATUS: ${e.response?.statusCode}');
      print('MESSAGE: ${e.message}');
      print('RESPONSE: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('================================================');

    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print('');
      print(
        '========== SEND GIFT MESSAGE UNKNOWN ERROR '
        '==========',
      );
      print('ERROR: $e');
      print('STACK: $stackTrace');
      print('API EXCEPTION: $exception');
      print('====================================================');

    }

    return messages;
  }
}