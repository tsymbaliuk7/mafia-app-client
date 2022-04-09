import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/models/user_model.dart';

class WebRTCUser{
  final String peerId;
  UserModel? user;
  RTCVideoRenderer? videoRenderer;
  RTCPeerConnection? connection;
  var isMutedVideo = false.obs;
  var isMutedAudio = false.obs;
  var isReadyToDisplay = false.obs;
  

  WebRTCUser({
    required this.peerId,
    this.user,
    this.videoRenderer, 
    this.connection, 
  });


}