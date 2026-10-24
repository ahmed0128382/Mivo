part of 'user_api.dart';

// Profile images and profile updates
mixin UserApiProfile on _UserApiBase {
  Future<UserImages> AddProfileImage({
    context,
    image,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image?.path,
          filename: image?.path?.split('/')?.last,
        ),
        "user_id": UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/AddProfileImage',
        data: formData,
      );

      if (response2.statusCode == 200) {
        ProfileImages = UserImages.fromJson(
          response2.data['ProfileImages'],
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return ProfileImages!;
  }

  Future<bool> DeleteProfileImage({
    context,
    ImageId,
  }) async {
    bool deleted = false;

    try {
      Response response2 = await dio.get(
        '/api/DeleteProfileImage/$ImageId',
      );

      if (response2.statusCode == 200) {
        deleted = true;
      } else {
        deleted = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return deleted;
  }

  Future<int> GetTimeTarget({
    context,
  }) async {
    int target = 0;

    try {
      Response response2 = await dio.get(
        '/api/getuserTime/$UserId',
      );

      if (response2.statusCode == 200) {
        target = int.parse(
          response2.data.toString(),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return target;
  }

  Future<usermodel> UpdatenormalProfile({
    Flag,
    ginder,
    Password,
    day,
    year,
    month,
    City,
    Description,
    context,
    token,
    name,
    PhoneNumber,
    Image,
  }) async {
    print(Password);
    print(name);
    print(City);
    print(ginder);
    print(day);
    print(year);
    print(month);
    print(Password);

    var map;

    if (Image != null) {
      map = {
        "description": Description.toString(),
        "name": name.toString(),
        "image": await MultipartFile.fromFile(
          Image?.path,
          filename:
              Image?.path?.split('/')?.last,
        ),
        "City": City,
        "ginder": ginder.toString(),
        "day": day.toString(),
        "year": year.toString(),
        "month": month.toString(),
        "Flag": Flag.toString(),
        "password":
            Password.toString(),
      };
    } else {
      map = {
        "description": Description.toString(),
        "name": name.toString(),
        "City": City,
        "ginder": ginder.toString(),
        "day": day.toString(),
        "year": year.toString(),
        "month": month.toString(),
        "Flag": Flag.toString(),
        "password":
            Password.toString(),
      };
    }

    map.removeWhere(
      (key, value) =>
          key == null ||
          value == null ||
          value == '' ||
          value == 'null',
    );

    try {
      FormData formData =
          FormData.fromMap(map);

      Response response2 = await dio.post(
        'api/UpdateProfile',
        data: formData,
      );

      print(response2.data);
      print(response2.data);

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );

        Dialogs().showtoast(
          'Profile Updated',
        );
      } else {
        print(response2.statusCode);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return userinfo;
  }

  FutureUpdatephoto({
    photo,
    context,
    token,
    avatar,
  }) async {
    var map;

    if (photo != null) {
      map = {
        "image": await MultipartFile.fromFile(
          photo?.path,
          filename:
              photo?.path?.split('/')?.last,
        ),
      };
    } else {
      map = {
        "image": avatar,
      };
    }

    String image = '';

    map.removeWhere(
      (key, value) =>
          key == null ||
          value == null,
    );

    try {
      FormData formData =
          FormData.fromMap(map);

      Response response2 = await dio.post(
        'api/Updatephoto',
        data: formData,
      );

      if (response2.statusCode == 200) {
        image = response2.data['image'];

        Dialogs().showtoast(
          'Photo Updated',
        );
      } else {
        print(response2.statusCode);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return image;
  }

}
