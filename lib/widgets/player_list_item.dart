import 'package:flutter/material.dart';
import 'package:mafiaclient/models/player_model.dart';

class PlayerListItem extends StatelessWidget {
  final int order;
  final PlayerModel player;
  final bool isYou;

  const PlayerListItem({Key? key, required this.order, required this.player, this.isYou = false}) : super(key: key);

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
          child: Text('$order. ${player.user.username} ${isYou ? '(you)' : ''}'),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: player.isOnVote ? const Color.fromARGB(255, 218, 0, 242) : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
        ),
      ],
    );
  }
}