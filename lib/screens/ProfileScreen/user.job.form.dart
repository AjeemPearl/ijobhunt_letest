import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/screens/ProfileScreen/educationdetails.dart';
import 'package:ijobhunt/screens/ProfileScreen/jobdetails.dart';
import 'package:ijobhunt/screens/ProfileScreen/personalinfo.dart';
import 'package:ijobhunt/screens/ProfileScreen/userprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserForm extends StatefulWidget {
  UserForm({
    super.key,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var token = '';
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
  var uimage = '';
  var jobtitle = '';
  var stillworking = '';
  var usercountry = '';

  Future getUserPersonalInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    name = pref.getString('uname') ?? '';
    email = pref.getString('uemail') ?? '';
    dob = pref.getString('udob') ?? '';
    phone = pref.getString('uphone') ?? '';
    profession = pref.getString('uproff') ?? '';
    address = pref.getString('uaddress') ?? '';
    about = pref.getString('uabout') ?? '';
    uimage = pref.getString('uimage') ?? '';
    degreetitle = pref.getString('degreetitle') ?? '';
    institute = pref.getString('institutename') ?? '';
    degreestartdate = pref.getString('degreestartdate') ?? '';
    degreeenddate = pref.getString('degreeenddate') ?? '';
    percent = pref.getString('degreepercent') ?? '';
    grade = pref.getString('degreegrade') ?? '';
    degreedetails = pref.getString('degreedetails') ?? '';
    orgname = pref.getString('organizationname') ?? '';
    jobtitle = pref.getString('job_title') ?? '';
    jobstartdate = pref.getString('jobstartDate') ?? '';
    jobenddate = pref.getString('jobendDate') ?? '';
    stillworking = pref.getString('stillWorking') ?? '';
    role = pref.getString('yourole') ?? '';
    jobdetails = pref.getString('jobdetails') ?? '';
    usercountry = pref.getString('country') ?? 'India';
    if (mounted) {
      setState(() {
        token = token;
        name = name;
        email = email;
        phone = phone;
        about = about;
        dob = dob;
        profession = profession;
        address = address;
        about = about;
        uimage = uimage;
        degreetitle = degreetitle;
        degreestartdate = degreestartdate;
        degreeenddate = degreeenddate;
        percent = percent;
        grade = grade;
        degreedetails = degreedetails;
        orgname = orgname;
        jobtitle = jobtitle;
        jobstartdate = jobstartdate;
        jobenddate = jobenddate;
        stillworking = stillworking;
        jobdetails = jobdetails;
        usercountry = usercountry;

        // ignore: avoid_print
      });
    }
  }

  // Future gettoken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   token = pref.getString(AppKeys.userData) ?? '';
  //   country = pref.getString('country') ?? '';

  //   if (mounted) {
  //     setState(() {
  //       token = token;
  //       country = country;

  //       // ignore: avoid_print
  //     });
  //   }
  // }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    getUserPersonalInfo();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.blueZodiacTwo,
        ),
        backgroundColor: AppColors.blueZodiacTwo,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  token: token,
                ),
              ),
            );
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: AppColors.white,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.myprofile,
          style: TextStyle(
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.bars))
        // ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: AppColors.blueZodiacTwo,
                unselectedLabelColor: Colors.grey,
                labelColor: AppColors.blueZodiacTwo,
                labelStyle: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                controller: tabController,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.personalinfromation,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.educationinfromation,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.professionalInformation,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    UserPersonalInfo(
                        // name: snapshot.data!.name.toString(),
                        // phone: snapshot.data!.phone.toString(),
                        // email: snapshot.data!.email.toString(),
                        // dob: snapshot.data!.dateofbirth.toString(),
                        // profession: snapshot.data!.profession.toString(),
                        // address: snapshot.data!.address.toString(),
                        // about: snapshot.data!.aboutyourself.toString(),
                        // image: snapshot.data!.image.toString(),
                        // degreetitle: snapshot.data!.degreetitle.toString(),
                        // institute: snapshot.data!.institutename.toString(),
                        // degreeenddate:
                        //     snapshot.data!.degreeenddate.toString(),
                        // degreestartdate:
                        //     snapshot.data!.degreestartdate.toString(),
                        // percent: snapshot.data!.degreepercent.toString(),
                        // grade: snapshot.data!.degreegrade.toString(),
                        // degreedetails:
                        //     snapshot.data!.degreedetails.toString(),
                        // orgname: snapshot.data!.organizationname.toString(),
                        // jobstartdate:
                        //     snapshot.data!.jobstartDate.toString(),
                        // jobenddate: snapshot.data!.jobendDate.toString(),
                        // role: snapshot.data!.yourole.toString(),
                        // jobdetails: snapshot.data!.jobdetails.toString(),
                        // jobtitle: snapshot.data!.jobTitle.toString(),
                        // stillworking:
                        //     snapshot.data!.stillWorking.toString(),
                        // token: token,
                        // usercountry: usercountry,
                        // name: name.toString(),
                        // phone: phone,
                        // email: email,
                        // dob: dob,
                        // profession: profession,
                        // address: address,
                        // about: about,
                        // image: uimage,
                        // degreetitle: degreetitle,
                        // institute: institute,
                        // degreeenddate: degreeenddate,
                        // degreestartdate: degreestartdate,
                        // percent: percent,
                        // grade: grade,
                        // degreedetails: degreedetails,
                        // orgname: orgname,
                        // jobstartdate: jobstartdate,
                        // jobenddate: jobenddate,
                        // role: role,
                        // jobdetails: jobdetails,
                        // jobtitle: jobtitle,
                        // stillworking: stillworking,
                        // token: token,
                        // usercountry: usercountry,
                        ),
                    EducationDetails(
                      name: name,
                      phone: phone,
                      email: email,
                      dob: dob,
                      profession: profession,
                      address: address,
                      about: about,
                      image: uimage,
                      degreetitle: degreetitle,
                      institute: institute,
                      degreeenddate: degreeenddate,
                      degreestartdate: degreestartdate,
                      percent: percent,
                      grade: grade,
                      degreedetails: degreedetails,
                      orgname: orgname,
                      jobstartdate: jobstartdate,
                      jobenddate: jobenddate,
                      role: role,
                      jobdetails: jobdetails,
                      jobtitle: jobtitle,
                      stillworking: stillworking,
                      token: token,
                      usercountry: usercountry,
                    ),
                    UserJobDetails(
                      name: name,
                      phone: phone,
                      email: email,
                      dob: dob,
                      profession: profession,
                      address: address,
                      about: about,
                      image: uimage,
                      degreetitle: degreetitle,
                      institute: institute,
                      degreeenddate: degreeenddate,
                      degreestartdate: degreestartdate,
                      percent: percent,
                      grade: grade,
                      degreedetails: degreedetails,
                      orgname: orgname,
                      jobstartdate: jobstartdate,
                      jobenddate: jobenddate,
                      role: role,
                      jobdetails: jobdetails,
                      jobtitle: jobtitle,
                      stillworking: stillworking,
                      token: token,
                      usercountry: usercountry,
                    )
                  ],
                ),
              ),
            ],
          ),

          //  FutureBuilder<UserModel?>(
          //   future: UserProFile.getUserData(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return
          //     } else {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}
