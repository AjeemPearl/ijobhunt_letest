import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/constants/app.keys.dart';
import '../../loginScreen/AuthenticationLogin/applesignin.dart';
import '../../loginScreen/AuthenticationLogin/authentication.dart';
import '../../loginScreen/login.view.dart';

class ShowMyDialog {
  static double value = 0.0;

  static Future postQuestion({
    required name,
    required phone,
    required email,
    required quesion,
    required BuildContext context,
  }) async {
    Map data = {
      'name': name.toString(),
      'number': phone.toString(),
      'email': email.toString(),
      'message': quesion.toString()
    };
    final response = await http.post(
      Uri.parse(ApiRoutes.postQuestions),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      // print(response);
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: "Data Sucessfully Saved ", context: context));
      Navigator.pop(context);
    }
  }

  static Future builddialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController messageController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
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
              height: 460,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
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
                          TextFormField(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            //userNameController.selection: TextSelection.collapsed(offset: userNameController.text.length),
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              hintText: "Enter your Name",
                              hintStyle: TextStyle(
                                color: AppColors.blueZodiacTwo,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Pease Enter Your Name" : null,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            controller: emailController,
                            //autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              hintText: 'Enter Your Email',
                            ),
                            validator: (val) =>
                                !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                        .hasMatch(val!)
                                    ? 'Please Enter Your Email'
                                    : null,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            keyboardType: TextInputType.phone,
                            //keyboardType: TextInputType.number,
                            controller: phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10.0,
                                ),
                              ),
                              hintText: "Enter Your PhoneNumber",
                              hintStyle: TextStyle(
                                color: AppColors.blueZodiacTwo,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Enter PhoneNumber" : null,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            //userNameController.selection: TextSelection.collapsed(offset: userNameController.text.length),
                            controller: messageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              hintText: "Enter your question",
                              hintStyle: TextStyle(
                                color: AppColors.blueZodiacTwo,
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Eneter Your question" : null,
                          ),
                          // const SizedBox(
                          //   height: 5.0,
                          // ),
                          MaterialButton(
                            height: MediaQuery.of(context).size.height * 0.04,
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                postQuestion(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  quesion: messageController.text,
                                  context: context,
                                );
                              }
                            },
                            color: AppColors.mirage,
                            child: Text(
                              "Submit",
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

  static Future bildratingdialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
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
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          right: 55,
                        ),
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                    ),
                  ],
                )),
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

  static Future<bool> showDeletePopup({required BuildContext context}) async {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: const Text('Are sure you want to Delete '),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences preferences =
                  await SharedPreferences.getInstance();
                  var token =preferences.getString(AppKeys.userData??'');
                  UserProFile.deleteAccount(context: context).whenComplete(()async {
                    if (Authentication.islogin == true) {
                      FacebookAuth.instance.logOut().whenComplete(() async {
                        preferences.remove(AppKeys.userData).whenComplete(
                              () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          ),
                        );
                      });
                      print("User Signed Out");
                    } else if (appleSignInAvailable.isAvailable) {
                      await FirebaseAuth.instance.signOut().whenComplete(() {});
                    } else if (token!.isNotEmpty) {

                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove(AppKeys.userData).whenComplete(() {

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      });
                    }
                    Authentication.signOut(context: context);
                  });




                },
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
