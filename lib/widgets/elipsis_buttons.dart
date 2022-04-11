import 'package:flutter/material.dart';

import '../globals.dart';

class ElipsisPrimaryButton extends StatelessWidget{
  final Function()? onTap;
  final String title;


  const ElipsisPrimaryButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.all(Radius.elliptical(250, 100)),
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.elliptical(250, 100)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.elliptical(250, 100)),
          onTap: onTap,
          child: SizedBox(
            height: 100,
            width: 250,
            child: Center(child: Text(title, style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18
            ),)),
          ),
        ),
      ),
    );
  }

}


class ElipsisSecondaryButton extends StatelessWidget{
  final Function()? onTap;
  final String title;


  const ElipsisSecondaryButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.elliptical(200, 80)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.elliptical(200, 80)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.elliptical(200, 80)),
          onTap: onTap,
          child: SizedBox(
            height: 80,
            width: 200,
            child: Center(child: Text(title, style: TextStyle(
              color: gradientColors[0], fontWeight: FontWeight.w600, fontSize: 16
            ),)),
          ),
        ),
      ),
    );
  }

}