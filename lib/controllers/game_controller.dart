import 'package:get/get.dart';
import 'package:mafiaclient/models/player_model.dart';

import '../models/game_settings.dart';
import '../models/user_model.dart';
import '../network/socket_service.dart';
import 'auth_controller.dart';

enum GameStage {lobby, start, inProgress, over}
enum DayPeriod {none, day, night}

class GameController extends GetxController{
  final AuthController authController = Get.find();

  var gameStage = GameStage.lobby.obs;
  var currentDayPeriod = DayPeriod.none.obs;
  var gameCycleCount = 0.obs;

  var haveHost = false.obs;
  int? hostId;

  var playersList = <PlayerModel>[].obs;

  GameSettings? gameSettings;

  var readyToDisplayGame = false.obs;
  bool needToReceiveGameData = true;

  @override
  void onInit() {
    if(!SocketService().socket.hasListeners('ask-for-game-data')){
      SocketService().socket.on('ask-for-game-data', (data){
        sendGameData(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('receive-game-data')){
      SocketService().socket.on('receive-game-data', (data){
        receiveGameData(Map<String, dynamic>.from(data));
      });
    }
    super.onInit();
  }

  PlayerModel? getMyPlayer(){
    return playersList.firstWhereOrNull((p0) => p0.user.id == authController.user.value.id);
  }

  PlayerModel? getHost(){
    return playersList.firstWhereOrNull((p0) => p0.role == PlayerRole.host);
  }

  Map<int, PlayerModel>? getDon(){
    Map<int, PlayerModel>? result;
    playersList.asMap().forEach((key, value) {
      if(value.isDon()){
        result = {key: value};
      }
    });
    return result;
  }

  Map<int, PlayerModel>? getMafia(){
    Map<int, PlayerModel> result = {};
    playersList.asMap().forEach((key, value) {
      if(value.role == PlayerRole.mafia){
        result[key] = value;
      }
    });
    return result.isEmpty ? null : result;
  }


   Map<int, PlayerModel>? getPlayersWithoutHost(){
    Map<int, PlayerModel> result = {};
    playersList.asMap().forEach((key, value) {
      if(value.role != PlayerRole.host){
        result[key] = value;
      }
    });
    return result.isEmpty ? null : result;
  }

  Map<int, PlayerModel>? getPeaceful(){
    Map<int, PlayerModel> result = {};
    playersList.asMap().forEach((key, value) {
      if(value.role == PlayerRole.peaceful){
        result[key] = value;
      }
    });
    return result.isEmpty ? null : result;
  }

  void receiveGameData(Map<String, dynamic> data){
    if(needToReceiveGameData){
      needToReceiveGameData = false;
      Map<String, dynamic> gameData = data['game_data'];
      if(gameData['isEmpty']){
        playersList.add(PlayerModel(user: authController.user.value));
      }
      else{
        playersList.value = List.from(gameData['players']).map((e) => PlayerModel.fromJson(e)).toList();
        if(playersList.where((p0) => p0.user.id == authController.user.value.id).isEmpty){
          playersList.add(PlayerModel(user: authController.user.value));
        }
        gameStage.value = GameStage.values[gameData['stage']];
        currentDayPeriod.value = DayPeriod.values[gameData['day_period']];
        gameCycleCount.value = gameData['gameCycleCount'];
        haveHost.value = gameData['haveHost'];
        hostId = gameData['hostId'] == 'none' ? null : gameData['hostId'];
        gameSettings = gameData['gameSettings'] == 'none' ? null : gameData['gameSettings'];
      }
      readyToDisplayGame.value = true;
    }
  }


  void sendGameData(Map<String, dynamic> requestData){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['players'] = playersList.map((element) => element.toJson()).toList();
    data['stage'] = gameStage.value.index;
    data['day_period'] = currentDayPeriod.value.index;
    data['gameCycleCount'] = gameCycleCount.value;
    data['haveHost'] = haveHost.value;
    data['hostId'] = hostId ?? 'none';
    data['isEmpty'] = false;
    data['gameSettings'] = gameSettings?.toJson() ?? 'none';

    SocketService().socket.emit('game-data-response', {'peerID': requestData['peerID'], 'game_data': data});

    UserModel user = UserModel.fromJson(requestData['user']);
    
    if(playersList.where((p0) => p0.user.id == user.id).isEmpty){
      playersList.add(PlayerModel(user: user));
    }

  }

  void deletePlayer(int userId){
    playersList.value = playersList.where((element) => element.user.id != userId).toList();
  }

  @override
  void onClose() {
    SocketService().socket.off('ask-for-game-data');
    SocketService().socket.off('receive-game-data');
    super.onClose();
  }
  
  
  
}