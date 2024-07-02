import 'package:flutter/material.dart';

import '../../../app/constants/app.colors.dart';


class TextWidget extends StatelessWidget {
  const TextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'i',
        style: TextStyle(
          color: AppColors.blackPearl,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: 'J',
            style: TextStyle(
              color: AppColors.rawSienna,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'ob',
            style: TextStyle(
              color: AppColors.blackPearl,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
          TextSpan(
            text: 'h',
            style: TextStyle(
              color: AppColors.rawSienna,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: 'unt',
            style: TextStyle(
              color: AppColors.blackPearl,
              fontWeight: FontWeight.w600,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
