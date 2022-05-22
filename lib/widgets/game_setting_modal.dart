import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/widgets/primary_buttons.dart';

class GameSettingsModal extends StatefulWidget {
  GameSettingsModal({Key? key, required this.room}) : super(key: key);

  final String room;
  final GameController game = Get.find();

  @override
  State<GameSettingsModal> createState() => _GameSettingsModalState();
}

class _GameSettingsModalState extends State<GameSettingsModal> {
  bool useAI = false;
  bool lastWordForKilled = false;
  int mafiaCount = 1;
  late int maxMafiaCount;

  @override
  void initState() {
    maxMafiaCount = max((widget.game.getPlayersWithoutHost()?.length ?? 1) ~/ 3, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          'Use AI frames processing',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Switch(
                        value: useAI,
                        activeColor: mainColors[widget.game.getCurrentStyleName()],
                        onChanged: (value) {
                          setState(() {
                            useAI = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Give last word for killed at night',
                        style: TextStyle(
                          fontSize: 20,
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: lastWordForKilled,
                        activeColor: mainColors[widget.game.getCurrentStyleName()],
                        onChanged: (value) {
                          setState(() {
                            lastWordForKilled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mafia cards number',
                        style: TextStyle(
                          fontSize: 20,
                          
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onTap: (){
                              
                              if(mafiaCount > 1){
                                setState(() {
                                  mafiaCount--;
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_circle_left_rounded,
                              color: Colors.grey.withOpacity(mafiaCount > 1 ? 1 : 0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(mafiaCount.toString()),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onTap: (){
                              if(mafiaCount < maxMafiaCount){
                                setState(() {
                                  mafiaCount++;
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_circle_right_rounded,
                              color: Colors.grey.withOpacity(mafiaCount < maxMafiaCount ? 1 : 0.5),
                            )
                          ),

                          
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: PrimaryButton(
                    title: 'Start Game!',
                    color: mainColors[widget.game.getCurrentStyleName()],
                    onTap: (){
                      Get.back();
                      widget.game.saveSettingAndStartGame(
                        useAI, 
                        lastWordForKilled, 
                        mafiaCount
                      );
                    },
                    buttonHeight: 45,
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
  }
}