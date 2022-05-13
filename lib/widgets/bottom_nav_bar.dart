import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/views/home_page.dart';

import '../controllers/webrtc_controller.dart';


class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, required this.openDrawer}) : super(key: key);

  final void Function()? openDrawer;

  final WebRTCController webrtcController = Get.find();
  final GameController game = Get.find();

 
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
          
          SizedBox(
            width: size.width,
            height: 80,
            child: Obx((){
              print(game.haveHost.value);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.transparent,
                      child: InkWell( 
                        borderRadius: BorderRadius.circular(40),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.list,
                            color:Colors.grey,
                            size: 25,
                          ),
                        ),
                        onTap: openDrawer
                      ),
                    ),
                    
                    Row(
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
                            }
                          ),
                        ),

                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10),
                           child: Material(
                            borderRadius: BorderRadius.circular(40),
                            color:Colors.transparent,
                            child: InkWell( 
                              borderRadius: BorderRadius.circular(40),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.phone,
                                  color:Colors.red,
                                  size: 25,
                                ),
                              ),
                              onTap: () {
                                webrtcController.isForceQuit = false;
                                Get.offAll(() => HomePage());
                              },
                            )
                          ),
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
                            }
                          ),
                        ),
                      ],
                    ),

                    game.gameStage.value == GameStage.lobby 
                    ? game.haveHost.value 
                      ? game.myPlayer.value.isHost() 
                        ? Material(
                            borderRadius: BorderRadius.circular(40),
                            color: const Color.fromARGB(255, 231, 231, 231),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(40),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'icons/crown.svg', 
                                  color: Colors.grey,
                                  width: 25,
                                ),
                              ),
                              onTap: () {
                                game.freeHostPlace(webrtcController.room);
                              }
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 25,
                          )
                      : Material(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'icons/crown.svg', 
                                color: const Color.fromARGB(255, 240, 216, 5),
                                width: 25,
                              ),
                            ),
                            onTap: () {
                              game.becomeAHost(webrtcController.room);
                            }
                          ),
                        )
                    : Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 25,
                          ),
                    
                    
                  ],
                ),
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
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}