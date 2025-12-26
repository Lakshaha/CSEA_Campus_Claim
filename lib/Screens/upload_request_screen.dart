import 'package:campus_commute/Screens/edit_user_screen.dart';
import 'package:campus_commute/Screens/home_screen.dart';
import 'package:campus_commute/Screens/requesting_ride.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:campus_commute/main.dart';

class uploadRequest extends StatefulWidget {
  const uploadRequest({super.key});

  @override
  State<uploadRequest> createState() => _uploadRequestState();
}

class _uploadRequestState extends State<uploadRequest> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? num;
  final destinationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final capacityController = TextEditingController();
  final transportController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final user = FirebaseAuth.instance.currentUser!;

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      selectedDate = picked;
      dateController.text =
          "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      timeController.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF233A66),
        centerTitle: true,
        //backgroundColor: Color(0xFF233A66),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 25),
          child: Form(
            key: _formkey,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF233A66),
                  borderRadius: BorderRadius.circular(20),
                ),
                //height: screenHeight * 0.4,
                width: screenWidth * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Destination',
                        style: TextStyle(
                          fontFamily: 'lato',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD662),
                        ),
                      ),
                    ),
                    TextFormField(
                      textAlign: TextAlign.center,
                      controller: destinationController,
                      decoration: InputDecoration(),
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter Destination'
                          : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Date: ',
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFFFFd662),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                            controller: dateController,
                            readOnly: true,
                            onTap: () => pickDate(context),
                            decoration: InputDecoration(
                              hintText: 'Select Date',
                              hintStyle: TextStyle(
                                fontFamily: 'lato',

                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please Select a Date'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Time: ',
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFFFFd662),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                            controller: timeController,
                            onTap: () => pickTime(context),
                            decoration: InputDecoration(
                              hintText: 'Select Time',
                              hintStyle: TextStyle(
                                fontFamily: 'lato',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please Enter Time'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Capacity: ',
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFFFFd662),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                            controller: capacityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // hintText
                              // hintStyle: TextStyle(
                              //   fontFamily: 'lato',
                              //   fontWeight: FontWeight.w700,
                              //   fontSize: 16,
                              //   color: Color(0xFFFFFFFF),
                              // ),
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) =>
                                value == '0' || value == null || value.isEmpty
                                ? 'Enter Number of people'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Transportation: ',
                            style: TextStyle(
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFFFFd662),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                            ),
                            controller: transportController,
                            decoration: InputDecoration(
                              // hintText: 'DD-MM-Y',
                              // hintStyle: TextStyle(
                              //   fontFamily: 'lato',
                              //   fontWeight: FontWeight.w700,
                              //   fontSize: 16,
                              //   color: Color(0xFFFFFFFF),
                              // ),
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please Enter Transport mode'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () async {
                        print(
                          'AUTH USER: ${FirebaseAuth.instance.currentUser}',
                        );

                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Selected Date and Time'),
                            ),
                          );
                        }
                        final int cap = int.parse(
                          capacityController.text.trim(),
                        );
                        if (cap == null || cap <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Enter Appropriate Capacity"),
                            ),
                          );
                          return;
                        }

                        final DateTime departureDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );

                        await FirebaseFirestore.instance
                            .collection('requests')
                            .add({
                              'destination': destinationController.text.trim(),
                              'transportation': transportController.text.trim(),
                              'capacity': cap,
                              'departureTime': Timestamp.fromDate(
                                departureDateTime,
                              ),
                              'createdBy':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Request Uploaded Successfully'),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => homeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD662),
                      ),
                      child: Text(
                        'Upload',
                        style: TextStyle(
                          fontFamily: 'lato',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF233A66),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFD9D9D9),
        selectedLabelStyle: TextStyle(
          fontFamily: 'lato',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF008080),
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'lato',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF000000),
        ),

        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => homeScreen()),
              ),
              icon: Icon(Icons.home, color: Color(0xFF000000)),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Add Ride Request',
            icon: IconButton(
              onPressed: () {}, //=> Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => uploadRequest()),
              // )
              icon: Icon(Icons.add, color: Color(0xFF008080)),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Check Requests',
            icon: IconButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MyRequestsScreen(myUid: user.uid),
                ),
              ),

              icon: Icon(Icons.list_alt, color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Edit User Info',
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
