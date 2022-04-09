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
        return Stack(
          children: [
            Container(
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
                        webrtcController.webrtcClients[peer]!.user?.username[0].toUpperCase() ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 40),
                      ),
                    ],
                  ),
                ),
              )
            ),
            Positioned(
              left: 5,
              bottom: 20,
              child: Container(
                
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                padding: const EdgeInsets.all(5),
                child: Text(webrtcController.webrtcClients[peer]!.user?.username.toUpperCase() ?? '', style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ),),
              ),
            ),
            webrtcController.webrtcClients[peer]!.isMutedAudio.value ? Positioned(
              right: 5,
              bottom: 20,
              child: Container(
                
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.mic_off_outlined,
                  size: 20,
                  color: Colors.white.withOpacity(0.6),
                ),
              )
            )
            : const SizedBox(),
            
            
          ],
        );
      }
    );
  }
}