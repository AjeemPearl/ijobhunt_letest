import 'dart:async';
import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ijobhunt/screens/employerscreen/employer.home.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constants/app.keys.dart';

class DemoPage extends StatefulWidget {
  final userType;
  const DemoPage({Key? key, required  String this.userType}) : super(key: key);
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  // final String _productID = 'com.tucimar.ijobhunts';
  final String _productID = 'Tuccimar1968';
  late String UserpaymentDate;

  bool _available = true;
  bool _showThanksMessage = false;
  String? _purchasedId = null;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _processingTransaction = false;
  bool _isSubscribed = true;
  bool isLoading = true;
  String? payment_date = null;
  DateTime? nextPaymentDate = null;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      setState(() {
        _purchases.addAll(purchaseDetailsList);
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      _subscription!.cancel();
    });

    _initialize();

    super.initState();
    checkSubscription();
    _loadPaymentDate();
  }
  Future<void> _loadPaymentDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UserpaymentDate = prefs.getString('paymentDate')?? 'Null';
    });
  }

  Future<void> checkSubscription() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(AppKeys.userData) ?? '';
    final url = Uri.parse('http://ijobshunts.com/public/api/payment-status');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'token': token,
    });
    final response = await http.post(url, headers: headers, body: body);
    print("abc = ${response.body}");
    final Map<String, dynamic> data = jsonDecode(response.body);
    final int paymentStatus = data['payment_status'];
   payment_date= data['payment_date'];


    nextPaymentDate = DateTime.parse(data['payment_day']).add(const Duration(days: 30));
    if(nextPaymentDate!.isAfter(DateTime.now())){
      print('Subscribed ${nextPaymentDate}');
      setState(() {
        _isSubscribed =true;
        isLoading = false;
      });
    }else{
      print('Not Subscribed ${nextPaymentDate}');
      setState(() {
        _isSubscribed =false;
        isLoading = false;
      });
    }

    // final paymentStatus = int.parse(jsonResponse['payment_status']);
    if (response.statusCode == 200) {
      if(paymentStatus==1){

      }
      else{

      }

      // print('xyz$paymentStatus');

      // Subscription is valid
      final jsonData = jsonDecode(response.body);

    } else {
      print('Subscription is invalid');
    }

    final jsonData = jsonDecode(response.body);

  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();

    List<ProductDetails> products = await _getProducts(
      productIds: Set<String>.from(
        [_productID],
      ),
    );

    setState(() {
      _products = products;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {

      _processingTransaction=true;
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          EasyLoading.show(status: 'please wait..', maskType: EasyLoadingMaskType.black,
          dismissOnTap: false
          );
          _processingTransaction=false;
          //  _showPendingUI();
          break;
        case PurchaseStatus.purchased:

         EasyLoading.showProgress(0.5, status: "Transaction is complete");
          _processingTransaction=false;
          setState(() {
            _showThanksMessage = true;
            _purchasedId = purchaseDetails.purchaseID;
          });
         SharedPreferences pref = await SharedPreferences.getInstance();
         String token = pref.getString(AppKeys.userData) ?? '';
          final url = Uri.parse('http://ijobshunts.com/public/api/receive-payment');
          final headers = {'Content-Type': 'application/json'};
          final body = jsonEncode({
            'token': token,
            'purchase_id': _purchasedId.toString(),
          });
          final response = await http.post(url, headers: headers, body: body);
         final Map<String, dynamic> data = json.decode(response.body);
         final  paymentDate = data['payment_date'];
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('paymentDate', paymentDate);
          print("efj = ${response.body}");
          if (response.statusCode == 200) {

            EasyLoading.showSuccess("Transaction is save");
            if(widget.userType == 'candidate') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage(),));
            }else{
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const BottomNavBar()));
            }
            // Subscription is valid
            // Fluttertoast.showToast(
            //   msg: 'Payment received successfully! $token',
            //   backgroundColor: Colors.green,
            // );
            final jsonData = jsonDecode(response.body);

          } else {
                 print('Subscription is invalid.$_purchasedId');
          }
          EasyLoading.dismiss();
          break;
        case PurchaseStatus.restored:
        // bool valid = await _verifyPurchase(purchaseDetails);
        // if (!valid) {
        //   _handleInvalidPurchase(purchaseDetails);
        // }
          break;
        case PurchaseStatus.error:
        // print("code error");
        // print(purchaseDetails.error!);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Transaction Failed'),
                content: const Text('Sorry, the transaction has failed.'),
                actions: [
                  ElevatedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );

          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }


      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);

      }
      EasyLoading.dismiss();

    });
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
    await _inAppPurchase.queryProductDetails(productIds);

    return response.productDetails;
  }

  ListTile _buildProduct({required ProductDetails product}) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: Text('${product.title} - ${product.price}'),
      subtitle: Text(product.description),
      trailing: ElevatedButton(
        onPressed: () {
          _subscribe(product: product);
        },
        child: const Text(
          'Subscribe',
        ),
      ),
    );
  }

  ListTile _buildPurchase({required PurchaseDetails purchase}) {
    if (purchase.error != null) {
      return ListTile(
        title: Text('${purchase.error}'),
        subtitle: Text(purchase.status.toString()),
      );
    }

    String? transactionDate;
    if (purchase.status == PurchaseStatus.purchased) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchase.transactionDate!),
      );
      transactionDate = ' @ ' + DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    }

    return ListTile(
      title: Text('${purchase.productID} ${transactionDate ?? ''}'),
      subtitle: Text(purchase.status.toString()),
    );
  }

  void _subscribe({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return const Scaffold(
        body: Center(
          child: Text('Loding..'),
        ),
      );
    }else if(_isSubscribed){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.blueGrey,
            onPressed: () {
              if(widget.userType == 'candidate') {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage(),));
              }else{
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const BottomNavBar()));
              }
            },
          ),
        ),

        body: Center(
          child: BlurryContainer(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.height*0.3,
            elevation: 10,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("You're now subscribed ",style: TextStyle(fontSize: 20),),
                const SizedBox(height: 10,),
                Text("Your Last Payment Date  $payment_date"),
                const SizedBox(height: 10,),
                Text("Your Next Payment Date ${DateFormat('dd MMM yyyy').format(nextPaymentDate!)} "),
                const SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                 //   primary: Colors.green,
                  ),
                  onPressed: () {
                    if(widget.userType == 'candidate') {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const HomePage(),));
                    }else{
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const BottomNavBar()));
                    }
                  },
                  child: const Text('GO BACK'),
                ),
              ],
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()))
          ),
          title: const Text('Buy Subscription'),

        ),
        body: _available
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlurryContainer(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.3,
            elevation: 1,
            color: Colors.grey.shade200 ,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Products ${_products.length}'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProduct(
                            product: _products[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('Past Purchases: ${_purchases.length}'),
                //       Expanded(
                //         child: ListView.builder(
                //           shrinkWrap: true,
                //           itemCount: _purchases.length,
                //           itemBuilder: (context, index) {
                //             return _buildPurchase(
                //               purchase: _purchases[index],
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                _processingTransaction ? Stack(
                  children: [
                    ModalBarrier(
                      color: Colors.black.withOpacity(0.3),
                      dismissible: false,
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),

                  ],
                ) : Container(),
              ],
            ),
          ),
        )
            : const Center(
          child: Text('The Store Is Not Available'),
        ),
      );
    }
  }
// void ShowErrorDialogBox()
// {
//   showDialogBox
// }
}
