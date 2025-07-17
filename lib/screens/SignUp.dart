import 'package:employement_management_system/screens/admin_home_dashboard.dart';
import 'package:employement_management_system/screens/Login.dart';
import 'package:employement_management_system/screens/addDetails.dart';
import 'package:employement_management_system/screens/phoneLogin.dart';
import 'package:employement_management_system/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Dashboard.dart';

class MySignUp extends StatefulWidget {
  MySignUp({Key? key}) : super(key: key);


  @override
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cpassword = TextEditingController();
  final authservice = AuthService();

  void signUp()async{
    try{
      final user = await authservice.signUp(_email.text, _password.text);
      if(user!= null){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> addDetails()));
      }
    }catch(e){
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset('assets/images/shape7.png'),
            Container(
              padding: EdgeInsets.only(left: 35, top: 60),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.black, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Form(
                            key: _key,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "Please Enter Full Name";
                                      }else if(!value!.contains("@gmail.com")){
                                        return "Please enter valid Email";
                                      }else{
                                        return null;
                                      }
                                    },
                                    controller: _email,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return "Please Enter Something";
                                      }else if(value!.length<4){
                                        return "Please enter Password greater than 4";
                                      }else return null;
                                    },
                                    controller: _password,
                                    style: TextStyle(color: Colors.black),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: _cpassword,
                                    validator: (value){
                                      if(value!.isEmpty)
                                        return "Please Enter Password";
                                      else if(value.toString()==_password)
                                        return "Please Enter the Same Password as Above";
                                      else return null;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )),
                                  ),
                                ],
                              )
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if(_key.currentState!.validate()) {
                                        signUp();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MyLogin()));
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 22),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 1,
                                width: 100,
                                color: Colors.grey,
                              ),
                              Text('  OR  ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.grey),),
                              Container(
                                height: 1,
                                width: 100,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.transparent,
                                child: IconButton(
                                    onPressed: () async {
                                      final user = await AuthService().signInWithGoogle();
                                      if (user != null) {
                                        // Navigate based on role or to dashboard
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyLogin()));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Google Sign-In failed')),
                                        );
                                      }
                                    },
                                    icon:  Image.asset('assets/images/google.png', height: 50,),
                                )
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.transparent,
                                child: IconButton(
                                    color: Colors.blueAccent,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => phoneLogin()),
                                      );
                                    },
                                    icon: Icon(
                                      size: 60,
                                      Icons.phone,
                                    )),
                              ),
                              // CircleAvatar(
                              //   radius: 30,
                              //   backgroundColor: Colors.transparent,
                              //   child: IconButton(
                              //       color: Colors.blue,
                              //       onPressed: () {},
                              //       icon: Icon(
                              //         size: 60,
                              //         Icons.facebook,
                              //       )),
                              // )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
