part of 'user_api.dart';

// Guess games, lucky packages, bubbles, coins, settings
mixin UserApiGames on _UserApiBase {
  Future<bool> NewGuess({
    context,
    Coins,
    Roomid,
    Sendergueess,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "Sender_id": UserId.toString(),
        "Coins": Coins.toString(),
        "Room_id": Roomid.toString(),
        "Sender_gueess": Sendergueess.toString(),
      });

      Response response2 = await dio.post(
        'api/NewGuessgame',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;
    }

    return check;
  }

  Future<bool> NewLuckyPackage({
    context,
    Coins,
    Roomid,
  }) async {
    print(Roomid);
    print(Coins);

    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "coins": Coins.toString(),
      });

      Response response2 = await dio.post(
        'api/SendLuckybags',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;
    }

    return check;
  }

  Future<bool> AcceptLuckyPackage({
    context,
    luckid,
    Roomid,
  }) async {
    print(Roomid);
    print(luckid);

    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "luck_id": luckid.toString(),
      });

      Response response2 = await dio.post(
        'api/AcceptLuckybags',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;
    }

    return check;
  }

  Future<bool> PlayGuess({
    context,
    guessid,
    Roomid,
    Sendergueess,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "Accept_id": UserId.toString(),
        "guess_id": guessid.toString(),
        "Room_id": Roomid.toString(),
        "Accept_gueess": Sendergueess.toString(),
      });

      Response response2 = await dio.post(
        'api/AcceptGuessgame',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;
    }

    return check;
  }

  Future<bool> Removebubbles({
    context,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/removebubbles',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return check;
  }

  Future<List> Exchangecoins({
    context,
    jwile,
  }) async {
    bool check = false;
    int coins = 0;
    int input = 0;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "beans": jwile.toString(),
      });

      Response response2 = await dio.post(
        'api/Exchangecoins',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print(
          response2.data['Exchangecoins']
              ['UserCoins']
              .runtimeType,
        );

        print(
          response2.data['Exchangecoins']
              ['UserInput']
              .runtimeType,
        );

        coins =
            response2.data['Exchangecoins']['UserCoins'];

        input =
            response2.data['Exchangecoins']['UserInput'];

        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return [check, coins, input];
  }

  Future<bool> Updatebubbles({
    bubbles,
    context,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "bubbles": bubbles.toString(),
      });

      Response response2 = await dio.post(
        'api/Setbubbles',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return check;
  }

  Future<bool> updateColoredMessage({
    Color,
    context,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "Color": Color.toString(),
      });

      Response response2 = await dio.post(
        'api/SetColordmessage',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return check;
  }

  Future<bool> setHidden({
    Hidden,
    context,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "Hidden": Hidden.toString(),
      });

      Response response2 = await dio.post(
        'api/SetHidden',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return check;
  }

}
