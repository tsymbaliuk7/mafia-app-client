import 'package:flutter/material.dart';
import 'package:mafiaclient/models/player_model.dart';

class PlayerListItem extends StatelessWidget {
  final int order;
  final PlayerModel player;
  final bool isYou;

  const PlayerListItem({Key? key, required this.order, required this.player, this.isYou = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey))
      ),
      child: Text('$order. ${player.user.username} ${isYou ? '(you)' : ''}'),
    );
  }
}