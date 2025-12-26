import 'package:campus_commute/models/requests.dart';
import 'package:campus_commute/services/request_service.dart';
import 'package:campus_commute/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestCardWidget extends StatelessWidget {
  final String requestId;
  final Map<String, dynamic> data;

  const RequestCardWidget({
    super.key,
    required this.requestId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime departureTime = (data['departureTime'] as Timestamp)
        .toDate();
    return Card(
      color: Color(0xFFFFD662),
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),

        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'lato',
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Color(0xFF233A66),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Destination :  ${data['destination']}"),
              Text(" Date : ${DateFormat('dd MM yyyy').format(departureTime)}"),
              Text("Time: ${DateFormat('hh:mm a').format(departureTime)}"),
              Text('Capacity: ${data['capacity']}'),
              Text('Transportation Mode: ${data['transportation']}'),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final user = await UserService().getCurrentUser();
                    debugPrint("AUTH USER $user");

                    await RequestService().markInterested(
                      requestId: requestId,
                      user: user,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Marked Interested')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Text("Interested"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
