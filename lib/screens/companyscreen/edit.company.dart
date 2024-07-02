import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/core/notifiers/theme.notifier.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/employerscreen/employer.home.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/preferences/app_preferences.dart';

class EditCompany extends StatefulWidget {
  EditCompany({
    super.key,
  });

  @override
  State<EditCompany> createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  final _formKey = GlobalKey<FormState>();
  final countrydropdown = GlobalKey<FormFieldState>();
  final _picker = ImagePicker();
  var token = AppPreferences.getUserData();
  var text = '';
  File? image;
  String img = '';
  String imgext = '';
  String? selectedValue;
  late String selectedPhoneCOde;
  bool isloading = false;
  List<String> keywords = <String>[];
  List<String> countries = [];
  List<String> phoneCodes = [];
  var countryCode;
  String? phoneNo;
  String? mobileNo;
  bool _isLoading = true;

  //TextEditingController mobileno = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController noofempcontroller = TextEditingController();
  TextEditingController employernamecontroller = TextEditingController();
  TextEditingController employerphonecontroller = TextEditingController();
  TextEditingController aboutcomanycontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController joblocationcontroller = TextEditingController();
  TextEditingController employeremialcontroller = TextEditingController();
  TextEditingController keywordcontroller = TextEditingController();

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
          print(imgext);
        });
      }
    }
  }

  void addKeyWords({required String keyWords}) async {
    keywords.add("$keyWords");
    print(keywords);
  }

  Future postCompanyData({
    required comapnyName,
    required noOfEmployee,
    required employerName,
    required phoneNumber,
    required phoneCode,
    required country,
    required aboutCompany,
    required empimage,
    required imageext,
    required token,
    required address,
    required emialaddress,
    required keywords,
  }) async {
    Map compdata = {
      'comapny_name': comapnyName.toString(),
      'no_of_employee': noOfEmployee.toString(),
      'employer_name': employerName.toString(),
      'phone_number': phoneNumber.toString(),
      'phone_code':phoneCode.toString(),
      'email': emialaddress.toString(),
      'country': country.toString(),
      'about_company': aboutCompany.toString(),
      'image': empimage,
      'image_ext': imageext,
      'token': token,
      'address': address.toString(),
    };
    print(compdata);
    final response = await http.post(
      Uri.parse(ApiRoutes.psotcompanydata),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: compdata,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Company Updated sucessfully", context: context),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: 'Please Chose image File ', context: context),
      );
    }
  }


  Future init() async {
    final country = await CountriesData.getcountries();
    final phonecodes = await CountriesData.getPhoneCodes();
    final data = await CountriesData.editGetData();

    for (var item in country) {
      countries.add(item["name"]);
    }
    for (var phone in phonecodes) {
      phoneCodes.add('+'+phone['phonecode']);
      print('+${phone['phonecode']}');
    }

    data!.forEach((element) {
      selectedValue = element.country.toString();
      companynamecontroller.text = element.comapnyName.toString();
      noofempcontroller.text = element.noOfEmployee.toString();
      employernamecontroller.text = element.employerName.toString();
      employerphonecontroller.text = element.phoneNumber.toString();
      selectedPhoneCOde = (element.phoneCode != null)?element.phoneCode.toString():'+91';
      aboutcomanycontroller.text = element.aboutCompany.toString();
      employeremialcontroller.text = element.email.toString();
      joblocationcontroller.text = element.address.toString();

    });
    print('1234a' + selectedPhoneCOde);

    if(mounted){
      setState(() {
        _isLoading = false;
      });
    }
    /*phoneCodes.forEach((element) {
      print(element);
    });*/
  }

  //List<Company> company = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;

    return _isLoading
        ?Center(child: CircularProgressIndicator(),)
        : Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColors.blueZodiacTwo,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            color: themeFlage
                ? AppColors.metgoldenColor
                : AppColors.blueZodiacTwo,
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.companyaddtext14,
          style: TextStyle(
            color: AppColors.blueZodiacTwo,
          ),
        ),
      ),
      // endDrawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo/logo2.png',
              height: 100,
              width: 100,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 8.0, right: 15, left: 15, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext3,
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
                      controller: companynamecontroller,
                      decoration: InputDecoration(
                        //hintText: "Your Company's Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Company name can't be empty"
                          : null,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext4,
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
                      keyboardType: TextInputType.number,
                      controller: noofempcontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? 'Please Enter No. of emoployees'
                          : null,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext5,
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
                      controller: employernamecontroller,
                      decoration: InputDecoration(
                        // hintText: 'a',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Name can't be empty"
                          : null,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .companyaddtext15,
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'\s'),
                        ),
                      ],
                      controller: employeremialcontroller,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .signuphinttext3,
                        hintStyle: TextStyle(
                          color: AppColors.blueZodiacTwo,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (val) =>
                      !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(val!)
                          ? AppLocalizations.of(context)!
                          .signuphinttext3
                          : null,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext6,
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
                    IntlPhoneField(
                      controller: employerphonecontroller,
                      decoration: InputDecoration(
                        //labelText: 'Phone Number',
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        // for version 2 and greater youcan also use this
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      initialCountryCode: null,
                      initialValue: '$selectedPhoneCOde${employerphonecontroller.text}',
                      //initialValue: em,
                      //initialCountryCode: selectedPhoneCOde,
                      dropdownIconPosition: IconPosition.trailing,
                      onCountryChanged: (country) {
                        selectedPhoneCOde = '+${country.dialCode}';
                      },
                      // onChanged: (phone) {
                      onChanged: (value) {
                        /*print(value);
                        countryCode = value.completeNumber;
                        mobileNo = value.number;*/
                      },
                    ),
                    /*TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: employerphonecontroller,
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
                            child: (phoneCodes.isNotEmpty)
                                ? DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: DropdownButton2(
                                    buttonWidth: 50,
                                    hint: const Text("+91"),
                                    items: phoneCodes.map((item) => DropdownMenuItem<String>(
                                            value: item, child: Text(item),
                                          ),).toSet().toList(),
                                    value: selectedPhoneCOde,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          selectedPhoneCOde = value.toString();
                                        });
                                      }
                                    }),
                              ),
                            )
                                : Text('+91'),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Phone number can't be empty"
                          : null,
                    ),*/
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .createkeywordemployer,
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
                                      padding:
                                      const EdgeInsets.all(8.0),
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
                      height:
                      MediaQuery.of(context).size.height * 0.03,
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      // validator: (value) => value!.isEmpty
                      //     ? "Create KeyWord for better job search experince"
                      //     : null,
                    ),
                    SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.03,
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext7,
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
                          ),
                          items:
                          countries.map((item) => item).toList(),
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                selectedValue = value.toString();
                                print(
                                    "new country is ${selectedValue}");
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    // DropdownButtonFormField2(
                    //     buttonWidth:
                    //         MediaQuery.of(context).size.width * 0.85,
                    //     key: countrydropdown,
                    //     items: countries
                    //         .map(
                    //           (item) => DropdownMenuItem<String>(
                    //             value: item,
                    //             child: Text(item),
                    //           ),
                    //         )
                    //         .toList(),
                    //     value: selectedValue,
                    //     validator: (value) => value == null
                    //         ? 'Please select the country'
                    //         : null,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedValue = value.toString();
                    //       });
                    //     }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.companyaddtext8,
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
                    Container(
                      //alignment: Alignment.center,
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: AppColors.blackPearl,
                        ),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 15,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                pickimage();
                              },
                              child: image == null
                                  ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2.0,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(
                                    5.0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                height: 20,
                                width: 140.0,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .companyaddtext9,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                                  : SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Image.file(
                                    File(image!.path).absolute,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .companyaddtext10,
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
                          ? "Enter Your Address"
                          : null,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .companyaddtext12,
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
                      controller: aboutcomanycontroller,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Please Tell us somthing about your company"
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
                            setState(() {
                              isloading = true;
                            });
                            print(selectedPhoneCOde);
                            postCompanyData(
                              comapnyName: companynamecontroller.text,
                              noOfEmployee: noofempcontroller.text,
                              employerName:
                              employernamecontroller.text,
                              phoneNumber: employerphonecontroller.text,
                              phoneCode: selectedPhoneCOde,
                              emialaddress:
                              employeremialcontroller.text,
                              country: selectedValue.toString(),
                              aboutCompany:
                              aboutcomanycontroller.text,
                              empimage: img.toString(),
                              imageext: imgext.toString(),
                              token: token.toString(),
                              address: joblocationcontroller.text,
                              keywords: keywords.toString(),
                            ).then((void nothing) {
                              setState(() {
                                isloading = false;
                              });
                            });
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackUtil.stylishSnackBar(
                                  text: 'Please enter details correctly!', context: context),
                            );
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
                              .companyaddtext11,
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
          ],
        ),
      ),
    );
  }
}
