import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/notificationmodel.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  static List<NotificationModel> notifications = [];
  static var responseJson = [];
  static DateTime? date;
  static Future<List<NotificationModel>?> getnotification(
      {required BuildContext context}) async {
    final response = await http.get(
      Uri.parse(ApiRoutes.getnotification),
    );
    if (response.statusCode == 201) {
      responseJson = json.decode(response.body);
      notifications =
          responseJson.map((e) => NotificationModel.fromJson(e)).toList();
      if (notifications.isNotEmpty) {
        return notifications;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: "No New Notification", context: context));
    }
  }
}
