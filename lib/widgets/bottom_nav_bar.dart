import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/globals.dart';
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
    return Stack(
      children: [
        Obx(() {
            int playerCount = game.getPlayersWithoutHost()?.length ?? 0;
            return game.myPlayer.value.isHost() && game.gameStage.value == GameStage.lobby
            ? SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 230,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.elliptical(230, 150)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: game
                                              .getPlayersWithoutHost()
                                              ?.keys
                                              .length
                                              .toString() ?? '0',
                                            style: TextStyle(
                                              color: playerCount < game.minPlayerNuber 
                                              ? Colors.red 
                                              : Colors.green,
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                          TextSpan(
                                            text: ' / ${game.minPlayerNuber}'
                                          ),
                                        ]
                                      )
                                    ),
                                  ],
                                )
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: playerCount < game.minPlayerNuber 
                                        ? const Color.fromARGB(255, 191, 191, 191) 
                                        :const Color.fromARGB(255, 218, 0, 242),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: playerCount < game.minPlayerNuber 
                                        ? const Color.fromARGB(255, 117, 117, 117)
                                        : Colors.white,
                                      )
                                    ),
                                  ),
                                  playerCount < game.minPlayerNuber ? const SizedBox()
                                  : Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(40),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      onTap: (){
                                        game.openGameSettingsModal(webrtcController.room);
                                      },
                                      child: const SizedBox(
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox()
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ) : SizedBox(height: 80, width: size.width,);
          }
        ),
        Obx(() {
            print(game.gameStage.value);
            return game.myPlayer.value.isHost() && game.gameStage.value == GameStage.start
            ? SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 230,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.elliptical(230, 150)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),
                              Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:const Color.fromARGB(255, 218, 0, 242),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.handshake_rounded,
                                        color: Colors.white,
                                      )
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(40),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      onTap: (){
                                        game.sendRoles(webrtcController.room);
                                      },
                                      child: const SizedBox(
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Expanded(
                                flex: 1,
                                child: SizedBox()
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ) : SizedBox(height: 80, width: size.width,);
          }
        ),
        Positioned(
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  ],
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
        
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
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
                                          : Container()
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
                                      : Container(),
                                  ],
                                ),
                              ),
        
                              
                              
                              
                            ],
                          ),
                        );
                        }
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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