import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../models/PayPalPackage.dart';
import '../../util/app_constants.dart';

class PurchasaApi {
  static const _Apikey='goog_gwCLyFNVrTWbbgyUeuqHLWLZHWQ';
  List  <PayPalPackage> PayPalPackages=[];
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
  static Future init()async{
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_Apikey);
  }
  static Future<List<Offering>> fetchoffers()async {
    await Purchases.setAttributes({'id':UserId.toString()});
    try{
      final offerings= await Purchases.getOfferings();
      final Current=offerings.current;
      print(Current);
      return Current==null?[]: [Current];
    }on PlatformException catch(e){
      return [];
    }
  }
  Future<List<PayPalPackage>> GeyPayPalPackages() async {
    try {

      Response response2 = await dio.get(
        '/api/GetPaypalPackage',
      );


      if (response2.statusCode == 200) {

        List list =response2.data['PaypalPackage'] ;

        list.forEach((element) {
          PayPalPackages.add(PayPalPackage.fromJson(element));
        });

      }
    } catch (e) {


    }

    return PayPalPackages;
  }
  static Future<bool> purchesPackage(Package package)async {

    try{

      await Purchases.purchasePackage(package);
      return true;

    }catch(e){
      return false;
    }

  }


}