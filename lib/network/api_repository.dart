import 'package:dio/dio.dart';
import 'package:mafiaclient/network/api_service.dart';
import '../exceptions/auth_exception.dart';
import '../models/user_model.dart';

class ApiRepository{

  static ApiRepository? _instance;
 
  factory ApiRepository() => _instance ?? ApiRepository._internal();

  ApiRepository._internal(){
    _instance = this;
  }

  Future<UserModel> signIn(Map<String, dynamic> data) async{
    String endpoint = 'auth/signin';
    final  api = ApiService().getApiWithOptions();
    try {
      final response = await api.post(endpoint, data: data);
      if(response.statusCode == 200){
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        ApiService().writeToken(data['accessToken']);
        return UserModel.fromJson(data);
      }
      else{
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        throw AuthException(data['message']);
      }
    }
    catch(e){
      if(e is DioError){
        int status = e.response?.statusCode ?? 401;
        if (status < 500) {
          Map<String, dynamic> data = Map<String, dynamic>.from(e.response?.data);
          throw AuthException(data['message']);
        } else {
          rethrow;
        }
      }
      else{
        rethrow;
      }
    }
  }

  Future<UserModel> signUp(Map<String, dynamic> data) async{
    String endpoint = 'auth/signup';
    final  api = ApiService().getApiWithOptions();
    try{
      final response = await api.post(endpoint, data: data);
      if(response.statusCode == 200){
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        ApiService().writeToken(data['accessToken']);
        return UserModel.fromJson(data);
      }
      else{
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        throw AuthException(data['message']);
      }
    }
    catch(e){
      if(e is DioError){
        int status = e.response?.statusCode ?? 401;
        if (status < 500) {
          Map<String, dynamic> data = Map<String, dynamic>.from(e.response?.data);
          throw AuthException(data['message']);
        } else {
          rethrow;
        }
      }
      else{
        rethrow;
      }
    }
  }

  Future<UserModel> getMyUser() async{
    String endpoint = 'user';
    final  api = ApiService().getApiWithOptions(withAuth: true);
    final response = await api.get(endpoint);
    if(response.statusCode == 200){
      Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
      return UserModel.fromJson(data['data']);
    }
    else{
      throw Exception('Failed to load user');
    }
  }

  Future<UserModel> updateUser(Map<String, dynamic> data) async{
    String endpoint = 'user';
    final  api = ApiService().getApiWithOptions(withAuth: true);
    try{
      final response = await api.post(endpoint, data: data);
      if(response.statusCode == 200){
        Map<String, dynamic> responseData = Map<String, dynamic>.from(response.data);
        return UserModel.fromJson(responseData['data']);
      }
      else{
        throw Exception('Failed to load user');
      }
    }
    catch(e){
      print(e);
      if(e is DioError){
        int status = e.response?.statusCode ?? 401;
        if (status < 500) {
          Map<String, dynamic> data = Map<String, dynamic>.from(e.response?.data ?? {});
          throw AuthException(data['message'] ?? '');
        } else {
          rethrow;
        }
      }
      else{
        rethrow;
      }
    }
    
  }




}
