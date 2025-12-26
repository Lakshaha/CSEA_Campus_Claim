import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRequestCard extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic> data;

  const MyRequestCard({super.key, required this.requestId, required this.data});

  @override
  Widget build(BuildContext context) {
    final departureTime = (data['departureTime'] as Timestamp).toDate();

    return Card(
      color: Color(0xFFFFD662),
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'lato',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF233A66),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Destination: ${data['destination']}"),
              Text(
                "Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(departureTime)}",
              ),
              Text("Capacity: ${data['capacity']}"),

              const SizedBox(height: 12),

              /// 🔽 Interested users list
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .doc(requestId)
                    .collection('interestedUsers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading interested users...");
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No one interested yet");
                  }

                  final users = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Interested Users:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...users.map((doc) {
                        final user = doc.data() as Map<String, dynamic>;
                        return Text("• ${user['name']} (${user['contact']})");
                      }).toList(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
