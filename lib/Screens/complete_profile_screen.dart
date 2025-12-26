import 'package:campus_commute/Screens/Home_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  final User user = FirebaseAuth.instance.currentUser!;

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      // await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
      //   {'phone': phoneController.text.trim()},
      // );
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'phone': phoneController.text.trim(),
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
      }, SetOptions(merge: true));

      // await ref.update({'phone': phoneController.text.trim()});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to Save Profile')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'COMMUTECAMPUS',
          style: TextStyle(
            fontFamily: 'bebas',
            color: Color(0xFF233A66),
            fontSize: 48,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formkey,
            child: SizedBox(
              //height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enter Contact Number',
                    style: TextStyle(
                      fontFamily: 'lato',
                      fontSize: 20,
                      color: Color(0xFF5F5F5F),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      hintText: 'Number',
                      hintStyle: TextStyle(
                        fontFamily: 'lato',
                        fontSize: 20,
                        color: Color(0xFF5F5F5F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.trim().length < 10
                        ? 'Enter Correct Contact Details'
                        : null,
                  ),
                  SizedBox(height: 45),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formkey.currentState!.validate()) return;

                            await saveProfile();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => homeScreen()),
                            );
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF233A66),
                      shape: RoundedRectangleBorder(),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
