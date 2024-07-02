import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/screens/ProfileScreen/userprofile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationDetails extends StatefulWidget {
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
  var stillworking = '';
  var usercountry = '';

  EducationDetails({
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
    required this.stillworking,
    required this.usercountry,
  });

  @override
  State<EducationDetails> createState() => _EducationDetailsState();
}

class _EducationDetailsState extends State<EducationDetails> {
  TextEditingController degreetitelcontroller = TextEditingController();
  TextEditingController institutenamecontroller = TextEditingController();
  TextEditingController degreestartcontroller = TextEditingController();
  TextEditingController degreeendcontroller = TextEditingController();
  TextEditingController degreepercentcontroller = TextEditingController();
  TextEditingController degreegradecontroller = TextEditingController();
  TextEditingController degreedetailscontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  void initState() {
    degreetitelcontroller.text = widget.degreetitle.toString();
    institutenamecontroller.text = widget.institute.toString();
    degreestartcontroller.text = widget.degreestartdate.toString();
    degreeendcontroller.text = widget.degreeenddate.toString();
    degreepercentcontroller.text = widget.percent.toString();
    degreegradecontroller.text = widget.grade.toString();
    degreedetailscontroller.text = widget.degreedetails.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            //height: MediaQuery.of(context).size.height,
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
                      controller: degreetitelcontroller,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.degree} : ',
                        hintText: 'Enter degree title',
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
                          value!.isEmpty ? "Enter Degree Title" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: institutenamecontroller,
                      decoration: InputDecoration(
                        labelText:
                            "${AppLocalizations.of(context)!.institute} :",
                        hintText: 'Enter institute name',
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
                          value!.isEmpty ? "Enter Institute Name" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: degreestartcontroller,
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
                            '${AppLocalizations.of(context)!.startdate} : ',
                        hintText: 'Select start date',
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
                          degreestartcontroller.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) =>
                          value!.isEmpty ? "Enter start date" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: degreeendcontroller,
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
                            '${AppLocalizations.of(context)!.enddate} : ',
                        hintText: 'Select end date',
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
                          degreeendcontroller.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) =>
                          value!.isEmpty ? "Enter End date" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: degreepercentcontroller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        focusColor: AppColors.blueZodiacTwo,
                        labelText:
                            '${AppLocalizations.of(context)!.percent} % : ',
                        hintText: 'e.g 80.0 out %',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Percentes" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: degreegradecontroller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText: '${AppLocalizations.of(context)!.grade} : ',
                        hintText: 'only latters e.g A+,B+ etc',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter grade" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: degreedetailscontroller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText:
                            '${AppLocalizations.of(context)!.details} : ',
                        hintText: 'Example: New york, America',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Details" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                            degreetitle: degreetitelcontroller.text,
                            institutename: institutenamecontroller.text,
                            degreestartdate: degreestartcontroller.text,
                            degreeenddate: degreeendcontroller.text,
                            degreepercent: degreepercentcontroller.text,
                            degreegrade: degreegradecontroller.text,
                            degreedetails: degreedetailscontroller.text,
                            organizationname: widget.orgname,
                            jobstartDate: widget.jobstartdate,
                            jobendDate: widget.jobenddate,
                            stillWorking: '',
                            yourole: widget.role,
                            jobdetails: widget.jobdetails,
                            job_title: widget.jobtitle,
                            usercountry: widget.usercountry,
                            keywords: '',
                          ).whenComplete(() {
                            if (mounted) {
                              setState(() {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfile(
                                      token: widget.token,
                                    ),
                                  ),
                                );
                                isloading = false;
                              });
                            }
                          });
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .saveeducational,
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
      ),
    );
  }
}
