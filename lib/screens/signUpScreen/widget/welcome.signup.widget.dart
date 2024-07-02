import 'package:flutter/material.dart';

import '../../../app/constants/app.colors.dart';
import '../../../app/constants/app.fonts.dart';

Widget welcomeTextSignup({required themeFlag, required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 80.0,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 2.0),
        child: RichText(
          text: TextSpan(
            text: 'Hey There 😲',
            style: TextStyle(
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
              fontWeight: FontWeight.w900,
              fontFamily: AppFonts.contax,
              fontSize: 35.0,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome To ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontFamily: AppFonts.contax,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: 'iJobhunt ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontFamily: AppFonts.contax,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                children: [
                  TextSpan(
                    text: "Signup ",
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                    ),
                  ),
                  TextSpan(
                    text: "& find a good job opportunity for yourself",
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ],
  );
}
