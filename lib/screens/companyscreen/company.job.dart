import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/companyjobs_model.dart';
import 'package:ijobhunt/core/notifiers/theme.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/employerscreen/edit.jobs.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CompanyPostedJobs extends StatefulWidget {
  // var jobid = '';
  var companyname = '';
  var token = '';
  CompanyPostedJobs({
    super.key,
    //required this.jobid,
    required this.token,
    required this.companyname,
  });

  @override
  State<CompanyPostedJobs> createState() => _CompanyPostedJobsState();
}

class _CompanyPostedJobsState extends State<CompanyPostedJobs> {
  // List<Company> jobs = [];
  var jobid = '';
  List<MyCompanyJObs> compaines = [];

  List<MyJobs> filterdata = [];
  Future<List<MyJobs>?> getlatestjobs() async {
    Map data = {'token': widget.token};
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
      final List company = json.decode(response.body)['company'];
      var jobsdata = company.map((e) => MyCompanyJObs.fromJson(e)).toList();

      return jobsdata[0].myJobs;
    }

    return null;
  }

  Future<List<MyJobs>?> removejob({required jobid}) async {
    Map data = {'job_id': jobid};
    final response = await http.post(
      Uri.parse(ApiRoutes.deleteJobs),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Job Removed sucessfully", context: context),
      );
      setState(() {
        init();
      });
    }

    return null;
  }

  Future init() async {
    final filterdata = await getlatestjobs();
    setState(() {
      this.filterdata = filterdata!.cast<MyJobs>();
      print(filterdata);
    });
  }

  @override
  void initState() {
    // removejob();
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            color: AppColors.blueZodiacTwo,
          ),
        ),
        title: Text(
          "Your Posted Jobs",
          style: TextStyle(
            color: AppColors.blueZodiacTwo,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: filterdata.length == '' || filterdata.length == null
                ? const Center(
                    child: Text("No Job Found For this Company"),
                  )
                : ListView.builder(
                    itemCount: filterdata.length,
                    itemBuilder: (context, index) {
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
                                  color: themeFlage
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(
                                    //   filterdata[index].id.toString(),
                                    //   style: const TextStyle(
                                    //     color: Colors.black,
                                    //   ),
                                    // ),
                                    Text(
                                      filterdata[index].jobTitle.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  widget.companyname,
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
                                      filterdata[index].jobLocation.toString(),
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
                                      borderRadius: BorderRadius.circular(4)),
                                  width: 150,
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        filterdata[index].currency.toString(),
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          color:
                                              Color.fromARGB(255, 28, 119, 31),
                                          // fontSize: 17.0,
                                          // fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(
                                        filterdata[index].salary.toString(),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 28, 119, 31),
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
                                  filterdata[index].jobType.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  filterdata[index].jobDesc.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            removejob(
                                              jobid: filterdata[index]
                                                  .id
                                                  .toString(),
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 25.0,
                                        width: 110.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.0,
                                              color: AppColors.blueZodiacTwo),
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
                                              Icons.delete,
                                              size: 15.0,
                                              color: AppColors.blueZodiacTwo,
                                            ),
                                            Text(
                                              "Remove",
                                              style: TextStyle(
                                                color: AppColors.blueZodiacTwo,
                                                fontWeight: FontWeight.bold,
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
                                            builder: (context) => EditJobs(
                                              jobid: filterdata[index]
                                                  .id
                                                  .toString(),
                                              jobdes: filterdata[index]
                                                  .jobDesc
                                                  .toString(),
                                              joblocation: filterdata[index]
                                                  .jobLocation
                                                  .toString(),
                                              jobtitle: filterdata[index]
                                                  .jobTitle
                                                  .toString(),
                                              salary: filterdata[index]
                                                  .salary
                                                  .toString(),
                                              currency: filterdata[index]
                                                  .currency
                                                  .toString(),
                                              country: filterdata[index]
                                                  .country
                                                  .toString(),
                                              jobtype: filterdata[index]
                                                  .jobType
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 25.0,
                                        width: 110.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2.0,
                                              color: AppColors.blueZodiacTwo),
                                          borderRadius: BorderRadius.circular(
                                            5.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 15.0,
                                              color: AppColors.blueZodiacTwo,
                                            ),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                color: AppColors.blueZodiacTwo,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
