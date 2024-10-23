import 'dart:convert';
import 'package:csdl_mobile/session_storage.dart';
import 'package:csdl_mobile/student/student_dtr.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';
import 'package:http/http.dart' as http;

class Student extends StatefulWidget {
  final int student_id;
  const Student({
    super.key,
    required this.student_id,
  });

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String student_id_number = "";
  String student_fullname = "";
  String duty_room_number = "";
  String duty_building_number = "";
  String duty_subject_code = "";
  String duty_subject_name = "";
  String duty_advisor_full_name = "";
  String duty_time = "";
  String day = "";
  String scheduled_time = "";
  String duty_hours = ""; // Change to String for display
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
                              const CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(
                                    'assets/images/sakana.jpg'), // Placeholder image
                              ),
                              const SizedBox(
                                  height:
                                      10), // Space between image and advisor name
                              // Advisor Name
                              Text(
                                'Advisor: $duty_advisor_full_name',
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
                                  student_fullname,
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
                                  'Duty Day: $day', // Update this line with actual value
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
                                  'Duty Time: $scheduled_time', // Update this line
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Text to white
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Assigned Hours: $duty_hours', // Display assigned hours here
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
                                const Text(
                                  'Time Rendered: ', // Add value if needed
                                  style: TextStyle(
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
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
                          child: const Text("Show DTR",
                              style: TextStyle(fontSize: 18)),
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
      var url = Uri.parse("${SessionStorage.url}CSDL.php");
      Map<String, dynamic> jsonData = {
        "assign_stud_id": widget.student_id,
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
            student_id_number = res['stud_school_id'] ?? ""; // Null safety
            student_fullname = res['StudentFullname'] ?? "";
            duty_room_number = res['room_number'] ?? "";
            duty_building_number = res['build_name'] ?? "";
            duty_subject_code = res['subject_code'] ?? "";
            duty_subject_name = res['subject_name'] ?? "";
            duty_advisor_full_name = res['AdvisorFullname'] ?? "";
            day = res['day_name'] ?? "";
            scheduled_time = res['DutyTime'] ?? "";
            duty_hours = res['assign_hours']?.toString() ??
                ""; // Ensure this is assigned correctly

            // Parse dutyH_name as integer (total seconds)
            int dutySeconds = int.tryParse(res['assign_hours'].toString()) ?? 0;

            // Calculate hours and minutes
            int hours = dutySeconds ~/ 3600; // Get whole hours
            int minutes = (dutySeconds % 3600) ~/ 60; // Remaining minutes

            // Format duty_time as "HH:MM"
            duty_time =
                "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";

            isLoading = false; // Set loading to false once data is fetched
          });
        } else {
          print("No data found");
          setState(() {
            isLoading = false; // Set loading to false if no data
          });
        }
      } else {
        print("Error fetching data: ${response.statusCode}");
        setState(() {
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        isLoading = false; // Set loading to false on exception
      });
    }
  }
}
