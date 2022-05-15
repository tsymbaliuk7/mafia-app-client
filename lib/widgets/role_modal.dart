import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleModal extends StatelessWidget {
  const RoleModal({
    Key? key, 
    required this.roleTitle, 
    required this.roleImage, 
    required this.roleColor,
  }) : super(key: key);

  final String roleTitle;
  final String roleImage;
  final Color roleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: SvgPicture.asset(roleImage, height: 120, color: roleColor,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              roleTitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: roleColor,
                fontSize: 45,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3
              ),
            ),
          )
        ]
      ),
    );
  }
}