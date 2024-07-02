import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/notificationmodel.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/screens/notificonSceen/localnotification.dart';
import 'package:ijobhunt/screens/notificonSceen/workmanager.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  void initState() {
    FirbaseMessage.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: Column(
      children: [
        //TextButton(onPressed: (){}, child: Text("data"),),
        listViwe(),
      ],
    ));
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        icon: const FaIcon(
          FontAwesomeIcons.arrowLeft,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Notification",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.green.shade300),
      child: Icon(
        Icons.notifications,
        size: 25,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget listViwe() {
    return FutureBuilder(
      future: NotificationServices.getnotification(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasData && NotificationServices.notifications.isNotEmpty) {
          return ListView.separated(
            itemBuilder: (context, index) {
              DateFormat dateFormat = DateFormat("yyyy-MM-dd");
              NotificationServices.date = dateFormat.parse(
                  '${NotificationServices.notifications[index].createdAt}');

              return listViweItem(index);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 0,
              );
            },
            itemCount: NotificationServices.notifications.length,
          );
        } else {
          return const Center(
            child: Text("No New Notification"),
          );
        }
      },
    );
  }

  Widget listViweItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [message(index), timeandDate(index)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget message(int index) {
    double textSize = 14;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NotificationServices.notifications[index].jobTitle.toString(),
            style: TextStyle(
                fontSize: textSize,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget timeandDate(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NotificationServices.notifications[index].jobDesc.toString(),
            maxLines: 4,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Text(
            NotificationServices.date.toString(),
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
