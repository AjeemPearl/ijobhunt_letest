import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/core/notifiers/langaugeChangeprovider.dart';
import 'package:ijobhunt/l10n/l10n.dart';
import 'package:ijobhunt/screens/companyscreen/company.job.dart';
import 'package:ijobhunt/screens/companyscreen/edit.company.dart';
import 'package:ijobhunt/screens/employerscreen/employer.home.dart';
import 'package:ijobhunt/screens/employerscreen/employeraccount.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/authentication.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/searchScreen/candidate.search.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.keys.dart';
import '../../app/routes/api.routes.dart';
import '../../core/models/company_model.dart';
import '../../core/notifiers/theme.notifier.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CompanyData> companydata = [];
  var token = '';
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
      // print(response);
      return CompanyData.fromJson(
        jsonDecode(response.body),
      );
    }
    isloading = false;
  }


  Future gettokendata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    setState(() {
      token = token;
      // ignore: avoid_print
      //print("token is new $token");
    });
  }

  @override
  void initState() {
    gettokendata();
    getCompanydata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;
    return Consumer<LanguageChangeProvider>(builder: (context, notifier, _) {
      var langauge = notifier.currentLocale ?? Localizations.localeOf(context);
      return Scaffold(
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCompany(
                          // compnayname: compnayname,
                          // companyaddress: companyaddress,
                          // noofemployee: noofemployee,
                          // aboutcompany: aboutcompany,
                          // employername: employername,
                          // employerphone: employerphone,
                          ),
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
                  //AppLocalizations.of(context)!.drawertextemployer,
                  'Company Profile',
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
                  //AppLocalizations.of(context)!.drawertextemployer,
                  'Search Candidate',
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
              // ListTile(
              //   leading: FaIcon(
              //     FontAwesomeIcons.circleUser,
              //     color: AppColors.blackPearl,
              //     size: MediaQuery.of(context).size.height / 50,
              //   ),
              //   title: Text(
              //     AppLocalizations.of(context)!.drawertextemployer,
              //     style: TextStyle(
              //         fontSize: MediaQuery.of(context).size.height / 50,
              //         color: AppColors.blackPearl,
              //         fontWeight: FontWeight.w400),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const BottomNavBar(
              //             //token: token,
              //             ),
              //       ),
              //     );
              //   },
              // ),
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

                  // // );SharedPreferences preferences =

                  // try {
                  //   await GoogleSignInApi og(context: context)
                  //       .whenComplete(
                  //     () => Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => LoginScreen(),
                  //       ),
                  //     ),
                  //   );
                  // } catch (e) {
                  //   print("error is ${e}");
                  // }
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
                  //    buttonElevation: 0,
                  //     buttonDecoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
                  //     dropdownDecoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(14),
                  //     ),
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
                    SizedBox(height: MediaQuery.of(context).size.height / 8.5),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height / 10),
                        child: Text(AppLocalizations.of(context)!.drawertext14,
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
                        final Uri url =
                            Uri.parse('https://in.pinterest.com/infoijobhunt/');
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
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                paymentstatus = snapshot.data!.paymentStatus.toString();

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.company!.length,
                    itemBuilder: (context, index) {
                      compnayname = snapshot
                          .data!.company![index].comapnyName
                          .toString();
                      companyaddress = snapshot
                          .data!.company![index].address
                          .toString();
                      noofemployee = snapshot
                          .data!.company![index].noOfEmployee
                          .toString();
                      employername = snapshot
                          .data!.company![index].employerName
                          .toString();
                      aboutcompany = snapshot
                          .data!.company![index].aboutCompany
                          .toString();
                      employerphone = snapshot
                          .data!.company![index].phoneNumber
                          .toString();
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.27,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: themeFlage
                                      ? AppColors.mirage
                                      : AppColors.blueZodiacTwo,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "http://www.ijobshunts.com/storage/app/public/${snapshot.data!.company![index].image}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        //showExitPopup();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const BottomNavBar(),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_outlined,
                                        color: themeFlage
                                            ? AppColors.metgoldenColor
                                            : AppColors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _scaffoldKey.currentState!
                                            .openEndDrawer();
                                      },
                                      icon: Icon(
                                        Icons.menu,
                                        color: themeFlage
                                            ? AppColors.metgoldenColor
                                            : AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * 0.10,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.companyprofiletext1}: ${snapshot.data!.company![index].comapnyName}",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.companyprofiletext2}: ${snapshot.data!.company![index].address.toString()}",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 2.5,
                                thickness: 0.5,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    15.0,
                                  ),
                                  height: 100,
                                  width:
                                  MediaQuery.of(context).size.width,
                                  //color: Colors.yellow,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color:
                                            AppColors.blueZodiacTwo,
                                          ),
                                          Text(
                                            "${AppLocalizations.of(context)!.companyprofiletext3}",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              AppColors.blueZodiacTwo,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.company![index]
                                                .phoneNumber
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackPearl,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Column(
                                      //   children: [
                                      //     Icon(
                                      //       Icons.email,
                                      //       color:
                                      //           AppColors.blueZodiacTwo,
                                      //     ),
                                      //     Text(
                                      //       "${AppLocalizations.of(context)!.companyprofiletext4}",
                                      //       style: TextStyle(
                                      //         fontSize: 15.0,
                                      //         fontWeight: FontWeight.w600,
                                      //         color: AppColors.blackPearl,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       snapshot.data!.company![index]
                                      //           .noOfEmployee
                                      //           .toString(),
                                      //       style: TextStyle(
                                      //         fontSize: 14.0,
                                      //         fontWeight: FontWeight.w600,
                                      //         color: AppColors.blackPearl,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      Column(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color:
                                            AppColors.blueZodiacTwo,
                                          ),
                                          Text(
                                            "${AppLocalizations.of(context)!.employeetext1}",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackPearl,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.company![index]
                                                .noOfEmployee
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackPearl,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1.5,
                                thickness: 0.5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                  15.0,
                                ),
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.yellow,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CompanyPostedJobs(
                                                  // jobid: snapshot
                                                  //     .data!
                                                  //     .company![index]
                                                  //     .myJobs![index]
                                                  //     .id
                                                  //     .toString(),
                                                  token: token,
                                                  companyname: snapshot
                                                      .data!
                                                      .company![index]
                                                      .comapnyName
                                                      .toString(),
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.05,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.40,
                                        decoration: BoxDecoration(
                                          color: AppColors.blueZodiacTwo,
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          "${AppLocalizations.of(context)!.companyprofileviewjobs}",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const EmployerAccount(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.05,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.40,
                                        decoration: BoxDecoration(
                                          color: AppColors.blueZodiacTwo,
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          "${AppLocalizations.of(context)!.companyprofileaddjobs}",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                  15.0,
                                ),
                                //height: MediaQuery.of(context).size.height * 0.26,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.yellow,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.companyprofiletext5} ${snapshot.data!.company![index].comapnyName}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                      ),
                                      child: Divider(
                                        height: 1.5,
                                        thickness: 0.5,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.company![index]
                                          .aboutCompany
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              } else {
                return const Padding(
                  padding: EdgeInsets.only(top: 110.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      );
    });
  }

}
