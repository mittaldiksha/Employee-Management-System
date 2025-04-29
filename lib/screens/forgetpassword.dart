import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key});

  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {

  TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isLoading = false;
  String message = '';

  void resetPassword() async {
    if (_key.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _email.text.trim());
        setState(() {
          message = "Password reset email sent!";
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          message = "Error: ${e.toString()}";
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white ,
      title: Text("Reset Password"),
      content: Form(
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter your registered email to receive a reset link."),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email"),
              validator: (value) =>
              value!.isEmpty ? 'Email required' : null,
            ),
            if (message.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(message, style: TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : resetPassword,
          child: isLoading ? CircularProgressIndicator() : Text("Send"),
        ),
      ],
    );
  }
}

    // return Container(
    //   child: Column(
    //     children: [
    //         TextFormField(
    //           controller: _email,
    //           validator: (value){
    //             if(value!.isEmpty)
    //               return "Please Enter Email";
    //             else if(!value.contains("@gmail.com")){
    //               return "Please Enter valid Email";
    //             }
    //             return null;
    //           },
    //           style: TextStyle(color: Colors.black),
    //           decoration: InputDecoration(
    //               fillColor: Colors.grey.shade100,
    //               filled: true,
    //               hintText: "Email",
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(10),
    //               )
    //           ),
    //         )
    //     ],
    //   ),
    // );
