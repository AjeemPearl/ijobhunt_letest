import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/notifiers/forgotepassword.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/widgets/custombox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController confrimpasswordcontroller = TextEditingController();
  String? passwordEmoji = "";
  bool passwordVisible = true;
  bool confrimpassword = true;
  String? passwordLevel = "";
  bool isloading = false;
  void checkPasswordStrength({required String password}) {
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if (password.contains(RegExp(strongPattern))) {
      passwordEmoji = '🚀';
      passwordLevel = 'Strong';
    } else if (password.contains(RegExp(mediumPattern))) {
      passwordEmoji = '🔥';
      passwordLevel = 'Medium';
    } else if (!password.contains(RegExp(strongPattern))) {
      passwordEmoji = '😢';
      passwordLevel = 'Weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.white,
          ),
        ),
        title: Text(AppLocalizations.of(context)!.resetpassword),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'\s'),
                        ),
                      ],
                      obscureText: passwordVisible,
                      onChanged: (value) {
                        checkPasswordStrength(password: value);
                      },
                      controller: newpasswordcontroller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.newpass,
                        hintStyle: TextStyle(color: AppColors.blackPearl),
                      ),
                      validator: (val) =>
                          !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                  .hasMatch(val!)
                              ? 'Plaease enter a Strong Password'
                              : null),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  child: TextFormField(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    controller: confrimpasswordcontroller,
                    obscureText: confrimpassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confrimpassword = !confrimpassword;
                          });
                        },
                        icon: Icon(
                          confrimpassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      hintText: AppLocalizations.of(context)!.confirmpass,
                      hintStyle: TextStyle(color: AppColors.blackPearl),
                    ),
                    validator: (val) => val!.isEmpty
                        ? 'Please Enter a Valid Password'
                        : val != newpasswordcontroller.text.toString()
                            ? 'Password not matched'
                            : null,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 2.0),
                    child: Row(
                      children: [
                        Text(passwordEmoji!),
                        const SizedBox(
                          height: 10.0,
                        ),
                        if (passwordLevel! == 'Weak')
                          CustomAnimatedContainer.customAnimatedContainer(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.10,
                            context: context,
                            color: Colors.red,
                            curve: Curves.easeIn,
                          ),
                        if (passwordLevel! == 'Medium')
                          CustomAnimatedContainer.customAnimatedContainer(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.40,
                            context: context,
                            color: Colors.blue,
                            curve: Curves.easeIn,
                          ),
                        if (passwordLevel! == 'Strong')
                          CustomAnimatedContainer.customAnimatedContainer(
                            height: 10,
                            width: MediaQuery.of(context).size.width * 0.70,
                            context: context,
                            color: Colors.green,
                            curve: Curves.easeIn,
                          ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          ForgotePassrdAuthantication.updatePassword(
                                  password: confrimpasswordcontroller.text,
                                  context: context)
                              .then((void nomethod) {
                            setState(() {
                              isloading = false;
                            });
                          });
                        }
                      },
                      style: ButtonStyle(
                        // side: MaterialStateBorderSide.resolveWith((states) => BorderRadius.all(context),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.blueZodiacTwo,
                        ),
                      ),
                      child: isloading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              AppLocalizations.of(context)!.companyaddtext11,
                              style: const TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
