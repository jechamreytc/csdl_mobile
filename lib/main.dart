import 'dart:convert';

import 'package:csdl_mobile/advisor/advisor.dart';
import 'package:csdl_mobile/session_storage.dart';
import 'package:csdl_mobile/student/student.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade600],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'HK SMS',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Subtitle (HK Scholars Management System)
                  Text(
                    'HK Scholars',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 1),
                  // Subtitle (HK Scholars Management System)
                  Text(
                    'Management System',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Login Card Container with Rounded Corners and Shadow
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.7), // Dark background for the card
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Title (Sign in)
                        Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Subtitle (Sign in your account)
                        Text(
                          'Sign in your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Login field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[700],
                            labelText: 'Login',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText:
                              !_passwordVisible, // Password visibility toggle
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[700],
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Suffix icon to toggle password visibility
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible =
                                      !_passwordVisible; // Toggle password visibility
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        // Remember me checkbox
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Checkbox(
                        //       value: true,
                        //       onChanged: (val) {},
                        //       checkColor: Colors.white,
                        //       activeColor: Colors.green,
                        //     ),
                        //     Text(
                        //       'Remember me',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 20),
                        // Login Button
                        SizedBox(
                          width: double.infinity, // Full width button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // Green color as in the design
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                Text('Login', style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              login();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Footer (Powered by something)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    try {
      var url = Uri.parse("${SessionStorage.url}user.php");

      // Construct the request body
      Map<String, dynamic> jsonData = {
        "users_username": _usernameController.text,
        "users_password": _passwordController.text
      };

      Map<String, String> requestBody = {
        "operation": "userLogin",
        "json": jsonEncode(jsonData),
      };

      // Make the HTTP POST request
      var response = await http.post(url, body: requestBody);
      var res = jsonDecode(response.body);
      // Check the user level and handle navigation
      if (res['users_level'] == 2) {
        int advisorId = res['users_id'];
        // If the user is an advisor, navigate to Advisor screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Advisor(
                    advisor_id: advisorId,
                  )),
        );
      } else if (res['users_level'] == 1) {
        // If the user is a student, retrieve and pass the student_id
        int userId = res['users_id'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Student(
              student_id: userId, // Pass the userId to the Student widget
            ),
          ),
        );
      } else {
        // Show a snack bar if the login credentials are invalid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")),
        );
      }
    } catch (e) {
      print("ERROR: $e"); // Print the error for debugging
    }
  }
}
