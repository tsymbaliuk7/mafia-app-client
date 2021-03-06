import 'package:flutter/material.dart';
import 'package:mafiaclient/models/player_model.dart';

class PlayerListItem extends StatelessWidget {
  final int order;
  final PlayerModel player;
  final bool isYou;
  final bool isJustKilled;

  const PlayerListItem({
    Key? key, 
    required this.order, 
    required this.player, 
    this.isYou = false,
    this.isJustKilled = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey))
          ),
          child: Text(
            '$order. ${player.user.username} ${isYou ? '(you)' : ''}',
            style: TextStyle(decoration: player.isAlive ? null : TextDecoration.lineThrough),
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: player.isOnVote ? 
              const Color.fromARGB(255, 218, 0, 242) 
              : isJustKilled ? Colors.black : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
        ),
      ],
    );
  }
}