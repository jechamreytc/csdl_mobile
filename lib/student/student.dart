import 'dart:convert';

import 'package:csdl_mobile/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';
import 'package:http/http.dart' as http;

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int student_id = 1;
  String student_id_number = "";

  @override
  void initState() {
    super.initState();
    // Automatically fetch student details when the widget is initialized
    getStudentsDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Student QR Code'),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              shadowColor: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Use the student_id_number for QR Code data if available
                          QRCode(
                              data: student_id_number.isNotEmpty
                                  ? student_id_number
                                  : "No ID"),
                        ],
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

  // Method to fetch student details
  void getStudentsDetails() async {
    try {
      var url = Uri.parse("${SessionStorage.url}student_operation.php");
      Map<String, dynamic> jsonData = {
        "students_id": student_id,
      };
      Map<String, String> requestBody = {
        "operation": "getStudentsDetails",
        "json": jsonEncode(jsonData),
      };

      var response = await http.post(url, body: requestBody);
      var res = jsonDecode(response.body);
      print(res);

      if (res != 0) {
        setState(() {
          student_id_number = res['students_id_number'];
        });
      }
    } catch (e) {
      print("ERROR NI $e");
    }
  }
}
