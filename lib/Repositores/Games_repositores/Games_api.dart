import 'package:dio/dio.dart';

import '../../models/GameModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

int GameIndex=2;
class Gamesapi extends MomentRepository {
  List<GamesModel> GamesList=[];
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
  Future<List<GamesModel>>  AllGames(context)async {

    GameIndex=2;
    try {
      Response response2 = await dio.get(
        '/api/GetAllGames',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['games']['data'];

        list.forEach((element) {
          GamesList.add(GamesModel.fromJson(element));
        });

      }
    } catch (e) {
      if (e is DioError) {
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return GamesList;

  }
  Future<List<GamesModel>>  GetMoreGames(context)async {
    

    try {
      Response response2 = await dio.get(
        '/api/GetAllGames?page=${GameIndex.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['games']['data'];
        if(list.isNotEmpty){
          GameIndex++;
        }
        
        list.forEach((element){
          GamesList.add(GamesModel.fromJson(element));
        });
        print(GamesList);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return GamesList;

  }
  Future<bool>  Increament({id})async {


    try {
      Response response2 = await dio.get(
        '/api/incrementuser/$id',
      );

      if (response2.statusCode == 200) {

      }
    } catch (e) {

    }

    return true;

  }
}
