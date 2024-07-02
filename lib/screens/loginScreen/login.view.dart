//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/applesignin.dart';
import 'package:ijobhunt/screens/loginScreen/widget/forgotpass.dart';
import 'package:ijobhunt/screens/notificonSceen/workmanager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as a;
import 'package:the_apple_sign_in/scope.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.fonts.dart';
import '../../core/notifiers/authentication.notifer.dart';
import '../../core/notifiers/theme.notifier.dart';
import '../signUpScreen/signup.screen.dart';
import 'AuthenticationLogin/authentication.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var firebasetoken = '';
  var emptype = '';
  late var compdata;
  var userid = '';
  var name = '';
  bool islogin = false;
  bool isloading = false;
  Map _userobj = {};
  bool _isSigningIn = false;

  Future getemptype() async {
    setState(() {
      emptype = AppPreferences.getUserType();
      compdata = AppPreferences.getCompanyData();
      // ignore: avoid_print
    });
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = AuthServices();
      final user = await authService
          .signInWithApple(scopes: [Scope.email, Scope.fullName]);
      if (user.uid.isNotEmpty) {
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
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  /*Future getcompanydata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    compdata = pref.getString('company') ?? '';
    setState(() {
      compdata = compdata;
      // ignore: avoid_print
    });
  }*/

  @override
  void initState() {
    FirbaseMessage.init();
    //firebasetoken = FirbaseMessage.firebasetoken;
    getemptype();
    //getcompanydata();
    super.initState();
// if(Platform.isIOS){                                                      //check for ios if developing for both android & ios
//   AppleSingIn.onCredentialRevoked.listen((_) {
//     print("Credentials revoked");
//   });
// }
  }

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    var authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    _userlogin() {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isloading = true;
        });
        authNotifier
            .userLogin(
          useremail: userEmailController.text,
          context: context,
          userpassword: userPassController.text,
          name: '',
          token: '',
        )
            .then((void nothing) {
          setState(() {
            isloading = false;
          });
        });
      }
    }

    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = themeNotifier.darkTheme;

    return Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: MediaQuery.paddingOf(context).top + 50.0,),
            const Spacer(
              flex: 4,
            ),
            Container(
              height: 60.0,
              //width: 250.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/logo/logo1.png',
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),

            //SizedBox(height: 8.0,),
            Padding(
              padding: (MediaQuery.of(context).size.width > 500)
                  ? const EdgeInsets.fromLTRB(150.0, 10.0, 25.0, 10.0)
                  : const EdgeInsets.fromLTRB(35.0, 50.0, 25.0, 12.0),
              child: RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.logintext1,
                  style: TextStyle(
                    color: themeFlag
                        ? AppColors.metgoldenColor
                        : AppColors.blueZodiacTwo,
                    fontWeight: FontWeight.w900,
                    fontFamily: AppFonts.contax,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 500) {
                  return Center(
                    child: SizedBox(
                      width: 800,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        child: Container(
                          //width: 600,
                          padding: const EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 100.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                //padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .logintext2,
                                            style: TextStyle(
                                              color: themeFlag
                                                  ? AppColors.metgoldenColor
                                                  : AppColors.blueZodiacTwo,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20.0,
                                              fontFamily: AppFonts.contax,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'iJobhunt',
                                            style: TextStyle(
                                              color: themeFlag
                                                  ? AppColors.metgoldenColor
                                                  : AppColors.blueZodiacTwo,
                                              fontSize: 20.0,
                                              fontFamily: AppFonts.contax,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 20.0, 25.0, 5.0),
                                child: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .logintext3,
                                                style: TextStyle(
                                                  color: themeFlag
                                                      ? AppColors.metgoldenColor
                                                      : AppColors.blueZodiacTwo,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .logintext5,
                                                style: TextStyle(
                                                  color: themeFlag
                                                      ? AppColors.metgoldenColor
                                                      : AppColors.blueZodiacTwo,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .logintext6,
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
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 0.0, 15.0, 0.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                RegExp(r'\s'),
                                              ),
                                            ],
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: userEmailController,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.email_outlined,
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.blueZodiacTwo,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 12.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12.0,
                                                ),
                                              ),
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .loginhinttext1,
                                              hintStyle: TextStyle(
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.blueZodiacTwo,
                                              ),
                                            ),
                                            validator: (val) => !RegExp(
                                                        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                    .hasMatch(val!)
                                                ? AppLocalizations.of(context)!
                                                    .loginhinttext1
                                                : null,
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                RegExp(r'\s'),
                                              ),
                                            ],
                                            textInputAction:
                                                TextInputAction.send,
                                            onFieldSubmitted: (value) {
                                              _userlogin();
                                            },
                                            obscureText: true,
                                            //autofocus: true,
                                            controller: userPassController,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.lock_outline,
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.blueZodiacTwo,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 12.0),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  12.0,
                                                ),
                                              ),
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .loginhinttext2,
                                              hintStyle: TextStyle(
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.blueZodiacTwo,
                                              ),
                                            ),
                                            validator: (val) => val!.isEmpty
                                                ? AppLocalizations.of(context)!
                                                    .loginhinttext2
                                                : null,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgotPassword(),
                                              ),
                                            );
                                          },
                                          child: Text(
//AppLocalizations.of(context)!.signupbuttontext2,
                                            '${AppLocalizations.of(context)!.forgotpassword}?',
                                            style: TextStyle(
                                                //decoration: TextDecoration.underline,
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.blueZodiacTwo,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40.0,
                                            //width: 600,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: MaterialButton(
                                              hoverElevation: 20.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              onPressed: () async {
                                                _userlogin();
                                              },
                                              color: AppColors.mirage,
                                              child: isloading
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 24.0,
                                                          width: 24.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color:
                                                                AppColors.white,
                                                            strokeWidth: 2.0,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        const Text(
                                                          'Please Wait....',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .loginbuttontext,
                                                      style: TextStyle(
                                                        color: themeFlag
                                                            ? AppColors
                                                                .metgoldenColor
                                                            : AppColors
                                                                .creamColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          //padding: const EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 2.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .logintext2,
                                      style: TextStyle(
                                        color: themeFlag
                                            ? AppColors.metgoldenColor
                                            : AppColors.blueZodiacTwo,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        fontFamily: AppFonts.contax,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'iJobhunt',
                                      style: TextStyle(
                                        color: themeFlag
                                            ? AppColors.metgoldenColor
                                            : AppColors.blueZodiacTwo,
                                        fontSize: 20.0,
                                        fontFamily: AppFonts.contax,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 5.0),
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .logintext3,
                                          style: TextStyle(
                                            color: themeFlag
                                                ? AppColors.metgoldenColor
                                                : AppColors.blueZodiacTwo,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .logintext5,
                                          style: TextStyle(
                                            color: themeFlag
                                                ? AppColors.metgoldenColor
                                                : AppColors.blueZodiacTwo,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .logintext6,
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 0.0, 15.0, 0.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\s'),
                                        ),
                                      ],
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      controller: userEmailController,
                                      //autofocus: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 12.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .loginhinttext1,
                                        hintStyle: TextStyle(
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                        ),
                                      ),
                                      validator: (val) =>
                                          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                  .hasMatch(val!)
                                              ? AppLocalizations.of(context)!
                                                  .loginhinttext1
                                              : null,
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\s'),
                                        ),
                                      ],
                                      textInputAction: TextInputAction.send,
                                      onFieldSubmitted: (value) {
                                        _userlogin();
                                      },
                                      obscureText: true,
                                      //autofocus: true,
                                      controller: userPassController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0,
                                                horizontal: 12.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .loginhinttext2,
                                        hintStyle: TextStyle(
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                        ),
                                      ),
                                      validator: (val) => val!.isEmpty
                                          ? AppLocalizations.of(context)!
                                              .loginhinttext2
                                          : null,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword(),
                                        ),
                                      );
                                    },
                                    child: Text(
//AppLocalizations.of(context)!.signupbuttontext2,
                                      '${AppLocalizations.of(context)!.forgotpassword}?',
                                      style: TextStyle(
                                          //decoration: TextDecoration.underline,
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 40.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: MaterialButton(
                                      hoverElevation: 20.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      onPressed: () async {
                                        _userlogin();
                                      },
                                      color: AppColors.mirage,
                                      child: isloading
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 24.0,
                                                  width: 24.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppColors.white,
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .loginbuttontext,
                                              style: TextStyle(
                                                color: themeFlag
                                                    ? AppColors.metgoldenColor
                                                    : AppColors.creamColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 1.0,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black.withOpacity(0.3),
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      AppLocalizations.of(context)!
                          .logindevidtext
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        //fontWeight: FontWeight.w600,
                        color: themeFlag
                            ? AppColors.metgoldenColor
                            : AppColors.blueZodiacTwo,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            const Spacer(),

            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 500) {
                    return SizedBox(
                      width: 500.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (appleSignInAvailable.isAvailable) {
                                _signInWithApple(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackUtil.stylishSnackBar(
                                      text: AppLocalizations.of(context)!
                                          .appleloginmessage,
                                      context: context),
                                );
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(
                                  4.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shedowgreyColor,
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo/applelogo.ico',
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  const Text('Sign-In with Apple'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Authentication.loginFacebook(context: context);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(
                                  4.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shedowgreyColor,
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo/Facebooklogo.png',
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  const Text('Sign-In with Apple'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          FutureBuilder(
                              future: Authentication.initializeFirebase(
                                  context: context),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text(
                                      'Error initializing Firebase');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GestureDetector(
                                    onTap: () async {
                                      User? user =
                                          await Authentication.signInWithGoogle(
                                              context: context);
                                      setState(() {
                                        _isSigningIn = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                          4.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.shedowgreyColor,
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/logo/googlelogo.png',
                                            height: 30.0,
                                            width: 30.0,
                                          ),
                                          const SizedBox(
                                            width: 16.0,
                                          ),
                                          const Text('Sign-In with Apple'),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                );
                              }),
                        ],
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (appleSignInAvailable.isAvailable) {
                            _signInWithApple(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackUtil.stylishSnackBar(
                                  text: AppLocalizations.of(context)!
                                      .appleloginmessage,
                                  context: context),
                            );
                          }
                        },
                        child: Container(
                          /*height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.82,*/
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              4.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shedowgreyColor,
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo/applelogo.ico',
                            height: 30.0,
                            width: 30.0,
                          ),
                          /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          */ /*const SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            "Sign in with Apple",
                            style: TextStyle(
                              // fontFamily:
                              //     GoogleFonts.comfortaa().fontFamily,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blueZodiacTwo,
                            ),
                          )*/ /*
                        ],
                      ),*/
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Authentication.loginFacebook(context: context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              4.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shedowgreyColor,
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo/Facebooklogo.png',
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: Authentication.initializeFirebase(
                              context: context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Error initializing Firebase');
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return GestureDetector(
                                onTap: () async {
                                  User? user =
                                      await Authentication.signInWithGoogle(
                                          context: context);
                                  setState(() {
                                    _isSigningIn = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      4.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shedowgreyColor,
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo/googlelogo.png',
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                ),
                              );
                            }
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            );
                          }),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.signupbuttontext1,
                  style: TextStyle(
                    color: themeFlag
                        ? AppColors.metgoldenColor
                        : AppColors.blueZodiacTwo,
                    fontSize: 14.0,
                  ),
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.signupbuttontext2,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: themeFlag
                          ? AppColors.metgoldenColor
                          : AppColors.blueZodiacTwo,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
