class UserModel{
  final int id;
  final String username;
  final String email;
  bool isMutedVideo;
  bool isMutedAudio;

  UserModel.empty() : 
    id = 0, 
    username = '', 
    email = '', 
    isMutedAudio = false, 
    isMutedVideo = false;

  UserModel({
    required this.id, 
    required this.username, 
    required this.email,
    this.isMutedAudio = false,
    this.isMutedVideo = false
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      isMutedVideo: json["isMutedVideo"],
      isMutedAudio: json["isMutedAudio"],
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["username"] = username;
    data["email"] = email;
    data["isMutedVideo"] = isMutedVideo;
    data["isMutedAudio"] = isMutedAudio;
    return data;
  }



}