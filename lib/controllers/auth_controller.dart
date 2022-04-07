import 'package:get/get.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/network/api_repository.dart';
import 'package:mafiaclient/network/api_service.dart';
import 'package:mafiaclient/views/home_page.dart';

import '../exceptions/auth_exception.dart';
import '../models/user_model.dart';
import '../views/sign_in_page.dart';

enum AuthStatus {initial, authenticated, unauthenticated}


class AuthController extends GetxController{
  var authStatus = AuthStatus.initial.obs;
  var status = Status.initial.obs;
  var errorMessage = ''.obs;
  Rx<UserModel> user = UserModel.empty().obs;


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
      user.value = UserModel.empty();
      authStatus.value = AuthStatus.unauthenticated;
    }
  }



  Future<void> signIn(String email, String password) async {
    status.value = Status.initial;
    try{
      user.value = await ApiRepository().signIn({
        'email': email, 
        'password': password
      });
      status.value = Status.success;
      authStatus.value = AuthStatus.authenticated;
    }
    on AuthException catch(error){
      status.value = Status.failure;
      errorMessage.value = error.message;
    }
    on Exception catch(_){
      status.value = Status.failure;
      errorMessage.value = 'Errors in sign in! Please, try again';
    }
  }


  Future<void> signUp(String username, String email, String password) async {
    try{
      user.value = await ApiRepository().signUp({
        'username': username, 
        'email': email, 
        'password': password
      });
      status.value = Status.success;
      authStatus.value = AuthStatus.authenticated;
    }
    on AuthException catch(error){
      status.value = Status.failure;
      errorMessage.value = error.message;
    }
    on Exception catch(_){
      status.value = Status.failure;
      errorMessage.value = 'Errors in sign up! Please, try again';
    }
  }

  
  
  void _setInitialScreen(AuthStatus authStatus) {
    if (authStatus == AuthStatus.authenticated) {
      Get.offAll(() => HomePage());  
    } else { 
      status.value = Status.initial;
      Get.offAll(() => SignInPage()); 
    }
  }
   
}