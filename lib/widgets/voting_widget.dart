import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/game_controller.dart';
import 'package:mafiaclient/widgets/voting_player_button.dart';

class VotingWidget extends StatefulWidget {
  VotingWidget({Key? key}) : super(key: key);

  final GameController game = Get.find();

  @override
  State<VotingWidget> createState() => _VotingWidgetState();
}

class _VotingWidgetState extends State<VotingWidget> {

  final CountDownController _controller = CountDownController();

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 0),
                ),
              ]
            ),
            child: widget.game.onVote.isNotEmpty ? 
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.game.onVote.map((e) {
                  var player = widget.game.getPlayerByUserIdWithOrder(e);
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: !widget.game.myPlayer.value.isHost() ? VotingPlayerButton(
                      orderId: player!.keys.first, 
                      onTap: (){
                        widget.game.voteFor(id: player.values.first.user.id);   
                    }) : const SizedBox(),
                  );
                }),
                CircularCountDownTimer(
                  width: 40,
                  height: 40,
                  initialDuration: 0,
                  duration: widget.game.myPlayer.value.isHost() ? 15 : 10,
                  controller: _controller,
                  isTimerTextShown: false,
                  isReverse: true,
                  isReverseAnimation: true,
                  autoStart: true,
                  fillColor: const Color.fromARGB(255, 218, 0, 242),
                  ringColor: Colors.white,
                  onComplete: (){
                    widget.game.voteFor();
                  },
                )
              ],
            ) : const SizedBox(),
          ),

        ],
      ),
    );
  }
}