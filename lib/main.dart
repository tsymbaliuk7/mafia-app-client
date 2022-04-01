import 'package:flutter/material.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/views/room.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final RoomsController roomsController = Get.put(RoomsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
                child:Obx((){
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
