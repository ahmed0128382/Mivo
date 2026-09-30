import 'package:flutter/material.dart';

import '../../util/styles.dart';
class CustomeCircleProgress extends StatelessWidget {
  const CustomeCircleProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CircularProgressIndicator(color: MainColor,);
  }
}
