import 'package:csdl_mobile/advisor/advisor_qr_scanner.dart';
import 'package:csdl_mobile/advisor/advisor_scholar_list.dart';
import 'package:flutter/material.dart';

class Advisor extends StatefulWidget {
  final int advisor_id;
  const Advisor({
    super.key,
    required this.advisor_id,
  });

  @override
  _AdvisorState createState() => _AdvisorState();
}

class _AdvisorState extends State<Advisor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blue.shade800,
        appBar: AppBar(
          title: const Text('Advisor'),
          backgroundColor: Colors.blue.shade800,
        ),
        drawer: advisorDrawer(context),
        body: const Center(
          child: Column(
            children: [
              Text('Advisor'),
            ],
          ),
        ),
      ),
    );
  }

  Widget advisorDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 9, 99, 58),
      child: SizedBox(
        width: 200, // Set the desired width of the drawer
        child: Column(
          children: [
            DrawerHeader(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Text("Advisor", style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              title: const Text("QR Scanner", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdvisorQrScanner(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              title:
                  const Text("Scholar List", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdvisorScholarList(
                      advisor_id: widget.advisor_id,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
