import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/models/employerlikedjobs.dart';
import 'package:ijobhunt/core/notifiers/jobsdata.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployerLikedJobs extends StatefulWidget {
  const EmployerLikedJobs({super.key});

  @override
  State<EmployerLikedJobs> createState() => _EmployerLikedJobsState();
}

class _EmployerLikedJobsState extends State<EmployerLikedJobs> {
  @override
  void initState() {
    FebJobs.employerLikedJobs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueZodiacTwo,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.white,
          ),
        ),
        title: Text(AppLocalizations.of(context)!.likedjobs),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<List<EmployerLikedJob>?>(
                future: FebJobs.employerLikedJobs(),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data![index];
                          return Card(
                            color: Colors.white,
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                                right: 10.0,
                                left: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.jobTitle.toString(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text(
                                    data.jobLocation.toString(),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text(
                                    data.salary.toString(),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Text(
                                    data.jobDesc.toString(),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.thumb_up_alt,
                                        color: AppColors.blueZodiacTwo,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        data.likes.toString(),
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontFamily:
                                              GoogleFonts.lato().fontFamily,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.blueZodiacTwo,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
