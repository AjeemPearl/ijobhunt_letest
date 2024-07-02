import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/notifiers/forgotepassword.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ijobhunt/screens/loginScreen/login.view.dart';

class ShowForgotPassword {
  static Future buildSignUpPopup(BuildContext context) {
    return showGeneralDialog(
      barrierLabel: "Enter OTP",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            //margin: const EdgeInsets.only(left: 12, right: 12),
            child: Stack(
              children: [
                Container(
                  //alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 230,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/logo/thankyou.png',
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 5.0,
                          right: 5.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.signuppopuptext1,
                              style: TextStyle(
                                color: AppColors.blueZodiacTwo,
                                fontSize: 18.0,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.signuppopuptext2,
                              style: TextStyle(
                                color: AppColors.blueZodiacTwo,
                                fontSize: 15.0,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                //fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 45.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .signuppopuptext3,
                                  style: TextStyle(
                                    color: AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    //fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .loginbuttontext,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15.0,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(left: 140.0, top: 16.0),
                            //   child: InkWell(
                            //     onTap: () {
                            //       Navigator.pushReplacement(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => LoginScreen(),
                            //         ),
                            //       );
                            //     },
                            //     child: Container(
                            //       padding: const EdgeInsets.all(5.0),
                            //       decoration: BoxDecoration(
                            //         border: Border.all(
                            //           width: 2.0,
                            //           color: AppColors.blueZodiacTwo,
                            //         ),
                            //         borderRadius: BorderRadius.circular(8.0),
                            //       ),
                            //       child: Text(
                            //         "Go to login screen",
                            //         style: TextStyle(
                            //           color: AppColors.blueZodiacTwo,
                            //           fontSize: 15.0,
                            //           fontFamily: GoogleFonts.lato().fontFamily,
                            //           //fontWeight: FontWeight.w600,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 5.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.blueZodiacTwo,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  static Future buildotpdialog(BuildContext context) {
    var otp = '';
    final formKey = GlobalKey<FormState>();
    bool isloading = false;
    return showGeneralDialog(
      barrierLabel: "Enter OTP",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            //margin: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              //alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.otptext1,
                            style: TextStyle(
                                fontSize: 15.0, color: AppColors.blueZodiacTwo),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.otptext2,
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        //top: 10.0,
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          OtpTextField(
                            numberOfFields: 4,
                            borderColor: Color(0xFF512DA8),
                            showFieldAsBox: true,
                            onSubmit: (String verificationCode) {
                              otp = verificationCode;
                            }, // end onSubmit
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          MaterialButton(
                            height: MediaQuery.of(context).size.height * 0.04,
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                isloading = true;
                                ForgotePassrdAuthantication.veryfiOTP(
                                        OTP: otp, context: context)
                                    .then((nomethod) {
                                  isloading = false;
                                });
                              }
                            },
                            color: AppColors.mirage,
                            child: isloading
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Please Wait....',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ],
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.submit,
                                    style: TextStyle(
                                      color: AppColors.creamColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
}
