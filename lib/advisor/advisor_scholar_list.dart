import 'dart:convert';
import 'package:csdl_mobile/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvisorScholarList extends StatefulWidget {
  final int advisor_id;
  const AdvisorScholarList({
    super.key,
    required this.advisor_id,
  });

  @override
  _AdvisorScholarListState createState() => _AdvisorScholarListState();
}

class _AdvisorScholarListState extends State<AdvisorScholarList> {
  List<dynamic> scholars = [];
  bool isLoading = true; // Loading state to manage UI
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getAssignedScholars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholar List'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show a loading indicator while data is being fetched
            : scholars.isNotEmpty
                ? createListView()
                : Text(errorMessage.isNotEmpty
                    ? errorMessage
                    : 'No scholars found.'), // Display error or "no data" message
      ),
    );
  }

  // Creates the ListView for displaying the scholars
  Widget createListView() {
    return ListView.builder(
      itemCount: scholars.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Handle the tap event here, for example, navigate to a detail screen
            showScholarDetails(
                index); // Example function for showing scholar details
          },
          child: Card(
            child: ListTile(
              title: Text(
                "${scholars[index]['personal_full_name']}", // Use first and last name
              ),
              subtitle: Text(
                'Contact: ${scholars[index]['personal_contact_number']}',
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to fetch assigned scholars
  void getAssignedScholars() async {
    try {
      var url = Uri.parse("${SessionStorage.url}user.php");
      Map<String, dynamic> jsonData = {
        "users_id": widget.advisor_id, // Adjust this ID as needed
      };

      Map<String, String> requestBody = {
        "operation": "getAssignedScholars",
        "json": jsonEncode(jsonData),
      };

      var response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res != 0) {
          setState(() {
            scholars = res;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = "No scholars assigned.";
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              "Failed to load scholars. Server returned status code: ${response.statusCode}.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  // Example function to handle the tap on a scholar item
  void showScholarDetails(int index) {
    final scholar = scholars[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(scholar['personal_full_name']),
          content: Text(
            'Contact: ${scholar['personal_contact_number']}\n'
            'Email: ${scholar['personal_email_address']}\n'
            'Address: ${scholar['personal_address']}',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
