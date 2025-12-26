import 'package:campus_commute/Screens/edit_user_screen.dart';
import 'package:campus_commute/Screens/upload_request_screen.dart';
import 'package:campus_commute/widgets/my_request_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyRequestsScreen extends StatelessWidget {
  final String myUid;

  const MyRequestsScreen({super.key, required this.myUid});

  Stream<QuerySnapshot> _myRequestsStream() {
    return FirebaseFirestore.instance
        .collection('requests')
        .where('createdBy', isEqualTo: myUid)
        .orderBy('departureTime')
        .where('departureTime', isGreaterThan: Timestamp.now())
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _myRequestsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("You haven't created any requests"));
          }

          final requests = snapshot.data!.docs;

          return ListView(
            children: requests.map((doc) {
              return MyRequestCard(
                requestId: doc.id,
                data: doc.data() as Map<String, dynamic>,
              );
            }).toList(),
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
              icon: Icon(Icons.home, color: Color(0xff000000)),
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
                  builder: (_) => MyRequestsScreen(myUid: myUid),
                ),
              ),

              icon: Icon(Icons.list_alt, color: Color(0xFF008080)),
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
