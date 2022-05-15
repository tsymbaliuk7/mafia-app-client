import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/views/room.dart';
import 'package:uuid/uuid.dart';

import '../network/socket_service.dart';
import 'auth_controller.dart';

enum Status {
  initial,
  loading,
  success,
  failure,
}


class RoomsController extends GetxController{

  String errorMessage = '';
  var roomStatus = Status.initial.obs;
  var joinStatus = Status.initial.obs;
  final AuthController authController = Get.find();


  @override
  void onInit() {
    ever(joinStatus, onStatusChange);

    try{
      roomStatus.value = Status.loading;
      if(!SocketService().socket.hasListeners('have-another-room')){
        SocketService().socket.on('have-another-room', (data){
          _handleHaveAnotherRoom(Map<String, dynamic>.from(data));
        });
      }
      if(!SocketService().socket.hasListeners('check-joining-room-failure')){
        SocketService().socket.on('check-joining-room-failure', (data){
          _handleCheckJoiningRoomFailure(Map<String, dynamic>.from(data));
        });
      }
      if(!SocketService().socket.hasListeners('check-joining-room-success')){
        SocketService().socket.on('check-joining-room-success', (data){
          _handleCheckJoiningRoomSuccess(Map<String, dynamic>.from(data));
        });
      }
      
      roomStatus.value = Status.success;
    }
    catch(_){
      errorMessage = 'Failed to connect to the server';
      roomStatus.value = Status.failure;
    }
   
    
    super.onInit();
  }
  
  void onStatusChange(Status status){
    if(status == Status.failure){
      Get.defaultDialog(
        title: "Error",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: gradientColors[0], fontSize: 18, fontWeight: FontWeight.w600),
        middleTextStyle: const TextStyle(color: Colors.black),
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        buttonColor: gradientColors[0],
        barrierDismissible: true,
        onConfirm: (){
          Get.back();
          errorMessage = '';
          joinStatus.value = Status.success;
        },
        radius: 50,
        content: Text(errorMessage)
      );
    }
  }

  void _handleHaveAnotherRoom(Map<String, dynamic> data){
    Get.defaultDialog(
        title: "Already in room!",
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: gradientColors[0], fontSize: 18, fontWeight: FontWeight.w600),
        middleTextStyle: const TextStyle(color: Colors.black),
        textConfirm: "Rejoin",
        textCancel: "Continue",
        confirmTextColor: Colors.white,
        buttonColor: gradientColors[0],
        barrierDismissible: true,
        cancelTextColor: gradientColors[0],
        onConfirm: (){
          SocketService().socket.emit('force-leave-request', {
            'room': data['current_room'],
            'user_id': authController.user.value.id,
            'current_peer': data['current_peer']
          });
          Get.offAll(() => RoomPage(id: data['current_room']));
        },
        onCancel: (){
          SocketService().socket.emit('force-leave-request', {
            'room': data['current_room'],
            'user_id': authController.user.value.id,
            'current_peer': data['current_peer']
          });
          Get.offAll(() => RoomPage(id: data['is_creating'] ? const Uuid().v4().split('-')[0] : data['room']));
        },
        radius: 50,
        content: Text('It seems that ${authController.user.value.username} is already in room.\nWould you like to reconnect to that room or continue with the new one?')
      );
  }

  void _handleCheckJoiningRoomFailure(Map<String, dynamic> data){
    errorMessage = data['error_message'];
    joinStatus.value = Status.failure;
  }

  void _handleCheckJoiningRoomSuccess(Map<String, dynamic> data){
    if(data['is_creating']){
      Get.offAll(() => RoomPage(id: const Uuid().v4().split('-')[0]));
    }
    else{
      Get.offAll(() => RoomPage(id: data['room']));
    }
  }


  


  void checkJoiningRoom({String room = '', bool isCreating = false}){
    SocketService().socket.emit('check-joining-room', {
      'room': room,
      'is_creating': isCreating,
      'user_id': authController.user.value.id,
    });
  }

  @override
  void onClose() {
    SocketService().socket.off('have-another-room');
    SocketService().socket.off('check-joining-room-failure');
    SocketService().socket.off('check-joining-room-success');
    super.onClose();
  }

}