// ignore_for_file: non_constant_identifier_name
import 'dart:convert';
import 'package:currency_picker/currency_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.keys.dart';
import '../../app/routes/api.routes.dart';
import '../../core/models/country_model.dart';
import '../../core/notifiers/country.notifier.dart';
import '../../core/notifiers/theme.notifier.dart';
import '../../core/utils/snackbar.util.dart';

class EmployerAccount extends StatefulWidget {
  const EmployerAccount({
    super.key,
  });

  @override
  State<EmployerAccount> createState() => _EmployerAccount();
}

class _EmployerAccount extends State<EmployerAccount> {
  var token = '';
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  final locationdropdown = GlobalKey<FormFieldState>();
  final countrydropdown = GlobalKey<FormFieldState>();
  String? selectedValue;
  String? selectedCountry;
  List<CountryModel> country = [];
  List<String> countries = [];
  var seletedcurrency = '';
  List<String> keywords = <String>[];
  var text = '';

  final TextEditingController salarycontroller = TextEditingController();
  final TextEditingController jobtitlecontroller = TextEditingController();
  final TextEditingController jobdesccontroller = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  final TextEditingController joblocationcontroller = TextEditingController();
  final TextEditingController keywordcontroller = TextEditingController();

  void addKeyWords({required String keyWords}) async {
    keywords.add("$keyWords");
    print(keywords);
  }

  Future postJobs(
      {required jobTitle,
      required jobDesc,
      required country,
      required jobLocation,
      required jobType,
      required salary,
      required token,
      required currency}) async {
    Map data = {
      'job_title': jobTitle,
      'job_desc': jobDesc,
      'country': country,
      'job_location': jobLocation,
      'job_type': jobType,
      'salary': salary,
      'currency': currency,
      'token': token,
    };
    final response = await http.post(
      Uri.parse(ApiRoutes.psotjobsapi),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    // ignore: avoid_print
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Job added sucessfully", context: context),
      );
    }
  }

  Future gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    //  seletedcurrency = pref.getString('selectedcurrency') ?? '';
    if (mounted) {
      setState(() {
        token = token;
        //seletedcurrency = seletedcurrency;
        // ignore: avoid_print
        //    print(seletedcurrency);
      });
    }
  }

  Future init() async {
    final country = await CountriesData.getcountries();
    setState(() {
      for (var item in country) {
        countries.add(item["name"]);
        print(countries);
      }
    });
  }

  Future<dynamic> setCurrency(String selectcurrency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedcurrency', selectcurrency);
  }

  void changecurrency({required currency}) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(
        locale: locale.languageCode, name: currency);
    seletedcurrency = (format.currencySymbol);
    setCurrency(format.currencySymbol);
  }

  @override
  void initState() {
    gettoken();
    init();
    super.initState();
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
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
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
            title: Text(
              AppLocalizations.of(context)!.addjobappbar,
              style: TextStyle(
                color: themeFlage ? AppColors.metgoldenColor : AppColors.white,
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
                    Row(
                      children: [],
                    ),
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
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: salarycontroller,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.5,
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: seletedcurrency == ''
                                          ? const FaIcon(
                                              FontAwesomeIcons.chevronDown,
                                              size: 15.0,
                                            )
                                          : Text(
                                              seletedcurrency,
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            ),
                                    ),
                                    onPressed: () {
                                      showCurrencyPicker(
                                        context: context,
                                        showFlag: false,
                                        showSearchField: true,
                                        showCurrencyName: true,
                                        showCurrencyCode: false,
                                        onSelect: (Currency currency) {
                                          setState(() {
                                            changecurrency(
                                                currency: currency.code);
                                          });

                                          print(
                                              'Select currency: ${currency.code}');
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

                              // DropdownButtonFormField2(
                              //     buttonWidth:
                              //         MediaQuery.of(context).size.width * 0.85,
                              //     // key: countrydropdown,
                              //     hint: const Text("--Please Select--"),
                              //     items: countries
                              //         .map(
                              //           (item) => DropdownMenuItem<String>(
                              //             value: item,
                              //             child: Text(item),
                              //           ),
                              //         )
                              //         .toList(),
                              //     value: selectedCountry,
                              //     validator: (value) => value == null
                              //         ? 'Please select the country'
                              //         : null,
                              //     onChanged: (value) {
                              //       setState(() {
                              //         selectedCountry = value.toString();
                              //       });
                              //     }),
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
                                    setState(() {
                                      selectedValue = value.toString();
                                    });
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
                                      if (seletedcurrency.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackUtil.stylishSnackBar(
                                              text: "Please select Currency ",
                                              context: context),
                                        );
                                      } else {
                                        setState(() {
                                          isloading = true;
                                          postJobs(
                                            jobTitle: jobtitlecontroller.text,
                                            jobDesc: jobdesccontroller.text,
                                            country: selectedCountry.toString(),
                                            jobLocation:
                                                joblocationcontroller.text,
                                            jobType: selectedValue.toString(),
                                            salary: salarycontroller.text,
                                            token: token,
                                            currency: seletedcurrency,
                                          );
                                          setState(() {
                                            isloading = false;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const BottomNavBar(),
                                              ),
                                            );
                                          });
                                        });
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
                                  child: isloading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              'Please Wait....',
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            CircularProgressIndicator(
                                              color: AppColors.white,
                                              strokeWidth: 2.5,
                                            ),

                                          ],
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!
                                              .savebutton,
                                          style: TextStyle(
                                            color: themeFlage
                                                ? AppColors.metgoldenColor
                                                : AppColors.creamColor,
                                            fontSize: 15.0,
                                            fontFamily:
                                                GoogleFonts.lato().fontFamily,
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
