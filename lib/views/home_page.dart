import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/views/room.dart';
import 'package:uuid/uuid.dart';

import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  
  final RoomsController roomsController = Get.put(RoomsController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
            child: Obx((){
              if(roomsController.roomStatus.value == Status.success){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: (){
                            authController.logout();
                          }, 
                          icon: const Icon(Icons.logout_rounded)
                        ),
                      ],
                    ),
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
            }),
          ) 
        ),
      )
    );
  }
}
