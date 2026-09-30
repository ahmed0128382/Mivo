

import '../../models/Usermodel.dart';
abstract class UserRepository {
  Future<usermodel> UserLogin({Phonenumber});
  Future<usermodel> UserLoginVerify();
  Future<usermodel> Userinfo( );


  Future<void> SignOut({context});



  getAllconstant(context);

}
