
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    this.token = token;
  }

  Future<bool> isTokenExist() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<void> readToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    this.token = token;
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
  }



}