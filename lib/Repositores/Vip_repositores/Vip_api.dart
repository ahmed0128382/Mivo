
import 'package:ahlachat/models/MyVip.dart';
import 'package:dio/dio.dart';

import '../../models/VipModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';


class Vipapi extends MomentRepository {
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
  List<VipModel> Vips=[];
  List<MyVipmodel>MyVips=[];

  Future<List<VipModel> >  GetVips( )async {

    try {
      Response response2 = await dio.get(
        '/api/GetVip',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Vip'];

        list.forEach((element) {
          Vips.add(VipModel.fromJson(element));
        });


      }
    } catch (e) {
      print(e);

    }

    return Vips;

  }
  Future<List<MyVipmodel> >  GetMyVips( )async {

    try {
      Response response2 = await dio.get(
        '/api/GetMyVips/$UserId',
      );
      print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data['MyVip'];

        list.forEach((element) {
          MyVips.add(MyVipmodel.fromJson(element));
        });


      }
    } catch (e) {
      print(e);

    }

    return MyVips;

  }
}
