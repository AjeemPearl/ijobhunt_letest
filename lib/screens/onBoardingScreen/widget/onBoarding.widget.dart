import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/models/onBoarding.model.dart';

class PageCard extends StatefulWidget {
  final OnBoardingModel card;

  const PageCard({Key? key, required this.card}) : super(key: key);

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          _buildPicture(context),
          const SizedBox(height: 20.0),
          _buildText(context),
        ],
      ),
    );
  }

  Widget _buildPicture(
    BuildContext context, {
    double size = 380,
  }) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(
        top: 100,
      ),
      child: Lottie.asset(widget.card.image!),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      widget.card.title!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: widget.card.textColor,
        fontWeight: FontWeight.w900,
        fontSize: 20.0,
      ),
    );
  }
}
