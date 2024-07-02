import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ijobhunt/app/constants/app.colors.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/core/models/country_model.dart';
import 'package:ijobhunt/core/notifiers/country.notifier.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({super.key});

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  TextEditingController controller = TextEditingController();
  List<String> counTry = [];
  List<String> countries = [];
  var seletedvalue = '';
  bool isselected = false;
  bool isloading = true;
  Timer? debouncer;

  Future<dynamic> setcountry(String selectedcountry) async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('country', selectedcountry);*/
    AppPreferences.setCountry(selectedcountry);
    print(selectedcountry);
  }

  Future init() async {
    final country = await CountriesData.getcountries();
    setState(() {
      for (Map<String, dynamic> item in country) {
        countries.add(item['name']);
      }
      setState(() {
        isloading = false;
      });
    });
  }

  onSearchTextChanged(String text) async {
    counTry.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    countries.forEach((country) {
      if (country.toLowerCase().contains(text)) {
        counTry.add(country);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueZodiac,
      appBar: AppBar(
        backgroundColor: AppColors.blueZodiacTwo,
        title: const Text(
          "Please Select Your Country",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 42,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              color: Colors.white,
              border: Border.all(color: Colors.black26),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              onChanged: onSearchTextChanged,
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  child: const Icon(Icons.search, color: Colors.black),
                ),
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
              child: isloading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.goldenColor,
                    ),
                  )
                  : counTry.isEmpty
                  ? ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: seletedvalue == countries[index]
                          ? AppColors.goldenColor
                          : Colors.white,
                      child: ListTile(
                        //selected: isselected,

                        title: Text(
                          countries[index],
                        ),
                        onTap: () {
                          setState(() {
                            isselected = true;
                            seletedvalue = countries[index];
                            setcountry(countries[index]);
                          });
                          Timer(Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  );
                },
              )
                  : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemCount: counTry.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: seletedvalue == counTry[index]
                          ? AppColors.goldenColor
                          : Colors.white,
                      child: ListTile(
                        //selected: isselected,

                        title: Text(
                          counTry[index],
                        ),
                        onTap: () {
                          setState(() {
                            isselected = true;
                            seletedvalue = counTry[index];

                            setcountry(counTry[index]);
                          });
                          Timer(Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
