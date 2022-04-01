import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

class WebRTCUser{
  final String peerId;
  RTCVideoRenderer? videoRenderer;
  RTCPeerConnection? connection;
  var isMutedVideo = false.obs;
  var isMutedAudio = false.obs;
  var isReadyToDisplay = false.obs;
  

  WebRTCUser({
    required this.peerId, 
    this.videoRenderer, 
    this.connection, 
  });


}