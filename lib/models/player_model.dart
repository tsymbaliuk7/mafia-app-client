import 'package:mafiaclient/models/user_model.dart';

enum PlayerRole {undefined, peaceful, mafia, don, host}

class PlayerModel{
  final UserModel user;
  bool isAlive;
  bool isOnVote;
  bool isVoting;
  bool isMafiaVoter;
  PlayerRole role;
  bool isSpeakingTurn;
  bool isCheating;
  bool haveLastWord;

  PlayerModel({
    required this.user, 
    this.isAlive = true, 
    this.role = PlayerRole.undefined, 
    this.isVoting = false,
    this.isMafiaVoter = false,
    this.isSpeakingTurn = false,
    this.isCheating = false,
    this.isOnVote = false,
    this.haveLastWord = false
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user.toJson();
    data['role'] = role.index;
    data['isAlive'] = isAlive;
    data['isSpeakingTurn'] = isSpeakingTurn;
    data['isVoting'] = isVoting;
    data['isMafiaVoter'] = isMafiaVoter;
    data['isCheating'] = isCheating;
    data['isOnVote'] = isOnVote;
    data['haveLastWord'] = haveLastWord;
    return data;
    
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      user: UserModel.fromJson(json["user"]),
      role: PlayerRole.values[json["role"]],
      isAlive: json["isAlive"],
      isSpeakingTurn: json["isSpeakingTurn"],
      isVoting: json["isVoting"],
      isMafiaVoter: json["isMafiaVoter"],
      isCheating: json["isCheating"],
      isOnVote: json["isOnVote"],
      haveLastWord: json["haveLastWord"],
    );
  }

  PlayerModel copyWith({
    UserModel? user,
    PlayerRole? role,
    bool? isAlive,
    bool? isSpeakingTurn,
    bool? isCheating,
    bool? isOnVote,
    bool? haveLastWord,
    bool? isVoting,
    bool? isMafiaVoter
  }){
    return PlayerModel(
      user: user ?? this.user,
      role: role ?? this.role,
      isAlive: isAlive ?? this.isAlive,
      isSpeakingTurn: isSpeakingTurn ?? this.isSpeakingTurn,
      isCheating: isCheating ?? this.isCheating,
      isOnVote: isOnVote ?? this.isOnVote,
      haveLastWord: haveLastWord ?? this.haveLastWord,
      isVoting: isVoting ?? this.isVoting,
      isMafiaVoter: isMafiaVoter ?? this.isMafiaVoter,
    );
  }
  

  bool isPeaceful(){
    return role == PlayerRole.peaceful || role == PlayerRole.undefined;
  }

  bool isMafia(){
    return role == PlayerRole.don || role == PlayerRole.mafia;
  }

  bool isHost(){
    return role == PlayerRole.host;
  }

  bool isDon(){
    return role == PlayerRole.don;
  }



}