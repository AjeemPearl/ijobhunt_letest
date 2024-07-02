import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/core/notifiers/user.notifier.dart';
import 'package:ijobhunt/screens/ProfileScreen/educationdetails.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ijobhunt/screens/ProfileScreen/userprofile.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPersonalInfo extends StatefulWidget {
  UserPersonalInfo({
    super.key,
  });

  @override
  State<UserPersonalInfo> createState() => _UserPersonalInfoState();
}

class _UserPersonalInfoState extends State<UserPersonalInfo> {
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
  File? image;
  var token = '';
  bool isloading = false;
  String img = '';
  String imgext = '';
  String? selectedCountry;
  String? selectedPhoneCOde;
  List<String> countries = [];
  List<String> PhoneCodes = [];
  final _formKey = GlobalKey<FormState>();
  final phoneCodeDropdown = GlobalKey<FormFieldState>();
  final _picker = ImagePicker();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController dateofbirthcontroller = TextEditingController();
  TextEditingController professioncontroller = TextEditingController();
  TextEditingController experincecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();

  Future pickimage() async {
    final pickedimage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );

    if (pickedimage != null) {
      if (mounted) {
        setState(() {
          image = File(pickedimage.path);
          Uint8List byts = File(pickedimage.path).readAsBytesSync();
          img = base64Encode(byts);
          imgext = p.extension(pickedimage.path);
        });
      }
    }
  }

  Future getUserPersonalInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
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
        usercountry = pref.getString('usercountry') ?? 'India';
      });
    }
    if (mounted) {
      setState(() {
        token = token;
        namecontroller.text = name;
        emailcontroller.text = email;
        phonecontroller.text = phone;
        aboutcontroller.text = about;
        dateofbirthcontroller.text = dob;
        professioncontroller.text = profession;
        addresscontroller.text = address;
        // about = about;
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
        selectedCountry = usercountry;

        // ignore: avoid_print
      });
    }
  }

  Future init() async {
    final country = await CountriesData.getcountries();
    final phonecodes = await CountriesData.getPhoneCodes();
    if (mounted) {
      setState(() {
        for (var item in country) {
          countries.add(item["name"]);
          //print(countries);
        }
        for (var phone in phonecodes) {
          if (mounted) {
            setState(() {
              PhoneCodes.add('+'+phone['phonecode']);
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    init();
    getUserPersonalInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                pickimage();
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shedowgreyColor,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  image: image == null
                                      ? uimage != ''
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                'http://www.ijobshunts.com/storage/app/public/${uimage}',
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/employerhome/user.png',
                                              ),
                                            )
                                      : DecorationImage(
                                          image: Image.file(
                                                  File(image!.path).absolute)
                                              .image,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              bottom: 2.0,
                              child: FaIcon(
                                FontAwesomeIcons.cameraRetro,
                                color: AppColors.blueZodiacTwo,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 15.0,
                          ),
                          child: Container(
                            width: 200,
                            // color: Colors.red,
                            child: Text(
                              name,
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.lato().fontFamily,
                                color: AppColors.blueZodiacTwo,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Divider(
                      height: 2.5,
                      thickness: 1.5,
                      color: AppColors.blueZodiacTwo,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context)!.name} : ',
                        hintText: 'Example: Jhon Marsh',
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
                          value!.isEmpty ? "Enter Your Full name" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'\s'),
                        ),
                      ],
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.email} :",
                        hintText: 'Example: Jhon@gmail.com',
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
                      validator: (val) =>
                          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(val!)
                              ? 'Enter Valid Email'
                              : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 98,
                            decoration: BoxDecoration(
                              border: Border.all(width: .5),
                              borderRadius:
                              BorderRadius.circular(8.0),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: DropdownButtonFormField2(
                                    //buttonWidth: 50,
                                    key: phoneCodeDropdown,
                                    hint: const Text("+91"),
                                    items: PhoneCodes
                                        .map(
                                          (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                        .toList(),
                                    value: selectedPhoneCOde,
                                    validator: (value) => value == null
                                        ? 'Please select the valid job location'
                                        : null,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          selectedPhoneCOde = value.toString();
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText: '${AppLocalizations.of(context)!.phone} : ',
                        hintText: 'Example: 9536204712',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter Valid phone number' : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: dateofbirthcontroller,
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
                        labelText: '${AppLocalizations.of(context)!.dob}: ',
                        hintText: 'Example: 01/01/1985',
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
                          dateofbirthcontroller.text =
                              DateFormat('dd MMMM yyyy').format(pickedDate);
                        }
                      },
                      validator: (value) =>
                          value!.isEmpty ? "Enter date of birth" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: professioncontroller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        focusColor: AppColors.blueZodiacTwo,
                        labelText:
                            '${AppLocalizations.of(context)!.profession} : ',
                        hintText: 'Example: Developer',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Your profession" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: addresscontroller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText:
                            '${AppLocalizations.of(context)!.companyaddtext10} : ',
                        hintText: 'Example: New york, America',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Your address" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.companyaddtext7} : ',
                      style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: DropdownSearch<String>(
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                labelText: selectedCountry ??
                                    '-- Please Select Country --',
                                labelStyle: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          items: countries.map((item) => item).toList(),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                selectedCountry = value.toString();
                                print("new country is ${selectedCountry}");
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    TextFormField(
                      controller: aboutcontroller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.blueZodiacTwo,
                          ),
                        ),
                        labelText:
                            '${AppLocalizations.of(context)!.aboutMe} : ',
                        hintText: 'Express Somthing About your self',
                        labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? "tell" : null,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (mounted) {
                            setState(() {
                              isloading = true;
                            });
                            // SharedPreferences pref =
                            //     await SharedPreferences.getInstance();
                            // pref.setString('uname', namecontroller.text);
                            // pref.setString('uphone', phonecontroller.text);
                            // pref.setString('uemail', emailcontroller.text);
                            // pref.setString('dob', dateofbirthcontroller.text);
                            // pref.setString(
                            //     'profession', professioncontroller.text);
                            // pref.setString('address', addresscontroller.text);
                            // pref.setString(
                            //     'ucountry', selectedCountry.toString());
                            // pref.setString('aboutu', aboutcontroller.text);
                          }

                          UserProFile.updateuser(
                            name: namecontroller.text,
                            phone: selectedPhoneCOde! + phonecontroller.text,
                            email: emailcontroller.text,
                            token: token,
                            dateofbirth: dateofbirthcontroller.text,
                            profession: professioncontroller.text,
                            address: addresscontroller.text,
                            aboutyourself: aboutcontroller.text,
                            image: img.toString(),
                            imageext: imgext,
                            context: context,
                            degreetitle: degreetitle,
                            institutename: institute,
                            degreestartdate: degreestartdate,
                            degreeenddate: degreeenddate,
                            degreepercent: percent,
                            degreegrade: grade,
                            degreedetails: degreedetails,
                            organizationname: orgname,
                            jobstartDate: jobstartdate,
                            jobendDate: jobenddate,
                            stillWorking: stillworking,
                            yourole: role,
                            jobdetails: jobdetails,
                            job_title: jobtitle,
                            usercountry: selectedCountry,
                            keywords: '',
                          ).whenComplete(() {
                            if (mounted) {
                              setState(() {
                                isloading = false;
                              });
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfile(
                                  token: token,
                                ),
                              ),
                            );
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
                                        .saveinformation,
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
