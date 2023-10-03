import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api.dart';
import 'package:http/http.dart' as http;

import '../screen/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String phoneNumber;
  late String verificationId;

  String selectedTo = '+91';
  List<String> toOptions = ['+91','+44'];


  void _showDropdown(BuildContext context, List<String> options, String selectedValue, Function(String) onSelection) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Adjust the height as needed
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  onSelection(options[index]);
                  Navigator.of(context).pop();
                },
                title: Text(
                  options[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Function to send OTP
  Future<void> sendOTP() async {
    verificationCompleted(PhoneAuthCredential credential) async {
      // Handle automatic verification, if applicable.
      // You can automatically sign in the user here.
    }

    verificationFailed(FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        // Handle invalid phone number
        print('Invalid phone number');
      }
      // Handle other errors
    }

    codeSent(String verificationId, int? resendToken) async {
      // Save the verification ID to use for manual code verification later
      this.verificationId = verificationId;
      // Navigate to the OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            verificationId: verificationId,
            onVerificationCompleted: () {
              // Handle verification completion
              print('Verification completed.');
              _handleSuccessfulLogin();
            },
            onVerificationFailed: () {
              // Handle verification failure
              print('Verification failed.');
              _handleFailedLogin();
            },
            onResendOTP: () {
              // Handle resend OTP button press
              print('Resend OTP pressed.');
              sendOTP();
            },
          ),
        ),
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // Auto-retrieval of the SMS code has timed out
      // Handle this case as needed
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: selectedTo+phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> storeUserMobileNumber(String mobileNumber) async {
    final apiUrl = Uri.parse('https://event.activeapp.in/login.php'); // Replace with your API endpoint

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'mobile_number': mobileNumber,
        },
      );

      if (response.statusCode == 200) {
        // Request was successful
        print('User data inserted successfully');

        // Parse the response to get the user ID
        final userId = jsonDecode(response.body)['userId'].toString();

        // Store the user ID in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);

        print('User ID stored in SharedPreferences: $userId');
      } else {
        // Request failed
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exceptions, such as network errors
      print('Error: $e');
    }
  }

  // Function to handle successful login
  Future<void> _handleSuccessfulLogin() async {
    // Implement your logic for a successful login
    // Navigate to the home screen or any other screen

    // User signed in successfully

    // Set isLoggedIn to true in SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    // Navigate to HomeScreen without a back arrow
    // Store user mobile number in the database via API

    final mobileNumber = selectedTo + phoneNumber;

    // Call the API to store the user's mobile number and get the user ID
    // final mobileNumber = selectedTo + phoneNumber;
    await storeUserMobileNumber(mobileNumber);

    // final mobileNumber = selectedTo + phoneNumber;
    // await storeUserMobileNumber(mobileNumber);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),),);


    // Navigator.of(context).pushReplacementNamed();
  }

  // Function to handle failed login
  void _handleFailedLogin() {
    // Implement your logic for a failed login
    // Display an error message or take appropriate action
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
          Center(child: Image.asset('assets/logo.png',height: MediaQuery.of(context).size.height * 0.15,)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Center(child: Text("Welcome to, Events",style: TextStyle(color: Colors.blue,fontSize: MediaQuery.of(context).size.height * 0.025,fontWeight: FontWeight.bold),)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15,),


          Center(child: Text("Verify your phone number",style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.height * 0.02,fontWeight: FontWeight.bold),)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          Center(child: Text("We have send you an One Time Password (OTP)\n on this mobile number",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.height * 0.015,fontWeight: FontWeight.bold),)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.purple,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _showDropdown(context, toOptions, selectedTo, (newValue) {
                                setState(() {
                                  selectedTo = newValue;
                                });
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height *0.054,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // padding: const EdgeInsets.all(8),
                              padding: const EdgeInsets.only(left: 4,right: 4,top: 4),
                              child: Center(
                                child: Text(
                                  selectedTo,style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              phoneNumber = value;
                            },
                          decoration: InputDecoration(
                          // labelText: 'Enter Your Mobile Number',
                          hintText: 'Enter Your Mobile Number',
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                  width: 2, color: Colors.black,
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide()
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: ()
                      {
                        sendOTP();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.blue,
                        ),
                        child: Center(child: const Text("Send OTP",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final VoidCallback onVerificationCompleted;
  final VoidCallback onVerificationFailed;
  final VoidCallback onResendOTP;

  OTPScreen({
    required this.verificationId,
    required this.onVerificationCompleted,
    required this.onVerificationFailed,
    required this.onResendOTP,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsCode;
  late String smsCode1;

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
        // Notify the parent screen about verification completion
        widget.onVerificationCompleted();
      } else {
        // Handle sign-in failure
        print('Sign-in failed');
        // Notify the parent screen about verification failure
        widget.onVerificationFailed();
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      // Handle error
      // Notify the parent screen about verification failure
      widget.onVerificationFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: ListView(
        children: [

          SizedBox(height: MediaQuery.of(context).size.height * 0.25,),
          Center(child: Text("Verify your phone number",style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height * 0.02,fontWeight: FontWeight.bold),)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          Center(child: Text("We have send you an One Time Password (OTP)\n on this mobile number",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height * 0.015,fontWeight: FontWeight.bold),)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

          OtpTextField(
            numberOfFields: 6,
            borderColor: Colors.white,
            fillColor: Colors.white,
            filled: true,
            // fieldWidth: Colors.white,
            textStyle: TextStyle(color: Colors.blue),
            focusedBorderColor: Colors.black,
            borderWidth: 2.0,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            // onCodeChanged: (String code) {
            //   //handle validation or checks here
            // },
            // onCodeChanged: (value) {
            //   smsCode = value;
            // },
            // onCodeChanged: (String code) {
            //   smsCode = code;
            // },
            onCodeChanged: (String verificationCode) {
              smsCode = verificationCode;
            },
            onSubmit: (String verificationCode){
              smsCode = verificationCode;
            },
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

          Center(
            child: GestureDetector(
              // onLongPress: ()
              // {
              //   print("111 : "+smsCode1.toString());
              // },
              // onDoubleTap: ()
              // {
              //   print("OTP : "+smsCode.toString());
              // },
              onTap: ()
              {
                verifyOTP();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.black,
                ),
                child: Center(child: const Text("Verify OTP",style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),


          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       TextField(
          //         onChanged: (value) {
          //           smsCode = value;
          //         },
          //         decoration: InputDecoration(
          //           labelText: 'Enter OTP',
          //         ),
          //       ),
          //       SizedBox(height: 16.0),
          //       ElevatedButton(
          //         onPressed: () {
          //           verifyOTP();
          //         },
          //         child: Text('Verify OTP'),
          //       ),
          //       SizedBox(height: 16.0),
          //       TextButton(
          //         onPressed: () {
          //           widget.onResendOTP();
          //         },
          //         child: Text('Resend OTP'),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}


