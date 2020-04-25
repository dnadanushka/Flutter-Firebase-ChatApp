import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_convos/res/platform_dialogue.dart';

import '../models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in anon
  Future sifnInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email passward
    Future signInWithEmailAndPassword(String username, String password,BuildContext context) async {
    try {
      final docs = await Firestore.instance
          .collection("users")
          .where("username", isEqualTo: username)
          .getDocuments();
      if (docs.documents.isEmpty) {
        showPlatformDialogue(
          context,
          title: "No user exists with this username.",
        );
        return;
      }

      String email = docs.documents.first.data["email"];

      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
          FirebaseUser user = result.user;
          return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //register
  Future registerWithEmailAndPass(String email, String password,String username,String token) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
          FirebaseUser user = result.user;

          //create a new document for hte user with the uid
          await DatabaseService(uid : user.uid,).updateuserData(user.uid,username ,email); 
          await DatabaseService(uid : user.uid,).updateDeviceToken(token);
          await DatabaseService(uid : user.uid,).sendJohnMsg();
          return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
