import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/models/player_model.dart';
import 'package:mafiaclient/widgets/player_list_item.dart';

class GameDrawer extends StatelessWidget {
  GameDrawer({Key? key}) : super(key: key);

  final GameController game = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Obx(() {
          PlayerModel? host = game.getHost();
          PlayerModel? myPlayer = game.getMyPlayer();
          Map<int, PlayerModel>? don, players, peaceful, mafia;

          if(myPlayer != null){
            if(myPlayer.isHost() || myPlayer.isMafia()){
              don = game.getDon();
              peaceful= game.getDon();
              mafia= game.getMafia();
            }
            if(myPlayer.isPeaceful()){
              players = game.getPlayersWithoutHost();
            }
          }

          

          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                    game.haveHost.value
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  'Host', 
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 240, 216, 5),
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'icons/crown.svg', 
                                    color: const Color.fromARGB(255, 240, 216, 5),
                                    width: 10,
                                  ),
                                )

                              ],
                            ),
                          ),
                          Text(host!.user.username)
                        ],
                      ),
                    )
                    : const SizedBox(),

                    (myPlayer!.isHost() || myPlayer.isMafia()) && don != null
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  'Don', 
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 39, 0, 78),
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'icons/hat.svg', 
                                    color: const Color.fromARGB(255, 39, 0, 78),
                                    width: 10,
                                  ),
                                )

                              ],
                            ),
                          ),
                          ...don.keys.map((e) => PlayerListItem(
                            order: game.haveHost.value ? e : e + 1,
                            player: don![e]!,
                          )).toList()
                          
                        ],
                      ),
                    )
                    : const SizedBox(),

                    (myPlayer.isHost() || myPlayer.isMafia()) && mafia != null
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  'Mafia', 
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'icons/tie.svg', 
                                    color: Colors.black,
                                    width: 5,
                                  ),
                                )

                              ],
                            ),
                          ),
                          ...mafia.keys.map((e) => PlayerListItem(
                            order: game.haveHost.value ? e : e + 1,
                            player: mafia![e]!,
                          )).toList()
                          
                        ],
                      ),
                    )
                    : const SizedBox(),

                    (myPlayer.isHost() || myPlayer.isMafia()) && peaceful != null
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  'Peaceful', 
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 220, 29, 15),
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'icons/peace.svg', 
                                    color: const Color.fromARGB(255, 220, 29, 15),
                                    width: 10,
                                  ),
                                )

                              ],
                            ),
                          ),
                          ...peaceful.keys.map((e) => PlayerListItem(
                            order: game.haveHost.value ? e : e + 1,
                            player: peaceful![e]!,
                          )).toList()
                          
                        ],
                      ),
                    )
                    : const SizedBox(),

                      myPlayer.isPeaceful() && players != null
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                const Text(
                                  'Players', 
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 15, 59, 220),
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'icons/player.svg', 
                                    color: const Color.fromARGB(255, 15, 59, 220),
                                    width: 10,
                                  ),
                                )

                              ],
                            ),
                          ),
                          ...players.keys.map((e) => PlayerListItem(
                            order: game.haveHost.value ? e : e + 1,
                            player: players![e]!,
                          )).toList()
                          
                        ],
                      ),
                    )
                    : const SizedBox(),
                    
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}