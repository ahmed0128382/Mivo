
import 'package:ahlachat/models/AchiveModel.dart';
import 'package:dio/dio.dart';


import '../../models/LevelGifts.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';

import '../Moment_repositores/Moment_repository.dart';

class Levelapi extends MomentRepository {
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
  List<AchiveModels> AchiveModelss=[];

  Future<List<AchiveModels> >  GetModels( )async {

    try {
      Response response2 = await dio.get(
        '/api/GetModels',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Models'];

        list.forEach((element) {
          AchiveModelss.add(AchiveModels.fromJson(element));
        });


      }
    } catch (e) {
      print(e);

    }

    return AchiveModelss;

  }

}
