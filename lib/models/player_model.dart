enum PlayerRole {undefined, peaceful, mafia, don, host}

class PlayerModel{
  final int userId;
  bool isAlive;
  PlayerRole role;
  bool isSpeakingTurn;
  bool isCheating;
  bool haveLastWord;

  PlayerModel({
    required this.userId, 
    this.isAlive = true, 
    this.role = PlayerRole.undefined, 
    this.isSpeakingTurn = false,
    this.isCheating = false,
    this.haveLastWord = false
  });
}