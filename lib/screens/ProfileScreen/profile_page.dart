// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/user.model.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/ProfileScreen/widgets/text_widget.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.keys.dart';
import '../../core/notifiers/langaugeChangeprovider.dart';
import '../../core/notifiers/theme.notifier.dart';

import '../../l10n/l10n.dart';
import '../companyscreen/add.company.dart';
import '../homescreens/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var token = '';
  var emptype = '';
  var compdata = '';
  Future gettokendata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    compdata = pref.getString('status') ?? '';
    emptype = pref.getString('usertype') ?? '';

    setState(() {
      token = token;
      compdata = compdata;
      emptype = emptype;
    });
  }

  Future<UserModel> updateuser({
    required token,
    required user_type,
  }) async {
    Map data = {'token': token, 'user_type': user_type};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.updateuser,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: "Details Updated sucessfully", context: context));
      return UserModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception();
    }
  }

  // void checkLogin() {
  //   if (emptype == 'EMPLOYEE') {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const HomePage(),
  //       ),
  //     );
  //   } else if (emptype == 'EMPLOYER' && compdata == '0' || compdata == 0) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const AddCompany(),
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const BottomNavBar(),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    // checkLogin();
    gettokendata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlag = Provider.of<ThemeNotifier>(context).darkTheme;
    return Consumer<LanguageChangeProvider>(builder: (context, notifier, _) {
      var langauge = notifier.locale ?? Localizations.localeOf(context);
      return Scaffold(
        backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: themeFlag ? AppColors.creamColor : AppColors.mirage,
        //   foregroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
        //   child: Icon(themeFlag ? Icons.nightlight : Icons.sunny),
        //   onPressed: () {
        //     Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
        //   },
        // ),
        body: LayoutBuilder(
          builder: (context, Constraints) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              // dropdownWidth: 160,
                              // dropdownPadding:
                              //     const EdgeInsets.symmetric(vertical: 6),
                              // dropdownDecoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(4),
                              //   //color: Colors.redAccent,
                              // ),
                              customButton: const FaIcon(
                                FontAwesomeIcons.language,
                                size: 35,
                                color: Colors.blue,
                              ),
                              //buttonWidth: 215,
                              hint: const Text("Chose Language"),
                              value: langauge,
                              onChanged: ((Locale? value) {
                                setState(() {
                                  notifier.changeLocale(value!);
                                });
                              }),
                              items: L10n.all
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        L10n.getlangauge(e.languageCode)
                                            .toString(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    const TextWidget(),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        bottom: 15.0,
                      ),
                      child: GestureDetector(
                        onTap: (() {
                          if (mounted) {
                            setState(() {
                              updateuser(token: token, user_type: 'EMPLOYEE')
                                  .whenComplete(
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                ),
                              );
                            });
                          }
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: themeFlag
                                ? AppColors.mirage
                                : AppColors.creamColor,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: themeFlag
                                      ? AppColors.blackPearl
                                      : AppColors.shedowgreyColor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.employeetext1,
                                  style: TextStyle(
                                    color: themeFlag
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.employeetext2,
                                  style: TextStyle(
                                    color: themeFlag
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateuser(token: token, user_type: 'EMPLOYER')
                                .then(
                              (value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddCompany(),
                                ),
                              ),
                            );
                          });
                          // ignore: avoid_print

                          // ignore: unrelated_type_equality_checks
                        },
                        child: Container(
                          //alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: themeFlag
                                ? AppColors.mirage
                                : AppColors.creamColor,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: themeFlag
                                      ? AppColors.blackPearl
                                      : AppColors.shedowgreyColor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.text1,
                                  style: TextStyle(
                                    color: themeFlag
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.employertext,
                                  style: TextStyle(
                                    color: themeFlag
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
