
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class ApiService{

  static ApiService? _instance;
 
  factory ApiService() => _instance ?? ApiService._internal();

  ApiService._internal(){
    _instance = this;
  }

  final Dio _api = Dio();
  String? token;
  final String baseApiUrl = 'https://hidden-temple-69290.herokuapp.com/api/';


  Dio getApiWithOptions({bool withAuth = false}){
    _api.interceptors.clear();
    _api.interceptors.add(_getInterseptors(withAuth));
    return _api;
  }


  InterceptorsWrapper _getInterseptors(bool withAuth){
    return InterceptorsWrapper(
      onRequest: (options, handler){
        options.baseUrl = baseApiUrl;
        options.headers = {
          'Accept' : 'application/json'
        };

        if(withAuth){
          options.headers['Authorization'] = 'Bearer ' + (token ?? '');
        }

        return handler.next(options);
      }
    );
  }


  void writeToken(String token) async {
    await GetStorage().write('token', token);
    this.token = token;
  }

  Future<bool> isTokenExist() async{
    return GetStorage().read('token') != null;
  }

  Future<void> readToken() async {
    var token = GetStorage().read('token');
    this.token = token;
  }

  void deleteToken() async {
    await GetStorage().remove('token');
    token = null;
  }



}