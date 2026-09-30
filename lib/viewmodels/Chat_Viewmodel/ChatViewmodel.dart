

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatViewmodel extends ChangeNotifier{

  final ImagePicker _picker = ImagePicker();
  File?  chatImage;
  Future GetChatGalery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
   chatImage = File(pickedFile.path);
    } else {

    }
    notifyListeners(); //
  }


}