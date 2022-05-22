import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/controllers/styles_controller.dart';

class PrimaryButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final double buttonHeight;
  final Color? color;

  final StylesController styles = Get.find();


  PrimaryButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.buttonHeight,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: color ?? mainColors[styles.styleKey.value],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class SecondaryButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final double buttonHeight;

  final StylesController styles = Get.find();


  SecondaryButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: mainColors[styles.styleKey.value]!),
        boxShadow: [
          BoxShadow(
            color: mainColors[styles.styleKey.value]!.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: mainColors[styles.styleKey.value],
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


