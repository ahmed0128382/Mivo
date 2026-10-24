part of 'user_api.dart';

// Search, chat, reports, image pickers
mixin UserApiSocial on _UserApiBase {
  Future<InboxRoomModel?> ChatInBox({
    userid,
  }) async {
    try {
      Response response2 = await dio.get(
        '/api/ChatWithuser/$UserId/$userid',
      );

      if (response2.statusCode == 200) {
        ChatRoom = InboxRoomModel.fromJson(
          response2.data,
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return ChatRoom;
  }

  Future<List<usermodel>> SearchUser(
    tittle,
  ) async {
    try {
      final String query =
          tittle?.toString().trim() ?? '';

      if (query.isEmpty) {
        return Searchuser;
      }

      Response response2 = await dio.get(
        '/api/SearchUser/$query',
      );

      if (response2.statusCode == 200) {
        List list = response2.data['users'];

        list.forEach((element) {
          Searchuser.add(
            usermodel.fromJson(element),
          );
        });
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Searchuser;
  }

  @override
  Future<bool> SendReport({
    context,
    contact,
    feedback,
    feedback_type,
    contact_type,
    image,
  }) async {
    bool data = false;

    try {
      var map;

      if (image != null) {
        map = {
          "user_id": UserId.toString(),
          "feedback": feedback.toString(),
          "contact": contact.toString(),
          "image": await MultipartFile.fromFile(
            image?.path,
            filename: image?.path?.split('/')?.last,
          ),
          "feedback_type":
              feedback_type.toString(),
          "contact_type":
              contact_type.toString(),
        };
      } else {
        map = {
          "user_id": UserId.toString(),
          "feedback": feedback.toString(),
          "contact": contact.toString(),
          "feedback_type":
              feedback_type.toString(),
          "contact_type":
              contact_type.toString(),
        };
      }

      print(
        '2222222222222222222222222222222222',
      );

      FormData formData =
          FormData.fromMap(map);

      Response response2 = await dio.post(
        '/api/SendReport',
        data: formData,
      );

      if (response2.statusCode == 200) {
        data = true;
      } else {
        data = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      data = false;

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

    return data;
  }

  Future getReportImage() async {
    final pickedFile =
        await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      var Signupimage =
          File(pickedFile.path);

      print(Signupimage);

      return Signupimage;
    } else {
      print('No image selected.');
    }
  }

  Future getImageGalary() async {
    final pickedFile =
        await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      var Signupimage =
          File(pickedFile.path);

      print(Signupimage);

      return Signupimage;
    } else {
      print('No image selected.');
    }
  }

}
