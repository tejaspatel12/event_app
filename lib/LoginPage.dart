import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _mobileNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              // onPressed: () => _sendOTP(context),
              onPressed: () {  },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
