import 'package:get/get.dart';

import '../models/room_model.dart';
import '../network/socket_service.dart';

enum Status {
  initial,
  loading,
  success,
  failure,
}


class RoomsController extends GetxController{

  var roomList = <RoomModel>[].obs;
  var roomStatus = Status.initial.obs;


  @override
  void onInit() {
    try{
      roomStatus.value = Status.loading;
      if(!SocketService().socket.hasListeners('share-rooms')){
        SocketService().socket.on('share-rooms', (data){
          roomList.value = List.from(data['rooms']).map((e) => RoomModel(id: e)).toList();
        });
      }
      roomStatus.value = Status.success;
    }
    catch(_){
      print(_);
      roomList.value = [];
      roomStatus.value = Status.failure;
    }
   
    
    super.onInit();
  }

}