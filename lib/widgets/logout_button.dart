import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final Function()? onTap;
  final double buttonHeight;

  final gradientColors = const [Color(0xFF6957FE), Color(0xFF7B98FF)];

  const LogoutButton({
    Key? key,
    required this.onTap,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: buttonHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[1].withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                onTap: onTap,
                child: const Center(
                  child: Icon(Icons.logout_rounded, color: Colors.red,),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}