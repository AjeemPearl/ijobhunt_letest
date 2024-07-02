import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:ijobhunt/core/models/jobsearchmodel.dart';
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/core/notifiers/jobsdata.dart';
import 'package:ijobhunt/main.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:ijobhunt/screens/homescreens/widgets/card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/jobserach.dart';

class SearchScreen extends StatefulWidget {
  var token = '';
  //var country = '';
  SearchScreen({
    super.key,
    //required this.country,
    required this.token,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final countrydropdown = GlobalKey<FormFieldState>();

  List<CountryModel> country = [];
  List<String> countries = [];
  String? selectedValue;
  var selectedcountry = '';
  var jobtitle = '';
  bool isloading = false;
  var responseJson = [];
  List<Jobs> searchResult = [];
  List<Result> jobsDetails = [];
  Future getJobs({required country, required jobtitle}) async {
    isloading = true;
    try {
      Map data = {
        'country': country ?? '',
        'job_title': jobtitle,
        'token': widget.token,
      };
      final response = await http.post(
        Uri.parse(
          'http://ijobshunts.com/public/api/advance-search-employee',
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      if (response.statusCode == 201) {
        responseJson = json.decode(response.body)['result'];
        jobsDetails = responseJson.map((e) => Result.fromJson(e)).toList();

        if (jobsDetails.isNotEmpty) {
          if (mounted) {
            setState(() {
              isloading = false;
            });
          }
          return jobsDetails;
        } else if (jobsDetails.isEmpty) {
          if (mounted) {
            setState(() {
              isloading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e);
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

  @override
  void initState() {
    //selectedValue = widget.country;
    init();
    //getJobs();
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
        mainAxisSize: MainAxisSize.max,
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
                            builder: (context) => const HomePage(),
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
                              jobtitle = value;
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
                      width: MediaQuery.of(context).size.width * 0.902,
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

                        //  DropdownButton(
                        //     isExpanded: true,
                        //     key: countrydropdown,
                        //     hint: const Text(
                        //       "--Please Select Country--",
                        //     ),
                        //     items: countries
                        //         .map(
                        //           (item) => DropdownMenuItem<String>(
                        //             value: item,
                        //             child: Text(item),
                        //           ),
                        //         )
                        //         .toList(),
                        //     value: selectedValue,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         selectedValue = value.toString();
                        //         //widget.country = value.toString();
                        //         //getJobs(country: selectedValue);
                        //       });
                        //       print("new country is ${selectedValue}");
                        //     }),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // searchResult.isNotEmpty || controller.text.isNotEmpty
          //     ? Expanded(
          //         flex: 7,
          //         child: ListView.builder(
          //             itemCount: searchResult.length,
          //             itemBuilder: (context, index) {
          //               return Padding(
          //                 padding: const EdgeInsets.only(
          //                   left: 10.0,
          //                   right: 10.0,
          //                   bottom: 8.0,
          //                 ),
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(8.0),
          //                     boxShadow: [
          //                       BoxShadow(
          //                           color: themeFlag
          //                               ? AppColors.blackPearl
          //                               : AppColors.shedowgreyColor,
          //                           blurRadius: 5,
          //                           spreadRadius: 1,
          //                           offset: const Offset(0, 4))
          //                     ],
          //                   ),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(12.0),
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Text(
          //                               searchResult[index].jobTitle.toString(),
          //                               style: const TextStyle(
          //                                 color: Colors.black,
          //                               ),
          //                             ),
          //                             FavoriteButton(
          //                                 iconSize: 35,
          //                                 isFavorite:
          //                                     searchResult[index].myLike,
          //                                 valueChanged: (value) {
          //                                   value
          //                                       ? FebJobs.saveFebJobs(
          //                                           widget.token,
          //                                           searchResult[index].id
          //                                               as int,
          //                                         )
          //                                       : FebJobs.removeFavJobs(
          //                                           widget.token,
          //                                           searchResult[index].id
          //                                               as int,
          //                                         );
          //                                 }),
          //                           ],
          //                         ),
          //                         searchResult[index].myCompany != null
          //                             ? Text(
          //                                 searchResult[index]
          //                                     .myCompany!
          //                                     .comapnyName
          //                                     .toString(),
          //                                 style: const TextStyle(
          //                                   color: Colors.black,
          //                                 ),
          //                               )
          //                             : Container(),
          //                         const SizedBox(
          //                           height: 4.0,
          //                         ),
          //                         Text(
          //                           searchResult[index].country.toString(),
          //                           style: const TextStyle(
          //                             color: Colors.black,
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 4.0,
          //                         ),
          //                         Row(
          //                           children: [
          //                             const Icon(
          //                               Icons.location_on,
          //                               color: Colors.grey,
          //                               size: 17.0,
          //                             ),
          //                             Text(
          //                               searchResult[index]
          //                                   .jobLocation
          //                                   .toString(),
          //                               style: const TextStyle(
          //                                 color: Colors.black,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         const SizedBox(
          //                           height: 4.0,
          //                         ),
          //                         Container(
          //                           decoration: BoxDecoration(
          //                               color: const Color.fromARGB(
          //                                   255, 187, 235, 188),
          //                               borderRadius: BorderRadius.circular(4)),
          //                           width: 150,
          //                           child: Row(
          //                             // mainAxisAlignment:
          //                             //     MainAxisAlignment.center,
          //                             children: [
          //                               Text(
          //                                 searchResult[index].currency == null
          //                                     ? '\$'
          //                                     : searchResult[index]
          //                                         .currency
          //                                         .toString(),
          //                                 style: const TextStyle(
          //                                   fontSize: 15.0,
          //                                   color: Color.fromARGB(
          //                                       255, 28, 119, 31),
          //                                   // fontSize: 17.0,
          //                                   // fontWeight: FontWeight.w600,
          //                                 ),
          //                               ),
          //                               const SizedBox(
          //                                 width: 5.0,
          //                               ),
          //                               Text(
          //                                 searchResult[index].salary.toString(),
          //                                 style: const TextStyle(
          //                                   color: Color.fromARGB(
          //                                       255, 28, 119, 31),
          //                                   // fontSize: 17.0,
          //                                   // fontWeight: FontWeight.w600,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 4.0,
          //                         ),
          //                         Text(
          //                           searchResult[index].jobType.toString(),
          //                           style: const TextStyle(
          //                             color: Colors.black,
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 4.0,
          //                         ),
          //                         Text(
          //                           overflow: TextOverflow.ellipsis,
          //                           searchResult[index].jobDesc.toString(),
          //                           style: const TextStyle(
          //                             color: Colors.black,
          //                           ),
          //                         ),
          //                         const SizedBox(
          //                           height: 12.0,
          //                         ),
          //                         Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             GestureDetector(
          //                               onTap: () {
          //                                 launchUrl(
          //                                   Uri(
          //                                       scheme: 'tel',
          //                                       path: searchResult[index]
          //                                           .myUser!
          //                                           .phone),
          //                                 );
          //                               },
          //                               child: Container(
          //                                 height: 25.0,
          //                                 width: 80.0,
          //                                 decoration: BoxDecoration(
          //                                   border: Border.all(
          //                                       width: 2.0,
          //                                       color: AppColors.purpleblulish),
          //                                   // color: Colors.green,
          //                                   borderRadius: BorderRadius.circular(
          //                                     5.0,
          //                                   ),
          //                                 ),
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceEvenly,
          //                                   children: [
          //                                     Icon(
          //                                       Icons.call,
          //                                       size: 15.0,
          //                                       color: AppColors.purpleblulish,
          //                                     ),
          //                                     Text(
          //                                       "Call",
          //                                       style: TextStyle(
          //                                         color:
          //                                             AppColors.purpleblulish,
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             GestureDetector(
          //                               onTap: () {
          //                                 launchUrl(
          //                                   Uri(
          //                                     scheme: 'mailto',
          //                                     path: searchResult[index]
          //                                         .myUser!
          //                                         .email,
          //                                   ),
          //                                 );
          //                               },
          //                               child: Container(
          //                                 height: 25.0,
          //                                 width: 80.0,
          //                                 decoration: BoxDecoration(
          //                                   border: Border.all(
          //                                       width: 2.0,
          //                                       color: AppColors.purpleblulish),
          //                                   borderRadius: BorderRadius.circular(
          //                                     5.0,
          //                                   ),
          //                                 ),
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceEvenly,
          //                                   children: [
          //                                     Icon(
          //                                       Icons.email,
          //                                       size: 15.0,
          //                                       color: AppColors.purpleblulish,
          //                                     ),
          //                                     Text(
          //                                       "E-mail",
          //                                       style: TextStyle(
          //                                         color:
          //                                             AppColors.purpleblulish,
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                             GestureDetector(
          //                               onTap: () {
          //                                 Navigator.pushReplacement(
          //                                   context,
          //                                   MaterialPageRoute(
          //                                     builder: (context) => JobDetails(
          //                                       jobtitle: searchResult[index]
          //                                           .jobTitle
          //                                           .toString(),
          //                                       comapnyname: searchResult[index]
          //                                           .myCompany!
          //                                           .comapnyName
          //                                           .toString(),
          //                                       salary: searchResult[index]
          //                                           .salary
          //                                           .toString(),
          //                                       jobdesc: searchResult[index]
          //                                           .jobDesc
          //                                           .toString(),
          //                                       employeremail:
          //                                           searchResult[index]
          //                                               .myUser!
          //                                               .email
          //                                               .toString(),
          //                                       employerno: searchResult[index]
          //                                           .myUser!
          //                                           .phone
          //                                           .toString(),
          //                                       token: widget.token,
          //                                       compid: searchResult[index]
          //                                           .id
          //                                           .toString(),
          //                                       currency: searchResult[index]
          //                                           .currency
          //                                           .toString(),
          //                                     ),
          //                                   ),
          //                                 );
          //                               },
          //                               child: Container(
          //                                 height: 25.0,
          //                                 width: 80.0,
          //                                 decoration: BoxDecoration(
          //                                   border: Border.all(
          //                                       width: 2.0,
          //                                       color: AppColors.purpleblulish),
          //                                   borderRadius: BorderRadius.circular(
          //                                     5.0,
          //                                   ),
          //                                 ),
          //                                 child: Row(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.spaceEvenly,
          //                                   children: [
          //                                     Text(
          //                                       "Details",
          //                                       style: TextStyle(
          //                                         color:
          //                                             AppColors.purpleblulish,
          //                                         fontWeight: FontWeight.bold,
          //                                       ),
          //                                     ),
          //                                     Icon(
          //                                       Icons.arrow_forward_ios,
          //                                       size: 15.0,
          //                                       color: AppColors.purpleblulish,
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             }),
          //       )
          //     :

          jobsDetails.isNotEmpty
              ? isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            jobsDetails[index]
                                                .jobTitle
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          FavoriteButton(
                                              iconSize: 35,
                                              isFavorite:
                                                  jobsDetails[index].myLike,
                                              valueChanged: (value) {
                                                value
                                                    ? FebJobs.saveFebJobs(
                                                        widget.token,
                                                        jobsDetails[index].id
                                                            as int,
                                                      )
                                                    : FebJobs.removeFavJobs(
                                                        widget.token,
                                                        jobsDetails[index].id
                                                            as int,
                                                      );
                                              }),
                                        ],
                                      ),
                                      jobsDetails[index].myCompany != null
                                          ? Text(
                                              jobsDetails[index]
                                                  .myCompany!
                                                  .comapnyName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        jobsDetails[index].country.toString(),
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
                                            jobsDetails[index]
                                                .jobLocation
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
                                              jobsDetails[index].currency ==
                                                      null
                                                  ? '\$'
                                                  : jobsDetails[index]
                                                      .currency
                                                      .toString(),
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
                                              jobsDetails[index]
                                                  .salary
                                                  .toString(),
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
                                        jobsDetails[index].jobType.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        jobsDetails[index].jobDesc.toString(),
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
                                                        .myUser!
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
                                                  path: jobsDetails[index]
                                                      .myUser!
                                                      .email,
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
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      JobDetails(
                                                    jobtitle: jobsDetails[index]
                                                        .jobTitle
                                                        .toString(),
                                                    comapnyname:
                                                        jobsDetails[index]
                                                            .myCompany!
                                                            .comapnyName
                                                            .toString(),
                                                    salary: jobsDetails[index]
                                                        .salary
                                                        .toString(),
                                                    jobdesc: jobsDetails[index]
                                                        .jobDesc
                                                        .toString(),
                                                    employeremail:
                                                        jobsDetails[index]
                                                            .myUser!
                                                            .email
                                                            .toString(),
                                                    employerno:
                                                        jobsDetails[index]
                                                            .myUser!
                                                            .phone
                                                            .toString(),
                                                    token: widget.token,
                                                    compid: jobsDetails[index]
                                                        .id
                                                        .toString(),
                                                    currency: jobsDetails[index]
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
                                                    Icons.arrow_forward_ios,
                                                    size: 15.0,
                                                    color:
                                                        AppColors.purpleblulish,
                                                  ),
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
              : const Center(
                  child: Text("No search result"),
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
                    getJobs(country: selectedValue, jobtitle: jobtitle);
                  },
                  child: Text(
                    'Find Jobs',
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
