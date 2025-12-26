import 'package:campus_commute/Screens/Home_Screen.dart';
import 'package:campus_commute/Screens/complete_profile_screen.dart';
import 'package:campus_commute/Screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsign;
import 'package:sign_in_button/sign_in_button.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final gsign.GoogleSignIn _googleSignIn = gsign.GoogleSignIn.instance;
  bool _isLoading = false;
  //final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> routeAfterLogin(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists ||
        doc.data()?['phone'] == null ||
        doc.data()?['phone'] == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CompleteProfileScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => homeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.initialize(
      serverClientId:
          '434182527652-slmd9gesigrdrdql1cb02e63pge8gmq5.apps.googleusercontent.com',
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await routeAfterLogin(context);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for this email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        default:
          message = 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Try again late')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final gsign.GoogleSignInAccount googleUser = await _googleSignIn
          .authenticate();

      final gsign.GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        //accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-in Error: $e");
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // void @override
  // void initState() {
  //   super.initState();

  //   _googleSignIn.serverClientId = '434182527652-slmd9gesigrdrdql1cb02e63pge8gmq5.apps.googleusercontent.com';
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login to your Account',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xFF808080),
                    ),
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),

                      prefixIcon: Icon(Icons.email_outlined),
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

                  SizedBox(height: 20),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      prefixIcon: Icon(Icons.lock_outline),
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
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'lato',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 45),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF233A66),
                        shape: RoundedRectangleBorder(),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'lato',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '-Or sign-in with-',
                    style: TextStyle(
                      color: Color(0xFF5F5F5F),
                      fontFamily: 'lato',
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: SignInButton(
                      Buttons.google,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      text: "Sign in With Google",
                      onPressed: () async {
                        final userCredential = await signInWithGoogle();
                        if (userCredential != null) {
                          await routeAfterLogin(context);

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //       'Sign in as ${userCredential.user?.displayName}',
                          //     ),
                          //   ),
                          // );
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account? ',
                        style: TextStyle(fontSize: 16, fontFamily: 'lato'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => signUp()),
                          );
                        },

                        child: Text(
                          "SignUp",
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
