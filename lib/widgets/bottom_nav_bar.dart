import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/webrtc_controller.dart';


class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final WebRTCController webrtcController = Get.find();

 
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 80,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, 80),
            painter: BottomCustomPainter(),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
              backgroundColor: Colors.red, 
              child: const Icon(Icons.phone), 
              elevation: 0.1, 
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(
            width: size.width,
            height: 80,
            child: Obx((){
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Material(
                    borderRadius: BorderRadius.circular(40),
                    color: webrtcController.webrtcClients[webrtcController.localClient]!.isMutedAudio.value 
                      ? const Color.fromARGB(255, 231, 231, 231)
                      : Colors.transparent,
                    child: InkWell( 
                        borderRadius: BorderRadius.circular(40),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            webrtcController.webrtcClients[webrtcController.localClient]!.isMutedAudio.value
                            ? Icons.mic_off_rounded
                            : Icons.mic_rounded,
                            color:Colors.grey,
                            size: 25,
                          ),
                        ),
                        onTap: () {
                          webrtcController.toggleMuteAudio();
                        }),
                  ),
                  Container(
                    width: 150,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(40),
                    color: webrtcController.webrtcClients[webrtcController.localClient]!.isMutedVideo.value 
                      ? const Color.fromARGB(255, 231, 231, 231)
                      : Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            webrtcController.webrtcClients[webrtcController.localClient]!.isMutedVideo.value
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                            color:Colors.grey,
                            size: 25,
                          ),
                        ),
                        onTap: () {
                          webrtcController.toggleMuteVideo();
                        }),
                  ),
                ],
              );
              }
            ),
          )
        ],
      ),
    );
  }
}

class BottomCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.50, -10, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}