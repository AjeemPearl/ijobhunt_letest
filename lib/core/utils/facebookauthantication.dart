// import 'dart:async';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// class FacebookAuthantication {
//   static final FacebookLogin facebookLogin = FacebookLogin();
//   static Future loginFacebook() async {
//     final FacebookLoginResult result = await facebookLogin.logIn(['email']);
//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final FacebookAccessToken accessToken = result.accessToken;
//         print('''
//          Logged in!
         
//          Token: ${accessToken.token}
//          User id: ${accessToken.userId}
//          Expires: ${accessToken.expires}
//          Permissions: ${accessToken.permissions}
//          Declined permissions: ${accessToken.declinedPermissions}
//          ''');
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//         print('Login cancelled by the user.');
//         break;
//       case FacebookLoginStatus.error:
//         print('Something went wrong with the login process.\n'
//             'Here\'s the error Facebook gave us: ${result.errorMessage}');
//         break;
//     }
//   }
// }
