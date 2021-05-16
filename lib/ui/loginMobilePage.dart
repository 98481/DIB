import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:phone_number_login/ui/MyHomePage.dart';
import 'package:phone_number_login/EmailAuthentication/authentication.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';
import 'package:phone_number_login/ui/RegisterMobilePage.dart';
import 'package:phone_number_login/phonemodel/phoneauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginMobilePage extends StatefulWidget {



  @override
  _LoginMobilePageState createState() => _LoginMobilePageState();
}

class _LoginMobilePageState extends State<LoginMobilePage> {
  bool _isHidden = true;

  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  final _key = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  TextEditingController _mobileController = TextEditingController();
  User user;
  final _phoneNumberKey = GlobalKey<FormState>();
  final _verifyPhoneKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _verifyPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  'Login in to get started',
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
                  'This is login page for owners,wait for OTP it also check for recaptche',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(

                width: MediaQuery.of(context).size.width,
                child:Form(
                  key: _phoneNumberKey,
                  child:Column(
                    children: [
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
                                      'assets/phone.png'),
                                  fit: BoxFit.fill,
                                ),),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*(3/4),
                              child: TextFormField(
                                controller: _mobileController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Phone number cannot be empty';
                                  }
                                  else if (!isPhoneNumberFormatValid('+91 ${value.trim()}'))
                                    return 'Invalid phone number';
                                  else
                                    return null;
                                },


                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                  prefix:Text('+91 ') ,
                                  fillColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  hintText: 'Mobile  Number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),


                                ),style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/5, 0, 10, 0),
                        child: FlatButton(
                          color: Colors.white,
                          child: Text('Verify Mobile Number',style: TextStyle(color: Color(0xffffd700),),),
                          onPressed: () async {
                            if (_phoneNumberKey.currentState.validate()) {
                              if (!(await sendVerificationPhoneMessage('+91 ${_mobileController.text.trim()}'))) {
                                showSnackBar(_scaffoldKey, content: 'Invalid Phone number');
                                return;
                              }
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Verify phone number',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    content: Form(
                                      key: _verifyPhoneKey,
                                      child: TextFormField(
                                        controller: _verifyPhoneController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Verification code',
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) return 'cannot be empty';
                                          if (value == ' ') return 'Wrong code';

                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        color: Colors.grey,
                                        child: Text(
                                          'Cancel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).maybePop(context);
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.grey,
                                        child: Text(
                                          'Verify',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if (!_verifyPhoneKey.currentState.validate())
                                            return;

                                          if (await verifyPhoneNumber(
                                              _verifyPhoneController.text.trim())) {


                                            while (await Navigator.of(context).maybePop());
                                          } else {
                                            _verifyPhoneController.text = ' ';
                                            _verifyPhoneKey.currentState.validate();
                                          }
                                          if(isPhoneNumberVerified){
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(),),);
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            },
                          textColor: Colors.grey,

                        ),
                      ),

                    ],
                  ),),



              ),
            ],
          ),
        ),
      ),);
  }
  void showSnackBar(
      GlobalKey<ScaffoldState> scaffoldKey, {
        String content = '',
        Color color = Colors.red,
      }) {
    scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(content),
          backgroundColor: color,
        ),
      );
  }

}
