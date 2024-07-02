import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/searchScreen/test.dart';
import 'package:ijobhunt/screens/splashScreen/select_countary.dart';

class SplashTwo extends StatefulWidget {
  const SplashTwo({super.key});

  @override
  State<SplashTwo> createState() => _SplashTwoState();
}

class _SplashTwoState extends State<SplashTwo> {
  bool showdata = false;
  late Timer timer;

  @override
  void initState() {
    timer = Timer(
        const Duration(seconds: 16),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectCountry(),
            )));

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.bottomRight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/logo/hellogifanimation.gif',
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 25.0,
              bottom: 25.0,
            ),
            child: TextButton(
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                AppPreferences.setOnBoardDone();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectCountry(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
