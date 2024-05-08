import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conclave/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

final Map<String, String> headers = {"Content-type": "application/json"};

class ApiServices {
  Future<String> showNameByNumber() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final num = await LocalStorageService().loadData('mobNo') ?? '';
      final querySnapshot = await firestore
          .collection('employee_details_v2')
          .where('MobileNo', isEqualTo: num)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        final userData = docSnapshot.data();

        return userData['Name'];
      }
    } catch (error) {
      debugPrint(error.toString());
      return "";
    }
    return "";
  }

  Future<String> saveImages(List<String> frame) async {
    final pf = await LocalStorageService().loadData('mobNo') ?? '';
    var name = await ApiServices().showNameByNumber();
    //

    final body = {"userName": name, "mobileNumber": pf, "frames": frame};

    print(body);
    Response response = await http.post(
        Uri.parse('https://may-i-lozthqfyea-el.a.run.app/aiml7/register_user'),
        // body: json.encode(body),
        body: json.encode(body),
        headers: headers);

    print(response.body);    
    var result = json.decode(response.body);
    print(result["message"] + "------>");

    print("qwerty");

    print(result["message"].contains("succ"));

    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Registration successful")),
    //   );

    return result["message"];

    //
  }
}
