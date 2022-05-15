import 'package:flutter/material.dart';

List<String> STUN =[
  "stun:stun.l.google.com:19302",
  "stun:stun1.l.google.com:19302",
  "stun:stun2.l.google.com:19302",
  "stun:stun:stun:stun3.l.google.com:19302",
  "stun:stun4.l.google.com:19302",
  "stun:stun.ekiga.net",
  "stun:stun:stun:stun.ideasip.com",
  "stun:stun.rixtelecom.se",
  "stun:stun.schlund.de",
  "stun:stun.stunprotocol.org:3478",
  "stun:stun:stun.voiparound.com",
  "stun:stun.voipbuster.com",
  "stun:stun.voipstunt.com",
  "stun:stun.voxgratia.org"
];


Map<String, dynamic> configuration = {
  'iceServers': [
    {
      'urls': ["stun:stun1.l.google.com:19302", 'stun:stun.l.google.com:19302']
    },
    {
      'url': 'turn:turn.anyfirewall.com:443?transport=tcp',
      'credential': 'webrtc',
      'username': 'webrtc'
    }
    
  ]
};
