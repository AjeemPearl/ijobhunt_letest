import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/ProfileScreen/userprofile.dart';
import 'package:ijobhunt/screens/companyscreen/add.company.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserJobDetails extends StatefulWidget {
  var dob = '';
  var profession = '';
  var name = '';
  var phone = '';
  var email = '';
  var address = '';
  var about = '';
  var degreetitle = '';
  var institute = '';
  var degreestartdate = '';
  var degreeenddate = '';
  var percent = '';
  var grade = '';
  var degreedetails = '';
  var orgname = '';
  var jobstartdate = '';
  var jobenddate = '';
  var role = '';
  var jobdetails = '';
  var image = '';
  var token = '';
  var jobtitle = '';
  var usercountry = '';
  var stillworking = '';
  UserJobDetails({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.profession,
    required this.address,
    required this.about,
    required this.image,
    required this.degreetitle,
    required this.institute,
    required this.degreestartdate,
    required this.degreeenddate,
    required this.percent,
    required this.grade,
    required this.degreedetails,
    required this.orgname,
    required this.jobstartdate,
    required this.jobenddate,
    required this.role,
    required this.jobdetails,
    required this.token,
    required this.jobtitle,
    required this.usercountry,
    required this.stillworking,
  });

  @override
  State<UserJobDetails> createState() => _UserJobDetailsState();
}

class _UserJobDetailsState extends State<UserJobDetails> {
  TextEditingController orgnamecontroller = TextEditingController();
  TextEditingController startdatecontroller = TextEditingController();
  TextEditingController enddatecontroller = TextEditingController();
  TextEditingController rolecontroller = TextEditingController();
  TextEditingController jobdetailscontroller = TextEditingController();
  TextEditingController jobtitlecontroller = TextEditingController();
  TextEditingController keywordcontroller = TextEditingController();
  bool isloading = false;
  bool valuefirst = false;
  var text = '';
  final _formKey = GlobalKey<FormState>();
  var stillworking = '';
  List<String> keywords = <String>[];
  @override
  void initState() {
    orgnamecontroller.text = widget.orgname;
    startdatecontroller.text = widget.jobstartdate;
    enddatecontroller.text = widget.jobenddate;
    rolecontroller.text = widget.role;
    jobdetailscontroller.text = widget.jobdetails;
    jobtitlecontroller.text = widget.jobtitle;
    widget.stillworking !='' && widget.stillworking =='0'?valuefirst =false:valuefirst =true;
    super.initState();
  }

  void addKeyWords({required String keyWords}) async {
    keywords.add("$keyWords");
    print(keywords);
  }

  // Future saveKeyWords() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   Map data = {
  //     'token': pref.getString(AppKeys.userData),
  //     'keywords': keywords.toString()
  //   };
  //   final response = await http.post(
  //     Uri.parse(ApiRoutes.addkeywords),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/x-www-form-urlencoded"
  //     },
  //     body: data,
  //     encoding: Encoding.getByName("utf-8"),
  //   );
  //   if (response.statusCode == 201) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
  //         text: "Keywords added sucessfully", context: context));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: orgnamecontroller,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.orgname} : ',
                      hintText: 'Ener organization name',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Organization Name" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: startdatecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: FaIcon(
                        FontAwesomeIcons.calendar,
                        color: AppColors.blueZodiacTwo,
                      ),
                      labelText: AppLocalizations.of(context)!.jobstartDate,
                      hintText: 'Enter Job Start Date',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                      );
                      if (pickedDate != null) {
                        startdatecontroller.text =
                            DateFormat('dd MMMM yyyy').format(pickedDate);
                      }
                    },
                    validator: (value) =>
                        value!.isEmpty ? "Enter start date" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Are You Still Working: ',
                        style: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      Checkbox(
                        checkColor: Colors.greenAccent,
                        activeColor: AppColors.blueZodiacTwo,
                        value: valuefirst,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              valuefirst = value!;
                              valuefirst
                                  ? stillworking = 'false'
                                  : stillworking = 'true';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Visibility(
                    visible: valuefirst == false,
                    child: TextFormField(
                      controller: enddatecontroller,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: FaIcon(
                          FontAwesomeIcons.calendar,
                          color: AppColors.blueZodiacTwo,
                        ),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText:
                            '${AppLocalizations.of(context)!.jobendDate} : ',
                        hintText: 'Enter Job End Date',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          enddatecontroller.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) =>
                          value!.isEmpty ? "Enter End Date" : null,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: jobtitlecontroller,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.jobtitle} ',
                      hintText: 'e.g. flutter developer etc',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter job title" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Visibility(
                    visible: keywords.isNotEmpty,
                    child: SizedBox(
                      height: 40,
                      //width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: keywords.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(keywords[index]),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: -15,
                                  child: IconButton(
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          keywords.removeAt(index);
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: keywordcontroller,
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {
                          text = value;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText:
                          '${AppLocalizations.of(context)!.createkeywordcandidate}',
                      hintText: 'Create your own keywords',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    // validator: (value) => value!.isEmpty
                    //     ? "Create KeyWord for better job search experince"
                    //     : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Visibility(
                    visible: text.isNotEmpty,
                    child: IconButton(
                      alignment: Alignment.center,
                      color: Colors.green,
                      onPressed: () {
                        addKeyWords(keyWords: text);
                        if (mounted) {
                          setState(() {
                            keywordcontroller.clear();
                            text = '';
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 40,
                      ),
                    ),
                  ),
                  // Visibility(
                  //   visible: text.isNotEmpty,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       addKeyWords(keyWords: text);
                  //       if (mounted) {
                  //         setState(() {
                  //           keywordcontroller.clear();
                  //           text = '';
                  //         });
                  //       }
                  //     },
                  //     child: SizedBox(
                  //       width: 100,
                  //       child: Card(
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child:
                  //               Row(children: [Text(keywordcontroller.text)]),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: rolecontroller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      labelText: '${AppLocalizations.of(context)!.role} : ',
                      hintText: 'e.g Flutter Developer etc.',
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Your Role" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    controller: jobdetailscontroller,
                    maxLines: 5,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      focusColor: AppColors.blueZodiacTwo,
                      labelText:
                          '${AppLocalizations.of(context)!.jobdetails} : ',
                      hintText: 'Enter Your Job Details',
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Job Details" : null,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (mounted) {
                          setState(() {
                            isloading = true;
                          });
                        }
                        UserProFile.updateuser(
                          name: widget.name,
                          phone: widget.phone,
                          email: widget.email,
                          token: widget.token,
                          dateofbirth: widget.dob,
                          profession: widget.profession,
                          address: widget.address,
                          aboutyourself: widget.about,
                          image: '',
                          imageext: '',
                          context: context,
                          degreetitle: widget.degreetitle,
                          institutename: widget.institute,
                          degreestartdate: widget.degreestartdate,
                          degreeenddate: widget.degreeenddate,
                          degreepercent: widget.percent,
                          degreegrade: widget.grade,
                          degreedetails: widget.degreedetails,
                          organizationname: orgnamecontroller.text,
                          jobstartDate: startdatecontroller.text,
                          jobendDate: enddatecontroller.text,
                          stillWorking: stillworking,
                          yourole: rolecontroller.text,
                          jobdetails: jobdetailscontroller.text,
                          job_title: jobtitlecontroller.text,
                          usercountry: widget.usercountry,
                          keywords: keywords.toString(),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              token: widget.token,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 2.0,
                          color: AppColors.blueZodiacTwo,
                        ),
                      ),
                      child: isloading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Please Wait....',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: AppColors.blueZodiacTwo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CircularProgressIndicator(
                                  color: AppColors.blueZodiacTwo,
                                  strokeWidth: 2.5,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.saveprofession,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                    color: AppColors.blueZodiacTwo,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.angleRight,
                                  color: AppColors.blueZodiacTwo,
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
