import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ETicketView extends StatelessWidget {
  const ETicketView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("E-Ticket"), leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // BARCODE SECTION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  BarcodeWidget(
                    barcode: Barcode.code128(), 
                    data: 'EVENT-${args['event_id']}-9923', // Dynamic ID
                    width: double.infinity,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  const Text("223221          227226", style: TextStyle(letterSpacing: 2)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // DETAILS SECTION (Matches your screenshot)
            _buildDetailCard([
              _infoTile("Event", "National Music Festival"),
              _infoTile("Date and Hour", "Monday, Dec 24 - 18.00 PM"),
              _infoTile("Event Location", "Grand Park, New York City, US"),
              _infoTile("Event Organizer", "World of Music"),
            ]),
            
            const SizedBox(height: 20),
            
            _buildDetailCard([
              _infoRow("Full Name", args['full_name']),
              _infoRow("Nickname", args['nickname']),
              _infoRow("Gender", args['gender']),
            ]),

            const SizedBox(height: 30),

            // DOWNLOAD BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5669FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => Get.snackbar("Success", "Ticket Saved to Gallery"),
                child: const Text("Download Ticket", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}