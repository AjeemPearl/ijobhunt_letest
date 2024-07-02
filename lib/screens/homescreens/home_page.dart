import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';

import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/applesignin.dart';
import 'package:ijobhunt/screens/notificonSceen/localnotification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/jobs_model.dart';
import 'package:ijobhunt/core/models/user.model.dart';
import 'package:ijobhunt/core/notifiers/jobsdata.dart';
import 'package:ijobhunt/core/notifiers/theme.notifier.dart';
import 'package:ijobhunt/screens/ProfileScreen/userprofile.dart';
import 'package:ijobhunt/screens/companyscreen/mytopcompanies.dart';
import 'package:ijobhunt/screens/homescreens/favjobs.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:ijobhunt/screens/homescreens/videoscreen.dart';
import 'package:ijobhunt/screens/homescreens/widgets/card_widget.dart';
import 'package:ijobhunt/screens/homescreens/widgets/showqusetiondilog.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/authentication.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/searchScreen/search.screen.dart';
import '../../app/constants/app.keys.dart';
import '../../core/models/getCompanies.dart';
import '../../core/notifiers/langaugeChangeprovider.dart';
import '../../l10n/l10n.dart';
import '../AndroidPayment/payment.dart';
import '../inapppurches/Paywall.dart';
import '../notificonSceen/notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSubscribed = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List companies = [];
  List<UserModel> user = [];
  var uname = '';
  var token = AppPreferences.getUserData();
  var themeflag;
  bool isloading = false;
  var isFavorite = '';
  var language = '';

  //Timer? debouncer;
  var employerphone = '';
  var employeremail = '';
  var companyname = '';
  var salary = '';
  var jobdesc = '';
  var jobtype = '';
  var selectedcountry = (AppPreferences.getCountry() == '')
      ? 'United States'
      : AppPreferences.getCountry();
  var location = '';
  var compid = '';
  int? payment;
  late bool duration;

  bool _isLoading = true;

  /*Future gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //token = pref.getString(AppKeys.userData) ?? '';
    //selectedcountry = pref.getString('country') ?? 'United States';
    if (mounted) {
      setState(() {
        token = token;
        print("token ===setState="+token);
        selectedcountry = selectedcountry;
        // ignore: avoid_print
      });
    }
  }*/

  Future getpaymentApi() async {
    // print("Hello how are you");
    Map data = {'token': token};
    final response = await http.post(
      Uri.parse(ApiRoutes.getpaymentapi),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    print("token ===getpaymentapi=" + token);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      // print(response.body);
      var jsondecded = Uri.parse(response.body);
      await launchUrl(jsondecded);
    }
  }

  Future<JobsModel?> getjobsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token1 = pref.getString(AppKeys.userData) ?? '';
    var selectedcountry1 = pref.getString('country') ?? 'United States';
    try {
      Map data = {
        'country': selectedcountry1,
        'token': token1,
      };
      print("token1 ===getjobsdata=" + token1);
      print("country1 ===getjobsdata=" + selectedcountry1);
      final response = await http.post(
        Uri.parse(ApiRoutes.jobsapi),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );
      print("=====" + response.body.toString());
      if (response.statusCode == 201) {
        //print("====="+response..toString());
        return JobsModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        return null;
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print(e);
    }
  }

  Future<List<Getcompanies>?> getCompaniesData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final response = await Dio().get(ApiRoutes.getcompaniesapi,
          queryParameters: {'country': pref.getString('country')});

      if (response.statusCode == 201) {
        return (response.data as List)
            .map((e) => Getcompanies.fromJson(e))
            .toList();
      } else {
        throw Exception();
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print(e);
    }
  }

  Future init() async {
    try {
      isloading = true;
      getjobsData();
      final companies = await getCompaniesData();
      setState(() {
        this.companies = companies!;
        isloading = false;
      });
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    checkSubscription();

    //gettoken();
    //print("user token here $gettoken()");
    super.initState();
  }

  bool differenceBetweenTodayAndOneMonthLater(
      String createdDate, String paymentDate) {
    final today = DateTime.now();
    print(today);
    DateTime freeTrial =
        DateTime.parse(createdDate).add(const Duration(days: 30));

    print('Created date: ${createdDate} & Free trial: ${freeTrial}');
    print('${freeTrial.month} is after addition of 30 days');

    print('started calculating days');
    if (today.isBefore(freeTrial)) {
      print('Is on freeTrial');
      return true;
    }
    DateTime _isOnSubscription =
        DateTime.parse(paymentDate).add(const Duration(days: 30));
    print('Payment date: ${paymentDate} & Subscription: ${_isOnSubscription}');
    if (today.isBefore(_isOnSubscription)) {
      print('Is on subscription');
      return true;
    }
    print('Neither freeTrial nor subscribed');

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

  Future<void> checkSubscription() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(AppKeys.userData) ?? '';
    final url = Uri.parse('http://ijobshunts.com/public/api/payment-status');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'token': token,
    });
    EasyLoading.show();
    final response = await http.post(url, headers: headers, body: body);
    EasyLoading.dismiss();
    print("abc = ${response.body}");
    final Map<String, dynamic> data = jsonDecode(response.body);
    final bool status = data['status'];
    final int paymentStatus = data['payment_status'];
    final String created_date = data['created_date'];
    final String payment_date = data['payment_day'];

    print(created_date);
    print(payment_date);
    //final int created_month = int.parse(data['created_month']);
    //final int payment_day= int.parse(data['payment_day']);
    //final int payment_month = int.parse(data['payment_month']);

    if (status) {
      bool duration =
          differenceBetweenTodayAndOneMonthLater(created_date, payment_date);
      //print("duration == ${duration}");
      if (duration) {
        _isSubscribed = true;
        init();
      } else {
        _isSubscribed = false;
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Internal Server Error, Please try again later ',
        backgroundColor: Colors.green,
      );
      print('Something went wrong api error');
    }

    final jsonData = jsonDecode(response.body);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    themeFlag = Provider.of<ThemeNotifier>(context).darkTheme;
    return _isLoading
        ? Container(
            color: AppColors.creamColor,
            child: const Column(
              children: [
                Spacer(
                  flex: 2,
                ),
                Text('Please Wait'),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          )
        : Consumer<LanguageChangeProvider>(
            builder: (context, notifier, _) {
              var langauge = notifier.locale ?? Localizations.localeOf(context);
              return LayoutBuilder(builder: (context, constraints) {
                return _isSubscribed
                    ? Scaffold(
                        key: _scaffoldKey,
                        appBar: AppBar(
                          iconTheme: IconThemeData(
                              color: themeFlag
                                  ? AppColors.creamColor
                                  : AppColors.mirage),
                          //automaticallyImplyLeading: false,
                          foregroundColor: themeFlag
                              ? AppColors.mirage
                              : AppColors.creamColor,
                          elevation: 0,
                          backgroundColor: themeFlag
                              ? AppColors.mirage
                              : AppColors.creamColor,
                          leadingWidth: 250,
                          leading: const Image(
                            image: AssetImage(
                              'assets/images/logo/logo1.png',
                            ),
                            height: 30,
                          ),
                          actions: [
                            SizedBox(
                              height: 50,
                              width: 250,
                              //color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 95.0,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // NotificationServices.showNotification(
                                      //     title: 'Jobtitle', body: 'JobDesc', payload: 'new');
                                      //NotificationServices.sendNotification("title", "body");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.notifications,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    },
                                    icon: const Icon(
                                      Icons.menu,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
                        backgroundColor: Colors.grey[100],
                        endDrawer: Drawer(
                          width: MediaQuery.of(context).size.width / 1,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              DrawerHeader(
                                margin: const EdgeInsets.only(bottom: 0),

                                ///***  Header of Drawer
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: <Widget>[
                                    Image(
                                      image: const AssetImage(
                                          "assets/images/logo/logo2.png"),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.home,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.drawertext3,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: FaIcon(
                                  Icons.search,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.drawertext10,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreen(
                                        //country: selectedcountry,
                                        token: token,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: FaIcon(
                                  Icons.payments,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.buySubscription,
                                  //AppLocalizations.of(context)!.drawertext10,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DemoPage(userType: 'candidate'),
                                    ),
                                  );

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => SearchScreen(
                                  //       //country: selectedcountry,
                                  //       token: token,
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.account_circle,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.drawertext4,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                        token: token,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.bell,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.drawertext7,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.heart,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.drawertext6,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FavJobs(
                                        employerphone: employerphone,
                                        employeremail: employeremail,
                                        companyname: companyname,
                                        token: token,
                                        compid: compid,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.logout,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .drawerlogoutbutton,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () async {
                                  AppPreferences.clearCredential();
                                  if (Authentication.islogin == true) {
                                    await FacebookAuth.instance.logOut();
                                  } else if (appleSignInAvailable.isAvailable) {
                                    await FirebaseAuth.instance
                                        .signOut()
                                        .whenComplete(() {});
                                  } else if (token.isNotEmpty) {
                                    setState(() {
                                      isloading = true;
                                    });
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    preferences
                                        .remove(AppKeys.userData)
                                        .whenComplete(() {
                                      setState(() {
                                        isloading = false;
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    });
                                  }
                                  Authentication.signOut(context: context);
                                  if (mounted) {
                                    setState(() {
                                      print("User Signed Out");
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.deleteaccount,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height /
                                              50,
                                      color: AppColors.blackPearl,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () async {
                                  ShowMyDialog.showDeletePopup(
                                      context: context);
                                  // UserProFile.deleteAccount(context: context)
                                  //     .whenComplete(() async {
                                  //   if (Authentication.islogin == true) {
                                  //     if (mounted) {
                                  //       setState(() {
                                  //         FacebookAuth.instance
                                  //             .logOut()
                                  //             .whenComplete(() async {
                                  //           SharedPreferences preferences =
                                  //               await SharedPreferences.getInstance();
                                  //           preferences.remove(AppKeys.userData).whenComplete(
                                  //                 () => Navigator.pushReplacement(
                                  //                   context,
                                  //                   MaterialPageRoute(
                                  //                     builder: (context) => LoginScreen(),
                                  //                   ),
                                  //                 ),
                                  //               );
                                  //         });
                                  //         print("User Signed Out");
                                  //       });
                                  //     }
                                  //   } else if (appleSignInAvailable.isAvailable) {
                                  //     await FirebaseAuth.instance
                                  //         .signOut()
                                  //         .whenComplete(() {});
                                  //   } else if (token.isNotEmpty) {
                                  //     setState(() {
                                  //       isloading = true;
                                  //     });
                                  //     SharedPreferences preferences =
                                  //         await SharedPreferences.getInstance();
                                  //     preferences.remove(AppKeys.userData).whenComplete(() {
                                  //       setState(() {
                                  //         isloading = false;
                                  //       });
                                  //       Navigator.pushReplacement(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => LoginScreen(),
                                  //         ),
                                  //       );
                                  //     });
                                  //   }
                                  //   Authentication.signOut(context: context);
                                  // });
                                },
                              ),
                              ListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.language,
                                  color: AppColors.blackPearl,
                                  size: MediaQuery.of(context).size.height / 50,
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    DropdownButton2(

                                      hint: const Text("Choose Language"),
                                      // buttonElevation: 0,
                                      // buttonDecoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(14),
                                      // ),
                                      // dropdownDecoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(14),
                                      // ),
                                      isExpanded: true,
                                      value: langauge,
                                      onChanged: ((Locale? value) {
                                        setState(() {
                                          notifier.changeLocale(value!);
                                        });
                                      }),
                                      items: L10n.all
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                L10n.getlangauge(e.languageCode)
                                                    .toString(),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                35),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10),
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .drawertext14,
                                            style: TextStyle(
                                                color: AppColors.blackPearl)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.zero,
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width,
                                //color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(
                                            'https://www.facebook.com/profile.php?id=100089006524415');
                                        await launchUrl(url);
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.facebook,
                                        color: AppColors.blueZodiac,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(
                                        FontAwesomeIcons.envelope,
                                        color: AppColors.rawSienna,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                55,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(
                                        FontAwesomeIcons.twitter,
                                        color: Colors.blue,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                55,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: FaIcon(
                                        FontAwesomeIcons.linkedin,
                                        color: Colors.blueAccent,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                55,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(
                                            'https://www.instagram.com/info.ijobhunt/');
                                        await launchUrl(url);
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.purpleAccent,
                                        size:
                                            MediaQuery.of(context).size.height /
                                                55,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(
                                            'https://in.pinterest.com/infoijobhunt/');
                                        await launchUrl(url);
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.pinterest,
                                        color: Colors.redAccent,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                25,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(height: MediaQuery.of(context).size.height / 350),
                              Padding(
                                padding: EdgeInsets.only(
                                    // bottom: MediaQuery.of(context).size.height / 75,
                                    left: MediaQuery.of(context).size.height /
                                        75),
                                child: const Text("ⓒ2023 iJobhunt"),
                              ),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .drawertext11,
                                        style: TextStyle(
                                            color: AppColors.blackPearl),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .drawertext12,
                                        style: TextStyle(
                                          color: AppColors.blackPearl,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .drawertext13,
                                        style: TextStyle(
                                          color: AppColors.blackPearl,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        body: WillPopScope(
                          onWillPop: showExitPopup,
                          child: SafeArea(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SizedBox(
                                    //alignment: Alignment.centerRight,
                                    height: MediaQuery.of(context).size.height *
                                        0.13,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchScreen(
                                                    //country: selectedcountry,
                                                    token: token,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  topRight: Radius.circular(
                                                    8.0,
                                                  ),
                                                ),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black26),
                                              ),
                                              child: const Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Icon(
                                                    Icons.search,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                      "Job title, keywords, or company")
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
                                                      SearchScreen(
                                                    //country: selectedcountry,
                                                    token: token,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                ),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black26),
                                              ),
                                              child: const Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  Icon(
                                                    Icons.location_pin,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    "Enter Country",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 8.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MyVideoPlayer()));
                                            },
                                            child: constraints.maxWidth > 600
                                                ? Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/logo/banner.jpg',
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: themeFlag
                                                                ? AppColors
                                                                    .blackPearl
                                                                : AppColors
                                                                    .shedowgreyColor,
                                                            blurRadius: 4,
                                                            spreadRadius: 0.5,
                                                            offset:
                                                                const Offset(
                                                                    0, 4))
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/logo/banner.jpg',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        8.0,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: themeFlag
                                                                ? AppColors
                                                                    .blackPearl
                                                                : AppColors
                                                                    .shedowgreyColor,
                                                            blurRadius: 4,
                                                            spreadRadius: 0.5,
                                                            offset:
                                                                const Offset(
                                                                    0, 4))
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .topcompanies,
                                                style: const TextStyle(
                                                  // fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          //color: Colors.red,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: isloading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : companies.isNotEmpty
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          companies.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var company =
                                                            companies[index];
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MyTopCompanies(
                                                                  companyid: company
                                                                      .id
                                                                      .toString(),
                                                                  token: token
                                                                      .toString(),
                                                                  employeremail:
                                                                      company
                                                                          .email
                                                                          .toString(),
                                                                  employerphone: company
                                                                      .phoneNumber
                                                                      .toString(),
                                                                  companyname: company
                                                                      .comapnyName
                                                                      .toString(),
                                                                  aboutcompany: company
                                                                      .aboutCompany
                                                                      .toString(),
                                                                  image: company
                                                                      .image
                                                                      .toString(),
                                                                  country: company
                                                                      .country
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              if (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width >
                                                                  500) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              2),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.15,
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.25,
                                                                        margin: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                1),
                                                                        child: Card(
                                                                            elevation: 0.5,
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Container(padding: const EdgeInsets.all(8.0), height: 150.0, width: 150.0, child: ClipOval(child: Container(color: Colors.grey[200], child: Image.network("http://www.ijobshunts.com/storage/app/public/${company.image}", fit: BoxFit.scaleDown)))),
                                                                                const SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Container(
                                                                                  // color: Colors.white,
                                                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      company.comapnyName.toString(),
                                                                                      style: const TextStyle(letterSpacing: 1, fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )),

                                                                        //   child:
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 2,
                                                                        right:
                                                                            2),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          200,

                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              1),
                                                                      child: Card(
                                                                          elevation: 0.5,
                                                                          child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(padding: const EdgeInsets.all(8.0), child: ClipOval(child: Container(height: 100, width: 100, color: Colors.red, child: Image.network("http://www.ijobshunts.com/storage/app/public/${company.image}", fit: BoxFit.scaleDown)))),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Container(
                                                                                // color: Colors.white,
                                                                                //width: MediaQuery.of(context).size.width*0.3,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    company.comapnyName.toString(),
                                                                                    style: const TextStyle(letterSpacing: 1, fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 5,
                                                                              )
                                                                            ],
                                                                          )),

                                                                      //   child:
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      })
                                                  : const Center(
                                                      child: Text(
                                                        "No Data Found",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .recomendedForYou,
                                                style: const TextStyle(
                                                    // fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    //height: MediaQuery.of(context).size.height,
                                    child: FutureBuilder<JobsModel?>(
                                      future: getjobsData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (mounted) {
                                            payment =
                                                snapshot.data!.paymentStatus;
                                          }
                                          // if (snapshot.data!.paymentStatus == 0 ||
                                          //     snapshot.data!.paymentStatus == '0') {
                                          //   return Center(
                                          //     child: Container(
                                          //       alignment: Alignment.center,
                                          //       child: _buildPopupDialog(context),
                                          //     ),
                                          //   );
                                          // }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics: const ScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.jobs!.length,
                                            itemBuilder: (context, index) {
                                              var data =
                                                  snapshot.data!.jobs![index];

                                              if (data.myUser != null) {
                                                employerphone = data
                                                    .myUser!.phone
                                                    .toString();
                                                employeremail = data
                                                    .myUser!.email as String;
                                              }
                                              if (data.myCompany != null) {
                                                companyname = data.myCompany!
                                                    .comapnyName as String;

                                                compid = data.myCompany!.id
                                                    .toString();
                                              }

                                              //salary = data.myUser!.phone as String;
                                              jobtype = data.jobType.toString();
                                              jobdesc = data.jobDesc.toString();

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  bottom: 8.0,
                                                ),
                                                child: Card(
                                                  elevation: 1,
                                                  child: Container(
                                                    color: Colors.grey[50],
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              data.jobTitle
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1),
                                                            ),
                                                            FavoriteButton(
                                                                iconSize: 35,
                                                                isFavorite:
                                                                    data.myLike,
                                                                valueChanged:
                                                                    (value) {
                                                                  value
                                                                      ? FebJobs.saveFebJobs(
                                                                          token,
                                                                          data.id
                                                                              as int)
                                                                      : FebJobs
                                                                          .removeFavJobs(
                                                                          token,
                                                                          data.id
                                                                              as int,
                                                                        );
                                                                  setState(() {
                                                                    isFavorite =
                                                                        value
                                                                            .toString();
                                                                  });
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            data.myCompany !=
                                                                    null
                                                                ? Text(
                                                                    companyname
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        letterSpacing:
                                                                            1),
                                                                  )
                                                                : Container(),
                                                            const SizedBox(
                                                              width: 8.0,
                                                            ),
                                                            SmoothStarRating(
                                                                allowHalfRating:
                                                                    false,
                                                                onRatingChanged:
                                                                    (v) {},
                                                                starCount: 5,
                                                                rating: data.myCompany !=
                                                                        null
                                                                    ? double.parse(
                                                                        '${data.myCompany!.rating}')
                                                                    : 0,
                                                                size: 15.0,
                                                                //isReadOnly: true,
                                                                filledIconData:
                                                                    Icons.star,
                                                                halfFilledIconData:
                                                                    Icons
                                                                        .star_half,
                                                                color: AppColors
                                                                    .purpleblulish,
                                                                borderColor:
                                                                    AppColors
                                                                        .purpleblulish,
                                                                spacing: 0.0),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.location_on,
                                                              color:
                                                                  Colors.grey,
                                                              size: 17.0,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              data.jobLocation
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Text(
                                                          data.country
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15.0,
                                                            // color: Color.fromARGB(
                                                            //     255, 28, 119, 31),
                                                            // fontSize: 17.0,
                                                            // fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Row(
                                                          // mainAxisAlignment:
                                                          //     MainAxisAlignment.center,
                                                          children: [
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              data.currency ==
                                                                      null
                                                                  ? '\$'
                                                                  : data
                                                                      .currency
                                                                      .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        28,
                                                                        119,
                                                                        31),
                                                                // fontSize: 17.0,
                                                                // fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              data.salary
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        28,
                                                                        119,
                                                                        31),
                                                                // fontSize: 17.0,
                                                                // fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Text(
                                                          data.jobType
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          data.jobDesc
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
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
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20))),
                                                              onPressed: () {
                                                                launchUrl(
                                                                  Uri(
                                                                      scheme:
                                                                          'tel',
                                                                      path: data.myUser !=
                                                                              null
                                                                          ? data
                                                                              .myUser!
                                                                              .phone
                                                                          : ''),
                                                                );
                                                              },
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Icon(
                                                                    Icons.call,
                                                                    size: 15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "Call",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .purple),
                                                              onPressed: () {
                                                                launchUrl(
                                                                  Uri(
                                                                    scheme:
                                                                        'mailto',
                                                                    path: data.myUser !=
                                                                            null
                                                                        ? data
                                                                            .myUser!
                                                                            .email
                                                                        : '',
                                                                  ),
                                                                );
                                                              },
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Icon(
                                                                    Icons.email,
                                                                    size: 15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "E-mail",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            JobDetails(
                                                                      jobtitle: data
                                                                          .jobTitle
                                                                          .toString(),
                                                                      comapnyname: data
                                                                          .myCompany!
                                                                          .comapnyName
                                                                          .toString(),
                                                                      salary: data
                                                                          .salary
                                                                          .toString(),
                                                                      jobdesc: data
                                                                          .jobDesc
                                                                          .toString(),
                                                                      employeremail: data.myUser !=
                                                                              null
                                                                          ? data
                                                                              .myUser!
                                                                              .email
                                                                              .toString()
                                                                          : '',
                                                                      employerno: data.myUser !=
                                                                              null
                                                                          ? data
                                                                              .myUser!
                                                                              .phone
                                                                              .toString()
                                                                          : '',
                                                                      compid: data
                                                                          .myCompany!
                                                                          .id
                                                                          .toString(),
                                                                      token:
                                                                          token,
                                                                      currency: data
                                                                          .currency
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                    "Details",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    size: 15.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ],
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
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              "Jobs Data Not Found ",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 15.0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _launchURL();
                                      },
                                      child: constraints.maxWidth > 600
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/logo/securitybanner.jpg',
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: themeFlag
                                                          ? AppColors.blackPearl
                                                          : AppColors
                                                              .shedowgreyColor,
                                                      blurRadius: 4,
                                                      spreadRadius: 0.5,
                                                      offset:
                                                          const Offset(0, 4))
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/logo/securitybanner.jpg',
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: themeFlag
                                                          ? AppColors.blackPearl
                                                          : AppColors
                                                              .shedowgreyColor,
                                                      blurRadius: 4,
                                                      spreadRadius: 0.5,
                                                      offset:
                                                          const Offset(0, 4))
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 15.0,
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.22,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            //color: Colors.white,

                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .bestcompanies,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            GoogleFonts.lato()
                                                                .fontFamily,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .bestcompanies3,
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            GoogleFonts.lato()
                                                                .fontFamily,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    RichText(
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .bestcompanies1,
                                                        style: TextStyle(
                                                          //fontSize: 13.0,
                                                          // fontWeight: FontWeight.bold,
                                                          fontFamily:
                                                              GoogleFonts.lato()
                                                                  .fontFamily,
                                                          color: Colors.black,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: AppLocalizations
                                                                    .of(context)!
                                                                .bestcompanies4,
                                                          ),
                                                          TextSpan(
                                                            text: AppLocalizations
                                                                    .of(context)!
                                                                .bestcompanies2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 35.0),
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      //color: Colors.white,

                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/logo/trusted.png',
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      //color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ShowMyDialog.bildratingdialog(context);
                                    },
                                    child: Container(
                                      height: 80.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      decoration: BoxDecoration(
                                        //color: Colors.yellow,
                                        color: Color(0XFFe9f7f8),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 15.0,
                                              right: 10.0,
                                            ),
                                            child: FaIcon(
                                              FontAwesomeIcons.star,
                                              color: AppColors.purpleblulish
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .homepagetext9,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: AppColors.blackPearl
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .homepagetext8,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: AppColors.blackPearl
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        GoogleFonts.lato()
                                                            .fontFamily,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ShowMyDialog.builddialog(context);
                                    },
                                    child: Container(
                                      height: 80.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      decoration: BoxDecoration(
                                        color: Color(0XFFe9f7f8),
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 15.0,
                                              right: 10.0,
                                            ),
                                            child: Icon(
                                              Icons.message,
                                              color: AppColors.purpleblulish
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .homepagetext7,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: AppColors.blackPearl
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: GoogleFonts.lato()
                                                    .fontFamily,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: AppLocalizations.of(
                                                          context)!
                                                      .homepagetext6,
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: AppColors.blackPearl
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        GoogleFonts.lato()
                                                            .fontFamily,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: Container(
                                      height: 250,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70,
                                            // height: MediaQuery.of(context).size.height * 0.31,
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Image(
                                                    image: AssetImage(
                                                      'assets/images/logo/logo1.png',
                                                    ),
                                                    height: 50,
                                                  ),
                                                  // SizedBox(
                                                  //   height: 10.0,
                                                  // ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "100,00+ Jobs\n",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          letterSpacing: 2,
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Libre"
                                                          // GoogleFonts.lato().fontFamily,
                                                          ),
                                                      children: [
                                                        WidgetSpan(
                                                            child: SizedBox(
                                                                height: 20)),
                                                        // Add space

                                                        TextSpan(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .homepagetext4,
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            letterSpacing: 1,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                GoogleFonts
                                                                        .lato()
                                                                    .fontFamily,
                                                          ),
                                                        ),
                                                        WidgetSpan(
                                                            child: SizedBox(
                                                                height: 20)),
                                                        // Add space

                                                        TextSpan(
                                                          text: AppLocalizations
                                                                  .of(context)!
                                                              .homepagetext5,
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            letterSpacing: 1,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: "Libre",
                                                            //GoogleFonts.lato().fontFamily,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 25.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchScreen(
                                                            //country: selectedcountry,
                                                            token: token,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 200.0,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1.0,
                                                          color: AppColors
                                                              .purpleblulish
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5.0,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .homepagetext3,
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .purpleblulish
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.arrow_forward,
                                                            size: 13.0,
                                                            color: AppColors
                                                                .purpleblulish
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            //  height: MediaQuery.of(context).size.height * 0.31,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    'assets/images/logo/searchjob.png',
                                                  ),
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    //height: MediaQuery.of(context).size.height * 0.12,
                                    width: MediaQuery.of(context).size.width,
                                    //color: Colors.red,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "ⓒ2023 iJobhunt",
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _launchAccessibilityURL();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .drawertext11,
                                                style: TextStyle(
                                                  color: AppColors.blackPearl,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _launchPrivacyURL();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .drawertext12,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _launchTeramURL();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .drawertext15,
                                                style: TextStyle(
                                                  color: AppColors.blackPearl,
                                                  fontSize: 15.0,
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
                        ),
                      )
                    : Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 75,
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: const Center(
                                      child: Text(
                                    "Your free Subscription is Expired to avail the Services",
                                    style: TextStyle(fontSize: 16.0),
                                  ))),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isloading = true;
                                  });
                                  if (Platform.isIOS) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const DemoPage(
                                                userType: 'candidate',
                                              )),
                                    );
                                  } else {
                                    EasyLoading.show();
                                    await getpaymentApi().whenComplete(() {
                                      setState(() {
                                        isloading = false;
                                      });
                                    });
                                    EasyLoading.dismiss();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.blueGrey[900],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Upgrade Now",
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
                        ),
                      );
              });
            },
          );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.paymentpopup),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          child: Text(AppLocalizations.of(context)!.paymentback),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isloading = true;
            });
            if (Platform.isIOS) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DemoPage(
                          userType: 'candidate',
                        )),
              );
            } else {
              getpaymentApi().whenComplete(() {
                setState(() {
                  isloading = false;
                });
              });
            }
          },
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Text(AppLocalizations.of(context)!.pay),
        ),
      ],
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}

_launchURL() async {
  const url = 'https://www.ijobhunts.com/about-us';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_launchPrivacyURL() async {
  const url = 'https://www.ijobhunts.com/privacy-policy';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_launchTeramURL() async {
  const url = 'https://www.ijobhunts.com/terms-and-condition';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

_launchAccessibilityURL() async {
  const url = 'https://www.ijobhunts.com/accessibility';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

firstlist(String imgVal, String text) {
  return SizedBox(
    width: 120.0,
    child: Container(
      alignment: Alignment.bottomCenter,
      // height: 40,
      // width: 40,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color:
                  themeFlag ? AppColors.blackPearl : AppColors.shedowgreyColor,
              blurRadius: 5,
              spreadRadius: 0.5,
              offset: const Offset(0, 4))
        ],
        color: Colors.white,
        image: DecorationImage(
          image: NetworkImage(
            imgVal,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 15.0,
          color: AppColors.purpleblulish,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
//cc/////d/d//ddd
