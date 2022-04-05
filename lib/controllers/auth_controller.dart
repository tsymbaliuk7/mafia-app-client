import 'package:get/get.dart';

import '../models/user_model.dart';

enum AuthStatus {initial, authenticated, unauthenticated}


class AuthController extends GetxController{
  var status = AuthStatus.initial.obs;
  late Rx<UserModel?> user;


  @override
  void onInit() {
    user.value = null;

    // ever(status, _setInitialScreen);

    super.onInit();
  }


  // _setInitialScreen(AuthStatus status) {
  //   if (status == null) {
        
  //     Get.offAll(() => const Register());
        
  //   } else {
        
  //     Get.offAll(() => Home());
        
  //   }
  // }
   
}