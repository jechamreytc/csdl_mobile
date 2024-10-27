import 'dart:convert';
import 'package:csdl_mobile/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class AdvisorQrScanner extends StatefulWidget {
  const AdvisorQrScanner({super.key});

  @override
  State<AdvisorQrScanner> createState() => _AdvisorQrScannerState();
}

class _AdvisorQrScannerState extends State<AdvisorQrScanner> {
  Barcode? _barcode;
  bool _attendanceMarked = false; // Flag to track attendance status

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        // Get the first barcode from the scanned data
        _barcode = barcodes.barcodes.firstOrNull;
      });

      // Show the confirmation dialog after a successful scan only if not marked
      if (_barcode != null && !_attendanceMarked) {
        _showConfirmationDialog(); // Show confirmation dialog
      }
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Attendance'),
          content: const Text('Do you want to mark attendance?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                studentsAttendance(); // Call the function to send attendance
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode, // Set the onDetect callback
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: _buildBarcode(_barcode), // Display scanned barcode
              ),
            ),
          ),
        ],
      ),
    );
  }

  void studentsAttendance() async {
    if (_barcode == null) return;

    try {
      var url = Uri.parse("${SessionStorage.url}CSDL.php");
      Map<String, dynamic> jsonData = {
        "stud_school_id": _barcode!.displayValue, // Use scanned barcode value
      };
      Map<String, String> requestBody = {
        "operation": "studentsAttendance",
        "json": jsonEncode(jsonData), // Convert jsonData to JSON
      };

      var response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        var res = response.body; // Directly use the response body
        if (res == '1') {
          // Attendance marked successfully
          print("Time in Success");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Attendance marked successfully!")),
          );
          setState(() {
            _attendanceMarked = true; // Mark attendance as done
          });
          Navigator.pop(context); // Exit the scanner
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to mark attendance."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while marking attendance."),
        ),
      );
    }
  }
}
