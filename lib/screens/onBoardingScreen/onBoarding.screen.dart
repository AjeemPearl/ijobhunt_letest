// ignore_for_file: avoid_types_as_parameter_names

import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:ijobhunt/screens/onBoardingScreen/widget/onBoarding.widget.dart';

import '../../app/constants/app.assets.dart';
import '../../app/constants/app.colors.dart';
import '../../core/models/onBoarding.model.dart';
import '../splashScreen/splashtwo.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({
    Key? key,
  }) : super(key: key);

  final List<OnBoardingModel> cards = [
    OnBoardingModel(
      image: AppAssets.onBoardingOne,
      title: "Looking For a job?",
      textColor: AppColors.creamColor,
      bgColor: AppColors.mirage,
    ),
    OnBoardingModel(
      image: AppAssets.onBoardingTwo,
      title: "So we are here to help you",
      bgColor: AppColors.creamColor,
      textColor: AppColors.mirage,
    ),
  ];

  List<Color> get colors => cards.map((p) => p.bgColor).toList();

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: widget.colors,
        radius: 30,
        itemCount: 2,
        curve: Curves.ease,
        duration: const Duration(seconds: 2),
        itemBuilder: (int) {
          OnBoardingModel card = widget.cards[int % widget.cards.length];
          return PageCard(card: card);
        },
        onFinish: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SplashTwo(),
            ),
          );
        },
      ),
    );
  }
}
