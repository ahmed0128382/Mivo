
import 'package:dio/dio.dart';

import '../../models/Inboxroom.dart';
import '../../models/MessageModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';


int Index=2;
class Chatapi extends MomentRepository {
  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );
  List<InboxRoomModel> InboxRooms=[];

  Future<List<InboxRoomModel> >  GetInboxRooms(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetMyInboxRoom/$UserId',
      );

      if (response2.statusCode == 200) {
        List list =response2.data;

        list.forEach((element) {
          InboxRooms.add(InboxRoomModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
      
    }

    return InboxRooms;

  }


  Future<Message> SentImageChat({ context,image, userid  }) async {
print(userid);print(UserId);
    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "message":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "user_id":userid.toString(),
        "sender_id":UserId.toString()
      });

      Response response2 = await dio.post(
        'api/sendImage',
        data: formData,
      );

      if (response2.statusCode == 200) {

        messages=Message.fromJson(response2.data['Messages']);
         
      }
    } catch (e) {
      print(e);


    }

    return messages;
  }
  Future<bool>  deleteInboxRooms({context, inboxid})async {
bool deleted=false;
    try {
      Response response2 = await dio.get(
        '/api/deleteInboxRoom/${inboxid}',
      );

      if (response2.statusCode == 200) {
        deleted=true;
      }else{
        deleted=false;
      }
    } catch (e) {

      print(e);
    }

    return deleted;

  }
  Future<bool>  deleteandBlockInboxRooms({context, inboxid})async {
    bool deleted=false;
    try {
      Response response2 = await dio.get(
        '/api/deleteInboxRoomandBlockUser/$inboxid/$UserId',
      );

      if (response2.statusCode == 200) {
        deleted=true;
      }else{
        deleted=false;
      }
    } catch (e) {
      print(e);

    }

    return deleted;

  }
  Future<bool> ReadInboxRoom({ context,InboxRoom}) async {

    bool read=false;
    try {
      FormData formData = new FormData.fromMap({
        "inboxroomid": InboxRoom.toString(),

      });
      Response response2 = await dio.post(
        'api/ReadInboxRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {

        read=true;
      }else{
        read=false;
      }
    } catch (e) {
      read=false;
      print(e);
    }

    return read;
  }

  Message messages=Message();

  Future<Message> SendMessage({ context,message,Senderid,userid}) async {


    try {
      FormData formData = FormData.fromMap({
        "message": message.toString(),
        "user_id":userid.toString(),
        "sender_id":Senderid.toString()

      });
      Response response2 = await dio.post(
        'api/sendmessage',
        data: formData,
      );


      if (response2.statusCode == 200) {

        messages=Message.fromJson(response2.data['Messages']);

       }
    } catch (e) {

      print(e);
    }

    return messages;
  }

  Future<Message> SendGiftMessage({ context,giftid,Senderid,userid}) async {




    try {
      FormData formData = FormData.fromMap({
        "gift_id": giftid.toString(),
        "user_id":userid.toString(),
        "sender_id":Senderid.toString()

      });
      Response response2 = await dio.post(
        'api/sendgiftmessage',
        data: formData,
      );


      if (response2.statusCode == 200) {

        messages=Message.fromJson(response2.data['Messages']);

      }
    } catch (e) {


    }

    return messages;
  }

}
