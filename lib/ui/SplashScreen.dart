import 'package:flutter/material.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  @override
  Widget build(BuildContext context) {

    return new SplashScreen(

      title: new Text(
        'Welcome To DIB\n I think you like it!',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      seconds: 4,

      navigateAfterSeconds: LoginPage(),
      //image: new Image.asset('assets/loading.gif'),
      image: new Image.asset('assets/animated.gif'),
      backgroundColor: Colors.white,
      imageBackground: Image.asset('assets/background.png').image,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 150.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.orangeAccent,
    );

  }

}