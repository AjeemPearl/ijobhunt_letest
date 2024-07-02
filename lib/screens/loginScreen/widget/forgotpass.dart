import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/notifiers/forgotepassword.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/loginScreen/widget/showdialogbox.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  TextEditingController emialcontroller = TextEditingController();
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
        title: Text(AppLocalizations.of(context)!.forgotpassword),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
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
                      controller: emialcontroller,
                      //autofocus: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.signuphinttext3,
                        hintStyle: TextStyle(color: AppColors.blackPearl),
                      ),
                      validator: (val) =>
                          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(val!)
                              ? 'Please Enter a valid email address'
                              : null,
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
                              ForgotePassrdAuthantication.forgotePassword(
                                      email: emialcontroller.text,
                                      context: context)
                                  .then((void nothing) {
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
                                  AppLocalizations.of(context)!.contti,
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
