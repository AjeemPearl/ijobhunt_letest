// ignore_for_file: prefer_const_constructors
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/models/user.model.dart';
import 'package:ijobhunt/core/notifiers/theme.notifier.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/screens/ProfileScreen/user.job.form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  var token = '';

  UserProfile({
    super.key,
    required this.token,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    var themeFlag = themeNotifier.darkTheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.white,
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 12.0),
        //     child: IconButton(
        //       onPressed: () {
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => UserForm(),
        //           ),
        //         );
        //         // print(snapshot.data!.name);
        //       },
        //       icon: FaIcon(
        //         FontAwesomeIcons.userEdit,

        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: FutureBuilder<UserModel?>(
        future: UserProFile.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shedowgreyColor,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    image: snapshot.data!.user!.image != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              'http://www.ijobshunts.com/storage/app/public/${snapshot.data!.user!.image}',
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: AssetImage(
                                              "assets/images/employerhome/user.png",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                    left: 15.0,
                                  ),
                                  child: Container(
                                    width: 200,
                                    // color: Colors.red,
                                    child: Text(
                                      "${snapshot.data!.user!.name}",
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 5.0,
                              top: 2.0,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserForm(),
                                    ),
                                  );
                                  // print(snapshot.data!.name);
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.userEdit,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.email} : ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: AppColors.blueZodiacTwo,
                                  ),
                                ),
                                Text(
                                  "${snapshot.data!.user!.email}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: AppColors.blueZodiacTwo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15.0, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.phone} : ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: AppColors.blueZodiacTwo,
                                  ),
                                ),
                                Text(
                                  "${snapshot.data!.user!.phone}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: AppColors.blueZodiacTwo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 2.5,
                          thickness: 1.5,
                          color: AppColors.blueZodiacTwo,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 15.0, left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.aboutMe,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.dob}: ${snapshot.data!.user!.dateofbirth}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.profession} : ${snapshot.data!.user!.profession}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.companyaddtext10} : ${snapshot.data!.user!.address}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.companyaddtext7} : ${snapshot.data!.user!.country}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.bio} : ${snapshot.data!.user!.aboutyourself}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 15.0, left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .educationinfromation,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.degree} : ${snapshot.data!.user!.degreetitle}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.institute} : ${snapshot.data!.user!.institutename}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.startdate} : ${snapshot.data!.user!.degreestartdate}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.enddate} : ${snapshot.data!.user!.degreeenddate}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.percent} : ${snapshot.data!.user!.degreepercent}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.grade} : ${snapshot.data!.user!.degreegrade}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.details} : ${snapshot.data!.user!.degreedetails}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 15.0, left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .professionalInformation,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.orgname}  : ${snapshot.data!.user!.organizationname}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.jobstartDate}  : ${snapshot.data!.user!.jobstartDate}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.jobendDate} : ${snapshot.data!.user!.jobendDate}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.role} : ${snapshot.data!.user!.yourole}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.jobdetails} : ${snapshot.data!.user!.jobdetails}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      color: AppColors.blueZodiacTwo,
                                    ),
                                  ),
                                ],
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
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
