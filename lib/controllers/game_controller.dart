import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/models/player_model.dart';
import 'package:mafiaclient/views/home_page.dart';
import 'package:mafiaclient/widgets/game_setting_modal.dart';
import 'package:mafiaclient/widgets/role_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  var playersRolesSend = false.obs;

  var haveHost = false.obs;
  int? hostId;

  var minPlayerNuber = 2;

  var playersList = <PlayerModel>[].obs;

  var myPlayer = PlayerModel(user: UserModel.empty()).obs;

  GameSettings? gameSettings;

  var speakingOrder = <int, bool>{}.obs;
  var onVote = <int>[].obs;

  var readyToDisplayGame = false.obs;
  bool needToReceiveGameData = true;

  String? room;


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
    if(!SocketService().socket.hasListeners('receive-players-list')){
      SocketService().socket.on('receive-players-list', (data){
        receivePlayersList(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('receive-host-data')){
      SocketService().socket.on('receive-host-data', (data){
        receiveHostData(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('start-game')){
      SocketService().socket.on('start-game', (data){
        getStartGameData(Map<String, dynamic>.from(data));
      });
    }
    
    super.onInit();
  }

  bool isNight(){
    return currentDayPeriod.value == DayPeriod.night;
  }

  bool myPlayerIsReady(){
    return myPlayer.value.user.id != 0;
  }

  String getCurrentStyleName(){
    if(gameStage.value == GameStage.lobby){
      return 'morning';
    }
    if(gameStage.value == GameStage.over){
      return 'evening';
    }
    if(isNight()){
      return 'night';
    }
    else{
      return 'day';
    }
  }

  void setRoomId(String roomId){
    room = roomId;
  }

  void restartGame(){
    gameStage(GameStage.lobby);
    gameCycleCount(0);
    currentDayPeriod(DayPeriod.none);
    playersRolesSend(false);
    haveHost(true);
    gameSettings = null;
    speakingOrder(<int, bool>{});
    onVote([]);

    playersList(playersList
      .map((element) => element.role != PlayerRole.host ? element.copyWith(role: PlayerRole.undefined) : element)
      .toList());
    
    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room
    };
    SocketService().socket.emit('send-start-game', data);
  }

  void changePeriod() async {
    if(currentDayPeriod.value == DayPeriod.night){
      currentDayPeriod(DayPeriod.day);
      gameCycleCount(gameCycleCount.value + 1);
      await makeCheckpoint();
    }
    else{
      currentDayPeriod(DayPeriod.night);
      playersList(playersList.map((p0) => p0.copyWith(isOnVote: false)).toList());
    }
    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room
    };
    SocketService().socket.emit('send-start-game', data);
  }


  void becomeAHost(){
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
      myPlayer(getMyPlayer());
    }
  }

  void freeHostPlace(){
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


  Map<int, PlayerModel>? getPlayersNotOnVote(){
    Map<int, PlayerModel> result = {};
    playersList.asMap().forEach((key, value) {
      if(!value.isOnVote && !value.isHost()){
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

  Map<int, PlayerModel>? getPlayerByUserIdWithOrder(int userId){
    Map<int, PlayerModel>? result;
    playersList.asMap().forEach((key, value) {
      if(value.user.id == userId){
        result = {key: value};
      }
    });
    return result;
  }

  Map<int, PlayerModel>? getNextSpeaker(){
    int? userId = speakingOrder
      .keys
      .toList()
      .firstWhereOrNull((element) => speakingOrder[element] == false);
    if(userId == null){
      return null;
    }
    return getPlayerByUserIdWithOrder(userId);
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
          if(GameStage.values[gameData['stage']] == GameStage.lobby){
            playersList.add(PlayerModel(user: authController.user.value));
          }
          else{
            Get.offAll(() => HomePage());
          }
          
        }
        Map<int, bool> order = {};
        Map<String, dynamic>.from(gameData['speakingOrder']).forEach((key, value) {
          order.addAll({int.parse(key): value});
        });

        playersRolesSend.value = gameData['playersRolesSend'];
        gameStage.value = GameStage.values[gameData['stage']];
        currentDayPeriod.value = DayPeriod.values[gameData['day_period']];
        gameCycleCount.value = gameData['gameCycleCount'];
        haveHost.value = gameData['haveHost'];
        speakingOrder(order);
        onVote(List<int>.from(gameData['onVote']));
        hostId = gameData['hostId'] == 'none' ? null : gameData['hostId'];
        gameSettings = gameData['gameSettings'] == 'none'
          ? null 
          : GameSettings.fromJson(gameData['gameSettings']);
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

  
  void shufflePlayers(){
    var host = getHost();
    var newList = List<PlayerModel>.from([host, ...playersList
      .where((element) => element.user.id != host?.user.id)
      .toList()
      ..shuffle()]
    );
    final Map<String, dynamic> data = <String, dynamic>{};
    data['players'] = newList.map((element) => element.toJson()).toList();
    data['withRoleNotification'] = false;
    data['room'] = room;
    SocketService().socket.emit('send-players-list', data);
    playersList(newList);
    myPlayer(getMyPlayer());
  }

  void receivePlayersList(Map<String, dynamic> data){
    playersList(List.from(data['players']).map((e) => PlayerModel.fromJson(e)).toList());
    myPlayer(getMyPlayer()!);
    if(data['withRoleNotification']){
      showRoleNotification();
    }
  }


  void showRoleNotification(){
    switch (myPlayer.value.role){
      case PlayerRole.don:
        Get.defaultDialog(
          title: '',
          backgroundColor: Colors.white,
          barrierDismissible: true,
          radius: 25,
          content: const RoleModal(
            roleTitle: 'don', 
            roleImage: 'icons/hat.svg', 
            roleColor: Color.fromARGB(255, 39, 0, 78),
          )
        );
        break;
      case PlayerRole.peaceful:
        Get.defaultDialog(
          title: '',
          backgroundColor: Colors.white,
          barrierDismissible: true,
          radius: 25,
          content: const RoleModal(
            roleTitle: 'peaceful', 
            roleImage: 'icons/peace.svg', 
            roleColor: Color.fromARGB(255, 220, 29, 15),
          )
        );
        break;
      case PlayerRole.mafia:
        Get.defaultDialog(
          title: '',
          backgroundColor: Colors.white,
          barrierDismissible: true,
          radius: 25,
          content: const RoleModal(
            roleTitle: 'mafia', 
            roleImage: 'icons/tie.svg', 
            roleColor: Colors.black,
          )
        );
        break;
      default:
        break;
    }
  }

  Map<String, dynamic> gameDataToMap(){
    Map<String, dynamic> order = {};
    speakingOrder.forEach((key, value) {
      order.addAll({key.toString(): value});
    });

    final Map<String, dynamic> data = <String, dynamic>{};
    data['playersRolesSend'] = playersRolesSend.value;
    data['players'] = playersList.map((element) => element.toJson()).toList();
    data['stage'] = gameStage.value.index;
    data['day_period'] = currentDayPeriod.value.index;
    data['gameCycleCount'] = gameCycleCount.value;
    data['haveHost'] = haveHost.value;
    data['speakingOrder'] = order;
    data['onVote'] = List<int>.from(onVote);
    data['hostId'] = hostId ?? 'none';
    data['isEmpty'] = false;
    data['gameSettings'] = gameSettings?.toJson() ?? 'none';
    return data;
  }


  void sendGameData(Map<String, dynamic> requestData){
    final Map<String, dynamic> data = gameDataToMap();

    SocketService().socket.emit('game-data-response', 
      {
        'peerID': requestData['peerID'], 
        'game_data': data
      }
    );

    UserModel user = UserModel.fromJson(requestData['user']);
    
    if(playersList.where((p0) => p0.user.id == user.id).isEmpty){
      if(gameStage.value == GameStage.lobby){
        playersList.add(PlayerModel(user: user));
      }
      
    }

  }

  void getStartGameData(Map<String, dynamic> gameData){
    
    gameData = gameData['game_data'];

    Map<int, bool> order = {};
    Map<String, dynamic>.from(gameData['speakingOrder']).forEach((key, value) {
      order.addAll({int.parse(key): value});
    });

    playersList.value = List.from(gameData['players']).map((e) => PlayerModel.fromJson(e)).toList();
    gameStage.value = GameStage.values[gameData['stage']];
    currentDayPeriod.value = DayPeriod.values[gameData['day_period']];
    gameCycleCount.value = gameData['gameCycleCount'];
    haveHost.value = gameData['haveHost'];
    speakingOrder(order);
    onVote(List<int>.from(gameData['onVote']));
    hostId = gameData['hostId'] == 'none' ? null : gameData['hostId'];
    gameSettings = gameData['gameSettings'] == 'none' ? null : GameSettings.fromJson(gameData['gameSettings']);
    playersRolesSend.value = gameData['playersRolesSend'];

    myPlayer.value = getMyPlayer() ?? PlayerModel(user: UserModel.empty());

  }

  void deletePlayer(int userId){
    if(gameStage.value == GameStage.lobby){
      playersList.value = playersList.where((element) => element.user.id != userId).toList();
    }  
  }

  void openGameSettingsModal(){
    Get.defaultDialog(
      title: "Game Settings",
      backgroundColor: Colors.white,
      titleStyle: TextStyle(color: gradientColors[0], fontSize: 18, fontWeight: FontWeight.w600),
      confirmTextColor: Colors.white,
      buttonColor: gradientColors[0],
      barrierDismissible: true,
      radius: 25,
      content: GameSettingsModal(room: room!,)
    );
  }

  void saveSettingAndStartGame(bool withAI, bool killedLastWord, int mafiaCount){
    gameSettings = GameSettings(mafiaCount: mafiaCount, withAI: withAI, lastWordForKilled: killedLastWord);
    gameStage(GameStage.start);
    currentDayPeriod(DayPeriod.night);
    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room
    };
    SocketService().socket.emit('send-start-game', data);

    generateRoles();
  }


  

  void reGenerateRoles(){
    playersList(playersList
      .map((element) => element.role == PlayerRole.host 
        ? element 
        : element.copyWith(role: PlayerRole.undefined))
      .toList()
    );
    generateRoles();
    
  }

  void sendRoles(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['players'] = playersList.map((element) => element.toJson()).toList();
    data['withRoleNotification'] = true;
    data['room'] = room;
    SocketService().socket.emit('send-players-list', data);
    playersRolesSend(true);
  }

  


  Future<void> startFirstDay() async {
    Map<int, bool> newSpeakingOrder = {};
    for (var elem in getPlayersWithoutHost()!.values) {
      newSpeakingOrder.addAll({elem.user.id: false});
    }

    
      
    speakingOrder(newSpeakingOrder);
    gameStage(GameStage.inProgress);
    currentDayPeriod(DayPeriod.day);
    gameCycleCount(gameCycleCount.value + 1);

    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room!
    };

    SocketService().socket.emit('send-start-game', data);

    await makeCheckpoint();
    
  }


  void startSpeach(int userId){
    Map<int, bool> newSpeakingOrder = {};
    speakingOrder.forEach((key, value) {
      if(key == userId){
        newSpeakingOrder.addAll({key: true});
      }
      else{
        newSpeakingOrder.addAll({key: value});
      }
    });
    speakingOrder(newSpeakingOrder);
    playersList(playersList
      .map((element) => element.user.id == userId 
        ? element.copyWith(isSpeakingTurn: true) 
        : element.copyWith(isSpeakingTurn: false))
      .toList()
    );

    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room!
    };

    SocketService().socket.emit('send-start-game', data);

  }


  bool haveSpeakers(){
    return playersList.where((p0) => p0.isSpeakingTurn).toList().isNotEmpty;
  }

  void setOnVote({int? id}){
    if(id != null){
      onVote(List.from(onVote)..add(id));
      playersList(playersList
        .map((element) => element.user.id == id 
          ? element.copyWith(isOnVote: true) 
          : element)
        .toList()
      );
      
    }
    playersList(playersList
      .map((element) => element.copyWith(isSpeakingTurn: false))
      .toList()
    );
    myPlayer(getMyPlayer());
    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room
    };
    SocketService().socket.emit('send-start-game', data);
    
  }


  Future<void> makeCheckpoint() async {
    final Map<String, dynamic> data = {};
    data['game_data'] = gameDataToMap();
    data['room'] = room!;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkpoint', json.encode(data));
  }

  Future<void> loadCheckPoint() async {
    final prefs = await SharedPreferences.getInstance();
    String? srt = prefs.getString('checkpoint');
    if(srt != null){
      Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(srt));
      if(data['room'] == room){
        getStartGameData(data);
      }
    }
  }


  Future<void> returnToCheckpoint() async {
    await loadCheckPoint();
    final Map<String, dynamic> data = {
      'game_data': gameDataToMap(),
      'room': room
    };
    SocketService().socket.emit('send-start-game', data);
  }


  void generateRoles(){
    List<int> randomUserIds = getPlayersWithoutHost()!.values.map((element) => element.user.id).toList()..shuffle();
    
    int donId = randomUserIds.removeLast();
    
    List<int> mafiaIds = [];
    for(int i = 0; i < gameSettings!.mafiaCount - 1; i++){
      mafiaIds.add(randomUserIds.removeLast());
    }


    playersList(playersList
      .map((element){
        if(element.user.id == donId){
          return element.copyWith(role: PlayerRole.don);
        }
        if(mafiaIds.contains(element.user.id)){
          return element.copyWith(role: PlayerRole.mafia);
        }
        return element.role == PlayerRole.undefined ? element.copyWith(role: PlayerRole.peaceful) : element;
      })
      .toList()
    );
  }

  @override
  void onClose() {
    SocketService().socket.off('ask-for-game-data');
    SocketService().socket.off('receive-game-data');
    SocketService().socket.off('receive-host-data');
    SocketService().socket.off('receive-players-list');
    SocketService().socket.off('start-game');
    super.onClose();
  }
  
}