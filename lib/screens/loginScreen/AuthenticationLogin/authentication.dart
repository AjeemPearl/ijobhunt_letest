import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/core/notifiers/authentication.notifer.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  static bool islogin = false;
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;

      } catch (e) {

      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      // print("fffff=>${googleSignIn}");

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );


        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }


    return user;
  }


  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var authNotifier =
          Provider.of<AuthenticationNotifier>(context, listen: false);
      authNotifier.userLogin(
        useremail: user.email.toString(),
        context: context,
        userpassword: '',
        name: user.displayName,
        token: user.uid,
      );

    }

    return firebaseApp;
  }

  

  static Future signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut().whenComplete(() async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.remove(AppKeys.userData).whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    )
              );

      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error signing out. Try again.'),
        ),
      );
    }
  }
 

  static Future loginFacebook({required BuildContext context}) async {
    FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]).then((value) {
      FacebookAuth.instance.getUserData().then((userData) async {
        islogin = true;
        var _userobj = userData;

        var authNotifier =
            Provider.of<AuthenticationNotifier>(context, listen: false);
        authNotifier.userLogin(
            useremail: _userobj['email'],
            context: context,
            userpassword: '',
            token: _userobj['id'],
            name: _userobj['name']);
      });
    });
  }
}
