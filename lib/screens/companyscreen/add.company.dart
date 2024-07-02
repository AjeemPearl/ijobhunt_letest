// ignore_for_file: import_of_legacy_library_into_null_safe, use_build_context_synchronously, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.keys.dart';
import '../../app/routes/api.routes.dart';
import '../../core/models/country_model.dart';
import '../../core/notifiers/country.notifier.dart';
import '../../core/notifiers/theme.notifier.dart';
import '../../core/utils/snackbar.util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'company.profie.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  String? selectedValue;
  String? selectedPhoneCOde;
  bool isloading = false;
  var token = '';
  final _formKey = GlobalKey<FormState>();
  final countrydropdown = GlobalKey<FormFieldState>();
  final phoneCodeDropdown = GlobalKey<FormFieldState>();
  File? image;
  String img = '';
  String imgext = '';
  final _picker = ImagePicker();
  var text = '';

  List<String> countries = [];
  List<String> PhoneCodes = [];
  List<String> keywords = <String>[];
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController noofempcontroller = TextEditingController();
  TextEditingController employernamecontroller = TextEditingController();
  TextEditingController employerphonecontroller = TextEditingController();
  TextEditingController aboutcomanycontroller = TextEditingController();
  TextEditingController jobdesccontroller = TextEditingController();
  TextEditingController countrycontroller = TextEditingController();
  TextEditingController joblocationcontroller = TextEditingController();
  TextEditingController employeremailcontroller = TextEditingController();
  TextEditingController keywordcontroller = TextEditingController();

  Future pickimage() async {
    final pickedimage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );

    if (pickedimage != null) {
      setState(() {
        image = File(pickedimage.path);
        Uint8List byts = File(pickedimage.path).readAsBytesSync();
        img = base64Encode(byts);
        imgext = p.extension(pickedimage.path);
      });
    }
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

  Future postCompanyData({
    required comapnyName,
    required noOfEmployee,
    required employerName,
    required phoneNumber,
    required country,
    required aboutCompany,
    required empimage,
    required imageext,
    required token,
    required address,
    required emailaddress,
    required keywords,
  }) async {
    Map compdata = {
      'comapny_name': comapnyName.toString(),
      'no_of_employee': noOfEmployee.toString(),
      'employer_name': employerName.toString(),
      'phone_number': phoneNumber.toString(),
      'email': emailaddress.toString(),
      'country': country.toString(),
      'about_company': aboutCompany.toString(),
      'image': empimage,
      'image_ext': imageext,
      'token': token,
      'address': address.toString(),
    };
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
      Map<String, dynamic> decodeddata = jsonDecode(response.body);

      SharedPreferences companystatus = await SharedPreferences.getInstance();
      companystatus
          .setString(AppKeys.companyStatus, decodeddata['status'].toString())
          .whenComplete(
            () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
            ),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Company Added sucessfully", context: context),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Some Error occurd Please try after some time",
            context: context),
      );
    }
  }

  Future gettoken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    token = pref.getString(AppKeys.userData) ?? '';
    setState(() {
      token = token;
      // ignore: avoid_print
    });
  }

  Future init() async {
    final country = await CountriesData.getcountries();
    final phonecodes = await CountriesData.getPhoneCodes();
    setState(() {
      for (var item in country) {
        countries.add(item["name"]);
      }
      for (var phone in phonecodes) {
        if (mounted) {
          setState(() {
            PhoneCodes.add('+' + phone['phonecode']);
          });
        }
      }
    });
  }

  @override
  void initState() {
    gettoken();
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeFlage = Provider.of<ThemeNotifier>(context).darkTheme;
    return LayoutBuilder(
      builder: (context, Constraints) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: AppColors.blueZodiacTwo,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                showExitPopup();
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: themeFlage
                    ? AppColors.metgoldenColor
                    : AppColors.blueZodiacTwo,
              ),
            ),
            title: Image.asset(
              'assets/images/logo/logo2.png',
              height: 100,
              width: 100,
            ),
          ),
          // endDrawer: MyDrawer(),
          body: WillPopScope(
            onWillPop: showExitPopup,
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  //top: 35.0,
                                  bottom: 15.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .companyaddtext1,
                                      style: TextStyle(
                                        color: themeFlage
                                            ? AppColors.metgoldenColor
                                            : AppColors.blueZodiacTwo,
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .companyaddtext2,
                                      style: TextStyle(
                                        color: themeFlage
                                            ? AppColors.metgoldenColor
                                            : AppColors.blueZodiacTwo,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.lato().fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext3,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext4,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext5,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
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
                                TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                  controller: employeremailcontroller,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext6,
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
                                  keyboardType: TextInputType.phone,
                                  controller: employerphonecontroller,
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      width: 100,
                                      height: 46,
                                      // decoration: BoxDecoration(
                                      // border: Border.all(width: .5),
                                      //   borderRadius:
                                      //       BorderRadius.circular(8.0),
                                      // ),
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 0.0),
                                          child: DropdownButtonFormField2(

                                              //buttonWidth: 50,
                                              key: phoneCodeDropdown,
                                              hint: const Text("+91"),
                                              items: PhoneCodes.map(
                                                (item) =>
                                                    DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                ),
                                              ).toList(),
                                              value: selectedPhoneCOde,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Please select the valid job location'
                                                  : null,
                                              onChanged: (value) {
                                                if (mounted) {
                                                  setState(() {
                                                    selectedPhoneCOde =
                                                        value.toString();
                                                  });
                                                }
                                              }),
                                        ),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Phone number can't be empty"
                                      : null,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
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
                                                        keywords
                                                            .removeAt(index);
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext7,
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
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          labelText: selectedValue ??
                                              '-- Please Select Country --',
                                          labelStyle: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          //hintText: "country in menu mode",
                                        ),
                                      ),
                                      popupProps: const PopupProps.menu(
                                        showSearchBox: true,
                                        // showSelectedItems: true,
                                        // disabledItemFn: (String s) => s.startsWith('I'),
                                      ),
                                      items: countries
                                          .map((item) => item)
                                          .toList(),
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            selectedValue = value.toString();
                                            print(
                                                "new country is ${selectedValue}");
                                          });
                                        }
                                      },
                                      validator: (value) => value == null
                                          ? "Country Can't be empty"
                                          : null,
                                    ),
                                  ),
                                ),

                                // DropdownButtonFormField2(
                                //     buttonWidth:
                                //         MediaQuery.of(context).size.width *
                                //             0.85,
                                //     key: countrydropdown,
                                //     hint: const Text("--Please Select--"),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .companyaddtext8,
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
                                                  height: 35,
                                                  width: 140.0,
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .companyaddtext9,
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Center(
                                                    child: Image.file(
                                                      File(image!.path)
                                                          .absolute,
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
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
                                  controller: aboutcomanycontroller,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                  padding: const EdgeInsets.only(
                                      top: 5.0, left: 10.0),
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
                                  controller: joblocationcontroller,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        15.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15.0),
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
                                        postCompanyData(
                                          comapnyName:
                                              companynamecontroller.text,
                                          noOfEmployee: noofempcontroller.text,
                                          employerName:
                                              employernamecontroller.text,
                                          phoneNumber: selectedPhoneCOde! +
                                              employerphonecontroller.text,
                                          country: selectedValue.toString(),
                                          address: joblocationcontroller.text,
                                          empimage: img.toString(),
                                          imageext: imgext.toString(),
                                          token: token.toString(),
                                          aboutCompany:
                                              aboutcomanycontroller.text,
                                          emailaddress:
                                              employeremailcontroller.text,
                                          keywords: keywords.toString(),
                                        ).then((void nothing) {
                                          setState(() {
                                            isloading = false;
                                          });
                                        });
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
                ],
              ),
            ),
          ),
        );
      },
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
                onPressed: () => Navigator.of(context).pop(true),
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
