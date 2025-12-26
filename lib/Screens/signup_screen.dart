import 'package:campus_commute/Screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password_confirmController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        final uid = credential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': numberController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        await credential.user!.updateDisplayName(nameController.text.trim());
        await credential.user!.reload();
        Navigator.pushNamed(context, 'home');
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration Failed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${(e.toString())}')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    password_confirmController.dispose();
    numberController.dispose();
    super.dispose();
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
            key: _formKey,
            child: SizedBox(
              //height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontFamily: 'lato',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF808080),
                    ),
                  ),
                  SizedBox(height: 28),

                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      hintText: 'Name',
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
                        value!.isEmpty ? 'Enter your name' : null,
                  ),

                  SizedBox(height: 15),
                  TextFormField(
                    controller: numberController,
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
                    validator: (value) => value!.isEmpty && value.length < 10
                        ? 'Enter Correct Contact Details'
                        : null,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontFamily: 'lato',
                        fontSize: 20,
                        color: Color(0xFF5F5F5F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: 'lato',
                        fontSize: 20,
                        color: Color(0xFF5F5F5F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) => value != null && value.length < 6
                        ? 'Password must be 6 digits long'
                        : null,
                  ),

                  SizedBox(height: 15),

                  TextFormField(
                    controller: password_confirmController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
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
                        value != null && value.length < 6 ||
                            passwordController.text.trim() !=
                                password_confirmController.text.trim()
                        ? 'Enter Correct Password'
                        : null,
                  ),

                  SizedBox(height: 30),
                  // Container(
                  //   padding: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xFF233A66),

                  //     //borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         spreadRadius: 2,
                  //         blurRadius: 10,
                  //         offset: Offset(0, 5),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       'Sign Up',
                  //       style: TextStyle(
                  //         fontFamily: 'lato',
                  //         fontSize: 24,
                  //         color: Color(0xFFFFFFFF),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF233A66),
                        shape: RoundedRectangleBorder(),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFFFFF),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'lato',
                                fontSize: 24,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text(
                  //   '-Or signup with-',
                  //   style: TextStyle(
                  //     color: Color(0xFF5F5F5F),
                  //     fontFamily: 'lato',
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // SizedBox(height: 10),
                  // Container(
                  //   child: IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.chrome_reader_mode),
                  //   ),
                  // ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(fontFamily: 'lato', fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => signIn()),
                          );
                        },

                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'lato',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
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
