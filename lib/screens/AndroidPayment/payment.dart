import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

import '../homescreens/home_page.dart';

class Payment extends StatelessWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.blueGrey,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomePage ()));
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId:
                        "sb-mjtwu24121534_api1.business.example.com",
                        secretKey:
                        "AnDyQ1GoCLY59lrrNQ37AZM9rn9lAr8Q8xMXaKK4GtEjkfBhjSFiq4x2",
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: const [
                          {
                            "amount": {
                              "total": '10.12',
                              "currency": "USD",
                              "details": {
                                "subtotal": '10.12',
                                "shipping": '0',
                                "shipping_discount": 0
                              }
                            },
                            "description":
                            "The payment transaction description.",
                            // "payment_options": {
                            //   "allowed_payment_method":
                            //       "INSTANT_FUNDING_SOURCE"
                            // },
                            "item_list": {
                              "items": [
                                {
                                  "name": "A demo product",
                                  "quantity": 1,
                                  "price": '10.12',
                                  "currency": "USD"
                                }
                              ],

                              // shipping address is not required though
                              "shipping_address": {
                                "recipient_name": "Jane Foster",
                                "line1": "Travis County",
                                "line2": "",
                                "city": "Austin",
                                "country_code": "US",
                                "postal_code": "73301",
                                "phone": "+00000000",
                                "state": "Texas"
                              },
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          print("onSuccess: $params");
                        },
                        onError: (error) {
                          print("onError: $error");
                        },
                        onCancel: (params) {
                          print('cancelled: $params');
                        }),
                  ),
                )
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blueGrey[900],
                ),
                child: Center(
                  child: Text("PayNow",
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
        )
    );
  }
}
