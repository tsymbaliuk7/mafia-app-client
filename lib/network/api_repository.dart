import 'package:dio/dio.dart';
import 'package:mafiaclient/network/api_service.dart';

import '../models/user_model.dart';

class ApiRepository{

  static ApiRepository? _instance;
 
  factory ApiRepository() => _instance ?? ApiRepository._internal();

  ApiRepository._internal(){
    _instance = this;
  }

  // Future<UserModel> signIn(Map<String, dynamic> data) async{

  // }

  // Future<UserModel> signUp(Map<String, dynamic> data) async{
    
  // }

  Future<UserModel> getMyUser() async{
    String endpoint = 'user';
    final  api = ApiService().getApiWithOptions(withAuth: true);
    final response = await api.get(endpoint);
    if(response.statusCode == 200){
      Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return UserModel.fromJson(data);
    }
    else{
      throw Exception('Failed to load user');
    }
  }

  // Future<UserModel> UpdateMyUser(Map<String, dynamic> data) async{
    
  // }



}
