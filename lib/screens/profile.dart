import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  String? name, email, phone, role;

  // getthesharedref() async{
  //   name= await SharedPreferenceHelper().getUserName();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'),),
      body: Container(
        child: Column(

        ),
      ),
    );
  }
}
