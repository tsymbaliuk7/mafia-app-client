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

  // Future<UserModel> getMyUser(Map<String, dynamic> data) async{
    
  // }

  // Future<UserModel> UpdateMyUser(Map<String, dynamic> data) async{
    
  // }



}
