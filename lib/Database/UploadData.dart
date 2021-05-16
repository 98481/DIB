import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  final CollectionReference profileList =
  FirebaseFirestore.instance.collection('profileInfo');

  String uid = FirebaseAuth.instance.currentUser.uid.toString();

  //here user uid

  Future<void> createUserDetails(String name,String category, String delivery,
      String range, String uid) async {
    return await profileList.doc(uid).set({
      "Shop Name":name,
      "Category": category,
      "Delivery": delivery,
      "range": range,
      "uid": uid
    });
  }

  Future<bool> checkIfDocExists(String uid) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('profileInfo');

      var doc = await collectionRef.doc(uid).get();
      return doc.exists;
    }
    catch (e) {
      throw e;
    }
  }
}