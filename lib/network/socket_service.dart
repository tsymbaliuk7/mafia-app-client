import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService{

  static SocketService? _instance;
 
  factory SocketService() => _instance ?? SocketService._internal();
  
  late IO.Socket _socket;
  final String baseUrl = 'https://mafia-client.herokuapp.com';

  

  SocketService._internal(){
    _socket = IO.io(baseUrl, getSocketOptions());
    _socket.on('connect', (_) => print('Connected'));
    _socket.on('reconnect_attempt', (_) => print('Reconnecting'));
    _socket.on('connecting', (_) => print('Connecting'));
    _socket.on('disconnect', (_) => print('Disconnected'));
    _socket.on('connect_error', (_) => print(_));
    _socket.on('error', (_) => print(_));
    
    
    
    _instance = this;
  }

  IO.Socket get socket => _socket;


  Map<String, dynamic> getSocketOptions(){
    return kIsWeb ? IO.OptionBuilder()
      .enableForceNew()
      .setReconnectionAttempts(double.infinity)
      .setTimeout(10000)
      .build() : IO.OptionBuilder()
      .enableForceNew()
      .setReconnectionAttempts(double.infinity)
      .setTimeout(10000)
      .setTransports(['websocket'])
      .build();
  }
  
}