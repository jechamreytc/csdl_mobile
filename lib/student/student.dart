import 'dart:convert';
import 'package:csdl_mobile/session_storage.dart';
import 'package:csdl_mobile/student/student_dtr.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';
import 'package:http/http.dart' as http;

class Student extends StatefulWidget {
  final int student_id;
  const Student({
    Key? key,
    required this.student_id,
  }) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String student_id_number = "";
  String student_first_name = "";
  String student_last_name = ""; // Fixed typo
  String duty_room_number = "";
  String duty_building_number = "";
  String duty_subject_code = "";
  String duty_subject_name = "";
  String duty_advisor_first_name = "";
  String duty_advisor_last_name = "";
  String duty_time = "";
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    getStudentsDetailsAndStudentDutyAssign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF007BFF), // Set the background color to blue
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align to start for better layout
                    children: [
                      // Header and Student Information
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left section (Profile picture and Advisor)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Profile picture
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: const AssetImage(
                                    'assets/profile.jpg'), // Placeholder image
                              ),
                              const SizedBox(
                                  height:
                                      10), // Space between image and advisor name
                              // Advisor Name
                              Text(
                                'Advisor: $duty_advisor_first_name $duty_advisor_last_name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // Text color to white
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                              width: 20), // Space between the sections

                          // Right section (Info beside the profile picture)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Student Name and ID
                                Text(
                                  '$student_first_name $student_last_name',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Text color to white
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'ID: $student_id_number',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .white70, // ID text to a lighter white
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Duty Information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Duty Building: $duty_building_number',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Duty Day: ', // Update this line with actual value
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Subject Code: $duty_subject_code', // Update this line
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Duty Time: duty time ni siya', // Update this line
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Room: $duty_room_number',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Time Rendered: ', // Add value if needed
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Subject Name: $duty_subject_name', // Add value if needed
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Time Remaining: $duty_time', // Add value if needed
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Centered QR Code Card
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  QRCode(
                                    data: student_id_number.isNotEmpty
                                        ? student_id_number
                                        : "No ID",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Show DTR button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDtr(
                                  student_id: widget.student_id,
                                ),
                              ),
                            );
                          },
                          child:
                              Text("Show DTR", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Method to fetch student details
  void getStudentsDetailsAndStudentDutyAssign() async {
    try {
      var url = Uri.parse("${SessionStorage.url}user.php");
      Map<String, dynamic> jsonData = {
        "users_id": widget.student_id,
      };
      Map<String, String> requestBody = {
        "operation": "getStudentsDetailsAndStudentDutyAssign",
        "json": jsonEncode(jsonData),
      };

      var response = await http.post(url, body: requestBody);

      // Check for response status code
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print(res);

        if (res != 0) {
          setState(() {
            student_id_number = res['personal_id_number'] ?? ""; // Null safety
            student_first_name = res['personal_first_name'] ?? "";
            student_last_name = res['personal_last_name'] ?? "";
            duty_room_number = res['rooms_number'] ?? "";
            duty_building_number = res['building_name'] ?? "";
            duty_subject_code = res['subjects_code'] ?? "";
            duty_subject_name = res['subjects_name'] ?? "";
            duty_advisor_first_name = res['advisor_first_name'] ?? "";
            duty_advisor_last_name = res['advisor_last_name'] ?? "";

            // Parse duty_hours as double
            double dutyHours = double.tryParse(res['duty_hours']) ?? 0.0;

            // Convert hours to seconds
            int totalSeconds = (dutyHours * 3600).toInt();

            // Calculate hours, minutes, and seconds
            int hours = totalSeconds ~/ 3600; // Get whole hours
            int minutes = (totalSeconds % 3600) ~/ 60; // Remaining minutes
            int seconds = totalSeconds % 60; // Remaining seconds

            // Format duty_time as "HH:MM:SS"
            duty_time =
                "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

            isLoading = false; // Set loading to false once data is fetched
          });
        } else {
          // Handle case where response is 0 (not found or error)
          setState(() {
            isLoading = false; // Set loading to false
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Student not found or an error occurred.")),
          );
        }
      } else {
        // Handle network error
        setState(() {
          isLoading = false; // Set loading to false
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to load data: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false
      });
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }
}
