import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../util/SizeConfig.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
class ProfileStack extends StatelessWidget {
  const ProfileStack({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);


    return Stack(
      children: [
        CircleAvatar(backgroundColor: MainColor,radius: SizeConfig.screenHeight!*0.081,child: CircleAvatar(backgroundColor: MainColor,radius: SizeConfig.screenHeight!*0.0793,backgroundImage:user.Signupimage==null?CachedNetworkImageProvider(user.Avatarlink??Images.unphoto):FileImage(user.Signupimage) as ImageProvider)),

        Positioned(bottom:5,right: 0, child: Icon(Icons.photo_camera_outlined,color: whitecolor,))
      ],
    );
  }
}
