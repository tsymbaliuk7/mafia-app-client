import 'package:flutter/material.dart';

class VotingPlayerButton extends StatelessWidget {
  const VotingPlayerButton({Key? key, 
    required this.orderId, 
    required this.onTap,
  }) : super(key: key);

  final int orderId;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
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
            child: Text(
              orderId.toString(), 
              style: const TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w600,
                fontSize: 30
              ),),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: onTap,
            ),
          ),
        )
      ],
    );
  }
}