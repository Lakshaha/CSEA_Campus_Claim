import 'package:campus_commute/Screens/Home_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_commute/main.dart';
import 'package:campus_commute/Screens/edit_user_screen.dart';
import 'package:campus_commute/Screens/requesting_ride.dart';
import 'package:campus_commute/Screens/upload_request_screen.dart';
import 'package:campus_commute/services/request_service.dart';

class editUserInfo extends StatefulWidget {
  const editUserInfo({super.key});

  @override
  State<editUserInfo> createState() => _editUserInfoState();
}

class _editUserInfoState extends State<editUserInfo> {
  final User _user = FirebaseAuth.instance.currentUser!;
  late final DocumentReference userDoc;

  @override
  void initState() {
    super.initState();
    userDoc = FirebaseFirestore.instance.collection('users').doc(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFD662),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFFD662),
        title: Text(
          'COMMUTECAMPUS',
          style: TextStyle(
            fontFamily: 'bebas',
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Color(0xFF233A66),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: width * 0.8,

            //height: height * 0.4,
            margin: EdgeInsets.fromLTRB(40, 10, 30, 0),
            padding: EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Color(0xFF233A66),
              borderRadius: BorderRadius.circular((20)),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'lato',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFD622),
              ),
              child: StreamBuilder(
                stream: userDoc.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xfffffffff),
                        backgroundImage: _user.photoURL != null
                            ? NetworkImage(_user.photoURL!)
                            : AssetImage('assets/images/default_user.png')
                                  as ImageProvider,
                      ),
                      SizedBox(height: 30),
                      profileText('User Name'),
                      SizedBox(height: 20),
                      profileText('${data['name']}'),
                      SizedBox(height: 12),
                      profileText('Contact '),
                      SizedBox(height: 12),
                      profileText('${data['phone']}'),
                      SizedBox(height: 12),
                      profileText('Email '),
                      SizedBox(height: 12),
                      profileText('${data['email']}'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD9D9D9),
        selectedItemColor: Color(0xFF008080),

        items: [
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => homeScreen()),
                );
              },
              icon: Icon(Icons.home, color: Color(0xFF000000)),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => uploadRequest()),
              ),
              icon: Icon(Icons.add, color: Color(0xff000000)),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MyRequestsScreen(myUid: _user.uid),
                ),
              ),

              icon: Icon(Icons.list_alt, color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              onPressed: () {}, //=> Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => editUserInfo()),
              // ),
              icon: Icon(Icons.person_2_outlined, color: Color(0xFF008080)),
            ),
          ),
        ],
      ),
    );
  }

  static Widget profileText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'lato',
        fontSize: 18,
        color: Color(0xFFFFD662),
      ),
    );
  }
}
