// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/loginScreen/widget/showdialogbox.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app.assets.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.fonts.dart';
import '../../app/routes/app.routes.dart';
import '../../core/notifiers/authentication.notifer.dart';
import '../../core/notifiers/theme.notifier.dart';
import '../../widgets/custombox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userEmailController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController userPassController = TextEditingController();
  final TextEditingController userCPassController = TextEditingController();

  final TextEditingController usermobilenoController = TextEditingController();
  AuthenticationNotifier authNotifier(bool renderUI) =>
      Provider.of<AuthenticationNotifier>(context, listen: renderUI);

  final _formKey = GlobalKey<FormState>();
  late List<bool> isSelected;
  var usertype = 'EMPLOYEE';
  bool isloading = false;
  var devicetoken = '';
  Future getdevicetoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    devicetoken = pref.getString('firbasetoken') ?? '';
    setState(() {
      devicetoken = devicetoken;
    });
  }

  @override
  void initState() {
    isSelected = [true, false];

    getdevicetoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = themeNotifier.darkTheme;



    return Scaffold(
      backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      //resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 16.0),
          Container(
            height: 60.0,
            //width: 250.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo/logo1.png',),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            child:  LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: (constraints.maxWidth>500)? 800: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 20,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(
                                //   height: 40.0,
                                // ),
                                /*Padding(
                                    padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 2.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: AppLocalizations.of(context)!.signuptext1,
                                        style: TextStyle(
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: AppFonts.contax,
                                          fontSize: 35.0,
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
                                                text: AppLocalizations.of(context)!.signuptext2,
                                                style: TextStyle(
                                                  color: themeFlag
                                                      ? AppColors.metgoldenColor
                                                      : AppColors.blueZodiacTwo,
                                                  fontFamily: AppFonts.contax,
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(context)!.signuptext3,
                                                style: TextStyle(
                                                  color: themeFlag
                                                      ? AppColors.metgoldenColor
                                                      : AppColors.blueZodiacTwo,
                                                  fontFamily: AppFonts.contax,
                                                  fontSize: 28.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
*/

                                Card(
                                  margin: (constraints.maxWidth>500)?EdgeInsets.symmetric(horizontal: 0.0):EdgeInsets.symmetric(horizontal: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: (constraints.maxWidth>500)?const EdgeInsets.symmetric(horizontal:100.0, vertical: 50):const EdgeInsets.symmetric(horizontal:8.0, vertical: 0.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: (constraints.maxWidth>500)?const EdgeInsets.only(top: 40):const EdgeInsets.only(top: 20.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: AppLocalizations.of(context)!.signuptext4,
                                                      style: TextStyle(
                                                        color: themeFlag
                                                            ? AppColors.metgoldenColor
                                                            : AppColors.blueZodiacTwo,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: AppLocalizations.of(context)!.signuptext5,
                                                      style: TextStyle(
                                                        color: themeFlag
                                                            ? AppColors.metgoldenColor
                                                            : AppColors.blueZodiacTwo,
                                                        fontWeight: FontWeight.w500,

                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Form(
                                                key: _formKey,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                          controller: userNameController,
                                                          keyboardType: TextInputType.text,
                                                          textInputAction: TextInputAction.next,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                            prefixIcon: Icon(Icons.person),
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                8.0,
                                                              ),
                                                            ),
                                                            hintText: AppLocalizations.of(context)!
                                                                .signuphinttext1,
                                                            hintStyle: TextStyle(
                                                              color: themeFlag
                                                                  ? AppColors.metgoldenColor
                                                                  : AppColors.blueZodiacTwo,
                                                            ),
                                                          ),
                                                          validator: (val) => val!.isEmpty
                                                              ? AppLocalizations.of(context)!
                                                              .signuphinttext1
                                                              : null),
                                                      (constraints.maxWidth>500)?SizedBox(height: 20.0,):SizedBox(height: 10.0,),
                                                      TextFormField(
                                                        controller: usermobilenoController,
                                                        keyboardType: TextInputType.phone,
                                                        textInputAction: TextInputAction.next,                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                        prefixIcon: Icon(Icons.phone),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(
                                                            8.0,
                                                          ),
                                                        ),
                                                        hintText: AppLocalizations.of(context)!
                                                            .signuphinttext2,
                                                        hintStyle: TextStyle(
                                                          color: themeFlag
                                                              ? AppColors.metgoldenColor
                                                              : AppColors.blueZodiacTwo,
                                                        ),
                                                      ),
                                                        validator: (val) => val!.isEmpty
                                                            ? AppLocalizations.of(context)!
                                                            .signuphinttext2
                                                            : null,
                                                      ),
                                                      (constraints.maxWidth>500)?SizedBox(height: 20.0,):SizedBox(height: 10.0,),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter.deny(
                                                            RegExp(r'\s'),
                                                          ),
                                                        ],
                                                        controller: userEmailController,
                                                        keyboardType: TextInputType.emailAddress,
                                                        textInputAction: TextInputAction.next,
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                          prefixIcon: Icon(Icons.email_rounded),
                                                          hintText: AppLocalizations.of(context)!
                                                              .signuphinttext3,
                                                          hintStyle: TextStyle(
                                                            color: themeFlag
                                                                ? AppColors.metgoldenColor
                                                                : AppColors.blueZodiacTwo,
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                          ),
                                                        ),
                                                        validator: (val) =>
                                                        !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                                            .hasMatch(val!)
                                                            ? AppLocalizations.of(context)!
                                                            .signuphinttext3
                                                            : null,
                                                      ),
                                                      (constraints.maxWidth>500)?SizedBox(height: 20.0,):SizedBox(height: 10.0,),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter.deny(
                                                            RegExp(r'\s'),
                                                          ),
                                                        ],
                                                        onChanged: (val) {
                                                          authNotifier(false)
                                                              .checkPasswordStrength(password: val);
                                                        },
                                                        controller: userPassController,
                                                        obscureText: true,
                                                        textInputAction: TextInputAction.done,
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                          prefixIcon: Icon(Icons.lock),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                          ),
                                                          hintText: AppLocalizations.of(context)!
                                                              .signuphinttext4,
                                                          hintStyle: TextStyle(
                                                            color: themeFlag
                                                                ? AppColors.metgoldenColor
                                                                : AppColors.blueZodiacTwo,
                                                          ),
                                                        ),
                                                        validator: (val) => val!.isEmpty
                                                            ? AppLocalizations.of(context)!
                                                            .signuphinttext4
                                                            : null,
                                                      ),
                                                      if (authNotifier(true).passwordLevel! != '')Padding(
                                                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                                                        child: Row(
                                                          children: [
                                                            Text(authNotifier(true).passwordLevel!),
                                                            const SizedBox(
                                                              height: 10.0,
                                                            ),
                                                            if (authNotifier(true).passwordLevel! == 'Weak')
                                                              CustomAnimatedContainer.customAnimatedContainer(
                                                                height: 10,
                                                                width: MediaQuery.of(context).size.width * 0.10,
                                                                context: context,
                                                                color: Colors.red,
                                                                curve: Curves.easeIn,
                                                              ),
                                                            if (authNotifier(true).passwordLevel! == 'Medium')
                                                              CustomAnimatedContainer.customAnimatedContainer(
                                                                height: 10,
                                                                width: MediaQuery.of(context).size.width * 0.20,
                                                                context: context,
                                                                color: Colors.blue,
                                                                curve: Curves.easeIn,
                                                              ),
                                                            if (authNotifier(true).passwordLevel! == 'Strong')
                                                              CustomAnimatedContainer.customAnimatedContainer(
                                                                height: 10,
                                                                width: MediaQuery.of(context).size.width * 0.30,
                                                                context: context,
                                                                color: Colors.green,
                                                                curve: Curves.easeIn,
                                                              ),
                                                            Text(authNotifier(true).passwordEmoji!),
                                                          ],
                                                        ),
                                                      ),
                                                      (constraints.maxWidth>500)?SizedBox(height: 20.0,):SizedBox(height: 10.0,),
                                                      TextFormField(
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter.deny(
                                                            RegExp(r'\s'),
                                                          ),
                                                        ],
                                                        onChanged: (val) {
                                                          authNotifier(false)
                                                              .checkPasswordStrength(password: '');
                                                        },
                                                        controller: userCPassController,
                                                        obscureText: true,
                                                        textInputAction: TextInputAction.done,
                                                        decoration: InputDecoration(
                                                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                          prefixIcon: Icon(Icons.lock),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(
                                                              8.0,
                                                            ),
                                                          ),
                                                          hintText: AppLocalizations.of(context)!
                                                              .signuphinttext4,
                                                          hintStyle: TextStyle(
                                                            color: themeFlag
                                                                ? AppColors.metgoldenColor
                                                                : AppColors.blueZodiacTwo,
                                                          ),
                                                        ),
                                                        validator: (val) => val!.isEmpty
                                                            ? AppLocalizations.of(context)!
                                                            .signuphinttext4
                                                            : (val != userPassController.text)?'Password don\'t match':null,
                                                      ),
                                                      SizedBox(height: 24.0),
                                                      Center(
                                                        child: Text(
                                                          "Plase Select Your Type",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      ToggleButtons(
                                                        borderRadius:
                                                        const BorderRadius.all(Radius.circular(8)),
                                                        constraints: const BoxConstraints(
                                                          minHeight: 40.0,
                                                          minWidth: 140.0,
                                                        ),
                                                        disabledColor: AppColors.shedowgreyColor,
                                                        fillColor: AppColors.accountTypeSelection,
                                                        selectedColor: AppColors.white,
                                                        isSelected: isSelected,
                                                        onPressed: (int index) {
                                                          setState(() {
                                                            for (int i = 0; i < isSelected.length; i++) {
                                                              isSelected[i] = i == index;
                                                              if (index == 0) {
                                                                usertype = 'EMPLOYEE'.toString();
                                                              } else {
                                                                usertype = 'EMPLOYER'.toString();
                                                              }
                                                            }
                                                            print(usertype);
                                                          });
                                                        },
                                                        children: const <Widget>[
                                                          Text("EMPLOYEE"),
                                                          Text("EMPLOYER"),
                                                        ],
                                                      ),
                                                      SizedBox(height: 30.0,),
                                                      //TabBar(tabs: tabs)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 40,
                                                      padding: (constraints.maxWidth>500)?const EdgeInsets.symmetric(horizontal:40.0, vertical: 0.0):const EdgeInsets.symmetric(horizontal:20.0, vertical: 0.0),
                                                      child: MaterialButton(
                                                        //height: MediaQuery.of(context).size.height * 0.05,
                                                        //minWidth: MediaQuery.of(context).size.width * 0.8,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        onPressed: () async {
                                                          _createAccount();
                                                          // ShowForgotPassword.buildSignUpPopup(context);
                                                        },
                                                        color: AppColors.blueZodiacTwo,
                                                        child: isloading
                                                            ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              height: 24.0,
                                                              width: 24.0,
                                                              child: CircularProgressIndicator(
                                                                color: AppColors.white,
                                                                strokeWidth: 2.0,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                            : Text(
                                                          AppLocalizations.of(context)!.signuptextbutton,
                                                          style: TextStyle(
                                                            color: themeFlag
                                                                ? AppColors.metgoldenColor
                                                                : AppColors.creamColor,
                                                            fontSize: 17,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.signuptext6,
                                      style: TextStyle(
                                        color: themeFlag
                                            ? AppColors.metgoldenColor
                                            : AppColors.blueZodiacTwo,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                                        Navigator.pop(context);
                                      },
                                      //
                                      child: Text(
                                        AppLocalizations.of(context)!.signuptext7,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: themeFlag
                                              ? AppColors.metgoldenColor
                                              : AppColors.blueZodiacTwo,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  _createAccount() {
    if (_formKey.currentState!.validate() && !isloading ) {
      setState(() {
        isloading = true;
      });
      authNotifier(false)
          .createAccount(
          context: context,
          useremail: userEmailController.text,
          username: userNameController.text,
          userpassword: userPassController.text,
          usermobileno: usermobilenoController.text,
          usertype: usertype,
          device_token: devicetoken)
          .then((void nothing) {
        setState(() {
          isloading = false;
        });
      });
    }
  }
}
