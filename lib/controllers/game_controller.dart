import 'package:get/get.dart';
import 'package:mafiaclient/models/player_model.dart';

import '../models/game_settings.dart';

enum GameStage {lobby, start, inProgress, over}
enum DayPeriod {none, day, night}

class GameController extends GetxController{
  var gameStage = GameStage.lobby.obs;
  var currentDayPeriod = DayPeriod.none.obs;
  var gameCycleCount = 0.obs;

  var haveHost = false.obs;
  int? hostId;

  var playersList = <PlayerModel>[].obs;

  var playersOnVote = <int>[].obs;

  GameSettings? gameSettings;
  
  
  
}