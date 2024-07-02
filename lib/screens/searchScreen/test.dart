import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  var responce = '';
  bool isloading = false;
  Future Test() async {
    setState(() {
      isloading = true;
    });
    //Map data = {'token': token, 'user_type': user_type};
    final response = await http.post(
      Uri.parse('http://ijobshunts.com/index.php'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
    );
    setState(() {
      responce = response.body.toString();
      isloading = false;
    });
  }

  @override
  void initState() {
    //Test();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                isloading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () {
                          Test();
                        },
                        child: const Text(
                          "Show",
                          style: TextStyle(color: Colors.black, fontSize: 30),
                        ),
                      ),
                Container(
                  child: Text(
                    responce,
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
