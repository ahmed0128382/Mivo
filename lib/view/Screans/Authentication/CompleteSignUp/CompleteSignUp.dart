
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';

class CompleteSignUp extends StatefulWidget {
  const CompleteSignUp({super.key});

  @override
  State<CompleteSignUp> createState() => _CompleteSignUpState();
}

class _CompleteSignUpState extends State<CompleteSignUp> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showDatePickers(BuildContext ctx) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: false);

    FocusScope.of(context).unfocus();

    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: SizeConfig.screenHeight! * 0.48366,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight! * 0.392,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumYear: 1950,
                maximumYear: DateTime.now().year,
                onDateTimeChanged: (val) {
                  setState(() {
                    user.History = '${val.month}/${val.day}/${val.year}';
                    user.day = val.day;
                    user.year = val.year;
                    user.month = val.month;
                  });
                },
              ),
            ),
            CupertinoButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                FocusScope.of(context).unfocus();
              },
              child: Text(
                getLang(context: context, key: 'OK'),
                style: style1.copyWith(color: MainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 7 && digits.length <= 15;
  }

  Future<void> _completeRegistration(LoginViewmodel user) async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();

    if (user.Comimage == null) {
      Dialogs().showtoast(
        getLang(context: context, key: 'Select_Photo'),
      );
    } else if (user.UsernameComp == null ||
        user.UsernameComp!.trim().isEmpty) {
      Dialogs().showtoast(
        getLang(context: context, key: 'Select_Name'),
      );
    } else if (user.History == null) {
      Dialogs().showtoast(
        getLang(context: context, key: 'Select_Birthday'),
      );
    } else if (user.Code2 == null) {
      Dialogs().showtoast(
        getLang(context: context, key: 'Select_Country'),
      );
    } else if (phone.isNotEmpty && !_isValidPhone(phone)) {
      Dialogs().showtoast('Please enter a valid phone number.');
    } else {
      await user.registerNewUser(
        context: context,
        phoneNumber: phone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    return Scaffold(
      // Allow the available body height to resize when the keyboard opens.
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          getLang(context: context, key: 'Set_Profile'),
          style: style2.copyWith(fontSize: 17),
        ),
        backgroundColor: whitecolor,
        iconTheme: const IconThemeData(color: Colors.black45),
        leading: InkWell(
          onTap: () async {
            if (Gmail != null) {
              final googleuser = GoogleSignIn();
              await googleuser.signOut();
              await FirebaseAuth.instance.signOut();
            }

            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.navigate_before_rounded,
            size: 40,
            color: Colors.black26,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (Gmail != null) {
            final googleuser = GoogleSignIn();
            await googleuser.signOut();
            await FirebaseAuth.instance.signOut();
          }
          return true;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Keeps fields and buttons reachable above the keyboard.
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              padding: WPadding15,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Profile photo
                    InkWell(
                      onTap: () => user.ComtImage(context),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 47,
                            backgroundColor: MainColor,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: whitecolor,
                              backgroundImage: user.Comimage == null
                                  ? const ExactAssetImage(
                                      Images.Personalphoto,
                                    )
                                  : FileImage(user.Comimage!)
                                      as ImageProvider,
                            ),
                          ),
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: MainColor,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: SizeConfig.TenSize! * 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.TenSize! * 3.5,
                      ),
                      child: Text(
                        getLang(context: context, key: 'Use_Pictuer'),
                        textAlign: TextAlign.center,
                        style: style6.copyWith(
                          fontSize: SizeConfig.TenSize! * 1.3,
                          color: Colors.black45,
                        ),
                      ),
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Name
                    Row(
                      children: [
                        Image.asset(
                          Images.EnterName,
                          height: SizeConfig.TenSize! * 4,
                          width: SizeConfig.TenSize! * 7,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: SizeConfig.TenSize! * 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1878f3)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.TenSize!,
                                  vertical: 5,
                                ),
                                child: TextFormField(
                                  initialValue: user.UsernameComp,
                                  onChanged: (value) {
                                    user.UpdateUsernameComp(name: value);
                                  },
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration.collapsed(
                                    hintText: getLang(
                                      context: context,
                                      key: 'Enter_Name',
                                    ),
                                    hintStyle:
                                        styleb45.copyWith(fontSize: 1.6),
                                  ),
                                  style: style8.copyWith(height: 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Birthday
                    InkWell(
                      onTap: () => _showDatePickers(context),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.EnterBirth,
                            height: SizeConfig.TenSize! * 4,
                            width: SizeConfig.TenSize! * 7,
                          ),
                          Expanded(
                            child: Container(
                              height: SizeConfig.TenSize! * 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1878f3)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.TenSize! * 2,
                                      ),
                                      child: Text(
                                        user.History ??
                                            getLang(
                                              context: context,
                                              key: 'What_Birthday',
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: style8.copyWith(
                                          height: 1.4,
                                          fontSize:
                                              SizeConfig.TenSize! * 1.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Gender
                    Row(
                      children: [
                        Image.asset(
                          Images.EnterSex,
                          height: SizeConfig.TenSize! * 4,
                          width: SizeConfig.TenSize! * 7,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    user.ginder = 1;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1878f3)
                                          .withOpacity(
                                        user.ginder == 1 ? 1 : 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.TenSize!,
                                      vertical: SizeConfig.TenSize!,
                                    ),
                                    child: Center(
                                      child: Text(
                                        getLang(
                                          context: context,
                                          key: 'Female',
                                        ),
                                        style: style4.copyWith(
                                          fontSize:
                                              SizeConfig.TenSize! * 1.3,
                                          color: user.ginder == 1
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    user.ginder = 0;
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1878f3)
                                          .withOpacity(
                                        user.ginder == 0 ? 1 : 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.TenSize!,
                                      vertical: SizeConfig.TenSize!,
                                    ),
                                    child: Center(
                                      child: Text(
                                        getLang(
                                          context: context,
                                          key: 'Male',
                                        ),
                                        style: style4.copyWith(
                                          fontSize:
                                              SizeConfig.TenSize! * 1.3,
                                          color: user.ginder == 0
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Phone number
                    Row(
                      children: [
                        Image.asset(
                          Images.Phone,
                          height: SizeConfig.TenSize! * 4,
                          width: SizeConfig.TenSize! * 7,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: SizeConfig.TenSize! * 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1878f3)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.TenSize!,
                                  vertical: 5,
                                ),
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [
                                    AutofillHints.telephoneNumber,
                                  ],
                                  decoration: InputDecoration.collapsed(
                                    hintText: getLang(
                                      context: context,
                                      key: 'Enter_Phone',
                                    ),
                                    hintStyle:
                                        styleb45.copyWith(fontSize: 1.6),
                                  ),
                                  style: style8.copyWith(height: 1),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: Dimensions.FONT_SIZE_LARGE),

                    // Country selection
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pushNamed(
                          context,
                          AppConstants.PickCode_Screan2,
                        );
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            Images.EnterLocation,
                            height: SizeConfig.TenSize! * 4,
                            width: SizeConfig.TenSize! * 7,
                          ),
                          Expanded(
                            child: Container(
                              height: SizeConfig.TenSize! * 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1878f3)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.TenSize! * 2,
                                      ),
                                      child: Text(
                                        user.Name2 ??
                                            getLang(
                                              context: context,
                                              key: 'Country',
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: style4.copyWith(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (user.Code2 != null) ...[
                                    Text(
                                      user.Flag2 ?? '',
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.TenSize! * 2.5,
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: Text(
                                        getLang(
                                          context: context,
                                          key: 'what_Country',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: styleb45.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    width: SizeConfig.TenSize! * 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Google email
                    if (Gmail != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.TenSize!,
                          vertical: SizeConfig.TenSize!,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.location,
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              getLang(context: context, key: 'Gmail'),
                              style: style4.copyWith(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                Gmail ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: styleb45.copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Do not use Spacer in a scrollable Column.
                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.TenSize! * 3.5,
                      ),
                      child: Text(
                        getLang(
                          context: context,
                          key: 'Complete_Profile',
                        ),
                        textAlign: TextAlign.center,
                        style: style6.copyWith(
                          fontSize: SizeConfig.TenSize! * 1.3,
                          color: Colors.black45,
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.TenSize! * 2.5),

                    // Complete registration
                    InkWell(
                      onTap: () => _completeRegistration(user),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: MainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          height: SizeConfig.TenSize! * 4.4,
                          child: Center(
                            child: Text(
                              getLang(context: context, key: 'Done'),
                              style: style1,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.TenSize! * 2.8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
