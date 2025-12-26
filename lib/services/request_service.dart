import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models//requests.dart';

class RequestService {
  final _collection = FirebaseFirestore.instance.collection('requests');

  Future<void> markInterested({
    required String requestId,
    required Map<String, dynamic> user,
  }) async {
    final requestRef = _collection.doc(requestId);

    final interestedRef = requestRef
        .collection('interestedUsers')
        .doc(user['uid']);

    // await interestedRef.set({
    //   'uid': user['uid'],
    //   'name': user['name'],
    //   'email': user['email'],
    //   'phone': user['phone'],
    //   'interestedAt': FieldValue.serverTimestamp(),
    // });

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      //read req
      // final ref = FirebaseFirestore.instance
      //     .collection('requests')
      //     .doc(requestId);
      final requestSnap = await transaction.get(requestRef);
      final data = requestSnap.data()!;

      final int curr_cap = data['capacity'];

      //prevent dupli interest
      final interestedSnap = await transaction.get(interestedRef);

      if (interestedSnap.exists) {
        throw Exception("Already Interested");
      }

      if (curr_cap <= 0) {
        transaction.delete(requestRef);
        return;
      }

      transaction.set(interestedRef, {
        'uid': user['uid'],
        'email': user['email'],
        'name': user['name'],
        'contact': user['phone'],
        'joinedAt': FieldValue.serverTimestamp(),
      });

      final int new_cap = curr_cap - 1;
      if (new_cap == 0) {
        transaction.update(requestRef, {'capacity': new_cap});
      } else {
        transaction.update(requestRef, {'capacity': new_cap});
      }
    });
  }

  Stream<List<Requests>> getAllRequests() {
    return _collection
        .orderBy('departureTime')
        .where('departureTime', isGreaterThan: Timestamp.now())
        .where('capacity', isGreaterThan: 0)
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map((doc) => Requests.fromFirestore(doc))
                .toList();
          },
        ); //{return snapshot.docs.map(doc) => return Requests.fromMap(doc.data, doc.Id)}});
  }

  Future<void> createRequest(Requests request) async {
    await _collection.add({
      ...request.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
