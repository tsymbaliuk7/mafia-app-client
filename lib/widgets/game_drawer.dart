import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/models/player_model.dart';
import 'package:mafiaclient/widgets/player_list_item.dart';

class GameDrawer extends StatelessWidget {
  GameDrawer({Key? key, required this.room}) : super(key: key);
  
  final String room;
  final GameController game = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Obx(() {
          PlayerModel? host = game.getHost();
          Map<int, PlayerModel>? don, players, peaceful, mafia;
          if(game.myPlayer.value.isHost() || game.myPlayer.value.isMafia()){
            don = game.getDon();
            peaceful= game.getPeaceful();
            mafia= game.getMafia();
          }
         
          if(game.myPlayer.value.isPeaceful() || game.myPlayer.value.isHost()){
            players = game.getPlayersWithoutHost();
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text('${host!.user.username} ${game.myPlayer.value.user.id == host.user.id ? '(you)' : ''}')
                        ],
                      ),
                    )
                    : const SizedBox(),

                    Column(
                      children: [
                        (game.myPlayer.value.isHost() || game.myPlayer.value.isMafia()) && don != null
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
                                isYou: game.myPlayer.value.user.id == don[e]!.user.id,
                              )).toList()
                              
                            ],
                          ),
                        )
                        : const SizedBox(),

                        (game.myPlayer.value.isHost() || game.myPlayer.value.isMafia()) && mafia != null
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
                                isYou: game.myPlayer.value.user.id == mafia[e]!.user.id,
                              )).toList()
                              
                            ],
                          ),
                        )
                        : const SizedBox(),

                        (game.myPlayer.value.isHost() || game.myPlayer.value.isMafia()) && peaceful != null
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
                                isYou: game.myPlayer.value.user.id == peaceful[e]!.user.id,
                              )).toList()
                              
                            ],
                          ),
                        )
                        : const SizedBox(),

                          (game.myPlayer.value.isPeaceful() || (game.myPlayer.value.isHost() && game.gameStage.value == GameStage.lobby)) 
                          && players != null
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
                                isYou: game.myPlayer.value.user.id == players[e]!.user.id,
                              )).toList()
                              
                            ],
                          ),
                        )
                        : const SizedBox(),
                      ],
                    ),
                    
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  game.myPlayer.value.isHost() &&  game.gameStage.value == GameStage.lobby
                  ? Material(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color.fromARGB(255, 231, 231, 231),
                    child: InkWell( 
                      borderRadius: BorderRadius.circular(40),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.shuffle,
                          color:Colors.grey,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        game.shufflePlayers();
                      }
                    ),
                  )
                  : const SizedBox(),

                  game.myPlayer.value.isHost() && game.gameStage.value == GameStage.start
                  ? Material(
                    borderRadius: BorderRadius.circular(40),
                    color: const Color.fromARGB(255, 231, 231, 231),
                    child: InkWell( 
                      borderRadius: BorderRadius.circular(40),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.refresh,
                          color:Colors.grey,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        game.reGenerateRoles();
                      }
                    ),
                  )
                  : const SizedBox(),

                  game.myPlayer.value.isHost() && game.gameStage.value == GameStage.inProgress
                  ? Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Material(
                          borderRadius: BorderRadius.circular(40),
                          color: const Color.fromARGB(255, 231, 231, 231),
                          child: InkWell( 
                            borderRadius: BorderRadius.circular(40),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.replay_outlined,
                                color:Colors.red,
                                size: 25,
                              ),
                            ),
                            onTap: () {
                              game.restartGame();
                            }
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(255, 231, 231, 231),
                        child: InkWell( 
                          borderRadius: BorderRadius.circular(40),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color:Colors.red,
                              size: 25,
                            ),
                          ),
                          onTap: () async {
                            await game.returnToCheckpoint();
                          }
                        ),
                      ),
                    ],
                  )
                  : const SizedBox()
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}