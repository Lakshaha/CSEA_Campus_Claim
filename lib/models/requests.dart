import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

class Requests {
  final String id;
  final String destination;
  final String transportation;
  final int capacity;
  final DateTime departureTime;
  final String createdBy;

  Requests({
    required this.id,
    required this.destination,
    required this.transportation,
    required this.capacity,
    required this.departureTime,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "destination": destination,
      "transportation": transportation,
      "capacity": capacity,
      "departureTime": Timestamp.fromDate(departureTime),
      "createdBy": createdBy,
    };
  }

  //factory Requests.fromFirestore(Map<String, dynamic> data) {
  factory Requests.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Requests(
      id: doc.id,
      destination: data['destination'],
      transportation: data['transportation'],
      capacity: data['capacity'],
      departureTime: (data['departureTime'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
    );
  }
}
