import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';

class VotingsResultModal extends StatelessWidget {
  VotingsResultModal({Key? key}) : super(key: key);

  final GameController game = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: min(900, MediaQuery.of(context).size.width - 50),
      child: Column(
        children: [
          ...game.onVote.map((element) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
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
                    child: Center(
                      child: Text(game
                        .getPlayerByUserIdWithOrder(element)
                        !.keys
                        .first
                        .toString(),
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.w600,
                          fontSize: 30
                        ),
                      )
                    ),
                  ),
                ),

                ...game
                  .votingResults
                  .entries
                  .where((mapElement) => mapElement.value == element)
                  .map((e) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:const Color.fromARGB(255, 218, 0, 242).withOpacity(0.5),
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
                      child: Text(game
                        .getPlayerByUserIdWithOrder(e.key)
                        !.keys
                        .first
                        .toString(),
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.w600,
                          fontSize: 30
                        ),
                      )
                    ),
                  ),
                ),),
                
              ],
            ),
          ))
        ]
      ),
    );
  }
}