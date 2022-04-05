import 'package:get/get.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/network/api_repository.dart';
import 'package:mafiaclient/network/api_service.dart';
import 'package:mafiaclient/views/home_page.dart';

import '../models/user_model.dart';
import '../views/sign_in_page.dart';

enum AuthStatus {initial, authenticated, unauthenticated}


class AuthController extends GetxController{
  var authStatus = AuthStatus.initial.obs;
  var status = Status.initial.obs;
  Rx<UserModel?> user = null.obs;


  @override
  void onInit() {
    ever(authStatus, _setInitialScreen);

    checkForAuth();

    super.onInit();
  }

  
  void checkForAuth() async{
    try{
      if(await ApiService().isTokenExist()){
        await ApiService().readToken();
        user.value = await ApiRepository().getMyUser();
      }
      else{
        throw Exception('Token don\'t exist');
      }
    }
    catch(_){
      user.value = null;
      authStatus.value = AuthStatus.unauthenticated;
    }
  }

  void _setInitialScreen(AuthStatus status) {
    if (status == AuthStatus.authenticated) {
      Get.offAll(() => HomePage());  
    } else { 
      Get.offAll(() => const SignInPage()); 
    }
  }
   
}