import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/controllers/webrtc_controller.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/video_view.dart';



class RoomPage extends StatefulWidget{

  RoomPage({Key? key, required this.id}) : super(key: key);

  final String id;
  final WebRTCController webrtcController = Get.put(WebRTCController());

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  @override
  void initState() {
    widget.webrtcController.startCapturing(widget.id);
    super.initState();
  }


  @override
  void dispose() {
    widget.webrtcController.leaveRoom();
    // Get.delete<WebRTCController>();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        int count = min(max((constraints.maxWidth / 300.0).round(), 2), 4);
                        return Obx(() {
                            if(widget.webrtcController.status.value == Status.success){
                              var itemList = widget
                                  .webrtcController
                                  .webrtcClients
                                  .keys
                                  .where((element) => widget
                                    .webrtcController
                                    .webrtcClients[element]
                                    !.isReadyToDisplay.value 
                                    && 
                                    widget
                                    .webrtcController
                                    .webrtcClients[element]
                                    ?.user != null)
                                  .toList();
                              return GridView.builder(
                                itemCount: itemList.length,
                                gridDelegate: 
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: count,
                                    mainAxisSpacing: 25,
                                    crossAxisSpacing: 25,
                                    childAspectRatio: 1.2
                                  ),
                                itemBuilder: (context, index){
                                  return VideoView(peer: itemList[index],);
                                }
                              );
                            }
                            else if(widget.webrtcController.status.value == Status.failure){
                              return const Center(child: Text('Ooops\nCammera access denied', textAlign: TextAlign.center,),);
                            }
                            else{
                              return const Center(child: CircularProgressIndicator(),);
                            }
                          }
                        );
                      },) 
                    )
                  ],
                ),
              ),
              Obx(() {
                if(widget.webrtcController.status.value == Status.success){
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    child: BottomNavBar(),
                  );
                }
                else{
                  return Container();
                }
              })

            ]
          ),
        ),
      )

    );
  }
}