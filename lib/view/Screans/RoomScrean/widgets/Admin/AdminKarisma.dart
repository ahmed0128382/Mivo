import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class AdminKarisma extends StatelessWidget {
  const AdminKarisma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(Helper().k_m_b_generator(Room.Currentroom?.chairs?[8].Karisma) ,style: style2.copyWith(fontSize: 7,color: whitecolor)),
        ),
        const  SizedBox(width: 3,),
        FaIcon(FontAwesomeIcons.heartCircleCheck,size: 7,color: Colors.red),
      ],
    );
  }
}
