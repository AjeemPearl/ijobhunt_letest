import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/notifiers/companynotifire.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/models/recomendedcandidates.dart';

class CandidateDetails extends StatefulWidget {
  var jobid = '';

  CandidateDetails({super.key, required this.jobid});

  @override
  State<CandidateDetails> createState() => _CandidateDetailsState();
}

class _CandidateDetailsState extends State<CandidateDetails> {
  bool stillworking = false;
  Future init() async {
    final userDetials =
        await EmployerCompanydata.getCandidateDetails(id: widget.jobid);
    if (mounted) {
      userDetails = userDetials!;
      print(userDetials);
    }
  }

  List<User> userDetails = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.blueZodiacTwo,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
            );
          },
        ),
        title: Text(AppLocalizations.of(context)!.canditateDetails),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: FutureBuilder<List<User>?>(
          future: EmployerCompanydata.getCandidateDetails(id: widget.jobid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: userDetails.length,
                itemBuilder: (context, index) {
                  if (userDetails[index].stillWorking == 'true') {
                    stillworking = true;
                  } else {
                    stillworking = false;
                  }
                  return Column(
                    children: [
                      Card(
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Personal Information",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Name :"),
                                    Text(" ${userDetails[index].name}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Email :"),
                                    Text(" ${userDetails[index].email}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Phone :"),
                                    Text(" ${userDetails[index].phone}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Date Of birth :"),
                                    Text(" ${userDetails[index].dateofbirth}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Address :"),
                                    Text(" ${userDetails[index].address}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Profession :"),
                                    Text(" ${userDetails[index].profession}")
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'About : ',
                                    style: TextStyle(
                                      color: AppColors.mirage,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${userDetails[index].aboutyourself}')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Educaion Information",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Degree :"),
                                    Text(" ${userDetails[index].degreetitle}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Start Date :"),
                                    Text(
                                        " ${userDetails[index].degreestartdate}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("End Date :"),
                                    Text(" ${userDetails[index].degreeenddate}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Institute Name :"),
                                    Text(" ${userDetails[index].institutename}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Percentage :"),
                                    Text(" ${userDetails[index].degreepercent}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Grade :"),
                                    Text(" ${userDetails[index].degreegrade}")
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Details : ',
                                    style: TextStyle(
                                      color: AppColors.mirage,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${userDetails[index].degreedetails}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Porfessional Information",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Organization Name :"),
                                    Text(
                                        " ${userDetails[index].organizationname}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Job Title :"),
                                    Text(" ${userDetails[index].jobTitle}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Role :"),
                                    Text(" ${userDetails[index].yourole}")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Job Start Date :"),
                                    Text(" ${userDetails[index].jobstartDate}")
                                  ],
                                ),
                                Visibility(
                                  visible: stillworking == false,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Resign Date :"),
                                      Text(" ${userDetails[index].jobendDate}")
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: stillworking == true,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("Still Working"),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Details : ',
                                    style: TextStyle(
                                      color: AppColors.mirage,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${userDetails[index].jobdetails}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
