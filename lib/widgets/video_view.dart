import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../controllers/webrtc_controller.dart';

class VideoView extends StatelessWidget {
  final String peer;
  final WebRTCController webrtcController = Get.find();


  VideoView({Key? key, required this.peer}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(25)
          ),
          child: !webrtcController.webrtcClients[peer]!.isMutedVideo.value 
          ? RTCVideoView(
              webrtcController.webrtcClients[peer]!.videoRenderer!,
              mirror: peer == webrtcController.localClient,
          )
          : Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 243, 214, 128),
                  width: 1
                ),
                color: const Color.fromARGB(255, 255, 239, 193)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    peer[0].toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 40),
                  ),
                ],
              ),
            ),
          )
        );
      }
    );
  }
}