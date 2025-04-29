import 'package:employement_management_system/screens/Home_Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class phoneLogin extends StatefulWidget {
  @override
  _phoneLoginState createState() => _phoneLoginState();
}

class _phoneLoginState extends State<phoneLogin> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  String? _verificationId;
  bool otpSent = false;

  void sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phone.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification Failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP() async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otp.text.trim(),
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeDashboard()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (!otpSent) ...[
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone Number (+91xxxxxxxxxx)"),
              ),
              ElevatedButton(
                onPressed: sendOTP,
                child: Text("Send OTP"),
              ),
            ] else ...[
              TextField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter OTP"),
              ),
              ElevatedButton(
                onPressed: verifyOTP,
                child: Text("Verify"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
