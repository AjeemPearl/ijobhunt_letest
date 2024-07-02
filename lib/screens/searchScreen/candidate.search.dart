import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/candidatesearch.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/screens/employerscreen/candidatedetails.dart';
import 'package:ijobhunt/screens/employerscreen/employer.home.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CandidateSearch extends StatefulWidget {
  const CandidateSearch({super.key});

  @override
  State<CandidateSearch> createState() => _CandidateSearchState();
}

class _CandidateSearchState extends State<CandidateSearch> {
  final countrydropdown = GlobalKey<FormFieldState>();
  final controller = TextEditingController();
  var jobtitle = '';
  bool isloading = false;
  var responseJson = [];
  var country = '';
  List<CountryModel> countrymodel = [];
  List<String> countries = [];
  List<User> searchResult = [];
  List<User> jobsDetails = [];
  String? selectedValue;

  Future getcandidats({required counTry, required jobtitle}) async {
    isloading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map data = {
      'country': counTry,
      'job_title': jobtitle,
      'token': pref.getString(AppKeys.userData)
    };
    final response = await http.post(
      Uri.parse(
        ApiRoutes.searchcaniddate,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "country": selectedValue.toString(),
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      responseJson = json.decode(response.body)['user'];
      jobsDetails = responseJson.map((e) => User.fromJson(e)).toList();
    }
    if (mounted) {
      setState(() {
        isloading = false;
      });
    }
    else {
      return null;
    }
  }
  Future init() async {
    final country = await CountriesData.getcountries();
    setState(() {
      for (var item in country) {
        countries.add(item["name"]);
      }
    });
  }

  // onSearchTextChanged(String text) async {
  //   searchResult.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //   jobsDetails.forEach((jobDetail) {
  //     if (jobDetail.jobTitle != null) {
  //       if (jobDetail.jobTitle!.toLowerCase().contains(text)) {
  //         searchResult.add(jobDetail);
  //         print(jobDetail);
  //       }
  //     }
  //   });
  //   setState(() {});
  // }

  @override
  void initState() {
    // getcandidats();
    init();
    super.initState();
  }

  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 25.0,
          ),
          Container(
            width: double.infinity,
            color: AppColors.blueZodiacTwo,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 42,
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              value.isEmpty
                                  ? jobsDetails.clear()
                                  : jobtitle = value;
                            });
                          }
                        },
                        controller: controller,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child:
                                const Icon(Icons.search, color: Colors.black),
                          ),
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      // alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 42,
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: DropdownSearch<String>(
                            key: countrydropdown,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  labelText: selectedValue ??
                                      '-- Please Select Country --',
                                  labelStyle: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                  )
                                  //hintText: "country in menu mode",
                                  ),
                            ),
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                              // showSelectedItems: true,
                              // disabledItemFn: (String s) => s.startsWith('I'),
                            ),
                            items: countries.map((item) => item).toList(),
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  selectedValue = value.toString();
                                  print("new country is ${selectedValue}");
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          jobsDetails.isNotEmpty || selectedValue != null || jobtitle.isNotEmpty
              ? isloading
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.35),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      flex: 7,
                      child: ListView.builder(
                          itemCount: jobsDetails.length,
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
                                      Text(
                                        jobsDetails[index].name.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        jobsDetails[index].jobTitle.toString(),
                                        style: const TextStyle(

                                            // fontSize: 17.0,
                                            // fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      // Text(
                                      //   jobsDetails[index].email.toString(),
                                      //   style: const TextStyle(
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                      // const SizedBox(
                                      //   height: 4.0,
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            jobsDetails[index]
                                                .dateofbirth
                                                .toString(),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          jobsDetails[index]
                                              .degreetitle
                                              .toString(),
                                          maxLines: 4,
                                          style: const TextStyle(

                                              // fontSize: 17.0,
                                              // fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        jobsDetails[index]
                                            .degreestartdate
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        jobsDetails[index]
                                            .degreedetails
                                            .toString(),
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
                                              launchUrl(
                                                Uri(
                                                    scheme: 'tel',
                                                    path: jobsDetails[index]
                                                        .phone),
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
                                                    color:
                                                        AppColors.purpleblulish,
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
                                                  path:
                                                      jobsDetails[index].email,
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
                                                    color:
                                                        AppColors.purpleblulish,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
              : Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.35),
                  child: const Center(
                    child: Text("No search result found"),
                  ),
                ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.80,
                  height: MediaQuery.of(context).size.height * 0.06,
                  color: AppColors.blueZodiacTwo,
                  onPressed: () {
                    getcandidats(
                        counTry: selectedValue ?? '', jobtitle: jobtitle);
                  },
                  child: Text(
                    'Find Candidates',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColors.creamColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
