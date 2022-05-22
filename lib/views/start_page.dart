import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/controllers/styles_controller.dart';

import '../controllers/auth_controller.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final StylesController styles = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColors[styles.styleKey.value],
    );
  }
}