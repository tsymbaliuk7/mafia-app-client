import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/views/room.dart';
import 'package:uuid/uuid.dart';

import '../controllers/rooms_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  
  final RoomsController roomsController = Get.put(RoomsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx((){
            if(roomsController.roomStatus.value == Status.success){
              return Column(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomPage(id: const Uuid().v4())));
                    }, 
                    icon: const Icon(Icons.add)
                  ),
                  ...roomsController.roomList.map((e) => InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomPage(id: e.id)));
                        },
                        child: Text(e.id)
                      )
                    ),
                ],
              );
            }
            else if(roomsController.roomStatus.value == Status.failure){
              return const Center(child: Text('Ooops\nFailed to load rooms',
              textAlign: TextAlign.center,),);
            }
            else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }) 
        ),
      )
    );
  }
}
