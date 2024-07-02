import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/core/notifiers/theme.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditJobs extends StatefulWidget {
  var jobid = '';
  var salary = '';
  var jobdes = '';
  var joblocation = '';
  var jobtitle = '';
  var currency = '';
  var country = '';
  var jobtype = '';

  EditJobs({
    super.key,
    required this.jobid,
    required this.salary,
    required this.jobdes,
    required this.joblocation,
    required this.jobtitle,
    required this.currency,
    required this.country,
    required this.jobtype,
  });

  @override
  State<EditJobs> createState() => _EditJobsState();
}

class _EditJobsState extends State<EditJobs> {
  bool isloading = false;
  var token = '';
  final _formKey = GlobalKey<FormState>();
  final locationdropdown = GlobalKey<FormFieldState>();
  final countrydropdown = GlobalKey<FormFieldState>();
  String? selectedValue;
  String? selectedCountry;
  String? seletedcurrency = '';
  List<CountryModel> country = [];
  List<String> countries = [];
  List<String> keywords = <String>[];
  var text = '';

  final TextEditingController salarycontroller = TextEditingController();
  final TextEditingController jobtitlecontroller = TextEditingController();
  final TextEditingController jobdesccontroller = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  final TextEditingController joblocationcontroller = TextEditingController();
  final TextEditingController keywordcontroller = TextEditingController();

  Future jobUpdate({
    required jobTitle,
    required jobid,
    required jobDesc,
    required country,
    required jobLocation,
    required jobType,
    required salary,
    required token,
    required currency,
  }) async {
    Map data = {
      'job_id': jobid,
      'job_title': jobTitle,
      'job_desc': jobDesc,
      'country': country,
      'job_location': jobLocation,
      'job_type': jobType,
      'salary': salary,
      'currency': currency,
    };
    final response = await http.post(
      Uri.parse(ApiRoutes.updateJobs),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    // ignore: avoid_print
    if (response.statusCode == 201) {
      //print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Job Updated  sucessfully", context: context),
      );
    }
  }

  Future gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';

    if (mounted) {
      setState(() {
        token = token;

        // ignore: avoid_print
      });
    }
  }

  Future init() async {
    final country = await CountriesData.getcountries();
    if (mounted) {
      setState(() {
        for (var item in country) {
          countries.add(item["name"]);
          print(countries);
        }
      });
    }
  }

  void changecurrency({required currency}) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(
        locale: locale.languageCode, name: currency);
    if (mounted) {
      setState(() {
        seletedcurrency = format.currencySymbol;
      });
    }
  }

  @override
  void initState() {
    gettoken();
    init();
    super.initState();
    jobdesccontroller.text = widget.jobdes;
    joblocationcontroller.text = widget.joblocation;
    jobtitlecontroller.text = widget.jobtitle;
    salarycontroller.text = widget.salary;
    seletedcurrency = widget.currency;
    selectedCountry = widget.country;
    selectedValue = widget.jobtype;
  }

  final List<String> items = [
    '--Plase Selsect--',
    'In person - precise location',
    'In person - general location',
    'Full Time',
    'part Time',
    'Remote',
    'Hybrid remotely.',
    'on the road'
  ];

  @override
  void dispose() {
    jobdesccontroller.dispose();
    joblocationcontroller.dispose();
    jobtitlecontroller.dispose();
    salarycontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const BottomNavBar(),
                //   ),
                // );
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: AppColors.blueZodiacTwo,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.updatejob,
              style: TextStyle(
                color: themeFlage
                    ? AppColors.metgoldenColor
                    : AppColors.blueZodiacTwo,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
          ),
          backgroundColor: themeFlage ? AppColors.mirage : AppColors.creamColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  // left: 15.0,
                  right: 15.0,
                  top: 5.0,
                  bottom: 15.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      //height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        // color: Colors.yellow,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 5.0,
                          bottom: 15.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.jobtitle,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: jobtitlecontroller,
                                decoration: InputDecoration(
                                  //hintText: "Your phone number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Job title can't be empty"
                                    : null,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.jobdescription,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: jobdesccontroller,
                                decoration: InputDecoration(
                                  //hintText: "Your phone number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Please enter the job description"
                                    : null,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.descjobsalary,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: salarycontroller,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        "$seletedcurrency",
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      showCurrencyPicker(
                                        context: context,
                                        showFlag: false,
                                        showSearchField: true,
                                        showCurrencyName: false,
                                        showCurrencyCode: true,
                                        onSelect: (Currency currency) {
                                          if (mounted) {
                                            setState(() {
                                              print(currency.code);
                                              changecurrency(
                                                  currency: currency.code);
                                            });
                                          }
                                        },
                                        favorite: ['USD'],
                                      );
                                    },
                                  ),
                                  //hintText: "Your phone number",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "salary can't be null"
                                    : null,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.country,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: DropdownSearch<String>(
                                    key: countrydropdown,
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                          labelText: selectedCountry ??
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
                                    items:
                                        countries.map((item) => item).toList(),
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          selectedCountry = value.toString();

                                          print(
                                              "new country is ${selectedCountry}");
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.descjoblocation,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              DropdownButtonFormField2(
                                  key: locationdropdown,
                                  hint: const Text("--Please Select--"),
                                  items: items
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ),
                                      )
                                      .toList(),
                                  value: selectedValue,
                                  validator: (value) => value == null
                                      ? 'Please select the valid job location'
                                      : null,
                                  onChanged: (value) {
                                    if (mounted) {
                                      setState(() {
                                        selectedValue = value.toString();
                                      });
                                    }
                                  }),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 10.0),
                                child: Text(
                                  AppLocalizations.of(context)!.address,
                                  style: TextStyle(
                                    color: themeFlage
                                        ? AppColors.metgoldenColor
                                        : AppColors.blueZodiacTwo,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: joblocationcontroller,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.isEmpty
                                    ? "Please enter the company address"
                                    : null,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              SizedBox(
                                height: 45.0,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (seletedcurrency!.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackUtil.stylishSnackBar(
                                              text: "Please select Currency ",
                                              context: context),
                                        );
                                      } else {
                                        if (mounted) {
                                          setState(() {
                                            isloading = true;
                                            jobUpdate(
                                              jobid: widget.jobid,
                                              salary: salarycontroller.text,
                                              jobDesc: jobdesccontroller.text,
                                              jobLocation:
                                                  joblocationcontroller.text,
                                              jobTitle: jobtitlecontroller.text,
                                              jobType: selectedValue.toString(),
                                              country:
                                                  selectedCountry.toString(),
                                              token: token,
                                              currency: seletedcurrency,
                                            ).whenComplete(() {
                                              if (mounted) {
                                                isloading = false;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BottomNavBar(),
                                                  ),
                                                );
                                              }
                                            });
                                          });
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeFlage
                                        ? AppColors.mirage
                                        : AppColors.mirage,
                                    elevation: 5.0,
                                    shadowColor: themeFlage
                                        ? AppColors.blackPearl
                                        : AppColors.shedowgreyColor,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.savebutton,
                                    style: TextStyle(
                                      color: themeFlage
                                          ? AppColors.metgoldenColor
                                          : AppColors.creamColor,
                                      fontSize: 15.0,
                                      fontFamily: GoogleFonts.lato().fontFamily,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
