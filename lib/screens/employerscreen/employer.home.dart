import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:appbar_animated/appbar_animated.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/company_model.dart';
import 'package:ijobhunt/core/models/recomendedcandidates.dart';
import 'package:ijobhunt/core/notifiers/companynotifire.dart';
import 'package:ijobhunt/core/notifiers/langaugeChangeprovider.dart';
import 'package:ijobhunt/l10n/l10n.dart';
import 'package:ijobhunt/screens/companyscreen/company.job.dart';
import 'package:ijobhunt/screens/companyscreen/company.profie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ijobhunt/screens/companyscreen/edit.company.dart';
import 'package:ijobhunt/screens/employerscreen/candidatedetails.dart';
import 'package:ijobhunt/screens/employerscreen/employeraccount.dart';
import 'package:ijobhunt/screens/employerscreen/employerlikedjobs.dart';
import 'package:ijobhunt/screens/employerscreen/matchedcandidates.dart';
import 'package:ijobhunt/screens/homescreens/widgets/showqusetiondilog.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/applesignin.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/authentication.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/searchScreen/candidate.search.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/preferences/app_preferences.dart';
import '../inapppurches/Paywall.dart';

class EmployerHome extends StatefulWidget {
  const EmployerHome({super.key});

  @override
  State<EmployerHome> createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CompanyData> companydata = [];
  var token = AppPreferences.getUserData();
  var uname = '';
  bool isloading = false;
  var paymentstatus = '';
  var compnayname = '';
  var noofemployee = '';
  var employername = '';
  var employerphone = '';
  var aboutcompany = '';
  var companyaddress = '';
  Future<CompanyData?> getCompanydata() async {
    isloading = true;
    Map data = {'token': token};
    final response = await http.post(
      Uri.parse(ApiRoutes.getcompanydata),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {


      print("token===employer="+token);
      // print(response);
      return CompanyData.fromJson(
        jsonDecode(response.body),
      );
    }
    isloading = false;
  }


  /*Future gettokendata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    setState(() {
      token = token;
      // ignore: avoid_print
      //print("token is new $token");
    });
  }*/

  @override
  void initState() {
    getCompanydata();
    //gettokendata();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
    Provider.of<AppleSignInAvailable>(context, listen: false);
    return Consumer<LanguageChangeProvider>(builder: (context, notifier, _) {
      var langauge = notifier.locale;
      return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width / 1,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: const EdgeInsets.only(bottom: 0),

                  ///***  Header of Drawer
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Image(
                        image: const AssetImage("assets/images/logo/logo2.png"),
                        height: MediaQuery.of(context).size.height / 12,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.home,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.drawertext3,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployerHome(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.edit,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.drawertext17,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCompany(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.building,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.companyprofile,
                    //'Company Profile',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyProfile(
                          //token: token,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.search,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.searchcandidate,
                    //'Search Candidate',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CandidateSearch(
                          //token: token,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    Icons.payments,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.buySubscription,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => DemoPage(userType: 'employer'),
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SearchScreen(
                    //       //country: selectedcountry,
                    //       token: token,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.drawerlogoutbutton,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    if (Authentication.islogin == true) {
                      if (mounted) {
                        setState(() {
                          FacebookAuth.instance.logOut().whenComplete(() async {
                            SharedPreferences preferences =
                            await SharedPreferences.getInstance();
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
                        });
                      }
                    } else if (token.isNotEmpty) {
                      SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                      preferences.remove(AppKeys.userData).whenComplete(() {
                        setState(() {
                          isloading = false;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      });
                    }
                    Authentication.signOut(context: context);
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.trash,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.deleteaccount,

                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: AppColors.blackPearl,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () async {
                    ShowMyDialog.showDeletePopup(context: context);
                    // UserProFile.deleteAccount(context: context)
                    //     .whenComplete(() async {
                    //   if (Authentication.islogin == true) {
                    //     if (mounted) {
                    //       setState(() {
                    //         FacebookAuth.instance
                    //             .logOut()
                    //             .whenComplete(() async {
                    //           SharedPreferences preferences =
                    //           await SharedPreferences.getInstance();
                    //           preferences.remove(AppKeys.userData).whenComplete(
                    //                 () => Navigator.pushReplacement(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => LoginScreen(),
                    //               ),
                    //             ),
                    //           );
                    //         });
                    //         print("User Signed Out");
                    //       });
                    //     }
                    //   } else if (appleSignInAvailable.isAvailable) {
                    //     await FirebaseAuth.instance
                    //         .signOut()
                    //         .whenComplete(() {});
                    //   } else if (token.isNotEmpty) {
                    //     setState(() {
                    //       isloading = true;
                    //     });
                    //     SharedPreferences preferences =
                    //     await SharedPreferences.getInstance();
                    //     preferences.remove(AppKeys.userData).whenComplete(() {
                    //       setState(() {
                    //         isloading = false;
                    //       });
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => LoginScreen(),
                    //         ),
                    //       );
                    //     });
                    //   }
                    //   Authentication.signOut(context: context);
                    // });
                  },
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.language,
                    color: AppColors.blackPearl,
                    size: MediaQuery.of(context).size.height / 50,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DropdownButton2(
                        hint: const Text("Choose Langauge"),
                        // buttonElevation: 0,
                        // buttonDecoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(14),
                        // ),
                        // dropdownDecoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(14),
                        // ),
                        isExpanded: true,
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
                              L10n.getlangauge(e.languageCode).toString(),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 8.5),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.height / 10),
                          child: Text(
                              AppLocalizations.of(context)!.drawertext14,
                              style: TextStyle(color: AppColors.blackPearl)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://www.facebook.com/profile.php?id=100089006524415');
                          await launchUrl(url);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: AppColors.blueZodiac,
                          size: MediaQuery.of(context).size.width / 25,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.envelope,
                          color: AppColors.rawSienna,
                          size: MediaQuery.of(context).size.height / 55,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.twitter,
                          color: Colors.blue,
                          size: MediaQuery.of(context).size.height / 55,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.linkedin,
                          color: Colors.blueAccent,
                          size: MediaQuery.of(context).size.height / 55,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://www.instagram.com/info.ijobhunt/');
                          await launchUrl(url);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Colors.purpleAccent,
                          size: MediaQuery.of(context).size.height / 55,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(
                              'https://in.pinterest.com/infoijobhunt/');
                          await launchUrl(url);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.pinterest,
                          color: Colors.redAccent,
                          size: MediaQuery.of(context).size.width / 25,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: MediaQuery.of(context).size.height / 350),
                Padding(
                  padding: EdgeInsets.only(
                    // bottom: MediaQuery.of(context).size.height / 75,
                      left: MediaQuery.of(context).size.height / 75),
                  child: const Text("ⓒ2023 iJobhunt"),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.drawertext11,
                          style: TextStyle(color: AppColors.blackPearl),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.drawertext12,
                          style: TextStyle(
                            color: AppColors.blackPearl,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppLocalizations.of(context)!.drawertext13,
                          style: TextStyle(
                            color: AppColors.blackPearl,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: FutureBuilder<CompanyData?>(
            future: getCompanydata(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.company!.isNotEmpty) {
                return ScaffoldLayoutBuilder(
                  backgroundColorAppBar: ColorBuilder(
                    Colors.transparent,
                    AppColors.blueZodiac,
                  ),
                  textColorAppBar: const ColorBuilder(Colors.white),
                  appBarBuilder: (context, colorAnimated) {
                    return AppBar(
                      backgroundColor: colorAnimated.background,
                      elevation: 5,
                      title: Text(
                        "Welcome ${snapshot.data!.company![0].comapnyName}",
                        style: TextStyle(
                          color: colorAnimated.color,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          showExitPopup();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: colorAnimated.color,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: colorAnimated.color,
                          ),
                        ),
                      ],
                    );
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            image: const DecorationImage(
                                filterQuality: FilterQuality.none,
                                image: AssetImage(
                                  "assets/images/employerhome/companybackground.jpg",
                                ),
                                fit: BoxFit.cover),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 110.0),
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      'http://www.ijobshunts.com/storage/app/public/${snapshot.data!.company![0].image}',
                                    ),
                                    fit: BoxFit.cover),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  160,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blackPearl,
                                    blurRadius: 5,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.5,
                          thickness: 2.5,
                          color: AppColors.blueZodiacTwo,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.38,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 2.5,
                                              spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          gradient: const RadialGradient(
                                            colors: [
                                              Color.fromARGB(255, 210, 70, 235),
                                              Color.fromARGB(255, 164, 8, 192),
                                              Color.fromARGB(255, 124, 4, 145),
                                              Color.fromARGB(255, 66, 5, 77),
                                              Color.fromARGB(255, 69, 0, 82),
                                            ],
                                            tileMode: TileMode.repeated,
                                            stops: [
                                              0.2,
                                              0.5,
                                              1.7,
                                              0.5,
                                              1.0,
                                            ],
                                            center: Alignment(
                                              1.0,
                                              1.0,
                                            ),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 8.0,
                                              right: 10.0,
                                              //left: 10,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith(
                                                            (states) => Colors
                                                            .purpleAccent)),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                      const EmployerAccount(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .add,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                    GoogleFonts.lato()
                                                        .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0,
                                              right: 10.0,
                                              left: 10,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: AppLocalizations.of(
                                                        context)!
                                                        .newjob,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontFamily:
                                                      GoogleFonts.lato()
                                                          .fontFamily,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations
                                                            .of(context)!
                                                            .employerhomeAddjob,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                          GoogleFonts.lato()
                                                              .fontFamily,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 2.5,
                                              spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          gradient: const RadialGradient(
                                            colors: [
                                              Color.fromARGB(255, 235, 158, 70),
                                              Color.fromARGB(255, 192, 106, 8),
                                              Color.fromARGB(255, 124, 4, 145),
                                              Color.fromARGB(255, 66, 5, 77),
                                              Color.fromARGB(255, 69, 0, 82),
                                            ],
                                            tileMode: TileMode.repeated,
                                            stops: [
                                              0.2,
                                              0.5,
                                              1.7,
                                              0.5,
                                              1.0,
                                            ],
                                            center: Alignment(
                                              1.0,
                                              1.0,
                                            ),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 8.0,
                                              right: 10.0,
                                              //left: 10,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateColor
                                                        .resolveWith(
                                                            (states) => Color
                                                            .fromARGB(
                                                            255,
                                                            255,
                                                            195,
                                                            64))),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                      const MatchedCandidates(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .view,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                    GoogleFonts.lato()
                                                        .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0,
                                              right: 10.0,
                                              left: 10,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: AppLocalizations.of(
                                                        context)!
                                                        .employermathcedcandidate,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontFamily:
                                                      GoogleFonts.lato()
                                                          .fontFamily,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations
                                                            .of(context)!
                                                            .employermathcedcandidatetext,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                          GoogleFonts.lato()
                                                              .fontFamily,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 2.5,
                                              spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          gradient: const RadialGradient(
                                            colors: [
                                              Colors.blueAccent,
                                              Color.fromARGB(255, 32, 110, 173),
                                              Color.fromARGB(255, 30, 4, 145),
                                              Color.fromARGB(255, 65, 8, 158),
                                              Color.fromARGB(255, 0, 59, 82),
                                            ],
                                            tileMode: TileMode.repeated,
                                            stops: [
                                              0.2,
                                              0.5,
                                              1.7,
                                              0.5,
                                              1.0,
                                            ],
                                            center: Alignment(
                                              1.0,
                                              1.0,
                                            ),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 8.0,
                                              right: 10.0,
                                              //left: 10,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith(
                                                        (states) => Color.fromARGB(
                                                        255, 87, 62, 199),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CompanyPostedJobs(
                                                            token: token,
                                                            companyname: snapshot
                                                                .data!
                                                                .company![0]
                                                                .comapnyName
                                                                .toString(),
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .clickHere,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                    GoogleFonts.lato()
                                                        .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0,
                                              right: 10.0,
                                              left: 10,
                                              child: RichText(
                                                text: TextSpan(
                                                    text: AppLocalizations.of(
                                                        context)!
                                                        .viewJobs,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontFamily:
                                                      GoogleFonts.lato()
                                                          .fontFamily,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                        AppLocalizations.of(
                                                            context)!
                                                            .viewJobstext,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                          GoogleFonts.lato()
                                                              .fontFamily,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Container(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(15.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black45,
                                              blurRadius: 2.5,
                                              spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                          gradient: const RadialGradient(
                                            colors: [
                                              Color.fromARGB(255, 70, 224, 235),
                                              Color.fromARGB(255, 4, 131, 153),
                                              Color.fromARGB(255, 58, 144, 155),
                                              Color.fromARGB(255, 66, 5, 77),
                                              Color.fromARGB(255, 69, 0, 82),
                                            ],
                                            tileMode: TileMode.repeated,
                                            stops: [
                                              0.2,
                                              0.5,
                                              1.7,
                                              0.5,
                                              1.0,
                                            ],
                                            center: Alignment(
                                              1.0,
                                              1.0,
                                            ),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              bottom: 8.0,
                                              right: 10.0,
                                              //left: 10,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith(
                                                        (states) => Color.fromARGB(
                                                        255, 3, 59, 66),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                      const CandidateSearch(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .search,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                    GoogleFonts.lato()
                                                        .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8.0,
                                              right: 10.0,
                                              left: 10,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: AppLocalizations.of(
                                                      context)!
                                                      .searchcandidate,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                    GoogleFonts.lato()
                                                        .fontFamily,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: AppLocalizations.of(
                                                          context)!
                                                          .searchcandidate1,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.0,
                                                        fontFamily:
                                                        GoogleFonts.lato()
                                                            .fontFamily,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                      ),
                                                    )
                                                  ],
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
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.02,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 200.0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .resentActiveties,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.grey,
                                        blurRadius: 2.5,
                                        // spreadRadius: 0.5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyPostedJobs(
                                                companyname: compnayname,
                                                token: token,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff000c66),
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2.5,
                                            spreadRadius: 0.5,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .recentlyPostedJobs,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                          GoogleFonts.lato().fontFamily,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.grey,
                                              blurRadius: 2.5,
                                              // spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const EmployerLikedJobs(),
                                        ),
                                      );
                                    }),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff000c66),
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2.5,
                                            spreadRadius: 0.5,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .markedFavourite,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily:
                                          GoogleFonts.lato().fontFamily,
                                          shadows: const [
                                            Shadow(
                                              color: Colors.grey,
                                              blurRadius: 2.5,
                                              // spreadRadius: 0.5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.02,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 180.0,
                                  top: 15.0,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .recomendedForYou,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.grey,
                                        blurRadius: 2.5,
                                        // spreadRadius: 0.5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height * 0.40,
                                  //color: Colors.red,
                                  child: FutureBuilder<RecomndedCandidates?>(
                                      future: EmployerCompanydata
                                          .getReomndedCandidate(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.status == true) {
                                          return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                              snapshot.data!.user!.length,
                                              itemBuilder: (context, index) {
                                                var data =
                                                snapshot.data!.user![index];
                                                return Padding(
                                                  padding:
                                                  const EdgeInsets.all(2.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              CandidateDetails(
                                                                jobid: data.id
                                                                    .toString(),
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        top: 8.0,
                                                        bottom: 8.0,
                                                        left: 12.0,
                                                        right: 12.0,
                                                      ),
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                data.name
                                                                    .toString(),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize:
                                                                  18.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Text(
                                                                data.email
                                                                    .toString(),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize:
                                                                  15.0,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const FaIcon(
                                                              FontAwesomeIcons
                                                                  .angleDoubleRight)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return const Center(
                                            child: Text(
                                                "No Recomended Candidate Found"),
                                          );
                                        }
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.blueZodiacTwo,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10.0,
                                left: 10.0,
                                child: Text(
                                  "ⓒ2023 iJobhunt",
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 8.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        _launchAccessibilityURL();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .drawertext11,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _launchPrivacyURL();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .drawertext12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 45,
                                child: TextButton(
                                  onPressed: () {
                                    _launchTeramURL();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.drawertext15,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(top: 110.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      );

    });
  }

  _launchURL() async {
    const url = 'https://www.ijobhunts.com/about-us';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchPrivacyURL() async {
    const url = 'https://www.ijobhunts.com/privacy-policy';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTeramURL() async {
    const url = 'https://www.ijobhunts.com/terms-and-condition';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchAccessibilityURL() async {
    const url = 'https://www.ijobhunts.com/accessibility';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
