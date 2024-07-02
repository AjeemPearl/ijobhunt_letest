import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/screens/homescreens/widgets/card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/constants/app.colors.dart';
import '../../core/models/get_fev_jobs.dart';
import '../../core/notifiers/jobsdata.dart';
import 'home_page.dart';
import 'jobdetails.dart';

class FavJobs extends StatefulWidget {
  var employerphone = '';
  var employeremail = '';
  var companyname = '';
  var token = '';
  var compid = '';
  FavJobs({
    super.key,
    required this.employerphone,
    required this.employeremail,
    required this.companyname,
    required this.token,
    required this.compid,
  });

  @override
  State<FavJobs> createState() => _FavJobsState();
}

class _FavJobsState extends State<FavJobs> {
  List<FevJobsGetModel> favjobs = [];
  // List favjob = [];

  Future initFevJobs() async {
    final favjobs = await FebJobs.getFavJobs(widget.token);
    setState(() {
      this.favjobs = favjobs;
    });
  }

  @override
  void initState() {
    initFevJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.blackPearl,
          ),
        ),
        title: const Text(
          "Favorite Jobs",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: favjobs.length == 0 || favjobs == null
            ? const Center(
                child: Text("No Favourite Jobs Found"),
              )
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                //physics: ScrollPhysics(),
                itemCount: favjobs.length,
                itemBuilder: (context, index) {
                  var favdata = favjobs[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      bottom: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
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
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  favdata.job!.jobTitle.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                FavoriteButton(
                                    iconSize: 35,
                                    isFavorite: true,
                                    valueChanged: (valueChanged) {
                                      //initFevJobs();
                                      FebJobs.removeFavJobs(
                                        widget.token,
                                        favdata.job!.id!.toInt(),
                                      );
                                    }),
                              ],
                            ),
                            Text(
                              widget.companyname.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 17.0,
                                ),
                                Text(
                                  favdata.job!.jobLocation.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 187, 235, 188),
                                  borderRadius: BorderRadius.circular(4)),
                              width: 150,
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.currency_rupee,
                                    color: Color.fromARGB(255, 28, 119, 31),
                                    size: 15.0,
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    favdata.job!.salary.toString(),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 28, 119, 31),
                                      // fontSize: 17.0,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              favdata.job!.jobType.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              favdata.job!.jobDesc.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 12.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(
                                      Uri(
                                          scheme: 'tel',
                                          path: widget.employerphone),
                                    );
                                  },
                                  child: Container(
                                    height: 25.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.0,
                                          color: AppColors.purpleblulish),
                                      // color: Colors.green,
                                      borderRadius: BorderRadius.circular(
                                        5.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          size: 15.0,
                                          color: AppColors.purpleblulish,
                                        ),
                                        Text(
                                          "Call",
                                          style: TextStyle(
                                            color: AppColors.purpleblulish,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(
                                      Uri(
                                        scheme: 'mailto',
                                        path: widget.employeremail,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 25.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.0,
                                          color: AppColors.purpleblulish),
                                      borderRadius: BorderRadius.circular(
                                        5.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 15.0,
                                          color: AppColors.purpleblulish,
                                        ),
                                        Text(
                                          "E-mail",
                                          style: TextStyle(
                                            color: AppColors.purpleblulish,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobDetails(
                                          jobtitle:
                                              favdata.job!.jobTitle.toString(),
                                          comapnyname:
                                              widget.companyname.toString(),
                                          salary:
                                              favdata.job!.salary.toString(),
                                          jobdesc:
                                              favdata.job!.jobDesc.toString(),
                                          employeremail:
                                              widget.employeremail.toString(),
                                          employerno:
                                              widget.employerphone.toString(),
                                          token: widget.token,
                                          compid: widget.compid,
                                          currency:
                                              favdata.job!.currency.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 25.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2.0,
                                          color: AppColors.purpleblulish),
                                      borderRadius: BorderRadius.circular(
                                        5.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Details",
                                          style: TextStyle(
                                            color: AppColors.purpleblulish,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 15.0,
                                          color: AppColors.purpleblulish,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
