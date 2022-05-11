import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/models/player_model.dart';

import '../controllers/webrtc_controller.dart';

class VideoView extends StatelessWidget {
  final int playerOrder;
  final PlayerModel playerModel;
  final WebRTCController webrtcController = Get.find();


  VideoView({Key? key, required this.playerModel, required this.playerOrder}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
        
      var webrtcUser = webrtcController.getWebRTCUser(playerModel.user.id);

      return webrtcUser != null ? Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: playerModel.isHost() ?const Color.fromARGB(255, 244, 212, 30).withOpacity(0.25) :Colors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(25)
            ),
            child: webrtcUser.isMutedVideo.value || webrtcUser.videoRenderer == null
            ?  Center(
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
                        '$playerOrder${playerModel.user.username[0].toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 40),
                      ),
                    ],
                  ),
                ),
              )
            : RTCVideoView(
                webrtcUser.videoRenderer!,
                mirror: webrtcUser.peerId == webrtcController.localClient,
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
              child: Text('${playerModel.isHost() ? '' : '$playerOrder.'}${playerModel.user.username}', style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500
              ),),
            ),
          ),
          
          webrtcUser.isMutedAudio.value ? Positioned(
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
      ) : const SizedBox();
    });
  }
}