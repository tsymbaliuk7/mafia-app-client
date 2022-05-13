import 'dart:typed_data';

import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/models/user_model.dart';
import 'package:mafiaclient/models/webrtc_user.dart';
import 'package:mafiaclient/views/home_page.dart';

import '../globals.dart';
import '../network/socket_service.dart';
import 'auth_controller.dart';

class WebRTCController extends GetxController{

  late String room;
  late String localClient;
  var status = Status.initial.obs;
  late RxMap<String, WebRTCUser> webrtcClients;

  final GameController game = Get.find();
  final AuthController authController = Get.find();

  bool isForceQuit = false;
  
  @override
  void onInit() {
    webrtcClients = <String, WebRTCUser>{}.obs;
    status.value = Status.loading;
    isForceQuit = false;
    if(!SocketService().socket.hasListeners('add-peer')){
      SocketService().socket.on('add-peer', (data){
        addPeer(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('session-description')){
      SocketService().socket.on('session-description', (data){
        _sessionDescription(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('ice-candidate')){
      SocketService().socket.on('ice-candidate', (data){
        _iceCandidate(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('remove-peer')){
      SocketService().socket.on('remove-peer', (data){
        removePeer(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('toggle-audio')){
      SocketService().socket.on('toggle-audio', (data){
        toggleMuteAudioByPeer(Map<String, dynamic>.from(data)['peerID']);
      });
    }
    if(!SocketService().socket.hasListeners('toggle-video')){
      SocketService().socket.on('toggle-video', (data){
        toggleMuteVideoByPeer(Map<String, dynamic>.from(data)['peerID']);
      });
    }
    if(!SocketService().socket.hasListeners('receive-tracks-state')){
      SocketService().socket.on('receive-tracks-state', (data){
        _setMediaValues(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('receive-peer-user-data')){
      SocketService().socket.on('receive-peer-user-data', (data){
        _setUserByPeer(Map<String, dynamic>.from(data));
      });
    }
    if(!SocketService().socket.hasListeners('force-leave-room')){
      SocketService().socket.on('force-leave-room', (data){
        _forceLeaveRoom(Map<String, dynamic>.from(data));
      });
    }
    localClient = SocketService().socket.id!;    

    super.onInit();
  }

  

  void _forceLeaveRoom(Map<String, dynamic> data){
    String targetPeer = data['current_peer'];
    if(localClient == targetPeer){
      SocketService().socket.emit('leave-socket-room', {
          'room': room,
        }
      );
      isForceQuit = true;
      Get.offAll(() => HomePage());
    }
    else{
      if(webrtcClients.containsKey(targetPeer)){
        if (webrtcClients[targetPeer] != null){ 
          webrtcClients[targetPeer]?.connection!.close();
          webrtcClients[targetPeer]?.connection = null;

          webrtcClients[targetPeer]?.videoRenderer!.srcObject!.getTracks().forEach((track) => track.stop());
          webrtcClients[targetPeer]?.videoRenderer!.srcObject!.dispose(); 
          webrtcClients[targetPeer]?.videoRenderer!.dispose();
          webrtcClients[targetPeer]?.videoRenderer = null;


          webrtcClients[targetPeer]?.isReadyToDisplay.value = false;

          
          webrtcClients.remove(targetPeer);
          
          
        
        }
      }
    }
    
  }


  void _setUserByPeer(Map<String, dynamic> data) async {
    webrtcClients[data['peerID']]!.user = UserModel.fromJson(data['user']);
    update();
  }

  void _setMediaValues(Map<String, dynamic> data){
    webrtcClients[data['peer']]!.isMutedAudio.value = data['audio'];
    webrtcClients[data['peer']]!.isMutedVideo.value = data['video'];
    update();
  }

  Future<Uint8List> _getFrameByteData() async{
    var track = webrtcClients[localClient]!.videoRenderer!.srcObject!.getVideoTracks()[0];
    var byteBuffer = await track.captureFrame();
    return byteBuffer.asUint8List();
  }


  void startCapturing(String id) async {
    
    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': true,
    };

    try{
      room = id;
      webrtcClients[localClient] = WebRTCUser(peerId: localClient);
      webrtcClients[localClient]!.videoRenderer = webrtc.RTCVideoRenderer();
      webrtcClients[localClient]!.videoRenderer!.initialize();
      webrtcClients[localClient]!.videoRenderer!.srcObject = await webrtc.navigator.mediaDevices.getUserMedia(constraints);
      webrtcClients[localClient]!.user = authController.user.value;

      webrtcClients[localClient]!.isMutedAudio.value = authController.user.value.isMutedAudio;
      webrtcClients[localClient]!.videoRenderer!.srcObject!.getAudioTracks()[0].enabled = !authController.user.value.isMutedAudio;

      webrtcClients[localClient]!.isMutedVideo.value = authController.user.value.isMutedVideo;
      webrtcClients[localClient]!.videoRenderer!.srcObject!.getVideoTracks()[0].enabled = !authController.user.value.isMutedVideo;


      webrtcClients[localClient]!.isReadyToDisplay.value = true;

      status.value = Status.success;

      SocketService().socket.emit('join', {
        'room': room,
        'user': authController.user.toJson(),
        }
      );

    }
    catch(_){
      status.value = Status.failure;
    }
  
    
  }

  WebRTCUser? getWebRTCUser(int userId){
    try {
      return webrtcClients.values.firstWhere((element) => element.user?.id == userId);
    }
    on StateError catch(_){
      return null;
    }
  }

  void toggleMuteAudio(){
    webrtcClients[localClient]!.isMutedAudio.value = !webrtcClients[localClient]!.isMutedAudio.value;
    webrtcClients[localClient]!.videoRenderer!.srcObject!.getAudioTracks()[0].enabled = !webrtcClients[localClient]!.isMutedAudio.value;
    
    update();
    SocketService().socket.emit('mute-audio', {'roomID': room});
  }

  void toggleMuteVideo(){
    webrtcClients[localClient]!.isMutedVideo.value = !webrtcClients[localClient]!.isMutedVideo.value;
    webrtcClients[localClient]!.videoRenderer!.srcObject!.getVideoTracks()[0].enabled = !webrtcClients[localClient]!.isMutedVideo.value;
    
    update();
    SocketService().socket.emit('mute-video', {'roomID': room});
  }

  void toggleMuteAudioByPeer(String peer){
    webrtcClients[peer]!.isMutedAudio.value = !webrtcClients[peer]!.isMutedAudio.value;
    update();
  }

  void toggleMuteVideoByPeer(String peer){
    webrtcClients[peer]!.isMutedVideo.value = !webrtcClients[peer]!.isMutedVideo.value;
    update();
  }


  void registerPeerConnectionListeners(String name) {
    // webrtcClients[name]?.connection?.onIceGatheringState = (RTCIceGatheringState state) {
    //   print('ICE gathering state changed: $state');
    // };

    // webrtcClients[name]?.connection?.onConnectionState = (RTCPeerConnectionState state) {
    //   print('Connection state change: $state');
    // };

    // webrtcClients[name]?.connection?.onSignalingState = (RTCSignalingState state) {
    //   print('Signaling state change: $state');
    // };

    // webrtcClients[name]?.connection?.onIceGatheringState = (RTCIceGatheringState state) {
    //   print('ICE connection state change: $state');
    // };

    webrtcClients[name]?.connection?.onAddStream = (MediaStream stream) {
      
      webrtcClients[name]!.videoRenderer = webrtc.RTCVideoRenderer();
      webrtcClients[name]!.videoRenderer!.initialize();
      webrtcClients[name]!.videoRenderer!.srcObject = stream;

      webrtcClients[name]!.isReadyToDisplay.value = true;
      
      webrtcClients.refresh();


    };
  }
  




  Future<void> addPeer(Map<String, dynamic> data) async {
   
    if(!webrtcClients.containsKey(data['peerID'])){
      bool createOffer = data['createOffer'];
      String peerId = data['peerID'];

      webrtcClients[peerId] = WebRTCUser(peerId: peerId);

      SocketService().socket.emit('send-user-id', {
        'peer': peerId,
        'user_id': authController.user.value.id
      });
      
      webrtcClients[peerId]!.connection = await createPeerConnection(configuration);

      registerPeerConnectionListeners(peerId);
      
      webrtcClients[localClient]!.videoRenderer!.srcObject!.getTracks().forEach((track) {
        webrtcClients[peerId]!.connection!.addTrack(track, webrtcClients[localClient]!.videoRenderer!.srcObject!);
      });

      SocketService().socket.emit('send-tracks-state', {
        'peer': peerId,
        'video': webrtcClients[localClient]!.isMutedVideo.value,
        'audio': webrtcClients[localClient]!.isMutedAudio.value,
      });

      
      
      webrtcClients[peerId]!.connection?.onIceCandidate = (candidate) {
        SocketService().socket.emit('relay-ice',
          {
            'peerID': peerId,
            'iceCandidate': candidate.toMap(),
          });
      };


      webrtcClients[peerId]!.connection!.onTrack = (RTCTrackEvent trackEvent) {
          trackEvent.streams[0].getTracks().forEach((track) {
            webrtcClients[peerId]!.videoRenderer!.srcObject!.addTrack(track);
          });
        };

     
        if (createOffer) {
          RTCSessionDescription offer = await webrtcClients[peerId]!.connection!.createOffer();
          await webrtcClients[peerId]!.connection!.setLocalDescription(offer);
          SocketService().socket.emit('relay-sdp', {
            'peerID' : peerId,
            'sessionDescription': offer.toMap(),
          });
      } 

    }
  }


  void _iceCandidate(Map<String, dynamic> data) async {
    String peerId = data['peerID'];
    Map<String, dynamic> iceCandidates = data['iceCandidate'];
    webrtcClients[peerId]!.connection!.addCandidate(RTCIceCandidate(
      iceCandidates['candidate'], 
      iceCandidates['sdpMid'], 
      iceCandidates['sdpMLineIndex'])
    );
  }

  void _sessionDescription(Map<String, dynamic> data) async {
    Map<dynamic, dynamic> sessionDescription = data['sessionDescription'];
    String peerId = data['peerID'];
    

    await webrtcClients[peerId]!.connection!.setRemoteDescription(RTCSessionDescription(sessionDescription['sdp'], sessionDescription['type']),);
    
    if (sessionDescription['type'] == 'offer') {
      var answer = await webrtcClients[peerId]!.connection!.createAnswer();

      await webrtcClients[peerId]!.connection!.setLocalDescription(answer);

      SocketService().socket.emit('relay-sdp', {
          'peerID' : peerId,
          'sessionDescription': answer.toMap(),
        });
    }

  }


  void removePeer(Map<String, dynamic> data) {
    String peer = data['peerId'];
    if(webrtcClients.containsKey(peer)){
      if (webrtcClients[peer] != null){ 
        webrtcClients[peer]?.connection!.close();
        webrtcClients[peer]?.connection = null;

        webrtcClients[peer]?.videoRenderer!.srcObject!.getTracks().forEach((track) => track.stop());
        webrtcClients[peer]?.videoRenderer!.srcObject!.dispose(); 
        webrtcClients[peer]?.videoRenderer!.dispose();
        webrtcClients[peer]?.videoRenderer = null;


        webrtcClients[peer]?.isReadyToDisplay.value = false;

        if(webrtcClients[peer]!.user!.id == game.getHost()?.user.id){
          game.deleteHostData();
        }

        game.deletePlayer(webrtcClients[peer]!.user!.id);

        webrtcClients.remove(peer);
        
        
      
      }
    }
  }

  void leaveRoom(){
    for (String peer in webrtcClients.keys) {

      webrtcClients[peer]?.connection?.close();
      webrtcClients[peer]?.connection = null;
      
      webrtcClients[peer]!.videoRenderer!.srcObject!.getTracks().forEach((track){track.stop();});
      webrtcClients[peer]!.videoRenderer!.srcObject!.dispose(); 
      webrtcClients[peer]!.videoRenderer!.dispose();
      webrtcClients[peer]!.videoRenderer = null;
    
    }

    webrtcClients.value = {};

    if(!isForceQuit){
      SocketService().socket.emit('leave', {'roomID': room, 'user_id': authController.user.value.id});
    }
  }

  @override
  void onClose() {
    SocketService().socket.off('add-peer');
    SocketService().socket.off('session-description');
    SocketService().socket.off('ice-candidate');
    SocketService().socket.off('remove-peer');
    SocketService().socket.off('toggle-audio');
    SocketService().socket.off('toggle-video');
    SocketService().socket.off('receive-tracks-state');
    SocketService().socket.off('receive-peer-user-data');
    SocketService().socket.off('force-leave-room');
    super.onClose();
  }
    




}