import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:phone_number_login/ui/MyHomePage.dart';
import 'package:phone_number_login/EmailAuthentication/authentication.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';
import 'package:phone_number_login/ui/RegisterMobilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RegisterAsIndividualPage extends StatefulWidget {



  @override
  _RegisterAsIndividualPageState createState() => _RegisterAsIndividualPageState();
}

class _RegisterAsIndividualPageState extends State<RegisterAsIndividualPage> {
  bool _isHidden = true;

  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  final _key = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  User user;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //height: MediaQuery.of(context).size.height,
      body: SingleChildScrollView(

        child: Container(

          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/9),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          decoration: BoxDecoration(
            color: Colors.white ,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),

            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/18,
                child: Text(
                  'Register in to get started',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),


              Container(
                padding: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/18,
                child: Text(
                  'Individuals no need to register by mobile , can register by email and password',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(

                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide( //                   <--- left side
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),),
                              child: Row(
                                children: [
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/email.png'),
                                        fit: BoxFit.fill,
                                      ),),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*(3/4),
                                    child: TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Email cannot be empty';
                                        }
                                        if (!RegExp(
                                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email Address';
                                        }
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(

                                        labelText: 'Email-ID',
                                        labelStyle: TextStyle(color: Colors.grey,),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),

                                        fillColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,


                                      ),style: TextStyle(color: Colors.grey,),),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide( //                   <--- left side
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),),
                              child: Row(
                                children: [
                                  Container(
                                    height: 16.0,
                                    width: 16.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/lock.png'),
                                        fit: BoxFit.fill,
                                      ),),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*(3/5),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: _isHidden,

                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Password cannot be empty';
                                        } else
                                          return null;
                                      },
                                      decoration: InputDecoration(

                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),

                                        fillColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.grey),
                                      ),

                                      style: TextStyle(color: Colors.grey,),


                                    ),
                                  ),
                                  InkWell(
                                    onTap: _toggleVisibility,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 5),


                            SizedBox(height: MediaQuery.of(context).size.height/7),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width-100,
                                  decoration:BoxDecoration(
                                    color: Color(0xffffd700),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                        offset: Offset(0, 6),
                                      ),
                                    ],

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),

                                  ),

                                  child: FlatButton(

                                    child: Text('Register as Individual'),
                                    onPressed: () async {
                                      if (_key.currentState.validate()) {
                                        //createUser();
                                        bool shouldNavigate = await register(_emailController.text, _passwordController.text);

                                        if (shouldNavigate) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => RegisterPage(isbuttonenable:true)),
                                          );
                                        }
                                      }
                                    },

                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width-100,
                                  decoration:BoxDecoration(
                                    color: Color(0xffffd700),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                        offset: Offset(0, 6),
                                      ),
                                    ],

                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),

                                  ),

                                  child: FlatButton(

                                    child: Text('Register as Owner'),
                                    onPressed: () async {
                                      Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) =>
                                            RegisterPage(isbuttonenable:false),),);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            FlatButton(

                              child: Row(
                                children: [
                                  Text('  Already have an account? ',style: TextStyle(color: Colors.grey),),
                                  Text('Login',style: TextStyle(color: Colors.black),),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => LoginPage(),),
                                );
                              },
                              textColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),);
  }
}
