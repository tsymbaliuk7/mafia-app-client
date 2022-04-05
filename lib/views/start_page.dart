import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class StartPage extends StatelessWidget {
  StartPage({Key? key}) : super(key: key);

  final AuthController webrtcController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 138, 189, 230),
    );
  }
}