// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../app/constants/app.colors.dart';
import '../../../const.dart';
import '../../../core/notifiers/theme.notifier.dart';

var themeFlag;

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    themeFlag = themeNotifier.darkTheme;
    return GridView.extent(
      maxCrossAxisExtent: 200,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        jobCard(
            "Human Resource",
            Icon(
              Icons.people_alt_outlined,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Building & Architecture",
            Icon(
              Icons.architecture_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Customer Service",
            Icon(
              Icons.headset_mic,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Hospitality & Leisure",
            Icon(
              Icons.hotel_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Marketing & Business",
            Icon(
              Icons.campaign_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Medical & Pharma",
            Icon(
              Icons.local_hospital_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Developer",
            Icon(
              Icons.developer_mode_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
        jobCard(
            "Software Engg.",
            Icon(
              Icons.computer_rounded,
              color: themeFlag
                  ? AppColors.metgoldenColor
                  : AppColors.blueZodiacTwo,
            ),
            themeFlag ? AppColors.mirage : AppColors.creamColor),
      ],
    );
  }
}

//**** Card Widgets
Widget jobCard(String txt, Icon icon, Color int) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      // ignore: todo
      //TODO: Function
      onTap: () {},
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: themeFlag
                    ? AppColors.blackPearl
                    : AppColors.shedowgreyColor,
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(4, 4))
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultBorderRadius),
          ),
          color: int,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(defaultPadding),
              child: icon,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                txt,
                style: TextStyle(
                  color: themeFlag
                      ? AppColors.metgoldenColor
                      : AppColors.blueZodiacTwo,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
