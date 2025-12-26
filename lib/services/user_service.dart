import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbols.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String name,
    required String phone,
  }) async {
    final uid = _auth.currentUser!.uid;

    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  //get current user data

  Future<Map<String, dynamic>> getCurrentUser() async {
    final uid = _auth.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser!;

    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    final doc = await ref.get();

    if (!doc.exists) {
      final data = {
        'name': user.displayName ?? 'Unknown',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
      };

      await ref.set(data);
      return {'uid': uid, ...data};
    }

    return {'uid': uid, ...doc.data()!};
  }

  Future<Map<String, dynamic>> getCurrentUserForInterest() async {
    final user = await getCurrentUser();

    return {'uid': user['uid'], 'name': user['name'], 'phone': user['phone']};
  }
}
