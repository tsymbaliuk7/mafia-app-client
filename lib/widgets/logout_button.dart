import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Function()? onTap;
  final double buttonHeight;

  const LogoutButton({
    Key? key,
    required this.onTap,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.red)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: const Center(
            child: Icon(Icons.logout_rounded, color: Colors.red,),
          ),
        ),
      ),
    );
  }
}