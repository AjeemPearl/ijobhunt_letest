import 'dart:convert';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/screens/companyscreen/company.profie.dart';
import 'package:ijobhunt/screens/companyscreen/edit.company.dart';
import 'package:ijobhunt/screens/employerscreen/employer.home.dart';
import 'package:ijobhunt/screens/searchScreen/candidate.search.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../app/routes/api.routes.dart';
import '../screens/inapppurches/Paywall.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  bool _isLoading = true;
  bool _isSubscribed = false;


  @override
  void initState() {
    checkSubscription();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
      body: Column(
        children: [
          SizedBox(width: MediaQuery
              .of(context)
              .size
              .width,),
          const Spacer(flex: 2,),
          const Text('Please Wait'),
          const Spacer(flex: 1,),
        ],
      ),
    )
        : _isSubscribed
        ? Scaffold(
      //extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: <Widget>[
          FaIcon(
            FontAwesomeIcons.home,
            size: 20,
            color: AppColors.white,
          ),
          FaIcon(
            FontAwesomeIcons.building,
            size: 20,
            color: AppColors.white,
          ),
          FaIcon(
            FontAwesomeIcons.userEdit,
            size: 20,
            color: AppColors.white,
          ),
          FaIcon(
            FontAwesomeIcons.search,
            size: 20,
            color: AppColors.white,
          ),
        ],
        onTap: (selectedindex) {
          setState(() {
            _page = selectedindex;
          });
        },
        color: AppColors.blueZodiacTwo,
        buttonBackgroundColor: AppColors.purpleblulish,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
      ),
      body: getSelectedWidget(index: _page),
    )
        : Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 75,),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              height: 50,
              child: const Center(child: Text(
                "Your free Subscription is Expired to avail the Services",
                style: TextStyle(fontSize: 16.0),),),),
          ),

          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DemoPage(
                      userType: 'employer',)),
                  );
                } else {
                  getpaymentApi();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.6,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blueGrey[900],
                ),
                child: const Center(
                  child: Text("Upgrade Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),);
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const EmployerHome();
        break;
      case 1:
        widget = const CompanyProfile();
        break;
      case 2:
        widget = EditCompany();
        break;
      case 3:
        widget = const CandidateSearch();
        break;
      default:
        widget = const EmployerHome();
    }
    return widget;
  }


  Future getpaymentApi() async {
    // print("Hello how are you");
    Map data = {'token': AppPreferences.getUserData()};
    final response = await http.post(
      Uri.parse(ApiRoutes.getpaymentapi),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // print(response.body);
      var jsondecded = Uri.parse(response.body);
      await launchUrl(jsondecded);
    }
  }

  Future<void> checkSubscription() async {
    final url = Uri.parse('http://ijobshunts.com/public/api/payment-status');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'token': AppPreferences.getUserData(),
    });
    EasyLoading.show();
    final response = await http.post(url, headers: headers, body: body);
    EasyLoading.dismiss();
    final Map<String, dynamic> data = jsonDecode(response.body);
    final bool status = data['status'];
    final String created_date = data['created_date'];
    final String payment_date = data['payment_day'];


    if (status) {
      await _validateSubscription(created_date, payment_date);
    } else {
      Fluttertoast.showToast(
        msg: 'Internal Server Error, Please try again later ',
        backgroundColor: Colors.green,
      );
      print('Something went wrong api error');
    }

    setState(() {
      _isLoading = false;
    });
  }


  Future<bool> _validateSubscription(String createdDate,
      String paymentDate) async {
    final today = DateTime.now();
    print(today);
    DateTime freeTrial = DateTime.parse(createdDate).add(
        const Duration(days: 30));

    print('Created date: ${createdDate} & Free trial: ${freeTrial}');
    print('${freeTrial.month} is after addition of 30 days');

    print('started calculating days');
    if (today.isBefore(freeTrial)) {
      print('Is on freeTrial');
      _isSubscribed = true;
      return true;
    }
    DateTime _isOnSubscription = DateTime.parse(paymentDate).add(
        const Duration(days: 30));
    print('Payment date: ${paymentDate} & Subscription: ${_isOnSubscription}');
    if (today.isBefore(_isOnSubscription)) {
      print('Is on subscription');
      _isSubscribed = true;
      return true;
    }
    print('Neither freeTrial nor subscribed');
    _isSubscribed = false;
    return false;
    /*print("today.month = ${today.day}");
    print("day= ${day}");
    print("today.month = ${today.month}");
    print("month = ${month}");*/


    /*if(today.month> month){
       if(today.day>day){
          if(today.month == paymentMonth || today.month < paymentMonth ){
            if(today.day == paymentDay || today.day < paymentDay){
              return false;
            }else{
              return true;
            }
          }else{
            return true;
          }

       }else{
         return false;
       }
    }else{
      return false;
    }*/
  }

}
