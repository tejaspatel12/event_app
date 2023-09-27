import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String phoneNumber;
  late String verificationId;

  // Function to send OTP
  Future<void> sendOTP() async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      // Handle automatic verification, if applicable.
      // You can automatically sign in the user here.
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        // Handle invalid phone number
        print('Invalid phone number');
      }
      // Handle other errors
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) async {
      // Save the verification ID to use for manual code verification later
      this.verificationId = verificationId;
      // Navigate to the OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            verificationId: verificationId,
          ),
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // Auto-retrieval of the SMS code has timed out
      // Handle this case as needed
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                phoneNumber = value;
              },
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sendOTP();
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String verificationId;

  OTPScreen({required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsCode;

  // Function to verify OTP and sign in
  Future<void> verifyOTP() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Check if the user is signed in
      if (userCredential.user != null) {
        // User signed in successfully
        print('User signed in: ${userCredential.user!.uid}');
        // Navigate to the home screen or any other screen
      } else {
        // Handle sign-in failure
        print('Sign-in failed');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                smsCode = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

