import 'package:flutter/material.dart';
import '../../../app/constants/app.colors.dart';
import '../../../app/constants/app.fonts.dart';

Widget welcomeTextLogin({required bool themeFlag}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 2.0),
        child: RichText(
          text: TextSpan(
            //text: AppLocalizations.of(context)!.logintext1,
            style: TextStyle(
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
              fontWeight: FontWeight.w900,
              fontFamily: AppFonts.contax,
              fontSize: 40.0,
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
                    text: 'Welcome ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontWeight: FontWeight.w300,
                      fontSize: 28.0,
                      fontFamily: AppFonts.contax,
                    ),
                  ),
                  TextSpan(
                    text: 'To ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontSize: 28.0,
                      fontFamily: AppFonts.contax,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: 'iJobhunt',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontSize: 28.0,
                      fontFamily: AppFonts.contax,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
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
                    text: 'Log In To ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: 'Your ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Account Right Now ! ',
                    style: TextStyle(
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
