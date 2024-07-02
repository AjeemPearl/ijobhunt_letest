// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

// ignore: must_be_immutable
class JobDetails extends StatefulWidget {
  var comapnyname = '';
  var jobtitle = '';
  var salary = '';
  var jobdesc = '';
  var employerno = '';
  var employeremail = '';
  var token = '';
  var compid = '';
  var currency = '';

  JobDetails({
    Key? key,
    required this.comapnyname,
    required this.jobtitle,
    required this.salary,
    required this.jobdesc,
    required this.employerno,
    required this.employeremail,
    required this.compid,
    required this.token,
    required this.currency,
  }) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  double value = 0.0;

  Future postRating() async {
    Map data = {
      'token': widget.token,
      'company_id': widget.compid,
      'rating_count': value.toString()
    };
    final response = await http.post(
      Uri.parse(ApiRoutes.getcount),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: "Thanks For Your response ", context: context));
      return 'Thanks For Your Response';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    //alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      //color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/logo/company.jpg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      ],
                    ),
                  ),
                 /* Positioned(top: 0,left: 0,
                    child: Container(
                      height: 30,width: 30,
                      margin: EdgeInsets.only(top: 30,left: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.white),
                      padding: const EdgeInsets.all(1.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const HomePage(),
                          //   ),
                          // );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                      alignment: Alignment.center ,
                    ),
                  ),*/
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      widget.comapnyname,
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Libre",
                          // letterSpacing: 1,
                          color: Colors.redAccent),
                    ),
                    5.height,
                    Text(
                      widget.jobtitle,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          //  fontFamily: "Libre",
                          color: Colors.black),
                    ),
                    5.height,
                    Text(
                      widget.employeremail,
                      style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          //  fontFamily: "Libre",
                          color: Colors.black),
                    ),
                    15.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.redAccent.withOpacity(0.1)),
                          child: const Text(
                            "Full-Time",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.currency == 'null'
                                  ? '\$'
                                  : widget.currency.toString(),
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Libre",
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                                  //color: Color.fromARGB(255, 28, 119, 31),
                                  // fontSize: 17.0,
                                  // fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "${widget.salary}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const Text(
                              "/Month",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.height,
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Requirement",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              // fontFamily: "Libre",
                              color: Colors.black),
                        ),
                      ],
                    ),
                    10.height,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,

                      ///color: Colors.red,
                      child: Text(
                        widget.jobdesc,
                        style: const TextStyle(
                          fontFamily: "Libre",
                          fontWeight: FontWeight.w200,
                          fontSize: 12,
                          wordSpacing: 2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffEDF2F6),
                        border: Border.all(
                          width: 1.0,
                          color: AppColors.blueZodiacTwo.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RatingStars(
                              value: value,
                              onValueChanged: (v) {
                                //
                                setState(() {
                                  value = v;
                                });
                              },
                              starBuilder: (index, color) => Icon(
                                    Icons.star,
                                    color: color,
                                  ),
                              starCount: 5,
                              starSize: 30,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              valueLabelRadius: 10,
                              maxValue: 5,
                              starSpacing: 2,
                              maxValueVisibility: true,
                              valueLabelVisibility: true,
                              animationDuration: const Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              valueLabelMargin: const EdgeInsets.only(right: 8),
                              starOffColor: Colors.white,
                              //  starOffColor: const Color(0xffe7e8ea),
                              // starColor: AppColors.blueZodiacTwo,
                              starColor: AppColors.blackPearl),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                (states) => AppColors.blueZodiacTwo.withOpacity(0.5),
                              ),
                            ),
                            onPressed: () {
                              postRating();
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontFamily: "Libre"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchUrl(
                              Uri(
                                scheme: 'tel',
                                path: widget.employerno,
                              ),
                            );
                          },
                          child: const BlurryContainer(
                            elevation: 5,
                            color: Color(0xffF5564E),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontFamily: "Libre",
                                    letterSpacing: 1,
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
                          child: const BlurryContainer(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            elevation: 5,
                            color: Color(0xff08D9D6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "E-mail",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: "Libre",
                                    color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}

extension Sizedbox on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());
}
