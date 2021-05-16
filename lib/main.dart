import 'package:flutter/material.dart';
import 'package:phone_number_login/ui/MyHomePage.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_number_login/ui/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = (prefs.getBool('isLoggedIn') == null) ? false : prefs.getBool('isLoggedIn');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? MyAppOther() : MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:Splashscreen(),
    );
  }
}
class MyAppOther extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Records',
      home: SplashScreen(

        title: new Text(
        'Welcome To DIB\n I think you like it!',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        seconds: 4,

        navigateAfterSeconds: MyHomePage(),
        //image: new Image.asset('assets/loading.gif'),
        image: new Image.asset('assets/animated.gif'),
        backgroundColor: Colors.white,
        imageBackground: Image.asset('assets/background.png').image,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.orangeAccent,
      ),
    );

  }
}
