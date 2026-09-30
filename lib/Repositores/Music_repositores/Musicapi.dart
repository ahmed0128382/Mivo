
import 'package:dio/dio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../models/UserMusic.dart';
import '../../models/VipModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';


class Musicapi extends MomentRepository {
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


  Future<usermusic> AddMusic({ context,SongModel? Music}) async {

print(Music?.data.runtimeType);
    print(Music?.data );
print('11111111111111111111111111111111111111111111' );
var musicsss=await MultipartFile.fromFile(Music?.data??'', filename: Music?.data.split('/').last);
print(musicsss);
print(musicsss.runtimeType);
print(musicsss.filename);


// Method

  usermusic ?music;
    try {
      FormData formData = new FormData.fromMap({
        "music": musicsss,
        "user_id":UserId.toString(),
        "name":Music?.title.toString()

      });
      Response response2 = await dio.post(
        'api/AddUserMusic',
        data: formData,
      );

      if (response2.statusCode == 200) {

        music=usermusic.fromJson(response2.data['UserMusic']);

      }
    } catch (e) {
print(e);


    }

   return music!;
  }
}
