import 'package:flutter/material.dart';
import 'package:mafiaclient/models/player_model.dart';

class PlayerListItem extends StatelessWidget {
  final int order;
  final PlayerModel player;

  const PlayerListItem({Key? key, required this.order, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text('$order. ${player.user.username}');
  }
}