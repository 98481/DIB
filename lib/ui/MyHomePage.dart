import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:phone_number_login/ui/LoginEmailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phone_number_login/phonemodel/phoneauth.dart';
final auth = FirebaseAuth.instance;
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  var tabs;
  int _count = 0;
  @override
  void initState() {
    tabs = [
      Container(
        child: LocationHomePage(),
      ),
      Container(
        child: Text("ORDER"),
      ),
      Container(
        child: Text("PAY-IN"),
      ),
      Container(
        child: Text("Profile"),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            '   My Account',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: Icon(Icons.logout,),
              disabledColor: Colors.white,
              onPressed: ()async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs?.clear();
                auth.signOut();
                setState(() {

                });

                //Navigator.pop(context,true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
        body: tabs[_count],
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: BottomNavigationBar(
              currentIndex: _count,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border),
                    activeIcon: Icon(Icons.favorite),
                  title: Text("Menu")
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    activeIcon: Icon(Icons.search_sharp),
                  title: Text("Order")

                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.payments_outlined),
                    activeIcon: Icon(Icons.payments),
                  title: Text("Pay-In")

                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined),
                    activeIcon: Icon(Icons.account_circle),
                  title: Text("Profile")

                ),
              ],
              onTap: (index) {
                setState(() {
                  _count = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocationHomePage extends StatefulWidget {
  @override
  _LocationHomePageState createState() => _LocationHomePageState();
}

class _LocationHomePageState extends State<LocationHomePage> {
  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("You can get current by pressing get location button and allow permissions to APP wait for 2minutes to load, Thankyou"),
            SizedBox(height: 20,),
            if (_currentAddress != null) Expanded(
              child: Container(
                height: 50,
                child: Text(
                    _currentAddress
                ),
              ),
            ),
            FlatButton(
              color: Color(0xffffd700),
              child: Text("Get location"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),

            FlatButton(
              color: Color(0xffffd700),
              child: Text("Manage Addresses"),
              onPressed: () {

              },
            ),
            FlatButton(
              color: Color(0xffffd700),
              child: Text("Change Password"),
              onPressed: () {

              },
            ),
            FlatButton(
              color: Color(0xffffd700),
              child: Text("Edit Profile"),
              onPressed: () {

              },
            ),
            FlatButton(
              color: Color(0xffffd700),
              child: Text("Logout"),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs?.clear();
                auth.signOut();

                //Navigator.pop(context,true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude,
          _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

}
