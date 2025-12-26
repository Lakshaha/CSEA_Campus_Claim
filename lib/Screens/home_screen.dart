import 'package:campus_commute/Screens/edit_user_screen.dart';
import 'package:campus_commute/Screens/requesting_ride.dart';
import 'package:campus_commute/Screens/upload_request_screen.dart';
import 'package:campus_commute/services/request_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/request_card_widget.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  Stream<QuerySnapshot> allRequests() {
    return FirebaseFirestore.instance
        .collection('requests')
        .orderBy('departureTime')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF233A66),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF233A66),
        title: Text(
          'COMMUTECAMPUS',
          style: TextStyle(
            fontFamily: 'bebas',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: RequestService().getAllRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Upcoming Requests",
                style: TextStyle(
                  fontFamily: 'lato',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD662),
                ),
              ),
            );
          }
          final request_items = snapshot.data!;

          return ListView.builder(
            itemCount: request_items.length,
            itemBuilder: (context, index) {
              final doc = request_items[index];
              final requestId = doc.id;
              return RequestCardWidget(requestId: doc.id, data: doc.toMap());
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD9D9D9),
        selectedItemColor: Color(0xFF008080),

        items: [
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed:
                  () {}, //=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => '')),
              icon: Icon(Icons.home, color: Color(0xFF008080)),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => uploadRequest()),
              ),
              icon: Icon(Icons.add, color: Color(0xff0000000)),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MyRequestsScreen(myUid: currentUserId),
                ),
              ),

              icon: Icon(Icons.list_alt, color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => editUserInfo()),
              ),

              icon: Icon(Icons.person_2_outlined, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
