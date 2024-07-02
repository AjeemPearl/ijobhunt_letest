import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/getCompanies.dart';
import 'package:ijobhunt/core/notifiers/jobsdata.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class MyTopCompanies extends StatefulWidget {
  var companyid = '';
  var image = '';
  var token = '';
  var country = '';
  var employeremail = '';
  var employerphone = '';
  var companyname = '';
  var aboutcompany = '';
  MyTopCompanies({
    super.key,
    required this.image,
    required this.aboutcompany,
    required this.companyname,
    required this.employeremail,
    required this.employerphone,
    required this.token,
    required this.companyid,
    required this.country,
  });

  @override
  State<MyTopCompanies> createState() => _MyTopCompaniesState();
}

class _MyTopCompaniesState extends State<MyTopCompanies> {
  List<Getcompanies> topcomanies = [];
  List<MyJobs> filterdata = [];
  bool isloading = false;

  Future<List<MyJobs>?> getlatestjobs(String id) async {
    //isloading = true;
    // Map data = {'country': selectedcountry};
    final response = await http.get(
      Uri.parse(ApiRoutes.getcompaniesapi),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
    );
    if (response.statusCode == 201) {
      final List company = json.decode(response.body);
      var jobsdata = company
          .map((e) => Getcompanies.fromJson(e))
          .where(
            (element) => element.id.toString().contains(id),
          )
          .toList();

      return jobsdata[0].myJobs;
    }

    return null;
  }

  Future init() async {
    isloading = true;
    final filterdata = await getlatestjobs(
      widget.companyid.toString(),
    );
    if (mounted) {
      setState(() {
        this.filterdata = filterdata!.cast<MyJobs>();
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(
                          'http://www.ijobshunts.com/storage/app/public/${widget.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const HomePage(),
                          //   ),
                          // );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
             10.height,
                Card(
                  elevation: 1,
                  child: Container(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          ClipOval(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              color: Colors.grey[100],
                                height: 100,
                                width: 100,
                                child: Image.network("http://www.ijobshunts.com/storage/app/public/${widget.image}",fit: BoxFit.cover,)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             10.height,
                              Text(
                                widget.companyname,
                                style: GoogleFonts.adamina(
                                    fontSize: 16, fontWeight: FontWeight.w600,
                                letterSpacing: 1
                                ),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              Text(
                                'Country:-  ${widget.country}',
                                style: GoogleFonts.notoSans(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 2.5,
                              ),
                              Text(
                                widget.aboutcompany,
                                maxLines: 5,
                                style: GoogleFonts.lato(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlurryContainer(
                    width: double.infinity,
                    elevation: 1,
                    color: AppColors.purpleblulish,
                    borderRadius: BorderRadius.circular(5),
                    child: Text(
                      "Posted Jobs",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3.5,
                ),
                Container(
                  width: double.infinity,
                  //color: Colors.red,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: isloading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : filterdata.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: filterdata.length,
                                itemBuilder: (context, index) {
                                  var data = filterdata[index];
                                  print(data);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      // left: 5.0,
                                      // right: 5.0,
                                      bottom: 10.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.shedowgreyColor,
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 4))
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  data.jobTitle.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                // FavoriteButton(
                                                //     iconSize: 35,
                                                //     isFavorite: false,
                                                //     valueChanged: (value) {
                                                //       value
                                                //           ? FebJobs.saveFebJobs(
                                                //               widget.token,
                                                //               data.id as int,
                                                //             )
                                                //           : FebJobs
                                                //               .removeFavJobs(
                                                //               widget.token,
                                                //               data.id as int,
                                                //             );
                                                //     }),
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
                                                  data.jobLocation.toString(),
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
                                                  color: const Color.fromARGB(
                                                      255, 187, 235, 188),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              width: 150,
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    data.currency.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      color: Color.fromARGB(
                                                          255, 28, 119, 31),
                                                      // fontSize: 17.0,
                                                      // fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    data.salary.toString(),
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 28, 119, 31),
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
                                              data.jobType.toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Text(
                                              overflow: TextOverflow.ellipsis,
                                              data.jobDesc.toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 12.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    launchUrl(
                                                      Uri(
                                                          scheme: 'tel',
                                                          path: widget
                                                              .employerphone),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 25.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2.0,
                                                          color: AppColors
                                                              .purpleblulish),
                                                      // color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.call,
                                                          size: 15.0,
                                                          color: AppColors
                                                              .purpleblulish,
                                                        ),
                                                        Text(
                                                          "Call",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .purpleblulish,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                        path: widget
                                                            .employeremail,
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 25.0,
                                                    width: 80.0,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2.0,
                                                          color: AppColors
                                                              .purpleblulish),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.email,
                                                          size: 15.0,
                                                          color: AppColors
                                                              .purpleblulish,
                                                        ),
                                                        Text(
                                                          "E-mail",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .purpleblulish,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            JobDetails(
                                                          jobtitle: data
                                                              .jobTitle
                                                              .toString(),
                                                          comapnyname: widget
                                                              .companyname
                                                              .toString(),
                                                          salary: data.salary
                                                              .toString(),
                                                          jobdesc: data.jobDesc
                                                              .toString(),
                                                          employeremail: widget
                                                              .employeremail
                                                              .toString(),
                                                          employerno: widget
                                                              .employeremail
                                                              .toString(),
                                                          token: widget.token,
                                                          compid: data.id
                                                              .toString(),
                                                          currency: data
                                                              .currency
                                                              .toString(),
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
                                                          color: AppColors
                                                              .purpleblulish),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          "Details",
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .purpleblulish,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 15.0,
                                                          color: AppColors
                                                              .purpleblulish,
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
                                },
                              ),
                            )
                          : const Center(
                              child:
                                  Text("No Posted Job Found For this company"),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
