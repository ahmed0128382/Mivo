import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/PayPalPackage.dart';
import '../../util/app_constants.dart';

class PurchasaApi {
  static const _Apikey = 'goog_gwCLyFNVrTWbbgyUeuqHLWLZHWQ';
 
  final Dio _dio = ApiClient.instance.dio;

  List<PayPalPackage> PayPalPackages = [];

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      return ApiException(
        statusCode: response?.statusCode,
        message: response?.data?['message']?.toString() ??
            response?.data?['error']?.toString() ??
            response?.data?['errNum']?.toString() ??
            error.message ??
            'Something went wrong',
        data: response?.data,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_Apikey);
  }

  static Future<List<Offering>> fetchoffers() async {
    await Purchases.setAttributes({
      'id': UserId.toString(),
    });

    try {
      final offerings = await Purchases.getOfferings();
      final Current = offerings.current;

      print(Current);

      return Current == null ? [] : [Current];
    } on PlatformException catch (e) {
      return [];
    }
  }

  Future<List<PayPalPackage>> GeyPayPalPackages() async {
    try {
      final Response response2 = await _dio.get(
        '/api/GetPaypalPackage',
      );

      if (response2.statusCode == 200) {
        final List list = response2.data['PaypalPackage'] ?? [];

        for (final element in list) {
          PayPalPackages.add(
            PayPalPackage.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return PayPalPackages;
  }

  static Future<bool> purchesPackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}