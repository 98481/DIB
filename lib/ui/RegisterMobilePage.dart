import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_number_login/Database/UploadData.dart';
import 'package:phone_number_login/ui/MyHomePage.dart';
import 'package:phone_number_login/EmailAuthentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:phone_number_login/phonemodel/phoneauth.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';


import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  final bool isbuttonenable;

  const RegisterPage({Key key, this.isbuttonenable}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _phoneNumberKey = GlobalKey<FormState>();
  final _verifyPhoneKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isHidden = true;
  void _toggleVisibility(){
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  String category;
  String deliver;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _rangeController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _verifyPhoneController = TextEditingController();
  bool isSignedIn(){
    if(FirebaseAuth.instance.currentUser != null)
    return true;
    else
      return false;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body:SingleChildScrollView(

              child:Container(

                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,

                  decoration: BoxDecoration(
                    color: Colors.white ,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),

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
                          ' Register in to get started',
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
                        height: MediaQuery.of(context).size.height/14,
                        child: Text(
                          'Owners Can Register by verifying Mobilenumber only then add shop details, individuals cannot again register with mobile',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(

                        width: MediaQuery.of(context).size.width,
                        child: Form(
                          key: _key,

                          child: Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [



                                    Form(
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
                                                      enabled: !widget.isbuttonenable,
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
                                              if(widget.isbuttonenable==true){
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
                                                            },
                                                          ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                }}},
                                                textColor: Colors.grey,
                                              ),
                                            ),

                                             ],
                                          ),),
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

                                            width: MediaQuery.of(context).size.width*(3/4),
                                            child: TextFormField(
                                              enabled: isSignedIn(),
                                              controller: _nameController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Name cannot be empty';
                                                } else
                                                  return null;
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),

                                                fillColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                labelText: 'Shop Name',
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),


                                              ),style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [

                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: MediaQuery.of(context).size.width/2,
                                                child: IgnorePointer(
                                                  ignoring: !isSignedIn(),
                                                  child: DropdownButton<String>(

                                                    value: category,
                                                    //elevation: 5,
                                                    style: TextStyle(color: Colors.grey),

                                                    items: <String>[
                                                      'Food',
                                                      'House Items',
                                                      'Utensils',
                                                      'Gifts',
                                                      'Electronics',
                                                      'Dresses',

                                                    ].map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,

                                                        child: Text(value,style: TextStyle(color: Colors.black),),

                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      "Choose a Category",
                                                      style: TextStyle(
                                                          color: Colors.grey,

                                                         ),
                                                    ),
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        category = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),


                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          width: MediaQuery.of(context).size.width/2,



                                               child: IgnorePointer(
                                                 ignoring: !isSignedIn(),
                                                 child: DropdownButton<String>(
                                                    value: deliver,
                                                    //elevation: 5,
                                                    style: TextStyle(color: Colors.black),

                                                    items: <String>[
                                                      'Yes',
                                                      'No',


                                                    ].map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value,style: TextStyle(color: Colors.black),),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      "Is it HomeDelivery",
                                                      style: TextStyle(
                                                          color: Colors.grey,

                                                    ),),
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        deliver = value;
                                                      });
                                                    },
                                                  ),
                                               ),
                                              ),

                                      ],
                                    ),
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
                                            width: MediaQuery.of(context).size.width*(3/4),
                                            child: TextFormField(
                                              enabled: isSignedIn(),
                                              controller: _rangeController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Range cannot be empty';
                                                }

                                                else
                                                  return null;
                                              },
                                              decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0.0)),

                                                fillColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                labelText: 'Del.Range(km)',
                                                labelStyle: TextStyle(color: Colors.grey),
                                              ),
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),



                                    SizedBox(height: 4),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width-70,
                                          decoration:BoxDecoration(
                                            color: Color(0xffffd700),


                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight: Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 3,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: FlatButton(

                                            child: Text('Submit'),
                                            onPressed: () async {
                                              if (_key.currentState.validate()) {

                                                String uid=FirebaseAuth.instance.currentUser.uid.toString();
                                                await DatabaseManager().createUserDetails(_nameController.text.toString(), category,deliver, _rangeController.text.toString(), uid);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => LoginPage()),
                                                );
                                              }
                                            },

                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width-70,
                                          decoration:BoxDecoration(
                                            color: widget.isbuttonenable?Color(0xffffd700):Color(0x40ffd700),


                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                              bottomRight: Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 3,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: FlatButton(

                                            child: Text('Skip this Page'),
                                            onPressed:()=> widget.isbuttonenable? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => LoginPage()),
                                            ):null,

                                          ),
                                        ),

                                      ],
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
