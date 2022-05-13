import 'package:get/get.dart';
import 'package:mafiaclient/models/player_model.dart';

import '../models/game_settings.dart';
import '../models/user_model.dart';
import '../network/socket_service.dart';
import 'auth_controller.dart';
import 'webrtc_controller.dart';

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

  var myPlayer = PlayerModel(user: UserModel.empty()).obs;

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
    if(!SocketService().socket.hasListeners('receive-host-data')){
      SocketService().socket.on('receive-host-data', (data){
        receiveHostData(Map<String, dynamic>.from(data));
      });
    }
    super.onInit();
  }

  bool myPlayerIsReady(){
    return myPlayer.value.user.id != 0;
  }


  void becomeAHost(String room){
    if(!haveHost.value && myPlayerIsReady()){
      SocketService().socket.emit('update-host-data', {
        'haveHost': true,
        'hostId': myPlayer.value.user.id,
        'room': room,
      });
      haveHost(true);
      hostId = myPlayer.value.user.id;
      myPlayer.value.role = PlayerRole.host;
      var newList = List<PlayerModel>.from([myPlayer.value, ...playersList
        .where((element) => element.user.id != myPlayer.value.user.id)
        .toList()]);
      playersList(newList);
    }
  }

  void freeHostPlace(String room){
    if(haveHost.value && myPlayer.value.isHost()){
      SocketService().socket.emit('update-host-data', {
        'haveHost': false,
        'hostId': null,
        'room': room,
      });
      haveHost(false);
      hostId = null;
      myPlayer.value.role = PlayerRole.undefined;
      var newList = List<PlayerModel>.from([...playersList
        .where((element) => element.user.id != myPlayer.value.user.id)
        .toList(), myPlayer.value]);
      playersList(newList);
    }
  }

  PlayerModel? getPlayerByUserId(int userId){
    return playersList.firstWhereOrNull((p0) => p0.user.id == userId);
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
      myPlayer.value = getMyPlayer() ?? PlayerModel(user: UserModel.empty());
      readyToDisplayGame.value = true;
    }
  }


  void deleteHostData(){
    haveHost(false);
    hostId = null;
  }


  void receiveHostData(Map<String, dynamic> data){
    if(data['haveHost']){
      haveHost(data['haveHost']);
      hostId = data['hostId'];
      var newHost = getPlayerByUserId(data['hostId']);
      if(newHost != null){
        newHost.role = PlayerRole.host;
        var newList = List<PlayerModel>.from([newHost, ...playersList
          .where((element) => element.user.id != newHost.user.id)
          .toList()]);
        playersList(newList);
      }
      else{
        haveHost(false);
        hostId = null;
      }
      
    }
    else{
      haveHost(data['haveHost']);
      hostId = null;
      var formerHost = getHost();
      if(formerHost != null){
        formerHost.role = PlayerRole.undefined;
        var newList = List<PlayerModel>.from([...playersList
          .where((element) => element.user.id != formerHost.user.id)
          .toList(), formerHost]);
        playersList(newList);
      }
      
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
    SocketService().socket.off('receive-host-data');
    super.onClose();
  }
  
  
  
}