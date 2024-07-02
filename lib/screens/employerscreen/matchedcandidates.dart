import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/models/recomendedcandidates.dart';
import 'package:ijobhunt/core/notifiers/companynotifire.dart';
import 'package:ijobhunt/screens/employerscreen/candidatedetails.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MatchedCandidates extends StatefulWidget {
  const MatchedCandidates({super.key});

  @override
  State<MatchedCandidates> createState() => _MatchedCandidatesState();
}

class _MatchedCandidatesState extends State<MatchedCandidates> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blueZodiacTwo,
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
        title: Text(AppLocalizations.of(context)!.matchedCandidates),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          FutureBuilder<RecomndedCandidates?>(
              future: EmployerCompanydata.getReomndedCandidate(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.status == true) {
                  return Expanded(
                    child: EmployerCompanydata.isloading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            //shrinkWrap: true,
                            itemCount: snapshot.data!.user!.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.user![index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 0.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CandidateDetails(
                                          jobid: data.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      left: 12.0,
                                      right: 12.0,
                                    ),
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name.toString(),
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              data.email.toString(),
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const FaIcon(
                                            FontAwesomeIcons.angleDoubleRight)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  );
                } else if (snapshot.hasData && snapshot.data!.status == false) {
                  return const Center(
                    child: Text("No Matched Candidate Found"),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
